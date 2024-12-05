import 'dart:async';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/account/service/account_services.dart';

import '../../../providers/main_provider.dart';

class AccountDataProvider with ChangeNotifier {

  // Parameter variables
  TextEditingController _username;
  TextEditingController _firstname;
  TextEditingController _lastname;
  TextEditingController _email;
  TextEditingController _job;
  TextEditingController _phoneNumber;
  TextEditingController _location;
  TextEditingController _gps;
  AccountServices _accountServices = AccountServices();

  // Constructor
  AccountDataProvider({
    String username = "",
    String firstname = "",
    String lastname = "",
    String email = "",
    String job = "",
    String phoneNumber = "",
    String location = "",
    String gps = ""
  })
      : _username = TextEditingController(text: username),
        _firstname = TextEditingController(text: firstname),
        _lastname = TextEditingController(text: lastname),
        _email = TextEditingController(text: email),
        _job = TextEditingController(text: job),
        _phoneNumber = TextEditingController(text: phoneNumber),
        _location = TextEditingController(text: location),
        _gps = TextEditingController(text: gps);

  // Getters
  TextEditingController get username => _username;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get job => _job;
  TextEditingController get phoneNumber => _phoneNumber;
  TextEditingController get location => _location;
  TextEditingController get gps => _gps;

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
          "job": _job.text,
          "location": _location.text
        }
      };
      await _accountServices.updateUserAndProsumerData(
          body,
          context.read<MainProvider>().actualUser!.accessToken,
          context.read<MainProvider>().actualUser!.username
      );

      // Retrieves user and prosumer data and update their locale value in Main Provider
      await context.read<MainProvider>().getUserDataAndToken(username: body['user']!['userName'], password: body['user']!['password']);
      Navigator.of(context).pop();

    } catch (e) {

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