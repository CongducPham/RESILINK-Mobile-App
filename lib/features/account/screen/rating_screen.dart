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
import 'package:resilink_mobile_application/features/account/provider/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants/global_variables.dart';
// Widget for the languages page
class RatingScreen extends StatefulWidget {
  RatingScreen({super.key});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    AppLocalizations.of(context)!.accountTitleRating,
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
          body: ChangeNotifierProvider(
            // Creating the Account provider in the tree structure
              create: (_) => RatingProvider(),
              builder: (context, child) {
                return Consumer<RatingProvider>( // Listening to Account, HomeNavigation and Main providers to access their data
                    builder: (context, ratingProvider, child) {

                      if (!ratingProvider.finishFetchRating && ratingProvider.loadingFetchRating) {
                        ratingProvider.getRatingUser(context);
                      }

                      return !ratingProvider.finishFetchRating && ratingProvider.loadingFetchRating ?
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                          : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar(
                                  minRating: 1,
                                  maxRating: 5,
                                  initialRating: ratingProvider.userRating,
                                  allowHalfRating: true,
                                  ratingWidget: RatingWidget(
                                      full: const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      half: const Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                      ),
                                      empty: const Icon(
                                        Icons.star_border,
                                        color: Colors.grey,
                                      )
                                  ),
                                  onRatingUpdate: (double newRate) =>
                                      ratingProvider.updateCurrentRating(
                                          newRate)
                              ),
                              SizedBox(height: 30),
                              Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  // Button to call up the language change function in the application
                                  child: DefaultButton(
                                      label: AppLocalizations.of(context)!
                                          .buttonModify,
                                      parentContext: context,
                                      function: null,
                                      futureFunction: () async => await ratingProvider.updateRatingUser(context)
                                  )
                              )
                            ],
                          ),
                        ),
                      );
                    }
                );
              }
          ),
        )
    );
  }
}
