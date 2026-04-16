import 'dart:async';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/account/service/account_services.dart';

import '../../../providers/main_provider.dart';

class AccountDataProvider with ChangeNotifier {

  // Parameter variables
  TextEditingController _id;
  TextEditingController _username;
  TextEditingController _firstname;
  TextEditingController _lastname;
  TextEditingController _email;
  TextEditingController _phoneNumber;
  TextEditingController _location;
  TextEditingController _gps;
  List<String> _activityDomainList = [];
  String _activityDomain = "";
  List<String> _activityProfessionList  = [];
  String _activityProfession = "";
  AccountServices _accountServices = AccountServices();

  // Constructor
  AccountDataProvider(BuildContext context, {
    String id = "",
    String username = "",
    String firstname = "",
    String lastname = "",
    String email = "",
    String phoneNumber = "",
    String location = "",
    String activityDomain = "",
    String activityProfession = "",
    String gps = "",
  })
      : _id = TextEditingController(text: id),
        _username = TextEditingController(text: username),
        _firstname = TextEditingController(text: firstname),
        _lastname = TextEditingController(text: lastname),
        _email = TextEditingController(text: email),
        _activityDomain = activityDomain,
        _activityProfession = activityProfession,
        _phoneNumber = TextEditingController(text: phoneNumber),
        _location = TextEditingController(text: location),
        _gps = TextEditingController(text: gps) {
    setActivityDomain(context);
    setFieldSpecialization(context, _activityDomain);
  }

  final List<String> activityDomainCodes = [
    "Crop Production", "Animal Production", "Traders", "Services", "Suppliers", "Consulting & Assistance", "Other"
  ];
  final Map<String, List<String>> activityProfessionCodes = {
    "Crop Production": ["Field crops", "Vegetable crops", "Arboriculture", "Fodder"],
    "Animal Production": ["Cattle", "Sheep", "Goats", "Backyard poultry", "Beekeepers"],
    "Traders": ["Retailers", "Wholesalers"],
    "Services": ["Agricultural equipment", "Irrigation equipment", "Phytosanitary products", "Fertilizers", "Seeds"],
    "Suppliers": ["Equipment rental or installation", "Labor", "Veterinary services", "Logistics"],
    "Consulting & Assistance": ["Public", "Private"],
    "Other": ["Other"],
  };

  // Getters
  TextEditingController get id => _id;
  TextEditingController get username => _username;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get phoneNumber => _phoneNumber;
  TextEditingController get location => _location;
  TextEditingController get gps => _gps;
  List<String> get activityDomainList => _activityDomainList;
  String get activityDomain => _activityDomain;
  List<String> get activityProfessionList => _activityProfessionList;
  String get activityProfession => _activityProfession;

