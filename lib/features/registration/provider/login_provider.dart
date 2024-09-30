import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginProvider with ChangeNotifier {

  // Variables and their initialization
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  bool _error = false;

  // Getters
  TextEditingController get username => _username;
  TextEditingController get password => _password;
  bool get error => _error;

  // Setters
  void setUsername(String newValue) {
    _username.text = newValue;
  }

  void setPassword(String newValue) {
    _password.text = newValue;
  }

  void setError(bool newValue) {
    _error = newValue;
  }

  // User login function.
  Future<void> signIn(BuildContext context, MainProvider mainProvider, HomeNavigationProvider homeNavigationProvider) async {

    // Set a popup to wait for connection
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
                Text(AppLocalizations.of(context)!.titlePopUpLogIn),
              ],
            ),
          ),
        );
      },
    );

    // Calls the user login function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      await mainProvider.getUserDataAndToken(username: _username.text, password: _password.text);

      /*
       * Close the waiting popup,
       * then close the registration page to return to the main navigation.
       */
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
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
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