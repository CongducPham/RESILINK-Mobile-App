import 'package:Resilink/features/account/screen/all_owner_offers_published.dart';
import 'package:Resilink/features/account/screen/all_owner_offers_purchased.dart';
import 'package:Resilink/features/account/screen/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_touch_headband.dart';
import 'package:Resilink/common/widget/offer_tile.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/account/provider/account_provider.dart';
import 'package:Resilink/features/account/screen/account_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/account/screen/parameters_language.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';

import '../../../common/widget/default_button.dart';
import '../../select_country/screen/select_country_screen.dart';

// Account page widget
class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;
  @override
  State<StatefulWidget> createState() {
    return AccountScreenState();
  }
}

class AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Creating the Account provider in the tree structure
      create: (_) => AccountProvider(),
      builder: (context, child) {
        return Consumer3<MainProvider, AccountProvider, HomeNavigationProvider>( // Listening to Account, HomeNavigation and Main providers to access their data
          builder: (context, mainProvider, accountProvider, homeNavigationProvider, child) {

            // Calls functions to retrieve the user's last published offers and current purchases if functions have not yet started
            if (!accountProvider.finishFetchPurchase && !accountProvider.finishFetchOffer && homeNavigationProvider.selectedIndex == 4) {
              accountProvider.setLastOfferPublish(context);
              accountProvider.setOfferPurchased(context);
            }

            return SingleChildScrollView(
                controller: accountProvider.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 3 clickable texts to position the user at the right part of the screen
                          GestureDetector(
                            onTap: () => accountProvider.scrollToSection(accountProvider.profileKey),
                            child: Text(
                              AppLocalizations.of(context)!.accountShiftToProfile,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: GlobalVariables.tertiaryColor),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => accountProvider.scrollToSection(
                                accountProvider.offerKey),
                            child: Text(
                              AppLocalizations.of(context)!.accountShiftToOffer,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: GlobalVariables.tertiaryColor),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => accountProvider.scrollToSection(
                                accountProvider.parametersKey),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .accountShiftToParameters,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: GlobalVariables.tertiaryColor),
                            ),
                          ),
                          SizedBox(height: 10),

                          // Calls up the widget managing the user's personal information
                          AccountProfile(parentContext: context, accountProvider: accountProvider),
                          const SizedBox(height: 5),

                          Text(
                            key: accountProvider.offerKey, // key to move to this area
                            AppLocalizations.of(context)!.accountPurchasesTitle,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),

                          /*
                           * Non-scrollable box displaying a list of offers purchased (3 maximum)
                           * height varies according to the number of items in the list, or if the function for retrieving purchased offers has been terminated
                           */
                          Container(
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height * 0.15,
                                maxHeight: 260
                            ),
                            height: MediaQuery.of(context).size.height * 0.14 * (accountProvider.offerPurchased.isNotEmpty ? accountProvider.contractPurchased.length > 3 ? 3 : accountProvider.offerPurchased.length : 1) + 10,
                            child: accountProvider.finishFetchPurchase && !accountProvider.loadingFetchPurchase ? // if loadingFetchPurchase is true, the asynchronous function is not completed and a waiting icon is displayed
                            accountProvider.offerPurchased.isNotEmpty ? // if offerPurchased is empty, there is no offers in the list so a message is displayed
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: accountProvider.contractPurchased.length > 3 ? 3 : accountProvider.contractPurchased.length,
                                itemBuilder: (_, int index) {
                                  return Column(
                                    children: [
                                      // Calls the generic tile for an offer
                                      OfferTile(
                                          parentContext: context,
                                          offer: accountProvider.offerPurchased[int.parse(accountProvider.contractPurchased[index].offer)]!,
                                          asset: accountProvider.assetPurchased[int.parse(accountProvider.contractPurchased[index].asset)]!,
                                          forPurchase: false,
                                          contract: accountProvider.contractPurchased[index],
                                      ),
                                      if (index != accountProvider.offerPurchased.length)
                                        SizedBox(height: 10)
                                    ],
                                  );
                                }) :
                              Center(
                                child: Text(AppLocalizations.of(context)!.textNoOfferPurchase),
                              )
                            : const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),

                          // clickable text for a complete list of current purchased offers in a new page
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AllOwnerOfferPurchased(accountProvider: accountProvider, parentContext: context, homeNavigationProvider: homeNavigationProvider,)));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.seeMoreText,
                                style: const TextStyle(
                                    fontSize: 14, color: GlobalVariables.tertiaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          Text(
                            AppLocalizations.of(context)!.accountTitlePublish,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          /*
                           * Non-scrollable box displaying a list of offers published (3 maximum)
                           * height varies according to the number of items in the list, or if the function for retrieving published offers has been terminated
                           */
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 170
                            ),
                            height: MediaQuery.of(context).size.height * 0.08 * (accountProvider.lastOfferPublish.isNotEmpty ? accountProvider.lastOfferPublish.length > 3 ? 3 : accountProvider.lastOfferPublish.length : 2),
                            child: accountProvider.finishFetchOffer && !accountProvider.loadingFetchOffer ? // if loadingFetchOffer is true, the asynchronous function is not completed and a waiting icon is displayed
                              accountProvider.lastOfferPublish.isNotEmpty ? // if lastOfferPublish is empty, there are no offers in the list and a message is displayed.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: accountProvider.lastOfferPublish.length > 3 ? 3 : accountProvider.lastOfferPublish.length,
                                  itemBuilder: (_, int index) {
                                    return Column(
                                      children: [
                                        /*
                                         * GestureDetector to display a popup giving the choice of modifying or deleting the published offer, with information on whether the offer is no longer available
                                         * if the container containing the published offer information is tapped.
                                         */
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                  ),
                                                  contentPadding: EdgeInsets.all(25.0),
                                                  titlePadding: EdgeInsets.zero,  // Pour mieux contrôler le padding du titre
                                                  title: Stack(
                                                    children: [
                                                      // Icône de retour (flèche ou croix) en haut à gauche
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: IconButton(
                                                          icon: Icon(Icons.arrow_back),  // Utilise Icons.close si tu veux une croix
                                                          onPressed: () {
                                                            Navigator.of(context).pop();  // Ferme la popup
                                                          },
                                                        ),
                                                      ),
                                                      // Le titre du popup, centré
                                                      Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 12.0),  // Ajuste le padding supérieur
                                                          child: Text(
                                                            AppLocalizations.of(context)!.titlePopUpModifyOffer,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Container(
                                                    height: MediaQuery.of(context).size.height * 0.25,
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        // Information dans le corps du popup
                                                        Expanded(
                                                          child: Text(
                                                            DateTime.parse(accountProvider.lastOfferPublish[index].validityLimit)
                                                                .isBefore(DateTime.now().toUtc().add(Duration(hours: 1)))
                                                                ? AppLocalizations.of(context)!.textPopUpModifyOfferBad
                                                                : AppLocalizations.of(context)!.textPopUpModifyOfferGood,
                                                            style: TextStyle(
                                                              fontSize: 13.0,
                                                            ),
                                                          ),
                                                        ),
                                                        // Rangée avec les boutons modifier et supprimer
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: DefaultButton(
                                                                label: AppLocalizations.of(context)!.buttonModify,
                                                                parentContext: context,
                                                                function: () {
                                                                  accountProvider.toUpdateOffer(
                                                                    accountProvider.lastOfferPublish[index],
                                                                    accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!,
                                                                    homeNavigationProvider,
                                                                    mainProvider,
                                                                    context,
                                                                  );
                                                                },
                                                                futureFunction: null,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: DefaultButton(
                                                                label: AppLocalizations.of(context)!.buttonDelete,
                                                                parentContext: context,
                                                                function: null,
                                                                futureFunction: () => accountProvider.deleteOfferAsset(
                                                                  context,
                                                                  accountProvider.lastOfferPublish[index].offerId!,
                                                                  accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!.id,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },

                                          //Default widget to display a customized container for published offers, as it requires information that cannot be displayed in a classic tile.
                                          child: DefaultTouchHeadband(
                                              offer: accountProvider.lastOfferPublish[index],
                                              asset: accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!,
                                              accountProvider: accountProvider,),
                                        ),
                                        if (index != accountProvider.lastOfferPublish.length)
                                          SizedBox(height: 10)
                                      ],
                                    );
                                  })
                              : Center(
                                child: Text(AppLocalizations.of(context)!.textNoOfferPublish),
                              )
                            : const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ]
                    ),

                    // clickable text for a complete list of all published offers in a new page
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AllOwnerOfferPublished(accountProvider: accountProvider, homeNavigationProvider: homeNavigationProvider)));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.seeMoreText,
                          style: const TextStyle(
                              fontSize: 14, color: GlobalVariables.tertiaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Parameters title
                    Text(
                      key: accountProvider.parametersKey,
                      AppLocalizations.of(context)!.accountTitleParameters,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Clickable text to access the languages page
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParametersLanguage())
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                              AppLocalizations.of(context)!.accountSubTitleLanguage,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Clickable text to access the country selection page
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectCountryScreen(fromParameters: true))
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_circle_outlined,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                              AppLocalizations.of(context)!.accountSubTitleLocalization,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Clickable text to access the rating page
                    /* Disable to downgrade the app
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RatingScreen())
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_border,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                              AppLocalizations.of(context)!.accountTitleRating,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                     */

                    // Clickable text to call the logout function and change page afterward
                    GestureDetector(
                      onTap: () {
                        mainProvider.logOutUser();
                        homeNavigationProvider.setIndexAndUpdateHeader(0);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout_outlined,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(AppLocalizations.of(context)!.accountSubTitleLogOut,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                )
            );
          },
        );
      },
    );
  }
}
