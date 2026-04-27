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
import 'package:resilink_mobile_application/features/account/provider/account_provider.dart';
import 'package:resilink_mobile_application/features/home/provider/home_provider.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/default_button.dart';
import '../../../common/widget/default_touch_headband.dart';
import '../../../common/widget/offer_tile.dart';
import '../../../constants/global_variables.dart';
import '../../../models/Asset.dart';
import '../../../models/Offer.dart';

// Widget for the published offers management page
class AllOwnerBlockedOffers extends StatefulWidget {
  AllOwnerBlockedOffers({super.key, required this.homeProvider, required this.homeNavigationProvider});

  HomeProvider homeProvider;
  HomeNavigationProvider homeNavigationProvider;

  @override
  AllOwnerBlockedOffersState createState() => AllOwnerBlockedOffersState();
}

class AllOwnerBlockedOffersState extends State<AllOwnerBlockedOffers> {

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
                  AppLocalizations.of(context)!.blockedOfferPageTitle,
                  style: const TextStyle(color: GlobalVariables.textHeaderColor),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (_) => HomeProvider(),
          builder: (context, child) {
            return Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {

                if (!homeProvider.finishFetchBlockedOffer) {
                  homeProvider.setOwnerBlockedOffer(context);
                }

                // Loading state
                if (!homeProvider.finishFetchBlockedOffer || homeProvider.loadingFetchBlockedOffer) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Empty state
                if (homeProvider.blockedOffer.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.textNoBlockedOffer,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: AnimatedList(
                    key: homeProvider.listKey,
                    initialItemCount: homeProvider.blockedOffer.length,
                    itemBuilder: (listContext, index, animation) { // FIX: renamed to listContext
                      final offer = homeProvider.blockedOffer[index];
                      return SizeTransition(
                        sizeFactor: animation,
                        child: Column(
                          children: [
                            SizedBox(
                              key: ValueKey(homeProvider.blockedOffer[index].id),
                              child: OfferTile(
                                parentContext: listContext,
                                offer: offer,
                                asset: homeProvider.blockedOfferAssets["${offer.serverUrl}|${offer.assetId}"]!,
                                forPurchase: false,
                                function: () => showDialog(
                                  context: listContext, // utilise listContext pour le dialog
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      contentPadding: const EdgeInsets.all(25.0),
                                      title: Text(
                                        AppLocalizations.of(dialogContext)!.titlePopUpUnblockingOffer,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: SizedBox(
                                        height: MediaQuery.of(dialogContext).size.height * 0.25,
                                        width: MediaQuery.of(dialogContext).size.width * 0.8,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                AppLocalizations.of(dialogContext)!.textPopUpUnblockOffer,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: DefaultButton(
                                                    label: AppLocalizations.of(dialogContext)!.buttonClose,
                                                    parentContext: dialogContext,
                                                    function: () => Navigator.pop(dialogContext),
                                                    futureFunction: null,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: DefaultButton(
                                                    label: AppLocalizations.of(dialogContext)!.buttonDelete,
                                                    parentContext: dialogContext,
                                                    function: null,
                                                    futureFunction: () async {
                                                      final int capturedIndex = index;
                                                      final Offer deletedOffer = homeProvider.blockedOffer[capturedIndex];
                                                      final Asset? deletedAsset = homeProvider.blockedOfferAssets["${deletedOffer.serverUrl}|${deletedOffer.assetId}"];
                                                      // Capture screen size via listContext (still alive)
                                                      final double screenWidth = MediaQuery.of(listContext).size.width;
                                                      final double screenHeight = MediaQuery.of(listContext).size.height;

                                                      await homeProvider.deleteIdBlockedOffer(dialogContext, deletedOffer);
                                                      Navigator.pop(dialogContext);

                                                      homeProvider.blockedOffer.removeAt(capturedIndex);

                                                      homeProvider.listKey.currentState!.removeItem(
                                                        capturedIndex,
                                                            (_, animation) => SizeTransition(
                                                          axis: Axis.vertical,
                                                          sizeFactor: animation,
                                                          // Use captured dimensions instead of MediaQuery.of(context)
                                                          child: deletedAsset != null
                                                              ? SizedBox(
                                                            width: screenWidth,
                                                            height: screenHeight * 0.1,
                                                            child: OfferTile(
                                                              parentContext: listContext,
                                                              offer: deletedOffer,
                                                              asset: deletedAsset,
                                                              forPurchase: false,
                                                            ),
                                                          )
                                                              : const SizedBox.shrink(),
                                                        ),
                                                        duration: const Duration(milliseconds: 500),
                                                      );

                                                      Future.delayed(const Duration(milliseconds: 500), () {
                                                        homeProvider.notifyListeners();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (index != homeProvider.blockedOffer.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}