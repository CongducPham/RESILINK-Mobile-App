import 'package:flutter/material.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/constants/global_variables.dart';

/*
 * A utility class that displays a customizable popup dialog.
 * The `DefaultPopUp` class provides a static method `show` that creates and displays ,an `AlertDialog` with a title,
 * message, and an optional button. The popup adapts to the screen size and offers a consistent design across the app.
 */
class DefaultPopUp {
  static void show(BuildContext context, String title, String message, String? buttonText) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogHeight = screenHeight * 0.25;
    final double dialogWidth = screenWidth * 0.8;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.all(25.0),
          content: Container(
            height: dialogHeight,
            width: dialogWidth,
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                if (buttonText != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: DefaultButton(label: buttonText, parentContext: context, function: () {Navigator.pop(context);}, futureFunction: null)
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}