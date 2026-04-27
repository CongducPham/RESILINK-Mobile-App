/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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