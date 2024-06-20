import 'package:flutter/material.dart';
import 'package:resilink_design/features/home_navigation/provider/home_navigation_provider.dart';

import '../../../models/Asset.dart';
import '../../../models/Filter.dart';
import '../../../models/Offer.dart';
import '../../../models/SpecificRent.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(HomeNavigationProvider provider)
      : _localisationController = TextEditingController(text: ""),
        _searchController = TextEditingController(text: ""),
        _assetTypeNames = provider.allAssetType.keys.toList(),
        _searchControllerFocusNode = FocusNode() {
    _allSugestion = List.from(_assetTypeNames);

    _searchController.addListener(() {
      _allSugestion = _assetTypeNames
          .where((item) =>
          item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
      notifyListeners();
    });
  }

  List<String> _allSugestion = [];
  List<String> _assetTypeNames;

  bool _selected = false;
  bool _isFormValid = false;
  bool _isSearchDone = false;
  double _distance = 10;
  TextEditingController _localisationController;
  TextEditingController _searchController;
  final FocusNode _searchControllerFocusNode;

  Filter filter = Filter();

  // TODO Make it dynamic with the call to get offers from API
  //Pour le moment Page home n'a pas de fonction pure donc mise en place de fausse news
  List<Offer> _searchedOffer = [Offer(offerId: 0, offerer: "acazaux", assetId: 0, beginTimeSlot: "4/06/2024", endTimeSlot: "25/06/2024", validityLimit: "25/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: null),
    Offer(offerId: 1, offerer: "Benguerir", assetId: 1, beginTimeSlot: "5/06/2024", endTimeSlot: "23/06/2024", validityLimit: "23/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: null),
    Offer(offerId: 2, offerer: "Karim", assetId: 2, beginTimeSlot: "5/06/2024", endTimeSlot: "23/06/2024", validityLimit: "23/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: SpecificRent(delayMargin: 0, lateRestitutionPenality: 0, deteriorationPenality: 0, nonRestitutionPenality: 0)),
  ];

  Map<int, Asset> _offerAssets = {
    0: Asset(id: 0, name: "Barley seed", description: "This late variety has good productivity with a high resistance to barley yellows. Negotiable offer, possibility of adding or removing stock.", assetType: "Crop", owner: "acazaux", transactionType: "sale/purchase", totalQuantity: 50, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "fales", image: "", specificAttributes: null),
    1: Asset(id: 1, name: "Apple", description: "Negotiable offer, possibility of adding or removing stock.", assetType: "Fruit", owner: "Benguerir", transactionType: "sale/purchase", totalQuantity: 50, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "false", image: "", specificAttributes: null),
    2: Asset(id: 2, name: "Warehouse", description: "Can store up to 50 tons of seeds or a few agricultural machines.", assetType: "Storage", owner: "Karim", transactionType: "rent", totalQuantity: null, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "false", image: "", specificAttributes: null),
  };

  List<String> get allSugestion => _allSugestion;
  bool get selected => _selected;
  bool get isFormValid => _isFormValid;
  bool get isSearchDone => _isSearchDone;
  double get distance => _distance;
  TextEditingController get localisationController => _localisationController;
  TextEditingController get searchController => _searchController;
  FocusNode get searchControllerFocusNode => _searchControllerFocusNode;
  List<Offer> get searchedOffer => _searchedOffer;
  List<String> get assetTypeNames => _assetTypeNames;
  Map<int, Asset> get offerAssets => _offerAssets;


  // Importer la fonction de récupération des assetTypes après tests de la navigation
  void setAllAssetType() {
  }

  void setSelected(bool newValue) {
    _selected = newValue;
    checkFormValidity();
  }

  void setSearchControllerAndSelected(String newValue, bool selected) {
    newValue.isNotEmpty ? _searchController.text = newValue : _searchController.clear();
    setSelected(selected);
  }

  void checkFormValidity() {
    _isFormValid = (_searchController.text.isNotEmpty || filter.assetType.isNotEmpty ) && _localisationController.text.isNotEmpty;
    notifyListeners();
  }

  void setSearchDone(bool value) {
    _isSearchDone = value;
    notifyListeners();
  }

  void setDistance(double value) {
    _distance = value;
    notifyListeners();
  }

}
