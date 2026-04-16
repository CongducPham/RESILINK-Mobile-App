import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/main_service.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../models/Asset.dart';
import '../models/Contract.dart';
import '../models/Offer.dart';
import '../models/Prosumer.dart';
import '../models/User.dart';

import 'dart:convert' as convert;


class MainProvider extends ChangeNotifier {

  // Variables and their initialization
  String _userName = "";
  bool _connected = false;
  String _country = "";
  bool _countryExist = false;
  bool _forPurchase = false;
  bool hasCompletedOnboarding = false;
  bool offerBlockedFromHome = false;
  VoidCallback? pendingOnOfferBlocked;

  MainService _mainService = MainService();

  // Asset and Offer for changing data of search page to see an offer details
  Offer? _offerDetails;
  Asset? _assetDetails;
  Contract? _actualContract;

  User? _actualUser;
  Prosumer? _actualProsumer;

  // Getters
  String get userName => _userName;
  bool get connected => _connected;
  bool get countryExist => _countryExist;
  String get country => _country;
  Offer? get offerDetails => _offerDetails;
  Asset? get assetDetails => _assetDetails;
  User? get actualUser => _actualUser;
  Prosumer? get actualProsumer => _actualProsumer;
  Contract? get actualContract => _actualContract;
  bool get forPurchase => _forPurchase;

  // Setters
  void setConnected(bool newValue) {
    _connected = newValue;
  }

  void setActualUser(User user) {
    _actualUser = user;
  }

  void setActualProsumer(Prosumer prosumer) {
    _actualProsumer = prosumer;
  }

  void setOfferAndAssetViewDetails(Offer offer, Asset asset, bool forPurchase) {
    _offerDetails = offer;
    _assetDetails = asset;
    _forPurchase = forPurchase;
    notifyListeners();
  }

  void setOfferAssetContractViewDetails(Offer offer, Asset asset, Contract contract) {
    _offerDetails = offer;
    _assetDetails = asset;
    _actualContract = contract;
    notifyListeners();
  }

  // Clears the details of the offer, asset, and contract.
  void clearOfferAssetContractViewDetails() {
    _offerDetails = null;
    _assetDetails = null;
    _actualContract = null;
    notifyListeners();
  }

  void clearOfferDetails() {
    // Reset offerDetails and assetDetails to null
    // Adjust the exact names according to your MainProvider
    _offerDetails = null;
    _assetDetails = null;
    notifyListeners();
  }

  // Get a translated version of assetType to display it
  String getTradAssetType(String assetType, BuildContext context) {

    String tradAssetType = "";

    switch (assetType) {
      case "Fruit" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeFruit;
        break;
      case "Vegetable" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeVegetable;
        break;
      case "Crop" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeCrop;
        break;
      case "Machinery" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeMachinery;
        break;
      case "Inputs" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeInputs;
        break;
      case "Labor" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeLabor;
        break;
      case "Other services" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeOtherServices;
        break;
      case "Storage" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeStorage;
        break;
      case "Transport" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeTransport;
        break;
      case "Livestock" :
        tradAssetType = AppLocalizations.of(context)!.assetTypeLivestock;
        break;
    }
    return tradAssetType;
  }

  // Updates the current user's data with the provided user data.
  Future<void> updateActualUser(Map<String, String> userData) async {
    userData["_id"] = actualUser!.id;
    userData["accessToken"] = actualUser!.accessToken;
    userData["createdAt"] = actualUser!.createdAt;
    userData["updatedAt"] = actualUser!.updateAt;
    userData["provider"] = actualUser!.provider;
    userData["account"] = actualUser!.account;
    await _mainService.updateActualUser(userData);
    _actualUser = User.fromJson(userData);
  }

  // Updates the current user's data with the provided user data.
  Future<void> updateActualProsumer(Map<String, dynamic> prosumerData) async {
    prosumerData["id"] = actualProsumer!.id;
    prosumerData["balance"] = actualProsumer!.balance;
    prosumerData["sharingAccount"] = actualProsumer!.sharingAccount;
    await _mainService.updateActualProsumer(prosumerData);
    _actualProsumer = Prosumer.fromJson(prosumerData);
  }

