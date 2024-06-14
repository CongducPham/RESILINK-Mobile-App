import 'package:flutter/material.dart';
import 'package:resilink_design/common/widget/default_pop_up.dart';

class PublishProvider extends ChangeNotifier {

  PublishProvider(this._contactEmail, this._contactName, this._contactFarm, this._contactNumber);

  // Variables for data in the mandatory part of the offer
  TextEditingController _offerName = TextEditingController(text: "");
  TextEditingController _offerLocalisation = TextEditingController(text: "");
  String _assetType = "";
  bool _selected = false;
  String _offerTransactionType = "sale/purchase";
  List<String> _offerTransactionTypeList = ['sale/purchase', 'rent'];

  bool _contactInfoActive = false;
  bool _optionActive = false;
  bool _isFormValid = false;

  // User data variables
  TextEditingController _contactName = TextEditingController(text: "");
  TextEditingController _contactFarm = TextEditingController(text: "");
  TextEditingController _contactNumber = TextEditingController(text: "");
  TextEditingController _contactEmail = TextEditingController(text: "");

  // Variables for data in the optional information section of the offer
  TextEditingController _offerDescription = TextEditingController(text: "");
  TextEditingController _offerPrice = TextEditingController(text: "0");
  TextEditingController _offerDuration = TextEditingController(text: "1");
  TextEditingController _offerQuantity = TextEditingController(text: "10");
  String _offerDurationRange = "month";

  TextEditingController get offerName => _offerName;
  TextEditingController get offerLocalisation => _offerLocalisation;
  String get assetType => _assetType;
  bool get selected => _selected;
  String get offerTransactionType => _offerTransactionType;
  List<String> get offerTransactionTypeList => _offerTransactionTypeList;

  bool get contactInfoActive => _contactInfoActive;
  bool get optionActive => _optionActive;
  bool get isFormValid => _isFormValid;

  TextEditingController get contactName => _contactName;
  TextEditingController get contactFarm => _contactFarm;
  TextEditingController get contactNumber => _contactNumber;
  TextEditingController get contactEmail => _contactEmail;

  TextEditingController get offerDescription => _offerDescription;
  TextEditingController get offerPrice => _offerPrice;
  TextEditingController get offerDuration => _offerDuration;
  TextEditingController get offerQuantity => _offerQuantity;
  String get offerDurationRange => _offerDurationRange;


  void setContactInfoActive(bool value) {
    _contactInfoActive = value;
    notifyListeners();
  }

  void setOptionActive(bool value) {
    _optionActive = value;
    notifyListeners();
  }

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

  void checkFormValidity() {
    _isFormValid = offerName.text.isNotEmpty && offerLocalisation.text.isNotEmpty && offerTransactionType.isNotEmpty && assetType.isNotEmpty;
    if (!_isFormValid && _optionActive) {
      _optionActive = false;
    }
    notifyListeners();
  }

  void publishOffer(BuildContext context, String title, String message, String? buttonText) {
    DefaultPopUp.show(context, title, message, buttonText);
  }

}