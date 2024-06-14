import 'package:flutter/material.dart';

import '../models/Asset.dart';
import '../models/Offer.dart';
import '../models/User.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "";
  bool _connected = true;
  String _token = "";

  // Asset and Offer for changing data of search page to see an offer details
  Offer? _offerDetails;
  Asset? _assetDetails;
  User? actualUser;


  String get userName => _userName;
  bool get connected => _connected;
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
  }
}