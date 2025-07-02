import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('kk'), // Kazakh
    Locale('ru'), // Russian  
    Locale('en'), // English
  ];
  
  Locale _currentLocale = const Locale('ru'); // Default to Russian
  
  Locale get currentLocale => _currentLocale;
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'kk': 'Қазақша',
    'ru': 'Русский', 
    'en': 'English',
  };
  
  // Language flags/emojis
  static const Map<String, String> languageFlags = {
    'kk': '🇰🇿',
    'ru': '🇷🇺',
    'en': '🇺🇸',
  };
  
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Сначала проверяем новый ключ, потом старый для обратной совместимости
    String? languageCode = prefs.getString('selected_language');
    if (languageCode == null) {
      languageCode = prefs.getString(_languageKey);
    }
    
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
    }
  }
  
  Future<void> setLanguage(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    
    notifyListeners();
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
  
  String getLanguageFlag(String languageCode) {
    return languageFlags[languageCode] ?? '🌍';
  }
}
