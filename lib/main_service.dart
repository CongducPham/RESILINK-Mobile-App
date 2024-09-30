import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:Resilink/models/Prosumer.dart';
import 'package:http/http.dart' as http;

import 'package:Resilink/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/service/logger.dart';
import 'models/User.dart';

class MainService {

  // Initializes and sets the locale based on stored preferences or the system locale if not set.
  Future<ui.Locale> setInitialLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      prefs.setString('languageCode', languageCode);
      return ui.Locale(languageCode, "");
    } else {
      prefs.setString('languageCode', ui.window.locale.languageCode);
      return ui.window.locale;
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
    var response = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 10), onTimeout: () {
      throw TimeoutException('The request timed out after 10 seconds');
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      info("fetchDataODEPconnection - success fetching data", data: responseBody);
      final User user = User.fromJson(responseBody);
      user.password = password;
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
        "Authorization": "",
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

}