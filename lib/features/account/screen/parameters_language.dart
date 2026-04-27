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
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/locale_provider.dart';

// Widget for the languages page
class ParametersLanguage extends StatefulWidget {
  ParametersLanguage({super.key});

  @override
  ParametersLanguageState createState() => ParametersLanguageState();
}

class ParametersLanguageState extends State<ParametersLanguage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // Needed when the language change
          child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Material(
                  color: GlobalVariables.headerBackgroundColor,
                  elevation: 4,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        AppLocalizations.of(context)!.languagePageTitle,
                        style: const TextStyle(color: GlobalVariables.textHeaderColor),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black54),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: localeProvider.valueLocale,
                        onChanged: (String? newValue) {
                          localeProvider.setValueLocale(newValue!);
                        },
                        /*
                         * creates a list of available languages
                         * ar = arabic
                         * en = english
                         */
                        items: localeProvider.valueLanguage.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'ar'
                                  ? AppLocalizations.of(context)!.languagePageFirstChoice
                                  : AppLocalizations.of(context)!.languagePageSecondChoice,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        // Button to call up the language change function in the application
                        child: DefaultButton(label: AppLocalizations.of(context)!.buttonModify, parentContext: context, function: null, futureFunction: () => localeProvider.setNewLocale()))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
