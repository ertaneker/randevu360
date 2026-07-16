import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının seçtiği dil tercihini SharedPreferences'ta saklar.
/// `null` → cihaz dilini kullan (varsayılan).
class LocaleProvider extends ChangeNotifier {
  static const _key = 'selected_locale';

  Locale? _locale;
  bool _loaded = false;

  Locale? get locale => _locale;
  bool get loaded => _loaded;

  /// Uygulama başlarken kayıtlı tercihi okur.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    _locale = code != null && code.isNotEmpty ? Locale(code) : null;
    _loaded = true;
    notifyListeners();
  }

  /// Kullanıcı yeni dil seçtiğinde kaydeder. `null` → sistem diline dön.
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_key, locale.languageCode);
    } else {
      await prefs.remove(_key);
    }
  }
}
