import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';

import '../../../providers/main_provider.dart';

class SignUpProvider with ChangeNotifier {

  // Variables and their initialization
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  TextEditingController _firstname = TextEditingController(text: "");
  TextEditingController _lastname = TextEditingController(text: "");
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _job = TextEditingController(text: "");
  TextEditingController _phoneNumber = TextEditingController(text: "");
  List<String> _activityDomainList = [];
  String _activityDomain = "Other";
  List<String> _activityProfessionList  = [];
  String _activityProfession = "Other";
  bool _showKeyboardChangeMessage = false;
  bool _error = false;

  // Constructor
  SignUpProvider(BuildContext context) {
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
  TextEditingController get username => _username;
  TextEditingController get password => _password;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get job => _job;
  TextEditingController get phoneNumber => _phoneNumber;
  List<String> get activityDomainList => _activityDomainList;
  String get activityDomain => _activityDomain;
  List<String> get activityProfessionList => _activityProfessionList;
  String get activityProfession => _activityProfession;
  bool get showKeyboardChangeMessage => _showKeyboardChangeMessage;
  bool get error => _error;


  // Setters
  void setError(bool newValue) async {
    Timer(const Duration(seconds: 5), () {
      _error = newValue;
    });
  }

  String translateDomain(BuildContext context, String code) {
    final loc = AppLocalizations.of(context)!;

    switch (code) {
      case "Crop Production":
        return loc.activityDomainCrop; // Production végétale / إلخ
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
    // si profession actuelle non valide => on prend la première
    if (!professionCodes.contains(_activityProfession)) {
      _activityProfession = professionCodes.first;
    }

    notifyListeners();
  }

  void setShowKeyboardChangeMessage(bool newValue) {
    _showKeyboardChangeMessage = newValue;
  }

  void setActivityProfession(String newProfession) {
    _activityProfession = newProfession;
  }

  // User registration function.
  Future<void> signUp(BuildContext context, MainProvider userProvider, HomeNavigationProvider homeNavigationProvider) async {

    // If the required fields are not filled in, a warning is displayed.
    if ( _email.text.isEmpty || lastname.text.isEmpty || firstname.text.isEmpty || username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.snackBarBadFilling),
            duration: Duration(seconds: 3),
          )
      );
    } else {

      // Set a popup to wait for registration
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
                  Text(AppLocalizations.of(context)!.titlePopUpSignUp),
                ],
              ),
            ),
          );
        },
      );

      // Calls the user creation function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
      try {
        await userProvider.createUserAndGetDataToken(userProvider.actualUser!.accessToken, <String, String>{
          "userName": _username.text,
          "firstName": _firstname.text,
          "lastName": _lastname.text,
          "roleOfUser": "prosumer",
          "email": _email.text,
          "password": _password.text,
          "phoneNumber": _phoneNumber.text,
          "activityDomain": _activityDomain,
          "specificActivity": _activityProfession,
          "location": ""
        });

        /*
         * Close the createUserAndGetDataToken popup window to confirm that it's working properly,
         * then close the waiting popup,
         * then close the registration page to return to the main navigation.
         */
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        homeNavigationProvider.setIndexAndUpdateHeader(0);
      } catch(e) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.popupFailConnexionTitle),
            content: Text(e is TimeoutException
                ? AppLocalizations.of(context)!.popupFailConnexionTimeout
                : e.toString().replaceAll("Exception: ", "")), // Show the error message with only the text
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.textOk),
              ),
            ],
          ),
        );
        setError(true);
      }
      notifyListeners();
    }
  }
}