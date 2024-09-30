import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/publish/services/publish_services.dart';
import 'package:location/location.dart';

import '../../../common/service/date_manager.dart';
import '../../../models/Asset.dart';
import '../../../models/Offer.dart';
import '../../../models/SpecificAttrModel.dart';
import '../../../providers/main_provider.dart';
import '../../home_navigation/screen/home_navigation_screen.dart';

class PublishProvider extends ChangeNotifier {

  /*
   * This constructor initializes variables based on the context in which the `PublishProvider` is created.
   * If it's for updating an existing offer (i.e., `offerToUpdate` and `assetToUpdate` are not null), all relevant variables are initialized with existing data for editing.
   * If it's for creating a new offer (i.e., both are null), variables are simply initialized with defaults.
   */
  PublishProvider({this.offerToUpdate, this.assetToUpdate, required List<String> offerTransactionTypeList, required BuildContext context}) {
    _assetType = assetToUpdate?.assetType ?? "";
    _selected = assetToUpdate != null ? true : false;
    _offerName = TextEditingController(text: assetToUpdate?.name ?? "");
    _offerTransactionTypeList.addAll(offerTransactionTypeList);
    _offerTransactionType = assetToUpdate?.transactionType ?? _offerTransactionTypeList[0];
    if (offerToUpdate != null && assetToUpdate != null) {
      _assetTypeList.addAll(getListAssetTypeResilink(context.read<HomeNavigationProvider>().allAssetType.keys.toList()));
      _specificAttributes.addAll(context.read<HomeNavigationProvider>().allAssetType[_assetType]!.specificAttrModel!.toList());
      for (var attr in _specificAttributes) {
        _specificAttributeValue[attr.name] = TextEditingController(text: "");
      }
      for (var attr in assetToUpdate!.specificAttributes!) {
        _specificAttributeValue[attr.attributeName] = TextEditingController(text: attr.value != null ? attr.value : _specificAttributeValue[attr.attributeName].text);
      }
      _offerLocalisation = _specificAttributeValue['GPS'] ?? TextEditingController(text: "");
      _isFormValid = true;
    } else {
      _assetTypeList.addAll(getListAssetTypeResilink(context.read<HomeNavigationProvider>().allAssetType.keys.toList()));
    }
    _offerPrice = TextEditingController(text: offerToUpdate?.price.toString() ?? "0");
    _offerQuantity = TextEditingController(text: assetToUpdate?.totalQuantity.toString() ?? "10");
    _offerDescription = TextEditingController(text: assetToUpdate?.description ?? "");
    _contactNumber = TextEditingController(text: context.read<MainProvider>().actualUser!.phoneNumber);
    _contactName = TextEditingController(text: context.read<MainProvider>().actualUser!.username);
    _contactEmail = TextEditingController(text: context.read<MainProvider>().actualUser!.email);
    _contactFarm = TextEditingController(text: context.read<MainProvider>().actualProsumer!.location);
  }

  // Variables and their initialization

  final Offer? offerToUpdate;
  final Asset? assetToUpdate;
  // Variables for data in the mandatory part of the offer
  TextEditingController _offerName = TextEditingController(text: "");
  TextEditingController _offerLocalisation = TextEditingController(text: "");
  String _assetType = "";
  bool _selected = false;
  String _offerTransactionType = "";
  List<String> _offerTransactionTypeList = [];
  List<String> _assetTypeList = [];
  List<String> _imageList = [];

  bool _contactInfoActive = false;
  bool _optionActive = false;
  bool _isFormValid = false;
  bool _addDuration = false;

  List<SpecificAttrModel> _specificAttributes = [];
  Map<String, dynamic> _specificAttributeValue = {};

  PublishServices _publishServices = PublishServices();

  // User data variables
  TextEditingController _contactName = TextEditingController(text: "");
  TextEditingController _contactFarm = TextEditingController(text: "");
  TextEditingController _contactNumber = TextEditingController(text: "");
  TextEditingController _contactEmail = TextEditingController(text: "");

  // Variables for data in the optional information section of the offer
  TextEditingController _offerDescription = TextEditingController(text: "");
  FocusNode _focusNodeDescription = FocusNode();
  TextEditingController _offerPrice = TextEditingController(text: "0");
  TextEditingController _offerDuration = TextEditingController(text: "1");
  TextEditingController _offerQuantity = TextEditingController(text: "10");
  String _offerDurationRange = "month";

