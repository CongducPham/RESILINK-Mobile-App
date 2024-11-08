import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';

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
  bool _showKeyboardChangeMessage = false;
  bool _error = false;

  // Getters
  TextEditingController get username => _username;
  TextEditingController get password => _password;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get job => _job;
  TextEditingController get phoneNumber => _phoneNumber;
  bool get showKeyboardChangeMessage => _showKeyboardChangeMessage;
  bool get error => _error;


  // Setters
  void setError(bool newValue) async {
    Timer(const Duration(seconds: 5), () {
      _error = newValue;
    });
  }

  void setShowKeyboardChangeMessage(bool newValue) {
    _showKeyboardChangeMessage = newValue;
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
          "job": _job.text,
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