  // Checks if the country exists and sets it if found.
  Future<bool> checkAndSetCountry () async {
    if (await _mainService.checkCountryExist()) {
      _country = await _mainService.getCountry();
      _countryExist = true;
      return true;
    } else {
      return false;
    }
  }

  // Sets the current country and marks it as existing.
  Future<void> setCountry (String country) async {
    await _mainService.setCountry(country);
    _country = country;
    _countryExist = true;
  }

  Future<void> migrateLocalDataIfNeeded() async {
    await _mainService.checkAndMigrateLocalData();
  }

  /*
   * Fetches user data and token based on username and password.
   * If not user is registered, use public account.
   */
  Future<void> getUserDataAndToken({String? username, String? password}) async {
    try {
      String localeUser = await _mainService.getLocaleUser() ?? "";
      User userTamp = await _mainService.fetchDataAndTokenUser(
          username ?? (localeUser.isNotEmpty ? convert.jsonDecode(localeUser)['userName'] : "public"),
          password ?? (localeUser.isNotEmpty ? convert.jsonDecode(localeUser)['password'] : "public123"));
      setActualUser(userTamp);
      if (userTamp.username != "public") {
        // If a reel user is connected, retrieve prosumer data
        Prosumer prosumer = await _mainService.fetchProsumerData(userTamp.accessToken, userTamp.username);
        setActualProsumer(prosumer);
        setConnected(true);
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Creates a new user and fetches data and token.
  Future<void> createUserAndGetDataToken(String token, Map<String, String> body) async {
    try {
      User userTamp = await _mainService.createAndFetchDataAndTokenUser(token, body);
      setActualUser(userTamp);
      Prosumer prosumerTamp = await _mainService.fetchProsumerData(userTamp.accessToken, userTamp.username);
      setActualProsumer(prosumerTamp);
      setConnected(true);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Periodically fetches user data and token every 1h30m.
  Future<void> fetchUserDataPeriodically(BuildContext context) async {
    const hour =  Duration(hours: 1, minutes: 30);
    Timer.periodic(hour, (Timer timer) async {
        await getUserDataAndToken();
    });
  }

  // Clears all data belonging to the user.
  Future<void> logOutUser() async {
    _actualProsumer = null;
    _actualUser = null;
    _connected = false;
    await _mainService.deleteActualUserAndProsumer();
    notifyListeners();
  }

  // Checks if user data exists in shared preferences.
  Future<bool> isUserSharedPreferencesExist() async {
    bool userExist = await _mainService.checkLocaleUser();
    return userExist;
  }

  // Convert base64 string in Uint8List
  // Need to be in Main provider to have access to it everywhere
  Uint8List convertBase64ToImg (String imageList) {
    Uint8List bytes = base64Decode(imageList);
    return bytes;
  }

  Future<void> changeIpAddress(String ipAddress) async {
    GlobalVariables.ipDomain = ipAddress;
    GlobalVariables.protocol = ipAddress == GlobalVariables.ipAddressMasterServer ? "https": "http" ;
    await _mainService.setIpAddress(ipAddress);
  }

  Future<void> checkAndSetLocalIpAddress() async {
    String ipAddress = await _mainService.getIpAddress();
    if (ipAddress.isNotEmpty) {
      GlobalVariables.ipDomain = ipAddress;
    }
  }

  String changeDateFormatToInterface(String date, String locale) {
    return _mainService.formatFriendlyDate(date, locale);
  }

  Future<void> loadOnboardingStatus() async {
    hasCompletedOnboarding = await _mainService.hasCompletedOnboarding();
    notifyListeners();
  }

  Future<void> incrementCountInterestForAssetType(String token, String id, String assetType) async {
    _mainService.incrementCountInterestForAssetType(token, id, assetType);
  }

}