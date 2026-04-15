import 'package:resilink_mobile_application/features/account/provider/account_provider.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/default_button.dart';
import '../../../common/widget/default_touch_headband.dart';
import '../../../constants/global_variables.dart';

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
        // AppBar title → rien à changer ✅
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: GlobalVariables.navigationBarColor,
          title: Center(
            child: Text(
              AppLocalizations.of(context)!.ownerOfferPublished,
              style: const TextStyle(color: GlobalVariables.textHeaderColor),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.transparent),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08 *
                      (widget.accountProvider.lastOfferPublish.isNotEmpty
                          ? widget.accountProvider.lastOfferPublish.length
                          : 2),
                  child: widget.accountProvider.finishFetchOffer && !widget.accountProvider.loadingFetchOffer
                      ? widget.accountProvider.lastOfferPublish.isNotEmpty
                      ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.accountProvider.lastOfferPublish.length,
                    itemBuilder: (_, int index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(25.0),
                                    title: Text(
                                      AppLocalizations.of(context)!.titlePopUpModifyOffer,
                                      // titleLarge (22) + override bold
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                                              DateTime.parse(widget.accountProvider.lastOfferPublish[index].validityLimit)
                                                  .isBefore(DateTime.now().toUtc().add(const Duration(hours: 1)))
                                                  ? AppLocalizations.of(context)!.textPopUpModifyOfferBad
                                                  : AppLocalizations.of(context)!.textPopUpModifyOfferGood,
                                              // bodyMedium (14)
                                              style: Theme.of(context).textTheme.bodyMedium,
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
                                                    widget.accountProvider.toUpdateOffer(
                                                      widget.accountProvider.lastOfferPublish[index],
                                                      widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!,
                                                      widget.homeNavigationProvider,
                                                      context.read<MainProvider>(),
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
                                                  futureFunction: () => widget.accountProvider.deleteOfferAsset(
                                                    context,
                                                    widget.accountProvider.lastOfferPublish[index].id!,
                                                    widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!.id,
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
                            child: DefaultTouchHeadband(
                              offer: widget.accountProvider.lastOfferPublish[index],
                              asset: widget.accountProvider.listOfferAsset[widget.accountProvider.lastOfferPublish[index].assetId]!,
                              accountProvider: widget.accountProvider,
                            ),
                          ),
                          if (index != widget.accountProvider.lastOfferPublish.length)
                            const SizedBox(height: 10),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      AppLocalizations.of(context)!.textNoOfferPublish,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}