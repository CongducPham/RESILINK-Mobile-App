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