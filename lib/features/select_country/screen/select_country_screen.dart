import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:resilink_design/features/select_country/widget/FlagTouch.dart';

import '../../../constants/global_variables.dart';

class SelectCountryScreen extends StatelessWidget {
  SelectCountryScreen({super.key  });

  FlagTouch selectCountryService = FlagTouch();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container()
              ),
              Expanded(
                  flex: 1,
                  child: Image(
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.sizeOf(context).width * 0.6,
                      image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!)
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Container(),
              ),
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
                                  selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.algeria, 'apple', constraints.maxWidth, constraints.maxHeight, context, "Algeria"),
                                  SizedBox(height: constraints.maxHeight * 0.05),
                                  selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.egypt, 'eggplant', constraints.maxWidth, constraints.maxHeight, context, "Egypt"),
                                  SizedBox(height: constraints.maxHeight * 0.05),
                                  selectCountryService.flagTouchNavigator(AppLocalizations.of(context)!.morocco, 'tomato', constraints.maxWidth, constraints.maxHeight, context, "Morocco"),
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