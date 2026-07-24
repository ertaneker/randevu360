import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_service.dart';

/// Açılıştaki Drive yedek kontrolünün sonucu.
enum DriveSyncResult {
  /// Uzakta daha yeni yedek vardı, indirildi — uygulama yeniden başlatılmalı.
  restored,

  /// Uzak yedek bu cihazın bildiği sürümle aynı.
  upToDate,

  /// Drive'da hiç yedek yok.
  noBackup,

  /// Sessiz Google girişi yapılamadı (izin yok / çevrimdışı) — kontrol atlandı.
  skipped,

  /// İndirme/sorgu hatası (detay [BackupService.lastError]).
  error,
}

/// Google Drive yedekleme servisi
/// SQLite veritabanını Google Drive'a yedekler ve geri yükler.
///
/// Geri yükleme iki aşamalıdır: indirilen dosya `restore_pending.db` olarak
/// kaydedilir; uygulama yeniden açıldığında DatabaseService veritabanını
/// açmadan önce bu dosyayı devreye alır (açık bir SQLite dosyasının üzerine
/// yazmak güvenli değildir).
class BackupService {
  static const String _backupFileName = 'esnaftakvim_backup.db';
  static const String restorePendingFileName = 'restore_pending.db';

  /// Bu cihazın bildiği son Drive yedeğinin modifiedTime değeri.
  /// Açılışta uzak değerle karşılaştırılır; farklıysa başka bir cihaz
  /// yedek yüklemiş demektir ve yedek indirilir.
  static const String _markerPrefKey = 'drive_backup_marker';
  static const String _mimeType = 'application/octet-stream';
  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/drive.file',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  GoogleSignInAccount? _account;

  /// Son işlemin hata açıklaması (UI'da gösterilir).
  String? lastError;

  Future<bool> authenticate() async {
    try {
      _account = await _googleSignIn.signInSilently();
      _account ??= await _googleSignIn.signIn();
      if (_account == null) {
        lastError = 'Google girişi iptal edildi';
        return false;
      }
      // Sessiz giriş, Drive izni daha önce verilmemiş bir hesap döndürebilir.
      // requestScopes izin zaten verilmişse ekran göstermeden true döner.
      final granted = await _googleSignIn.requestScopes(_scopes);
      if (!granted) {
        lastError = 'Google Drive izni verilmedi';
        return false;
      }
      return true;
    } catch (e) {
      lastError = e.toString();
      return false;
    }
  }

  /// Ekran göstermeden giriş dener — açılış kontrolü için. Hesap yoksa veya
  /// Drive izni hiç verilmemişse false döner; kullanıcı akışı bölünmez.
  Future<bool> authenticateSilently() async {
    try {
      _account = await _googleSignIn.signInSilently();
      return _account != null;
    } catch (e) {
      lastError = e.toString();
      return false;
    }
  }

  Future<String?> _getAccessToken() async {
    if (_account == null) return null;
    final auth = await _account!.authentication;
    return auth.accessToken;
  }

