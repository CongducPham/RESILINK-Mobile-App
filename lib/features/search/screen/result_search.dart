import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/features/search/provider/search_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/widget/offer_tile.dart';

/*
 * This widget displays the search results, including a list of offers found based on the user's search criteria.
 * It also provides a button to modify the search if needed.
 */
class ResultSearch extends StatefulWidget {
  const ResultSearch({super.key});

  @override
  State<StatefulWidget> createState() {
    return ResultSearchState();
  }

}

class ResultSearchState extends State<ResultSearch> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>( // Listening to Search provider to access their data and manage them
      builder: (context, searchProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
            Text(
              AppLocalizations.of(context)!.resultsTitle,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 15),
            // Container displaying the list of found offers
            Container(
              height: context.read<SearchProvider>().searchedOffer.isNotEmpty ? MediaQuery.of(context).size.height * 0.14 * (context.read<SearchProvider>().searchedOffer.length > 4 ? 4 : context.read<SearchProvider>().searchedOffer.length) + 10 : 70,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5
              ),
              child: context.read<SearchProvider>().searchedOffer.isNotEmpty ? ListView.builder(
                  // Prevents the list from being scrollable if there is less than 3 offers
                  physics: context.read<SearchProvider>().searchedOffer.length > 2 ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                  itemCount: context.read<SearchProvider>().searchedOffer.length,
                  itemBuilder: (_, int index) {
                    return Column(
                      children: [
                        // Widget displaying each found offer
                        OfferTile(parentContext: context, offer: context.read<SearchProvider>().searchedOffer[index], asset: context.read<SearchProvider>().offerAssets[context.read<SearchProvider>().searchedOffer[index].assetId]!, forPurchase: true),
                        if (index != context.read<SearchProvider>().searchedOffer.length)
                          SizedBox(height: 10)
                      ],
                    );
                  }
              ) : Center(
                child: Text(AppLocalizations.of(context)!.textNoOffer),
              ),
            ),
            SizedBox(height: 10),
            // Button to modify the search criteria
            Align(
                alignment: AlignmentDirectional.centerEnd,
                child: DefaultButton(
                    label: AppLocalizations.of(context)!.buttonModifySearch,
                    parentContext: context,
                    function: () => searchProvider.setSearchDone(false),
                    futureFunction: null
                )
            ),
            /*Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DefaultButton(label: AppLocalizations.of(context)!.buttonSave, parentContext: context, function: null, futureFunction: null)
          ),
           */
          ],
        );
      }
    );
  }

}