import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class MainService {

  Future<ui.Locale> setInitialLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      prefs.setString('languageCode', languageCode!);
      return ui.Locale(languageCode, "");
    } else {
      prefs.setString('languageCode', ui.window.locale.languageCode);
      return ui.window.locale;
    }
  }

  Future<ui.Locale> setNewLocale(String newLocale) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale);
    return ui.Locale(newLocale, "");
  }

  Future<bool> checkCountryExist() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("LocalizeUser");
  }

  Future<String> getCountry() async {
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getString('LocalizeUser'));
    return prefs.getString('LocalizeUser')!;
  }

}