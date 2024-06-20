import 'package:shared_preferences/shared_preferences.dart';

class SelectCountryService {

  Future<void> setCountry(String selectedCountry) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('LocalizeUser', selectedCountry!);
    print(prefs.getString('LocalizeUser'));
  }

}