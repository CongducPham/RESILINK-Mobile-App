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
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';

/*
 * A utility class that displays a customizable popup dialog.
 * The `DefaultPopUp` class provides a static method `show` that creates and displays ,an `AlertDialog` with a title,
 * message, and an optional button. The popup adapts to the screen size and offers a consistent design across the app.
 */
class DefaultPopUp {

  static void show(BuildContext context, Future<void> Function()? futureFunction, Function? function) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogHeight = screenHeight * 0.25;
    final double dialogWidth = screenWidth * 0.8;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context)!.popupTitleConfirm,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          actions: [
            DefaultButton(
              label: AppLocalizations.of(context)!.buttonConfirm,
              parentContext: context,
              function: function != null ? () {
                // Close the dialog after confirming
                Navigator.of(context).pop();
                // Call Future function
                if (function != null) {
                  function!();
                }
              } : null,
              futureFunction: futureFunction != null ? () async {
                // Close the dialog after confirming
                Navigator.of(context).pop();
                // Call Future function
                if (futureFunction != null) {
                  futureFunction!();
                }
              } : null,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.buttonClose,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: GlobalVariables.tertiaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}