  // Getters
  TextEditingController get offerName => _offerName;
  TextEditingController get offerLocalisation => _offerLocalisation;
  String get assetType => _assetType;
  bool get selected => _selected;
  String get offerTransactionType => _offerTransactionType;
  List<String> get offerTransactionTypeList => _offerTransactionTypeList;
  List<String> get assetTypeList => _assetTypeList;
  List<String> get imageList => _imageList;

  bool get contactInfoActive => _contactInfoActive;
  bool get optionActive => _optionActive;
  bool get isFormValid => _isFormValid;
  bool get addDuration => _addDuration;

  TextEditingController get contactName => _contactName;
  TextEditingController get contactFarm => _contactFarm;
  TextEditingController get contactNumber => _contactNumber;
  TextEditingController get contactEmail => _contactEmail;

  TextEditingController get offerDescription => _offerDescription;
  FocusNode get focusNodeDescription => _focusNodeDescription;
  TextEditingController get offerPrice => _offerPrice;
  TextEditingController get offerDuration => _offerDuration;
  TextEditingController get offerQuantity => _offerQuantity;
  String get offerDurationRange => _offerDurationRange;

  List<SpecificAttrModel> get specificAttributes => _specificAttributes;
  Map<String, dynamic> get specificAttributeValue=> _specificAttributeValue;

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
    }
    return tradAssetType;
  }

  // Takes a list to eliminate duplicates (assetTypes), then returns a list
  List<String> getListAssetTypeResilink(List<String> listAssetType) {
    List<String> result = [];

    for (String assetType in listAssetType) {
      String input = _publishServices.getCorrectAssetTypeRegex(assetType);
      result.add(input);
    }

    return result.toSet().toList();
  }

  // Setters
  void setContactInfoActive(bool value) {
    _contactInfoActive = value;
    notifyListeners();
  }

  /*
   * Set _optionActive to value, if true, initialise specificAttributes if it's empty
   * When _optionActive is true, display new data to the user to fill.
   */
  void setOptionActive(bool value, HomeNavigationProvider homeNavigationProvider, BuildContext context) {
    _optionActive = value;
    if (value && specificAttributes.isEmpty) {
      _specificAttributes.addAll(context.read<HomeNavigationProvider>().allAssetType[_assetType]?.specificAttrModel ?? []);
      for (var attr in _specificAttributes) {
        _specificAttributeValue[attr.name] = TextEditingController(text: attr.name == "Condition"? "fair" : "");
      }
    }
    notifyListeners();
  }

  // Set _assetType and _selected and call checkFormValidity to update the page displayed
  void setAssetTypeAndIsSelected(String value, bool selected) {
    _assetType = value;
    _selected = selected;
    checkFormValidity();
  }

  void setOfferDurationRange(String value) {
    _offerDurationRange = value;
    notifyListeners();
  }

  void setOfferTransaction(String value) {
    _offerTransactionType = value;
  }

  void setAddDuration(bool value) {
    _addDuration = value;
    notifyListeners();
  }

  void setSpecificAttributes(dynamic value, String name) {
    _specificAttributeValue[name] = value;
  }

  // Ask for permissions to get
  Future<void> setLocalisation() async {
    Location location = Location();
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      _offerLocalisation.text = '<${locationData.latitude},${locationData.longitude}>';
    }
  }

  // Checks if conditions are right for _optionActive to be true (=> clickable option button on page)
  void checkFormValidity() {
    _isFormValid = offerName.text.isNotEmpty && offerLocalisation.text.isNotEmpty && offerTransactionType.isNotEmpty && assetType.isNotEmpty;
    if (!_isFormValid && _optionActive) {
      _optionActive = false;
    }
    notifyListeners();
  }

  // Set Description node focus to false
  void unFocus() {
    _focusNodeDescription.unfocus();
  }

  // Add the image base64 in String form
  void addElementImageList (String image) {
    _imageList.add(image);
  }

  // Delete an image base64 in String form
  void removeElementImageList (int index) {
    _imageList.removeAt(index);
  }

  // Publish an offer, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> publishOffer(BuildContext context, HomeNavigationProvider homeNavigationProvider) async {

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
                Text(AppLocalizations.of(context)!.titlePopUpPublishOffer),
              ],
            ),
          ),
        );
      },
    );

    // Calls the publish offer function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      // Set in maps the offer and asset data
      Map<String, dynamic> offer = {
        "offerer": context.read<MainProvider>().actualUser!.username,
        "assetId": 0,
        "beginTimeSlot": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        "validityLimit": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())),
        "price": int.parse(_offerPrice.text),
        "deposit": 0,
        "cancellationFee": 0,
      };
      Map<String, dynamic> asset = {
        "name": _offerName.text,
        "description": _offerDescription.text,
        "assetType": _assetType,
        "unit": "",
        "owner": context.read<MainProvider>().actualUser!.username,
        "transactionType": _offerTransactionType,
        "regulatedId": "",
        "regulator": "false",
        "images": _imageList,
      };
      asset['specificAttributes'] = [];
      _specificAttributeValue.forEach((key, value) {
        asset['specificAttributes'].add({'attributeName': key, 'value': value.text ?? ""});
      });
      asset['specificAttributes'].add({'attributeName': "GPS", 'value': _offerLocalisation.text});

      if (homeNavigationProvider.allAssetType[_assetType]!.nature == 'immaterial') {
        asset["totalQuantity"] = double.parse(_offerQuantity.text) + 1;
        offer['endTimeSlot'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now()));
        offer['offeredQuantity'] = int.parse(_offerQuantity.text);
        offer['remainingQuantity'] = int.parse(_offerQuantity.text);
      } else if (homeNavigationProvider.allAssetType[_assetType]!.nature == 'material' && offerTransactionType == "rent") {
        offer['endTimeSlot'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now()));
      }

      print(asset);
      await _publishServices.publishOffer({'offer': offer, 'asset': asset}, context.read<MainProvider>().actualUser!.accessToken);
      // A new assetType has been created so need to retrieves the assetTypes
      await homeNavigationProvider.setAssetTypesAndGetUser(context);
      Navigator.of(context).pop();
      homeNavigationProvider.setIndexAndUpdateHeader(0);
    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemPublishingOffer),
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

  // Update an offer, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> updateOfferAsset(BuildContext context, HomeNavigationProvider homeNavigationProvider) async {

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
                Text(AppLocalizations.of(context)!.titlePopUpUpdatingOffer),
              ],
            ),
          ),
        );
      },
    );

    // Calls the update offer function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      Map<String, dynamic> offer = {
        "offerer": context.read<MainProvider>().actualUser!.username,
        "assetId": context.read<MainProvider>().assetDetails!.id,
        "beginTimeSlot": context.read<MainProvider>().offerDetails!.beginTimeSlot,
        "validityLimit": _addDuration ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())) : context.read<MainProvider>().offerDetails!.validityLimit,
        "price": int.parse(_offerPrice.text),
        "deposit": 0,
        "cancellationFee": 0,
      };
      Map<String, dynamic> asset = {
        "name": _offerName.text,
        "description": _offerDescription.text,
        "assetType": _assetType,
        "unit": context.read<MainProvider>().assetDetails!.unit,
        "owner": context.read<MainProvider>().actualUser!.username,
        "transactionType": _offerTransactionType,
        "totalQuantity": _offerQuantity.text,
        "regulatedId": "",
        "regulator": "false",
        "images": _imageList,
      };

      // Add specificAttributes dynamically with what is in _specificAttributeValue
      asset['specificAttributes'] = [];
      _specificAttributeValue.forEach((key, value) {
        asset['specificAttributes'].add({'attributeName': key, 'value': value.text ?? ""});
      });

      if (offerTransactionType != "rent"){
        asset["totalQuantity"] = double.parse(_offerQuantity.text) + 1;
      }

      // Depending of the assetType nature (immaterial/material, adding/deleting some information
      if (homeNavigationProvider.allAssetType[_assetType]!.nature == 'immaterial') {
        offer['endTimeSlot'] = offer['validityLimit'];
        offer['offeredQuantity'] = double.parse(_offerQuantity.text);
      } else if (homeNavigationProvider.allAssetType[_assetType]!.nature == 'material') {
        asset.remove("totalQuantity");
        if (offerTransactionType == "rent"){
          offer['endTimeSlot'] = offer['validityLimit'];
        }
      }

      await _publishServices.updateOfferAsset(context.read<MainProvider>().actualUser!.accessToken, {'asset': asset, 'offer': offer}, context.read<MainProvider>().offerDetails!.offerId!);
      Navigator.of(context).pop();
      homeNavigationProvider.setIndexAndUpdateHeader(4);

    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemUpdatingOffer),
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
}