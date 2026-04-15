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