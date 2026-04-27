/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';


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