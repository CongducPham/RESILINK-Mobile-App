import 'package:flutter/material.dart';
import 'package:resilink_design/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_design/main_service.dart';

import '../models/Asset.dart';
import '../models/Offer.dart';
import '../models/User.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "";
  bool _connected = true;
  String _token = "";
  String _country = "";
  bool _countryExist = false;
  Locale _locale = Locale("en");
  MainService _mainService = MainService();

  // Asset and Offer for changing data of search page to see an offer details
  Offer? _offerDetails;
  Asset? _assetDetails;
  User? actualUser;


  String get userName => _userName;
  Locale get locale => _locale;
  bool get connected => _connected;
  bool get countryExist => _countryExist;
  String get country => _country;
  String get token => _token;
  Offer? get offerDetails => _offerDetails;
  Asset? get assetDetails => _assetDetails;

  void setConnected(bool newValue) {
    _connected = newValue;
    notifyListeners();
  }

  void setToken(String newValue) {
    _token = newValue;
    notifyListeners();
  }

  void setOfferAndAssetViewDetails(Offer offer, Asset asset) {
    _offerDetails = offer;
    _assetDetails = asset;
    notifyListeners();
  }

  void clearOfferAndAssetViewDetails() {
    _offerDetails = null;
    _assetDetails = null;
    notifyListeners();
  }

  void setActualUser(Map<String, String> userMap) {
    actualUser = User.fromJson(userMap);
    notifyListeners();
  }

  Future<void> setInitialLocale() async {
    _locale = await _mainService.setInitialLocale();
    notifyListeners();
  }

  Future<void> setNewLocale(String newLocale) async {
    _locale = await _mainService.setNewLocale(newLocale);
    notifyListeners();
  }

  Future<bool> checkAndSetCountry () async {
    if (await _mainService.checkCountryExist()) {
      _country = await _mainService.getCountry();
      _countryExist = true;
      return true;
    } else {
      return false;
    }
  }

}