import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/features/publish/services/publish_services.dart';
import 'package:Resilink/features/search/service/search_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/service/date_manager.dart';
import '../../../models/Asset.dart';
import '../../../models/Filter.dart';
import '../../../models/Offer.dart';
import '../../../models/SpecificRent.dart';
import '../../../providers/main_provider.dart';

class SearchProvider extends ChangeNotifier {

  // Constructor
  SearchProvider(HomeNavigationProvider provider, MainProvider mainProvider)
      : _localisationController = TextEditingController(text: ""),
        _searchController = TextEditingController(text: ""),
        _cityVillageController = TextEditingController(text: ""),
        _assetTypeNames = provider.allAssetType.keys.toList(),
        _searchControllerFocusNode = FocusNode() {
    _allSuggestion = List.from(_assetTypeNames);

    _searchController.addListener(() {
      _allSuggestion = _assetTypeNames
          .where((item) =>
          item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
      notifyListeners();
    });
  }

  // Variables and their initialization
  List<String> _allSuggestion = [];
  List<String> _assetTypeNames;

  bool _selected = false;
  bool _isFormValid = false;
  bool _isSearchDone = false;
  double _distance = 10;
  TextEditingController _localisationController;
  TextEditingController _searchController;
  TextEditingController _cityVillageController;
  final FocusNode _searchControllerFocusNode;

  SearchServices _searchServices = SearchServices();
  Filter _filter = Filter();

  List<Offer> _searchedOffer = [];
  Map<int, Asset> _offerAssets = {};

  // Getters
  List<String> get allSugestion => _allSuggestion;
  bool get selected => _selected;
  bool get isFormValid => _isFormValid;
  bool get isSearchDone => _isSearchDone;
  double get distance => _distance;
  TextEditingController get localisationController => _localisationController;
  TextEditingController get cityVillageController => _cityVillageController;
  TextEditingController get searchController => _searchController;
  FocusNode get searchControllerFocusNode => _searchControllerFocusNode;
  Filter get filter => _filter;
  List<Offer> get searchedOffer => _searchedOffer;
  List<String> get assetTypeNames => _assetTypeNames;
  Map<int, Asset> get offerAssets => _offerAssets;

  // Gets the translated asset type name
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
    }
    return tradAssetType;
  }

  // Gets a unique list of asset types after conversion
  List<String> getListAssetTypeResilink(List<String> listAssetType, BuildContext context) {
    List<String> result = [];

    PublishServices publishServices = PublishServices();

    for (String assetType in listAssetType) {
      String input = publishServices.getCorrectAssetTypeRegex(assetType);
      result.add(input);
    }

    return result.toSet().toList(); // Convertir en ensemble pour éliminer les doublons, puis revenir à la liste
  }

  // Checks if the form is valid
  void checkFormValidity() {
    _isFormValid = (_searchController.text.isNotEmpty || _filter.assetType.isNotEmpty ) && _localisationController.text.isNotEmpty;
    notifyListeners();
  }

  // Setters
  // Sets selection and checks form validity
  void setSelected(bool newValue) {
    _selected = newValue;
    checkFormValidity();
  }

  // Updates search controller text and selection status
  void setSearchControllerAndSelected(String newValue, bool selected) {
    newValue.isNotEmpty ? _searchController.text = newValue : _searchController.clear();
    setSelected(selected);
  }

  void setSearchDone(bool value) {
    _isSearchDone = value;
    if (!value) {
      _searchedOffer = [];
      _offerAssets = {};
    }
    notifyListeners();
  }

  void setDistance(double value) {
    _distance = value;
    notifyListeners();
  }

  // Retrieves the user's location
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

  // Performs a filtered offer search and updates results
  Future<void> setOfferFiltered(BuildContext context) async {

    // Set a popup to wait for fetching offers
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
      // Fetch list of filtered offers and all assets
      await _searchServices.fetchOfferFiltered(_searchedOffer, _filter.getMapFilter(), context.read<MainProvider>().actualUser!.accessToken);
      if (_searchedOffer.isNotEmpty) {
        await _searchServices.fetchAsset(_offerAssets, context
            .read<MainProvider>()
            .actualUser!
            .accessToken);
      }
      Navigator.of(context).pop();
      context.read<HomeNavigationProvider>().setHasResultSearch(true);
      setSearchDone(true);
    } catch (e) {

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

  // Handles the purchase of services by creating a request and a contract
  Future<void> buyingServices(BuildContext context, Asset asset, Offer offer, HomeNavigationProvider homeNavigationProvider) async {

    // Set a popup to wait for fetching offers
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
            'endTimeSlot': (asset.transactionType == "rent" && homeNavigationProvider.allAssetType[asset.assetType]!.nature == "material" ) && context.read<HomeNavigationProvider>().allAssetType[asset.assetType]!.nature != "immaterial" ? offer.endTimeSlot : offer.validityLimit,
            'validityLimit': offer.validityLimit,
            'transactionType': asset.transactionType,
            'offerIds': [offer.offerId],
          },
          context.read<MainProvider>().actualUser!.accessToken
      );
      await _searchServices.createContract(offer.offerId!, requestId, context.read<MainProvider>().actualUser!.accessToken);
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

  // Call function to add an offer id in the prosumer blockedOffers list
  Future<void> addBlockedOffer (BuildContext context, Offer offer, HomeNavigationProvider homeNavigationProvider) async {

    // Set a popup to wait for blocking an offer
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
      await _searchServices.setOfferInBlockedOfferList(offer.offerId!, context.read<MainProvider>().actualUser!.username, context.read<MainProvider>().actualUser!.accessToken);
      Navigator.of(context).pop();
      homeNavigationProvider.setIndexAndUpdateHeader(0);
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

}
