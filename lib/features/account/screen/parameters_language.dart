import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_design/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';

class ParametersLanguage extends StatelessWidget {
  ParametersLanguage({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
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
                    //TODO to complete if notification page/features is implemented
                  },
                ),
              ],
            ),
            body: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: MediaQuery.of(context).size.height * 0.2,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.blueGrey,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  userProvider.setNewLocale('ar');
                                },
                                child: Column(
                                    children: [
                                      SvgPicture.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/2/2b/Flag_of_the_Arab_League.svg",
                                        fit: BoxFit.fill,
                                        width: constraints.maxWidth * 0.4,
                                        height: constraints.maxHeight * 0.8,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.languagePageFirstChoice,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ]
                                ),
                              )
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  userProvider.setNewLocale('en');
                                },
                                child: Column(
                                    children: [
                                      SvgPicture.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/8/83/Flag_of_the_United_Kingdom_%283-5%29.svg",
                                        fit: BoxFit.fill,
                                        width: constraints.maxWidth * 0.4,
                                        height: constraints.maxHeight * 0.8,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.languagePageSecondChoice,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ]
                                ),
                              )
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}