import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/AssetType.dart';

class HomeNavigationProvider with ChangeNotifier {

  HomeNavigationProvider();

  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  bool _hasResultSearch = false;

  final Map<String, AssetType> _allAssetType = {
    "Fruit": AssetType(name: "Fruit", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Vegetable": AssetType(name: "Vegetable", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Crop": AssetType(name: "Crop", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Machinery": AssetType(name: "Machinery", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Transport":AssetType(name: "Transport", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Inputs":AssetType(name: "Inputs", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Storage":AssetType(name: "Storage", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Labor":AssetType(name: "Labor", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
    "Other services":AssetType(name: "Other services", description: "", nature: "immaterial", unit: "kg", regulated: false, regulator: "", sharingIncentive: false, specificAttrModel: []),
  };

  // Getter
  int get selectedIndex => _selectedIndex;
  bool get hasResultSearch => _hasResultSearch;
  PageController get pageController => _pageController;
  Map<String, AssetType> get allAssetType => _allAssetType;

  // Setter
  void setIndexAndUpdateHeader(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  void setHasResultSearch(bool value) {
    _hasResultSearch = value;
  }

}
