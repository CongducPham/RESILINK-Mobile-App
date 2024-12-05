import 'package:Resilink/features/account/provider/account_provider.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/default_button.dart';
import '../../../common/widget/default_touch_headband.dart';
import '../../../common/widget/offer_tile.dart';
import '../../../constants/global_variables.dart';

// Widget for the purchased offers management page
class AllOwnerOfferPurchased extends StatefulWidget {
  AllOwnerOfferPurchased({super.key, required this.accountProvider, required this.parentContext, required this.homeNavigationProvider});

  AccountProvider accountProvider;
  BuildContext parentContext;
  HomeNavigationProvider homeNavigationProvider;

  @override
  AllOwnerOfferPurchasedState createState() => AllOwnerOfferPurchasedState();
}

class AllOwnerOfferPurchasedState extends State<AllOwnerOfferPurchased> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar( // Same AppBar as the main navigation page
          centerTitle: true,
          backgroundColor: GlobalVariables.navigationBarColor,
          title: Center(
              child: Text(
                  AppLocalizations.of(context)!.ownerOfferPublished,
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
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                SizedBox(
                  // Height varies according to the number of items in the list, or if the function for retrieving purchased offers has been terminated
                  height: MediaQuery.of(context).size.height * 0.14 * (widget.accountProvider.offerPurchased.isNotEmpty ? widget.accountProvider.offerPurchased.length : 1),
                  child: widget.accountProvider.finishFetchPurchase && !widget.accountProvider.loadingFetchPurchase ? // if loadingFetchPurchase is true, the asynchronous function is not completed and a waiting icon is displayed
                  widget.accountProvider.offerPurchased.isNotEmpty ? // if offerPurchased is empty, there is no offers in the list so a message is displayed
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: widget.accountProvider.contractPurchased.length,
                      itemBuilder: (_, int index) {
                        return Column(
                          children: [
                            // Calls the generic tile for an offer
                            OfferTile(
                              parentContext: widget.parentContext,
                              offer: widget.accountProvider.offerPurchased[int.parse(widget.accountProvider.contractPurchased[index].offer)]!,
                              asset: widget.accountProvider.assetPurchased[int.parse(widget.accountProvider.contractPurchased[index].asset)]!,
                              forPurchase: false,
                              contract: widget.accountProvider.contractPurchased[index],
                              homeNavigationProvider: widget.homeNavigationProvider,
                            ),
                            if (index != widget.accountProvider.offerPurchased.length)
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
            ]),
          ),
        ),
      ),
    );
  }
}
