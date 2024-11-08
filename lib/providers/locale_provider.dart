import 'package:flutter/material.dart';

import '../main_service.dart';

class LocaleProvider extends ChangeNotifier {

  // Variables and their initialization
  List<String> _valueLanguage = ["en", "ar"];
  Locale _locale = Locale("en");
  MainService _mainService = MainService();
  String _valueLocale = "en";

  // Getters
  Locale get locale => _locale;
  List<String> get valueLanguage => _valueLanguage;
  String get valueLocale => _valueLocale;

  // Sets the initial locale based on saved preferences or defaults.
  Future<void> setInitialLocale() async {
    _locale = await _mainService.setInitialLocale();
    _valueLocale = _locale.languageCode;
    notifyListeners();
  }

  // Sets a new locale and updates the current language code.
  Future<void> setNewLocale() async {
    _locale = await _mainService.setNewLocale(_valueLocale);
    _valueLocale = _locale.languageCode;
    notifyListeners();
  }

  // Updates the current language code and notifies listeners.
  void setValueLocale(String newValue) async {
    _valueLocale = newValue;
    notifyListeners();
  }
}