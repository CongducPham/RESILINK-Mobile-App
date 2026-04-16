import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/publish/services/publish_services.dart';
import 'package:location/location.dart';

import '../../../common/service/date_manager.dart';
import '../../../models/Asset.dart';
import '../../../models/Offer.dart';
import '../../../models/SpecificAttrModel.dart';
import '../../../providers/main_provider.dart';

class PublishProvider extends ChangeNotifier {

  /*
   * This constructor initializes variables based on the context in which the `PublishProvider` is created.
   * If it's for updating an existing offer (i.e., `offerToUpdate` and `assetToUpdate` are not null), all relevant variables are initialized with existing data for editing.
   * If it's for creating a new offer (i.e., both are null), variables are simply initialized with defaults.
   */
  PublishProvider({this.offerToUpdate, this.assetToUpdate, required List<String> offerTransactionTypeList, required BuildContext context}) {
    _assetType = assetToUpdate != null ? _publishServices.getCorrectAssetTypeRegex(assetToUpdate!.assetType) : "";
    _selected = assetToUpdate != null ? true : false;
    _offerName = TextEditingController(text: assetToUpdate?.name ?? "");
    _offerTransactionTypeList.addAll(offerTransactionTypeList);
    _offerTransactionType = offerToUpdate?.transactionType ?? _offerTransactionTypeList[0];
    if (offerToUpdate != null && assetToUpdate != null) {
      _acceptSharing = offerToUpdate!.acceptSharing;
      _assetTypeList.addAll(getListAssetTypeResilink(context.read<HomeNavigationProvider>().allAssetType.keys.toList()));
      _specificAttributes.addAll(context.read<HomeNavigationProvider>().allAssetType[_assetType]!.assetDataModel!.toList());
      for (var attr in _specificAttributes) {
        _specificAttributeValue[attr.name] = TextEditingController(text: "");
      }
      for (var attr in assetToUpdate!.specificAttributes!) {
        if (attr.attributeName != "City/Village") {
          _specificAttributeValue[attr.attributeName] = TextEditingController(text: attr.value != null ? attr.value : _specificAttributeValue[attr.attributeName].text);
        } else {
          _offerCityVillage = TextEditingController(text: attr.value);
        }
      }
      _offerLocalisation = _specificAttributeValue['GPS'] ?? TextEditingController(text: "");
      for (var images in assetToUpdate!.images!) {
        _imageList.add(images);
      }
      _isFormValid = true;
    } else {
      _assetTypeList.addAll(getListAssetTypeResilink(context.read<HomeNavigationProvider>().allAssetType.keys.toList()));
      if (context.read<MainProvider>().actualUser!.gps != null && context.read<MainProvider>().actualUser!.gps != "") {
        _offerLocalisation = TextEditingController(text: context.read<MainProvider>().actualUser!.gps);
        _offerCityVillage = TextEditingController(text: "");
      } else {
        _offerLocalisation = TextEditingController(text: "");
        _offerCityVillage = TextEditingController(text: context.read<MainProvider>().actualProsumer?.location ?? "");
      }
    }
    _offerPrice = TextEditingController(text: offerToUpdate?.price.toString() ?? "0");
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
  TextEditingController _offerCityVillage = TextEditingController(text: "");
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
  bool _acceptSharing = true;

  Map<String, String> _transationTypeMap = {
    "sale/purchase": "sale/purchase",
    "rent": "rent",
    "بيع/شراء": "sale/purchase",
    "إيجار": "rent",
  };

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
  String _offerDurationRange = "month";

  // Dispose of controllers
  @override
  void dispose() {
    _offerName.dispose();
    _offerLocalisation.dispose();
    _offerCityVillage.dispose();
    _contactName.dispose();
    _contactFarm.dispose();
    _contactNumber.dispose();
    _contactEmail.dispose();
    _offerDescription.dispose();
    _offerPrice.dispose();
    _offerDuration.dispose();
    _specificAttributeValue.clear();
    _specificAttributeValue.forEach((key, controller) {
      if (controller is TextEditingController) {
        controller.dispose();
      }
    });
    super.dispose();
  }

  // Getters
  TextEditingController get offerName => _offerName;
  TextEditingController get offerLocalisation => _offerLocalisation;
  TextEditingController get offerCityVillage => _offerCityVillage;
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
  bool get acceptSharing => _acceptSharing;

  TextEditingController get contactName => _contactName;
  TextEditingController get contactFarm => _contactFarm;
  TextEditingController get contactNumber => _contactNumber;
  TextEditingController get contactEmail => _contactEmail;

  TextEditingController get offerDescription => _offerDescription;
  FocusNode get focusNodeDescription => _focusNodeDescription;
  TextEditingController get offerPrice => _offerPrice;
  TextEditingController get offerDuration => _offerDuration;
  String get offerDurationRange => _offerDurationRange;

  List<SpecificAttrModel> get specificAttributes => _specificAttributes;
  Map<String, dynamic> get specificAttributeValue=> _specificAttributeValue;



  // Takes a list to eliminate duplicates (assetTypes), then returns a list
  List<String> getListAssetTypeResilink(List<String> listAssetType) {
    final Set<String> result = {};
    for (String assetType in listAssetType) {
      String cleanType = _publishServices.getCorrectAssetTypeRegex(assetType);

      // Check if the cleaned assetType is in the allowed list
      if (GlobalVariables.allowedAndOrderedAssetTypes.contains(cleanType)) {
        result.add(cleanType);
      }
    }

    return result.toList();
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
      _specificAttributes.addAll(context.read<HomeNavigationProvider>().allAssetType[_assetType]?.assetDataModel ?? []);
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

  void setAcceptSharing(bool value) {
    _acceptSharing = value;
    notifyListeners();
  }

  void setSpecificAttributes(dynamic value, String name) {
    _specificAttributeValue[name].text = value;
  }

  // Ask for permissions to get GPS coord.
  Future<void> setLocalisationOnGPS() async {
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

  void setLocalisation(String gps) async {
    _offerLocalisation.text = gps;
    checkFormValidity();
    notifyListeners();
  }

  // Checks if conditions are right for _optionActive to be true (=> clickable option button on page)
  void checkFormValidity() {
    _isFormValid = offerName.text.isNotEmpty && (offerLocalisation.text.isNotEmpty || offerCityVillage.text.isNotEmpty) && offerTransactionType.isNotEmpty && assetType.isNotEmpty;
    if (!_isFormValid && _optionActive) {
      _optionActive = false;
      _specificAttributes = [];
      _specificAttributeValue = {};
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
  void  removeElementImageList (int index) {
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
        "assetId": 0,
        "transactionType": _transationTypeMap[_offerTransactionType],
        "beginTimeSlot": dateToGMTPlus1(),
        "endTimeSlot": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())),
        "validityLimit": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())),
        "offeredQuantity": 1,
        "price": int.parse(_offerPrice.text),
        "deposit": 0,
        "paymentMethod": "total",
        "paymentFrequency": 0,
        "cancellationFee": 0,
        "country": context.read<MainProvider>().country,
        "rentInformation": {
          "delayMargin": 0,
          "lateRestitutionPenalty": 0,
          "deteriorationPenalty": 0,
          "nonRestitutionPenalty": 0
        }
      };
      Map<String, dynamic> asset = {
        "name": _offerName.text,
        "description": _offerDescription.text,
        "assetType": _assetType,
        "multiAccess": true,
        "unit": "",
        "totalQuantity": 1,
        "images": _imageList,
      };
      asset['specificAttributes'] = [];
      _specificAttributeValue.forEach((key, value) {
        if (key != "GPS" && key != "City/Village") {
          asset['specificAttributes'].add({'attributeName': key, 'value': value.text ?? ""});
        }
      });
      if (_offerCityVillage.text != null && _offerCityVillage.text.isNotEmpty) {
        asset['specificAttributes'].add({'attributeName': "City/Village", 'value': _offerCityVillage.text});
        asset['specificAttributes'].add({'attributeName': "GPS", 'value': ""});
      } else {
        asset['specificAttributes'].add({'attributeName': "GPS", 'value': _offerLocalisation.text});
        asset['specificAttributes'].add({'attributeName': "City/Village", 'value': ""});
      }

      await _publishServices.publishOffer({'offer': offer, 'asset': asset}, context.read<MainProvider>().actualUser!.accessToken);
      // A new assetType has been created so need to retrieves the assetTypes
      // await homeNavigationProvider.setAssetTypesAndGetUser(context);
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
      List<String> _imageToUpdate = [];

      for (var element in _imageList) {
        if (element.contains("https://")) {
          _imageToUpdate.add(await _publishServices.convertImageToBase64(element));
        } else {
          _imageToUpdate.add(element);
        }
      }

      Map<String, dynamic> offer = {
        "assetId": context.read<MainProvider>().assetDetails!.id,
        "beginTimeSlot": context.read<MainProvider>().offerDetails!.beginTimeSlot,
        "endTimeSlot": _addDuration ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())) : context.read<MainProvider>().offerDetails!.validityLimit,
        "validityLimit": _addDuration ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(addDurationToDate(int.parse(_offerDuration.text), _offerDurationRange, DateTime.now())) : context.read<MainProvider>().offerDetails!.validityLimit,
        "price": int.parse(_offerPrice.text),
        "deposit": 0,
        "cancellationFee": 0,
        "offeredQuantity": 1,
        "paymentMethod": "total",
        "paymentFrequency": 0,
        "rentInformation": {
          "delayMargin": 0,
          "lateRestitutionPenalty": 0,
          "deteriorationPenalty": 0,
          "nonRestitutionPenalty": 0
        }
      };

      Map<String, dynamic> asset = {
        "name": _offerName.text,
        "description": _offerDescription.text,
        "assetType": _assetType,
        "unit": context.read<MainProvider>().assetDetails!.unit,
        "multiAccess": true,
        "totalQuantity": 1,
        "images": _imageToUpdate,
      };

      // Add specificAttributes dynamically with what is in _specificAttributeValue
      asset['specificAttributes'] = [];
      _specificAttributeValue.forEach((key, value) {
        if (key != "City/Village") {
          asset['specificAttributes'].add({'attributeName': key, 'value': value.text ?? ""});
        }
      });
      asset['specificAttributes'].add({'attributeName': "City/Village", 'value': _offerCityVillage.text});

      await _publishServices.updateOfferAsset(context.read<MainProvider>().actualUser!.accessToken, {'asset': asset, 'offer': offer}, context.read<MainProvider>().offerDetails!.id!);
      Navigator.of(context).pop();
      context.read<MainProvider>().clearOfferAssetContractViewDetails();
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