  // Ask for permissions to get GPS coord.
  Future<void> setLocalisation() async {
    Location location = Location();
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      _gps.text = '<${locationData.latitude},${locationData.longitude}>';
      notifyListeners();
    }
  }

  String translateDomain(BuildContext context, String code) {
    final loc = AppLocalizations.of(context)!;

    switch (code) {
      case "Crop Production":
        return loc.activityDomainCrop; // Crop production / etc.
      case "Animal Production":
        return loc.activityDomainAnimal;
      case "Traders":
        return loc.activityDomainTraders;
      case "Services":
        return loc.activityDomainServices;
      case "Suppliers":
        return loc.activityDomainSuppliers;
      case "Consulting & Assistance":
        return loc.activityDomainConsulting;
      case "Other":
        return loc.fieldSpecializationOther;
      default:
        return loc.activityDomainOther;
    }
  }

  String translateProfession(BuildContext context, String code) {
    final loc = AppLocalizations.of(context)!;

    switch (code) {
    // Crop Production
      case "Field crops":
        return loc.fieldSpecializationFieldCrops;
      case "Vegetable crops":
        return loc.fieldSpecializationVegetableCrops;
      case "Arboriculture":
        return loc.fieldSpecializationArboriculture;
      case "Fodder":
        return loc.fieldSpecializationFodder;

    // Animal Production
      case "Cattle":
        return loc.fieldSpecializationCattle;
      case "Sheep":
        return loc.fieldSpecializationSheep;
      case "Goats":
        return loc.fieldSpecializationGoats;
      case "Backyard poultry":
        return loc.fieldSpecializationPoultry;
      case "Beekeepers":
        return loc.fieldSpecializationBeekeepers;

    // Traders
      case "Retailers":
        return loc.fieldSpecializationRetailers;
      case "Wholesalers":
        return loc.fieldSpecializationWholesalers;

    // Services
      case "Agricultural equipment":
        return loc.fieldSpecializationAgriculturalEquipment;
      case "Irrigation equipment":
        return loc.fieldSpecializationIrrigationEquipment;
      case "Phytosanitary products":
        return loc.fieldSpecializationPhytosanitary;
      case "Fertilizers":
        return loc.fieldSpecializationFertilizers;
      case "Seeds":
        return loc.fieldSpecializationSeeds;

    // Suppliers
      case "Equipment rental or installation":
        return loc.fieldSpecializationEquipmentRental;
      case "Labor":
        return loc.fieldSpecializationLabor;
      case "Veterinary services":
        return loc.fieldSpecializationVeterinary;
      case "Logistics":
        return loc.fieldSpecializationLogistics;

    // Consulting & Assistance
      case "Public":
        return loc.fieldSpecializationPublic;
      case "Private":
        return loc.fieldSpecializationPrivate;

    // Default case
      case "Other":
        return loc.fieldSpecializationOther;

      default:
        return loc.fieldSpecializationOther;
    }
  }

  void setActivityDomain (BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    _activityDomainList = activityDomainCodes.map((code) {
      switch (code) {
        case "Crop Production": return loc.activityDomainCrop;
        case "Animal Production": return loc.activityDomainAnimal;
        case "Traders": return loc.activityDomainTraders;
        case "Services": return loc.activityDomainServices;
        case "Suppliers": return loc.activityDomainSuppliers;
        case "Consulting & Assistance": return loc.activityDomainConsulting;
        case "Other": return loc.activityDomainOther;
        default: return loc.activityDomainOther;
      }
    }).toList();
    if (_activityDomain.isEmpty) {
      _activityDomain = AppLocalizations.of(context)!.activityDomainCrop;
    }
  }

  void setFieldSpecialization(BuildContext context, String domainCode) {
    _activityDomain = domainCode;
    final professionCodes = activityProfessionCodes[domainCode]!;
    // if current profession is invalid => take the first one
    if (!professionCodes.contains(_activityProfession)) {
      _activityProfession = professionCodes.first;
    }

    notifyListeners();
  }

  void setActivityProfession(String code) {
    _activityProfession = code;
    notifyListeners();
  }

  void clearGps() {
    _gps.text = "";
    notifyListeners();
  }

  // Update user data including his prosumer data, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> updateUserData(BuildContext context) async {

    // Set a popup to wait for updating user data
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
                Text(AppLocalizations.of(context)!.titlePopUpUpdateUser),
              ],
            ),
          ),
        );
      },
    );

    // Calls the user data updating function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      Map<String, Map<String, String>> body = {
        "user" : {
          "userName": _username.text,
          "firstName": _firstname.text,
          "lastName": _lastname.text,
          "roleOfUser": 'prosumer',
          "email": _email.text,
          "password": context.read<MainProvider>().actualUser!.password!,
          "phoneNumber": _phoneNumber.text,
          "gps": _gps.text,
        },
        "prosumer" : {
          "activityDomain": _activityDomain,
          "specificActivity": _activityProfession,
          "location": _location.text
        }
      };
      await _accountServices.updateUserAndProsumerData(
          body,
          context.read<MainProvider>().actualUser!.accessToken,
          context.read<MainProvider>().actualUser!.id
      );

      // Retrieves user and prosumer data and update their locale value in Main Provider
      await context.read<MainProvider>().getUserDataAndToken(username: body['user']!['userName'], password: body['user']!['password']);
      Navigator.of(context).pop();

    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemSetUpdateUser),
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