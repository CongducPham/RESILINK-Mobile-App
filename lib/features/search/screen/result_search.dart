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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/search/provider/search_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/widget/offer_tile.dart';

class ResultSearch extends StatelessWidget {
  const ResultSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final offers = searchProvider.searchedOffer;
    final offerAssets = searchProvider.offerAssets;
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Results page title — headlineMedium for a prominent section heading
                Text(
                  AppLocalizations.of(context)!.resultsTitle,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: DefaultButton(
                    label: AppLocalizations.of(context)!.buttonModifySearch,
                    parentContext: context,
                    function: () => searchProvider.setSearchDone(false),
                    futureFunction: null,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: theme.dividerColor.withAlpha(80),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(10),
              thickness: 3,
              child: ListView.separated(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  final assetKey = "${offer.serverUrl}|${offer.assetId}";
                  return OfferTile(
                    parentContext: context,
                    offer: offer,
                    asset: offerAssets[assetKey]!,
                    forPurchase: true,
                    // Removes the blocked offer and its asset from the search results
                    onOfferBlocked: () {
                      searchProvider.removeBlockedOffer(offer, assetKey);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}