  Future<void> _saveMarker(String modifiedTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_markerPrefKey, modifiedTime);
  }

  /// Açılışta çağrılır: Drive'daki yedek bu cihazın bilmediği bir sürümse
  /// indirir (restore_pending.db). [localHasData] false ise (taze kurulum)
  /// ilk bulunan yedek doğrudan indirilir; true ise ilk karşılaştırmada
  /// yereldeki taze veri korunur ve uzak sürüm benimsenir.
  Future<DriveSyncResult> syncFromDriveIfNewer(
      {required bool localHasData}) async {
    try {
      if (!await authenticateSilently()) return DriveSyncResult.skipped;
      final token = await _getAccessToken();
      if (token == null) return DriveSyncResult.skipped;

      final files = await _searchBackups(token);
      if (files.isEmpty) return DriveSyncResult.noBackup;
      final remoteModified = files[0]['modifiedTime'].toString();

      final prefs = await SharedPreferences.getInstance();
      final marker = prefs.getString(_markerPrefKey);

      if (marker == remoteModified) return DriveSyncResult.upToDate;

      if (marker == null && localHasData) {
        // Bu cihaz yedeği hiç görmemiş ama yerelde veri var — üzerine yazmak
        // taze veriyi kaybettirir. Uzak sürümü benimse, bundan sonra fark
        // oluşursa indirilecek.
        await _saveMarker(remoteModified);
        return DriveSyncResult.upToDate;
      }

      final ok = await restore();
      return ok ? DriveSyncResult.restored : DriveSyncResult.error;
    } catch (e) {
      lastError = e.toString();
      return DriveSyncResult.error;
    }
  }

  /// Yedekleme yap
  Future<bool> backup(DatabaseService db) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        lastError = 'Google oturumu bulunamadı';
        return false;
      }

      // Açık DB dosyasını kopyalamak yerine VACUUM INTO ile tutarlı snapshot al
      final dir = await getApplicationDocumentsDirectory();
      final snapshot = File(p.join(dir.path, 'backup_snapshot.db'));
      if (await snapshot.exists()) await snapshot.delete();
      await db.exportTo(snapshot.path);

      final dbBytes = await snapshot.readAsBytes();
      await snapshot.delete();

      final existingId = await _findNewestBackupId(token);
      final http.Response response;

      if (existingId != null) {
        // Mevcut yedeğin içeriğini güncelle (dosya çoğalmasın)
        response = await http.patch(
          Uri.parse(
            'https://www.googleapis.com/upload/drive/v3/files/$existingId?uploadType=media&fields=modifiedTime',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': _mimeType,
          },
          body: dbBytes,
        );
      } else {
        final boundary = 'backup_${DateTime.now().millisecondsSinceEpoch}';
        final metadata = jsonEncode({'name': _backupFileName});
        final bodyBytes = <int>[
          ...utf8.encode(
            '--$boundary\r\n'
            'Content-Type: application/json; charset=UTF-8\r\n\r\n'
            '$metadata\r\n'
            '--$boundary\r\n'
            'Content-Type: $_mimeType\r\n\r\n',
          ),
          ...dbBytes,
          ...utf8.encode('\r\n--$boundary--\r\n'),
        ];

        response = await http.post(
          Uri.parse(
            'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&fields=modifiedTime',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/related; boundary=$boundary',
          },
          body: bodyBytes,
        );
      }

      if (response.statusCode != 200) {
        lastError = _describeDriveError('yükleme', response);
        return false;
      }

      // Yüklenen sürümü "bilinen sürüm" olarak işaretle — açılış kontrolü
      // kendi yüklediğimiz yedeği yeniden indirmesin.
      try {
        final modified =
            jsonDecode(response.body)['modifiedTime']?.toString();
        if (modified != null) await _saveMarker(modified);
      } catch (_) {}
      return true;
    } catch (e) {
      lastError = e.toString();
      return false;
    }
  }

  /// Yedekten geri yükle.
  /// Dosyayı `restore_pending.db` olarak kaydeder; geri yükleme uygulama
  /// yeniden başlatıldığında tamamlanır.
  Future<bool> restore() async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        lastError = 'Google oturumu bulunamadı';
        return false;
      }

      final files = await _searchBackups(token);
      if (files.isEmpty) {
        lastError = 'Drive üzerinde yedek bulunamadı';
        return false;
      }
      final fileId = files[0]['id'] as String;

      final downloadResponse = await http.get(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?alt=media'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (downloadResponse.statusCode != 200) {
        lastError = _describeDriveError('indirme', downloadResponse);
        return false;
      }

      final dir = await getApplicationDocumentsDirectory();
      final pending = File(p.join(dir.path, restorePendingFileName));
      await pending.writeAsBytes(downloadResponse.bodyBytes, flush: true);

      // İndirilen sürümü işaretle — açılış kontrolü aynı yedeği tekrar
      // indirip yeniden başlatma döngüsüne girmesin.
      await _saveMarker(files[0]['modifiedTime'].toString());

      return true;
    } catch (e) {
      lastError = e.toString();
      return false;
    }
  }

  /// Son yedekleme tarihini kontrol et
  Future<DateTime?> getLastBackupTime() async {
    try {
      final token = await _getAccessToken();
      if (token == null) return null;

      final files = await _searchBackups(token);
      if (files.isEmpty) return null;

      return DateTime.parse(files[0]['modifiedTime']);
    } catch (e) {
      return null;
    }
  }

  Future<String?> _findNewestBackupId(String token) async {
    final files = await _searchBackups(token);
    if (files.isEmpty) return null;
    return files[0]['id'] as String;
  }

  Future<List<dynamic>> _searchBackups(String token) async {
    final uri = Uri.https('www.googleapis.com', '/drive/v3/files', {
      'q': "name = '$_backupFileName' and trashed = false",
      'orderBy': 'modifiedTime desc',
      'fields': 'files(id,modifiedTime)',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      lastError = _describeDriveError('arama', response);
      return const [];
    }

    return jsonDecode(response.body)['files'] as List;
  }

  /// Drive API hatasını teşhis edilebilir mesaja çevirir. 403 çoğunlukla
  /// Google Cloud projesinde Drive API'nin etkin olmamasından gelir.
  String _describeDriveError(String op, http.Response response) {
    String detail = '';
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      detail = body['error']?['message']?.toString() ?? '';
    } catch (_) {
      detail = response.body;
    }
    if (detail.length > 160) detail = detail.substring(0, 160);

    if (response.statusCode == 403 &&
        (detail.contains('has not been used') || detail.contains('disabled'))) {
      return 'Google Drive API projede etkin değil — Google Cloud Console > '
          'API kitaplığından "Google Drive API" etkinleştirilmeli. ($detail)';
    }
    return 'Drive $op hatası (HTTP ${response.statusCode}): $detail';
  }
}
