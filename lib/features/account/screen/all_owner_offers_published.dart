import 'package:Resilink/features/account/provider/account_provider.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/default_button.dart';
import '../../../common/widget/default_touch_headband.dart';
import '../../../constants/global_variables.dart';

// Widget for the published offers management page
class AllOwnerOfferPublished extends StatefulWidget {
  AllOwnerOfferPublished({super.key, required this.accountProvider, required this.homeNavigationProvider});

  AccountProvider accountProvider;
  HomeNavigationProvider homeNavigationProvider;

  @override
  AllOwnerOfferPublishedState createState() => AllOwnerOfferPublishedState();
}

class AllOwnerOfferPublishedState extends State<AllOwnerOfferPublished> {

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
                  height: MediaQuery.of(context).size.height * 0.08 * (widget.accountProvider.lastOfferPublish.isNotEmpty ? widget.accountProvider.lastOfferPublish.length : 2),
                  child: widget.accountProvider.finishFetchOffer && !widget.accountProvider.loadingFetchOffer ? // if loadingFetchOffer is true, the asynchronous function is not completed and a waiting icon is displayed
                  widget.accountProvider.lastOfferPublish.isNotEmpty ? // if lastOfferPublish is empty, there is no offers in the list so a message is displayed
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.accountProvider.lastOfferPublish.length,
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
                                      title: Text(
                                        AppLocalizations.of(context)!.titlePopUpModifyOffer,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Container(
                                        height: MediaQuery.of(context).size.height * 0.25,
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                DateTime.parse(widget.accountProvider.lastOfferPublish[index].validityLimit).isBefore(DateTime.now().toUtc().add(Duration(hours: 1))) ?
                                                AppLocalizations.of(context)!.textPopUpModifyOfferBad
                                                    : AppLocalizations.of(context)!.textPopUpModifyOfferGood,
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
                                                        label: AppLocalizations.of(context)!.buttonModify,
                                                        parentContext: context,
                                                        function: () {
                                                          Navigator.pop(context);
                                                          widget.accountProvider.toUpdateOffer(widget.accountProvider.lastOfferPublish[index], widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!, widget.homeNavigationProvider, context.read<MainProvider>(), context);
                                                          },
                                                        futureFunction: null)
                                                ),
                                                Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: DefaultButton(
                                                        label: AppLocalizations.of(context)!.buttonDelete,
                                                        parentContext: context,
                                                        function: null,
                                                        futureFunction: () => widget.accountProvider.deleteOfferAsset(context, widget.accountProvider.lastOfferPublish[index].offerId!, widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!.id))
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              //Default widget to display a customized container for published offers, as it requires information that cannot be displayed in a classic tile.
                              child: DefaultTouchHeadband(
                                offer: widget.accountProvider.lastOfferPublish[index],
                                asset: widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!,
                                accountProvider: widget.accountProvider,),
                            ),
                            if (index != widget.accountProvider.lastOfferPublish.length)
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
            ]),
          ),
        ),
      ),
    );
  }
}
