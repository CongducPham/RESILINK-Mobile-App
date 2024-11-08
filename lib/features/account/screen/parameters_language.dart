import 'package:Resilink/common/widget/default_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/locale_provider.dart';

// Widget for the languages page
class ParametersLanguage extends StatefulWidget {
  ParametersLanguage({super.key});

  @override
  _ParametersLanguageState createState() => _ParametersLanguageState();
}

class _ParametersLanguageState extends State<ParametersLanguage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // Needed when the language change
          child: Scaffold(
            appBar: AppBar( // Same AppBar as the main navigation page
              centerTitle: true,
              backgroundColor: GlobalVariables.navigationBarColor,
              title: Center(
                  child: Text(
                      AppLocalizations.of(context)!.languagePageTitle,
                      style: const TextStyle(
                          color: GlobalVariables.textHeaderColor
                      )
                  )
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.transparent),
                  onPressed: () {
                  },
                ),
              ],
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
        );
      },
    );
  }
}
