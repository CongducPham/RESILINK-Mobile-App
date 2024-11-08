import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/home_navigation/service/home_navigation_services.dart';

import '../../../models/AssetType.dart';
import '../../../providers/main_provider.dart';

class HomeNavigationProvider with ChangeNotifier {

  // Constructor
  HomeNavigationProvider();

  // Variables and their initialization
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  HomeNavigationServices _homeNavigationServices = HomeNavigationServices();
  bool _settingAssetTypes = false;

  bool _hasResultSearch = false;
  Map<String, AssetType> _allAssetType = {};

  // Getters
  int get selectedIndex => _selectedIndex;
  bool get hasResultSearch => _hasResultSearch;
  PageController get pageController => _pageController;
  Map<String, AssetType> get allAssetType => _allAssetType;
  bool get settingAssetTypes => _settingAssetTypes;

  // Setters
  void setHasResultSearch(bool value) {
    _hasResultSearch = value;
  }

  void setSettingAssetTypes(bool value) {
    _settingAssetTypes = value;
  }

  // Set a new value for _selectedIndex and call the function to change the focused page on screen
  void setIndexAndUpdateHeader(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  // Retrieve all AssetTypes from API , displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> setAssetTypesAndGetUser(BuildContext context) async {

    // Set _settingAssetTypes to true to notify view that the function doesn't need tu be recall
    setSettingAssetTypes(true);

    /*
     * Calls getUserDataAndToken to set the user data and token for API,
     * Then calls the fetching AssetTypes function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _loadingFetchPurchase to false to notify the parent calling the function that the function has finished
     */
    try {
      await _homeNavigationServices.fetchAllAssetTypes(_allAssetType, context.read<MainProvider>().actualUser!.accessToken);
      context.read<HomeNavigationProvider>().setHasResultSearch(true);
    } catch (e) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemRetrievingAssetType),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.textOk),
            ),
          ],
        ),
      );
    }
  }

}
