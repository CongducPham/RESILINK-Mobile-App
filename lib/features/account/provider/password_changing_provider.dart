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
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/account/service/password_changing_services.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../providers/main_provider.dart';

class PasswordChangingProvider extends ChangeNotifier {

  TextEditingController _newPassword = TextEditingController(text: "");
  TextEditingController _oldPassword = TextEditingController(text: "");
  PasswordChangingServices _passwordChangingServices = PasswordChangingServices();

  TextEditingController get newPassword => _newPassword;
  TextEditingController get oldPassword => _oldPassword;

  Future<void> updatePassword(BuildContext context) async {
    if (_newPassword.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.snackBarPasswordBadLength),
            duration: Duration(seconds: 3),
          )
      );
    } else {
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
        Map<String, String> body = {
          "oldPassword": _oldPassword.text,
          "newPassword": _newPassword.text
        };
        await _passwordChangingServices.updateUserPassword(
            context.read<MainProvider>().actualUser!.accessToken,
            body
        );
        await context.read<MainProvider>().getUserDataAndToken(username: context.read<MainProvider>().actualUser!.username!, password: _newPassword.text);
        Navigator.of(context).pop();
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
    }
    notifyListeners();
  }
}