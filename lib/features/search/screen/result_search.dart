import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/features/search/provider/search_provider.dart';

import '../../../common/widget/offer_tile.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Results",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: MediaQuery.of(context).size.height * 0.13 * context.read<SearchProvider>().searchedOffer.length,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.39
          ),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: context.read<SearchProvider>().searchedOffer.length > 5 ? 5 : context.read<SearchProvider>().searchedOffer.length,
              itemBuilder: (_, int index) {
                return Column(
                  children: [
                    OfferTile(parentContext: context, offer: context.read<SearchProvider>().searchedOffer[index], asset: context.read<SearchProvider>().offerAssets[context.read<SearchProvider>().searchedOffer[index].assetId]!),
                    if (index != context.read<SearchProvider>().searchedOffer.length)
                      SizedBox(height: 10)
                  ],
                );
              }
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: DefaultButton(label: "Modify search", parentContext: context, function: null, futureFunction: null)
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: DefaultButton(label: "Save", parentContext: context, function: null, futureFunction: null)
        ),
      ],
    );
  }

}