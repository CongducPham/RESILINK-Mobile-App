import 'package:flutter/material.dart';

import '../../../models/AssetType.dart';

class HomeNavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  String _headerText = "Home";
  PageController _pageController = PageController(initialPage: 0);

  /* Container for SearchPage, needed to get back properly on the result page in case of offerdetail called
  searchPage = 0;
  resultSearch = 1;
  offerDetails = 2;
   */
  bool _hasResultSearch = false;

  final List<String> _headerListValue = [
    "Home",
    "Search",
    "Publish",
    "News",
    "Account"
  ];

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
  String get headerText => _headerText;
  PageController get pageController => _pageController;
  Map<String, AssetType> get allAssetType => _allAssetType;

  // Setter
  void setIndexAndUpdateHeader(int index) {
    _selectedIndex = index;
    _headerText = _headerListValue[index];
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  void setActualPageOnItemTapped(int index) {
      _selectedIndex = index;
      _headerText = _headerListValue[index];
      //add again to add animation for changing page
      /*_pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

       */
      _pageController.jumpToPage(index);
      notifyListeners();
  }

  void setHasResultSearch(bool value) {
    _hasResultSearch = value;
  }

}
