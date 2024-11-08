import 'package:flutter/material.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/constants/global_variables.dart';

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
          title: Center(child: Text(AppLocalizations.of(context)!.popupTitleConfirm)),
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
                Navigator.of(context).pop(); // Close the dialog without any action
              },
              child: Text(AppLocalizations.of(context)!.buttonClose),
            ),
          ],
        );
      },
    );
  }

}