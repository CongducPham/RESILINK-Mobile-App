import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/select_country/widget/FlagTouch.dart';

import '../../../constants/global_variables.dart';

// This widget displays the application's logo and a list of country options that the user can choose from.
class SelectCountryScreen extends StatelessWidget {
  SelectCountryScreen({super.key, this.fromParameters = false});

  bool fromParameters;

  // Instance of FlagTouch used to handle flag selection actions
  FlagTouch selectCountryService = FlagTouch();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: fromParameters ? AppBar( // Same AppBar as the main navigation page
            centerTitle: true,
            backgroundColor: GlobalVariables.navigationBarColor,
            title: Center(
                child: Text(
                    AppLocalizations.of(context)!.accountSubTitleLocalization,
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
          ) : null,
          body: Column(
            children: [
              // First expanded section is empty to create space at the top
              Expanded(
                  flex: 1,
                  child: Container()
              ),

              // Second expanded section displays the logo of the application
              Expanded(
                  flex: 1,
                  child: Image(
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!)
                  )
              ),

              // Third expanded section is empty to create more space between the logo and the country selection
              Expanded(
                flex: 2,
                child: Container(),
              ),

              // Fourth expanded section contains the country selection interface
              Expanded(
                  flex: 13,
                  child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              SizedBox(
                                  height: constraints.maxHeight * 0.07,
                                  child: Text(
                                    AppLocalizations.of(context)!.chooseCountry,
                                    style: const TextStyle(
                                        fontSize: 20
                                    ),
                                  )
                              ),

                              Container(
                                margin: EdgeInsets.only(left: constraints.maxWidth * 0.1, right: constraints.maxWidth * 0.1),
                                height: constraints.maxHeight * 0.9,
                                width: constraints.maxWidth * 0.27,
                                child: Column(
                                  children: [
                                    SizedBox(height: constraints.maxHeight * 0.05),

                                    // Buttons for selecting Algeria, Egypt, and Morocco
                                    selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.algeria, 'apple', constraints.maxWidth, constraints.maxHeight, context, "Algeria", fromParameters),
                                    SizedBox(height: constraints.maxHeight * 0.05),
                                    selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.egypt, 'eggplant', constraints.maxWidth, constraints.maxHeight, context, "Egypt", fromParameters),
                                    SizedBox(height: constraints.maxHeight * 0.05),
                                    selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.morocco, 'tomato', constraints.maxWidth, constraints.maxHeight, context, "Morocco", fromParameters),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  )
              ),

              SizedBox(height: MediaQuery.sizeOf(context).width * 0.05)
            ],
          ),
        )
    );
  }
}
