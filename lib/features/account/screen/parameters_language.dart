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
