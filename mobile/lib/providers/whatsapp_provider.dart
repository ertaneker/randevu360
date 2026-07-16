import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class WhatsAppProvider extends ChangeNotifier {
  /// Hiçbir çağrı UI'yı süresiz bloklamamalı, ama süreler işe göre değişir:
  /// eşleştirme kodu Baileys'in WhatsApp'a bağlanmasını beklediği için uzun,
  /// mesaj gönderimi orta, salt okuma çağrıları kısa.
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _sendTimeout = Duration(seconds: 30);
  static const Duration _pairingTimeout = Duration(seconds: 60);

  bool _isConnected = false;
  bool _isPairing = false;
  String? _pairingCode;
  String? _connectionStatus;
  String? _error;
  List<Map<String, dynamic>> _messageLogs = [];

  bool get isConnected => _isConnected;
  bool get isPairing => _isPairing;
  String? get pairingCode => _pairingCode;
  String? get connectionStatus => _connectionStatus;
  String? get error => _error;
  List<Map<String, dynamic>> get messageLogs => _messageLogs;

  // Baileys servisine pairing code isteği gönder
  Future<bool> requestPairingCode(String businessId, String phoneNumber) async {
    _isPairing = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/pairing/request'),
        headers: _headers,
        body: jsonEncode({
          'businessId': businessId,
          'phoneNumber': phoneNumber,
        }),
      ).timeout(_pairingTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _pairingCode = data['pairingCode'];
        _isPairing = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Pairing hatası: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      _isPairing = false;
      notifyListeners();
      return false;
    }
  }

  // Bağlantı durumunu kontrol et
  Future<void> checkStatus(String businessId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/status/$businessId'),
        headers: _headers,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _isConnected = data['connected'] ?? false;
        _connectionStatus = data['status'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  // Direkt mesaj gönder
  Future<bool> sendMessage(String businessId, String phone, String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/send'),
        headers: _headers,
        body: jsonEncode({
          'businessId': businessId,
          'phone': phone,
          'message': message,
        }),
      ).timeout(_sendTimeout);

      return response.statusCode == 200;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  /// Şablon mesajı gönderir. Randevu akışlarından arka planda çağrılır; mesaj
  /// gitmese bile randevu kaydı geçerlidir, bu yüzden hata kullanıcıya
  /// yansıtılmaz (aksi halde alakasız ekranlarda hata olarak görünüyordu).
  Future<bool> sendTemplate(
    String businessId,
    String phone,
    String templateName,
    Map<String, String> variables,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/send-template'),
        headers: _headers,
        body: jsonEncode({
          'businessId': businessId,
          'phone': phone,
          'templateName': templateName,
          'variables': variables,
        }),
      ).timeout(_sendTimeout);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('sendTemplate başarısız ($templateName): $e');
      return false;
    }
  }

  // Toplu mesaj (rehberdeki herkese)
  Future<bool> sendBulk(String businessId, List<String> phones, String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/send-bulk'),
        headers: _headers,
        body: jsonEncode({
          'businessId': businessId,
          'phones': phones,
          'message': message,
        }),
      ).timeout(_timeout);

      return response.statusCode == 200;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Mesaj geçmişini getir
  Future<void> loadMessageLogs(String businessId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/logs/$businessId?limit=50'),
        headers: _headers,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        _messageLogs = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  // ──── MESAJ ŞABLONLARI ────

  List<Map<String, dynamic>> _templates = [];
  List<String> _templateVariables = [];
  bool _templatesLoading = false;

  List<Map<String, dynamic>> get templates => _templates;
  List<String> get templateVariables => _templateVariables;
  bool get templatesLoading => _templatesLoading;

  /// Sunucudaki şablonları getirir. Kaydedilmemiş olanlar varsayılan metinle döner.
  Future<bool> loadTemplates(String businessId) async {
    _templatesLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/templates/$businessId'),
        headers: _headers,
      ).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Şablonlar alınamadı (${response.statusCode})');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _templates = List<Map<String, dynamic>>.from(data['templates'] ?? []);
      _templateVariables = List<String>.from(data['variables'] ?? []);
      _templatesLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _templatesLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Şablonları sunucuya kaydeder. Zamanlayıcı bunları kullandığı için
  /// uygulama kapalıyken gönderilen hatırlatmalar da bu metinlerle gider.
  Future<bool> saveTemplates(String businessId, Map<String, String> templates) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/templates/$businessId'),
        headers: _headers,
        body: jsonEncode({'templates': templates}),
      ).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Şablonlar kaydedilemedi (${response.statusCode})');
      }

      await loadTemplates(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ──── RANDEVU SENKRONU ────

  /// Randevuları WhatsApp servisine gönderir. Hatırlatmalar sunucudaki
  /// zamanlayıcıdan gittiği için uygulama kapalı olsa da çalışır.
  /// Tamamlanan/iptal edilen randevular sunucudan silinir.
  ///
  /// Arka planda çalışır: başarısız olursa randevu yine de yerelde kayıtlıdır
  /// ve sonraki senkronda tekrar denenir, bu yüzden kullanıcıya hata basmaz.
  Future<bool> syncAppointments(List<Map<String, dynamic>> appointments) async {
    if (appointments.isEmpty) return true;

    // Telefonun bağlantısı anlık takılabiliyor; tek denemede pes etme.
    for (var attempt = 1; attempt <= 2; attempt++) {
      final started = DateTime.now();
      try {
        final response = await http.post(
          Uri.parse('${AppConstants.whatsappServiceUrl}/api/appointments/sync'),
          headers: _headers,
          body: jsonEncode({'appointments': appointments}),
        ).timeout(_timeout);

        final ms = DateTime.now().difference(started).inMilliseconds;
        debugPrint('Randevu senkronu: ${response.statusCode} (${ms}ms, deneme $attempt)');

        if (response.statusCode == 200) return true;
      } catch (e) {
        final ms = DateTime.now().difference(started).inMilliseconds;
        debugPrint('Randevu senkronu başarısız (${ms}ms, deneme $attempt): $e');
      }

      if (attempt == 1) await Future.delayed(const Duration(seconds: 2));
    }

    return false;
  }

  // ──── BORÇ HATIRLATMA ────

  /// Borçlu listesini sunucuya gönderir (tam durum: listede olmayanların
  /// borcu kapanmış sayılır). Arka plan işi; hata kullanıcıya yansıtılmaz.
  Future<bool> syncDebts(String businessId, List<Map<String, dynamic>> debts) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/debts/sync'),
        headers: _headers,
        body: jsonEncode({'businessId': businessId, 'debts': debts}),
      ).timeout(_timeout);

      debugPrint('Borç senkronu: ${response.statusCode} (${debts.length} borçlu)');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Borç senkronu başarısız: $e');
      return false;
    }
  }

  String _debtReminderFrequency = 'off';
  String get debtReminderFrequency => _debtReminderFrequency;

  /// Borç hatırlatma sıklığını sunucudan getirir (off/daily/weekly/monthly).
  Future<void> loadDebtReminderFrequency(String businessId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/debt-settings/$businessId'),
        headers: _headers,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _debtReminderFrequency = data['frequency']?.toString() ?? 'off';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Borç hatırlatma ayarı okunamadı: $e');
    }
  }

  Future<bool> saveDebtReminderFrequency(String businessId, String frequency) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/debt-settings/$businessId'),
        headers: _headers,
        body: jsonEncode({'frequency': frequency}),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        _debtReminderFrequency = frequency;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Bağlantıyı kes
  Future<void> disconnect(String businessId) async {
    try {
      await http.post(
        Uri.parse('${AppConstants.whatsappServiceUrl}/api/disconnect/$businessId'),
        headers: _headers,
      ).timeout(_timeout);
      _isConnected = false;
      _pairingCode = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-Api-Key': AppConstants.apiKey,
  };

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
