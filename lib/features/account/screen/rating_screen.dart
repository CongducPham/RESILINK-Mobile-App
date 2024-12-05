import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/features/account/provider/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          appBar: AppBar( // Same AppBar as the main navigation page
            centerTitle: true,
            backgroundColor: GlobalVariables.navigationBarColor,
            title: Center(
                child: Text(
                    AppLocalizations.of(context)!.accountTitleRating,
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
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.transparent),
                onPressed: () {},
              ),
            ],
          ),
          body: ChangeNotifierProvider(
            // Creating the Account provider in the tree structure
              create: (_) => RatingProvider(),
              builder: (context, child) {
                return Consumer<
                    RatingProvider>( // Listening to Account, HomeNavigation and Main providers to access their data
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
