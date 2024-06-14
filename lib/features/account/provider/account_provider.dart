import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/Asset.dart';
import '../../../models/Offer.dart';
import '../../../models/SpecificRent.dart';

class AccountProvider with ChangeNotifier {
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _firstname = TextEditingController(text: "");
  TextEditingController _lastname = TextEditingController(text: "");
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _job = TextEditingController(text: "");
  TextEditingController _phoneNumber = TextEditingController(text: "");
  TextEditingController _location = TextEditingController(text: "");

  List<Offer> _lastOfferPublish = [
    Offer(offerId: 0, offerer: "acazaux", assetId: 0, beginTimeSlot: "4/06/2024", endTimeSlot: "05/06/2024", validityLimit: "05/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: null),
    Offer(offerId: 4, offerer: "acazaux", assetId: 4, beginTimeSlot: "4/06/2024", endTimeSlot: "05/06/2024", validityLimit: "05/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: SpecificRent(delayMargin: 0, lateRestitutionPenality: 0, deteriorationPenality: 0, nonRestitutionPenality: 0)),
  ];

  Map<int, Asset> _offerAssets = {
    0: Asset(id: 0, name: "Cucumber", description: "", assetType: "Crop", owner: "acazaux", transactionType: "sale/purchase", totalQuantity: 50, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "fales", image: "", specificAttributes: null),
    4: Asset(id: 4, name: "machine worker", description: "I can work with harvesting tractors and seeders", assetType: "Labor", owner: "acazaux", transactionType: "rent", totalQuantity: null, unit: "", availableQuantity: 0, regulatedId: "", regulator: "false", image: "", specificAttributes: null),
  };

  bool _error = false;

  TextEditingController get username => _username;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get job => _job;
  TextEditingController get phoneNumber => _phoneNumber;
  TextEditingController get location => _location;

  bool get error => _error;

  List<Offer> get lastOfferPublish => _lastOfferPublish;
  Map<int, Asset> get listOfferAsset => _offerAssets;

  void checkValueValid (BuildContext context ) {
  }

  void setError(bool newValue) async {
    Timer(const Duration(seconds: 5), () {
      _error = newValue;
    });
  }
}