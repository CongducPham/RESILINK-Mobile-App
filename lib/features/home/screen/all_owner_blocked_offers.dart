import 'package:Resilink/features/account/provider/account_provider.dart';
import 'package:Resilink/features/home/provider/home_provider.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/default_button.dart';
import '../../../common/widget/default_touch_headband.dart';
import '../../../common/widget/offer_tile.dart';
import '../../../constants/global_variables.dart';
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
        appBar: AppBar( // Same AppBar as the main navigation page
          centerTitle: true,
          backgroundColor: GlobalVariables.navigationBarColor,
          title: Center(
              child: Text(
                  AppLocalizations.of(context)!.blockedOfferPageTitle,
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
        body: ChangeNotifierProvider(
          create: (_) => HomeProvider(),
          builder: (context, child) {
            return Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {

                if (!homeProvider.finishFetchBlockedOffer) {
                  homeProvider.setOwnerBlockedOffer(context);
                }

                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height * 0.14
                          ),
                          // Height varies according to the number of items in the list, or if the function for retrieving purchased offers has been terminated
                          height: MediaQuery.of(context).size.height * 0.14 * (homeProvider.blockedOffer.isNotEmpty ? homeProvider.blockedOffer.length : 2),
                          width: MediaQuery.of(context).size.width,
                          child: homeProvider.finishFetchBlockedOffer && !homeProvider.loadingFetchBlockedOffer ? // if loadingFetchOffer is true, the asynchronous function is not completed and a waiting icon is displayed
                          homeProvider.blockedOffer.isNotEmpty ? // if lastOfferPublish is empty, there is no offers in the list so a message is displayed
                          AnimatedList(
                              key: homeProvider.listKey,
                              scrollDirection: Axis.vertical,
                              initialItemCount: homeProvider.blockedOffer.length,
                              itemBuilder: (context, index, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        key: ValueKey(homeProvider.blockedOffer[index].offerId),
                                        child: OfferTile(
                                          parentContext: context,
                                          offer: homeProvider.blockedOffer[index],
                                          asset: homeProvider.blockedOfferAssets[homeProvider.blockedOffer[index].assetId]!,
                                          forPurchase: false,
                                          function: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                ),
                                                contentPadding: EdgeInsets.all(25.0),
                                                title: Text(
                                                  AppLocalizations.of(context)!.titlePopUpUnblockingOffer,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.25,
                                                  width: MediaQuery.of(context).size.width * 0.8,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(context)!.textPopUpUnblockOffer,
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: DefaultButton(
                                                                  label: AppLocalizations.of(context)!.buttonClose,
                                                                  parentContext: context,
                                                                  function: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  futureFunction: null)
                                                          ),
                                                          Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: DefaultButton(
                                                                label: AppLocalizations.of(context)!.buttonDelete,
                                                                parentContext: context,
                                                                function: null,
                                                                futureFunction: () async {
                                                                  await homeProvider.deleteIdBlockedOffer(context, homeProvider.blockedOffer[index]);
                                                                  Navigator.pop(context);
                                                                  Offer deletedOffer = homeProvider.blockedOffer[index];
                                                                  homeProvider.blockedOffer.removeAt(index);
                                                                  homeProvider.listKey.currentState!.removeItem(
                                                                    index,
                                                                    (_, animation) => SizeTransition(
                                                                      axis: Axis.vertical,
                                                                      sizeFactor: animation,
                                                                      child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width,
                                                                        height: MediaQuery.of(context).size.height * 0.1,
                                                                        child: OfferTile(
                                                                          parentContext: context,
                                                                          offer: deletedOffer,
                                                                          asset: homeProvider.blockedOfferAssets[deletedOffer.assetId]!,
                                                                          forPurchase: false,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    duration: const Duration(milliseconds: 500),
                                                                  );
                                                                  Future.delayed(const Duration(milliseconds: 500), () {
                                                                    homeProvider.notifyListeners();
                                                                  });
                                                                },
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      if (index != homeProvider.blockedOffer.length)
                                        SizedBox(height: 10)
                                    ],
                                  ),
                                );
                              }
                          )
                          : Center(
                            child: Text(AppLocalizations.of(context)!.textNoBlockedOffer),
                          )
                              : const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ]
                  ),
                );
              }
            );
          }
        ),
      ),
    );
  }
}
