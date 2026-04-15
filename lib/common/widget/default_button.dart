import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';

/*
 * A customizable button widget that can execute either a synchronous or asynchronous function.
 * This button is designed to be reusable across the app with specific styling options.
 * Depending on the label text, it can display different colors and trigger either a regular function or an asynchronous function when pressed.
 */
class DefaultButton extends StatelessWidget {
  DefaultButton({super.key, required this.label, required this.parentContext, required this.function, required this.futureFunction});

  // inherited variables
  BuildContext parentContext;
  String label;
  Function? function;
  Future<void> Function()? futureFunction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          function != null ? function!() : futureFunction!();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: (label == "Delete" || label == "حذف" || label == "Change password" || label == "تغيير كلمة المرور") ? GlobalVariables.tertiaryColor : Colors.transparent,//GlobalVariables.backgroundColor,
          elevation: 0, // Disable elevation to keep same background color as scaffold widget
          side: const BorderSide(color: GlobalVariables.tertiaryColor),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: label == "Delete" || label == "حذف" || label == "Change password" || label == "تغيير كلمة المرور"
                ? GlobalVariables.textHeaderColor
                : GlobalVariables.tertiaryColor,
          ),
        )
    );
  }

}