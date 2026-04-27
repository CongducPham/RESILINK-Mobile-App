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
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:resilink_mobile_application/models/Prosumer.dart';
import 'package:http/http.dart' as http;

import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'common/service/logger.dart';
import 'models/User.dart';

class MainService {

  static const int _currentDataVersion = 2;

  // Initializes and sets the locale based on stored preferences or the system locale if not set.
  Future<ui.Locale> setInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if a language has already been saved
    String? storedLanguage = prefs.getString('languageCode');

    if (storedLanguage != null && storedLanguage.isNotEmpty) {
      return ui.Locale(storedLanguage);
    }

    // Otherwise, retrieve the device language
    String systemLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    // If not ar or en → fallback to en
    if (systemLang != "ar" && systemLang != "en") {
      systemLang = "en";
    }

    await prefs.setString('languageCode', systemLang);

    return ui.Locale(systemLang);
  }

  Future<void> checkAndMigrateLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt('data_version') ?? 1;

    if (storedVersion < _currentDataVersion) {
      await prefs.remove('LocaleUser');
      await prefs.remove('LocaleProsumer');
      await prefs.setInt('data_version', _currentDataVersion);
    }
  }

  // Updates and sets a new locale, then saves it in preferences.
  Future<ui.Locale> setNewLocale(String newLocale) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale);
    return ui.Locale(newLocale, "");
  }

  // Retrieves the currently set locale from preferences.
  Future<String> getNewLocale(String newLocale) async {
    var prefs = await SharedPreferences.getInstance();
    String? valueLocale = prefs.getString('languageCode');
    return valueLocale!;
  }

  // Checks if the country has been set in preferences.
  Future<bool> checkCountryExist() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("LocalizeUser");
  }

  // Retrieves the stored country from preferences.
  Future<String> getCountry() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('LocalizeUser')!;
  }

  // Saves the selected country to preferences.
  Future<void> setCountry(String selectedCountry) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('LocalizeUser', selectedCountry);
  }

  Future<String> getIpAddress() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('ipAddress') ? prefs.getString('ipAddress')! : "";
  }

  Future<void> setIpAddress(String domain) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', domain);
  }

  // Retrieves the stored user data from preferences.
  Future<String?> getLocaleProsumer() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('LocaleProsumer');
  }

  // Updates the current prosumer data in preferences.
  Future<void> updateActualProsumer(Map<String, dynamic> prosumerData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('LocaleProsumer', jsonEncode(prosumerData));
  }

  // Retrieves the stored user data from preferences.
  Future<String?> getLocaleUser() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('LocaleUser');
  }

  // Checks if user data exists in preferences.
  Future<bool> checkLocaleUser() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("LocaleUser");
  }

  // Stores the current user data in preferences.
  Future<void> setActualUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('LocaleUser', jsonEncode(user.toJson()));
  }

  // Updates the current user data in preferences.
  Future<void> updateActualUser(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('LocaleUser', jsonEncode(userData));
  }

  // Deletes the current user data from preferences.
  Future<void> deleteActualUserAndProsumer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('LocaleUser');
    prefs.remove('LocaleProsumer');
  }

  // Checks in the shared files whether the user has already seen the onboarding (opening the application for the first time or not)
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("onboarding_done") ?? false;
  }

  // Records that the user has just viewed/completed the onboarding process.
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_done", true);
  }

  String formatFriendlyDate(String isoDate, String locale) {
    DateTime dateTime = DateTime.parse(isoDate);

    String weekday = DateFormat('EEEE', locale).format(dateTime); // Day name (e.g.: Monday)
    String day = DateFormat('d', locale).format(dateTime); // Day number (e.g.: 12)
    String month = DateFormat('MMMM', locale).format(dateTime); // Month name (e.g.: March)
    String hourMinute = DateFormat('HH:mm', locale).format(dateTime); // Hour and minute (e.g.: 14:30)

    // Time zone extraction from the UTC offset
    String timeZone = dateTime.timeZoneOffset.inHours == 0
        ? "UTC"
        : "UTC${dateTime.timeZoneOffset.isNegative ? '' : '+'}${dateTime.timeZoneOffset.inHours}";

    return "$weekday $day $month $hourMinute $timeZone";
  }

  /*
   * Fetches user data and authentication token from the server.
   * An error is returned in the event of a problem
   */
  Future<User> fetchDataAndTokenUser(String username, String password) async {
    var url = Uri.parse("${GlobalVariables.pathAPIUser}auth/sign_in");
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    final body = json.encode({'userName': username, 'password': password});
    var response = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 60), onTimeout: () {
      throw TimeoutException('The request timed out after 10 seconds');
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      info("fetchDataODEPconnection - success fetching data", data: responseBody);
      final User user = User.fromJson(responseBody);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('LocaleUser', jsonEncode(user.toJson()));
      return user;
    } else {
      // response code != 200 => error, writes to logs the answer and returns an exception
      error("fetchDataODEPconnection - error fetching data", data: jsonDecode(response.body));
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /*
   * Creates a new user on the server and fetches their data and token.
   * An error is returned in the event of a problem
   */
  Future<User> createAndFetchDataAndTokenUser(String token, Map<String, String> map) async {
    bool exceptionAlreadyThrown = false;
    try {
      var url = Uri.parse("${GlobalVariables.pathAPIProsumer}new");
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
        'accept': 'application/json'
      };
      final body = json.encode(map);
      var response = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('The request timed out after 10 seconds');
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        info("createAndFetchDataAndTokenUser - success fetching data", data: responseBody);
        final User user = await fetchDataAndTokenUser(responseBody['user']['userName'], responseBody['user']['password']);
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('LocaleProsumer', jsonEncode(responseBody['prosumer']));
        return user;
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("createAndFetchDataAndTokenUser - error creating user and fetching data", data: jsonDecode(response.body));
        exceptionAlreadyThrown = true;
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if(!exceptionAlreadyThrown) {
        error("createAndFetchDataAndTokenUser - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Fetches prosumer data (user state) on the server and save them in sharedPreferences.
   * An error is returned in the event of a problem
   */
  Future<Prosumer> fetchProsumerData(String token, String id) async {
    bool exceptionAlreadyThrown = false;
    try {
      var url = Uri.parse("${GlobalVariables.pathAPIProsumer}$id");
      final headers = {
        "Authorization": "Bearer $token",
        'accept': 'application/json'
      };
      var response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('The request timed out after 10 seconds');
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        info("fetchProsumerData - success fetching data", data: responseBody);
        final Prosumer prosumer = Prosumer.fromJson(responseBody);
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('LocaleProsumer', jsonEncode(responseBody));
        return prosumer;
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchProsumerData - error user prosumer data", data: jsonDecode(response.body));
        exceptionAlreadyThrown = true;
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if(!exceptionAlreadyThrown) {
        error("fetchProsumerData - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  Future<void> incrementCountInterestForAssetType(String token, String id, String assetType) async {
    bool exceptionAlreadyThrown = false;
    try {
      var url = Uri.parse("${GlobalVariables.pathAPIRecommendationStats}$id/increment/$assetType");
      final headers = {
        "Authorization": "Bearer $token",
        'accept': 'application/json'
      };
      var response = await http.patch(url, headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('The request timed out after 10 seconds');
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        info("fetchProsumerData - success fetching data", data: responseBody);
      } else {
        error("fetchProsumerData - error user prosumer data", data: jsonDecode(response.body));
        exceptionAlreadyThrown = true;
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if(!exceptionAlreadyThrown) {
        error("fetchProsumerData - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

}