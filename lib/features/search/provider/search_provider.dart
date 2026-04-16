import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/features/search/service/search_services.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/service/date_manager.dart';
import '../../../models/Asset.dart';
import '../../../models/Filter.dart';
import '../../../models/Offer.dart';
import '../../../providers/main_provider.dart';

class SearchProvider extends ChangeNotifier {

  // Constructor
  SearchProvider(HomeNavigationProvider provider, MainProvider mainProvider, BuildContext context)
      : _localisationController = TextEditingController(text: ""),
        _searchController = TextEditingController(text: ""),
        _cityVillageController = TextEditingController(text: ""),
        _countryController = TextEditingController(text: mainProvider.country),
        _searchControllerFocusNode = FocusNode() {
    _assetTypeNames = getListAssetTypeResilink(provider.allAssetType.keys.toList(), context);
    _allSuggestion = List.from(_assetTypeNames);
    _searchController.addListener(() {
      _allSuggestion = _assetTypeNames
          .where((item) =>
          item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
      notifyListeners();
    });
  }

  // Variables
  List<String> _allSuggestion = [];
  List<String> _assetTypeNames = [];
  bool _selected = false;
  bool _isFormValid = false;
  bool _isSearchDone = false;
  double _distance = 10;
  TextEditingController _localisationController;
  TextEditingController _countryController;
  TextEditingController _searchController;
  TextEditingController _cityVillageController;
  final FocusNode _searchControllerFocusNode;
  SearchServices _searchServices = SearchServices();
  Filter _filter = Filter();

  List<Offer> _searchedOffer = [];
  Map<String, Asset> _offerAssets = {}; // key: "serverUrl|assetId"

  // Getters
  List<String> get allSugestion => _allSuggestion;
  bool get selected => _selected;
  bool get isFormValid => _isFormValid;
  bool get isSearchDone => _isSearchDone;
  double get distance => _distance;
  TextEditingController get localisationController => _localisationController;
  TextEditingController get countryController => _countryController;
  TextEditingController get cityVillageController => _cityVillageController;
  TextEditingController get searchController => _searchController;
  FocusNode get searchControllerFocusNode => _searchControllerFocusNode;
  Filter get filter => _filter;
  List<Offer> get searchedOffer => _searchedOffer;
  List<String> get assetTypeNames => _assetTypeNames;
  Map<String, Asset> get offerAssets => _offerAssets; // key: "serverUrl|assetId"

  // Gets a unique list of asset types after conversion
  List<String> getListAssetTypeResilink(List<String> listAssetType, BuildContext context) {
    List<String> result = [];
    for (String assetType in listAssetType) {
      String input = _searchServices.getCorrectAssetTypeRegex(assetType);
      result.add(input);
    }
    return result.toSet().toList();
  }

  // Checks if the form is valid
  void checkFormValidity() {
    _isFormValid = (_searchController.text.isNotEmpty || _filter.assetType.isNotEmpty) && _localisationController.text.isNotEmpty;
    notifyListeners();
  }

  void setSelected(bool newValue) {
    _selected = newValue;
    checkFormValidity();
  }

  void setSearchControllerAndSelected(String newValue, bool selected) {
    newValue.isNotEmpty ? _searchController.text = newValue : _searchController.clear();
    setSelected(selected);
  }

  void setDistance(double value) {
    _distance = value;
    notifyListeners();
  }

  Future<void> setLocalisationByGPS() async {
    Location location = Location();
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      _localisationController.text = '<${locationData.latitude},${locationData.longitude}>';
      filter.setCoordinate(locationData.latitude!, locationData.longitude!);
    }
  }

  void setLocalisation(String gps) async {
    _localisationController.text = gps;
    if (gps.isNotEmpty) {
      gps = gps.replaceAll('<', '').replaceAll('>', '');
      List<String> parts = gps.split(',');
      filter.setCoordinate(double.parse(parts[0]), double.parse(parts[1]));
    } else {
      filter.clearCoordinate();
    }
    notifyListeners();
  }

  void setCityVillage(String cityVillage) async {
    filter.setCityVillage(cityVillage);
  }

  void setSearchDone(bool value) {
    _isSearchDone = value;
    if (!value) {
      _searchedOffer = [];
      _offerAssets = {};
    }
    notifyListeners();
  }

  Future<void> setOfferFiltered(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context)!.titlePopUpLoadingSearch),
              ],
            ),
          ),
        );
      },
    );

    try {
      filter.setDistanceKilometer(_distance);
      filter.setCountry(_countryController.text);

      _searchedOffer.clear();
      _offerAssets.clear();

      await _searchServices.fetchOfferFilteredWithAssets(
        _searchedOffer,
        _offerAssets,
        _filter.getMapFilter(),
        context.read<MainProvider>().actualUser!.accessToken,
      );

      Navigator.of(context).pop();
      context.read<HomeNavigationProvider>().setHasResultSearch(true);
      setSearchDone(true);
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemLoadingOffer),
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
    notifyListeners();
  }

  Future<void> buyingServices(BuildContext context, Asset asset, Offer offer, HomeNavigationProvider homeNavigationProvider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context)!.titlePopUpBuyingOffer),
              ],
            ),
          ),
        );
      },
    );

    try {
      int requestId = await _searchServices.createRequestWithId(
        {
          'requestor': context.read<MainProvider>().actualUser!.username,
          'beginTimeSlot': dateToGMTPlus1(),
          'endTimeSlot': (offer.transactionType == "rent" && homeNavigationProvider.allAssetType[asset.assetType]!.nature == "material") &&
              context.read<HomeNavigationProvider>().allAssetType[asset.assetType]!.nature != "immaterial"
              ? offer.endTimeSlot
              : offer.validityLimit,
          'validityLimit': offer.validityLimit,
          'transactionType': offer.transactionType,
          'offerIds': [offer.id],
        },
        context.read<MainProvider>().actualUser!.accessToken,
      );
      await _searchServices.createContract(offer.id!, requestId, context.read<MainProvider>().actualUser!.accessToken);
      Navigator.of(context).pop();
      homeNavigationProvider.setIndexAndUpdateHeader(4);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemBuyingOffer),
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

  Future<void> addBlockedOffer(BuildContext context, Offer offer, HomeNavigationProvider homeNavigationProvider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context)!.titlePopUpBlockingOffer),
              ],
            ),
          ),
        );
      },
    );

    try {
      await _searchServices.setOfferInBlockedOfferList(
        offer.id!,
        context.read<MainProvider>().actualUser!.username,
        context.read<MainProvider>().actualUser!.accessToken,
        offer.serverUrl,
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemBlockingOffer),
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

  /// Removes a blocked offer and its asset from the search results list.
  /// [assetKey] must be the composite key "serverUrl|assetId".
  void removeBlockedOffer(Offer offer, String assetKey) {
    _searchedOffer.remove(offer);
    _offerAssets.remove(assetKey);
    notifyListeners();
  }
}