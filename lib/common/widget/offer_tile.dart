import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/models/Contract.dart';
import 'package:Resilink/providers/main_provider.dart';

import '../../constants/global_variables.dart';
import '../../features/home_navigation/provider/home_navigation_provider.dart';
import '../../models/Asset.dart';
import '../../models/Offer.dart';

/*
 * A widget that displays an offer in a tile format, typically used in a list.
 * The tile includes information about the asset and offer, and can navigate to detailed views when tapped.
 */
class OfferTile extends StatelessWidget {
  OfferTile({super.key, required this.parentContext, required this.offer, required this.asset, required this.forPurchase, this.function, this.contract, this.homeNavigationProvider});

  // inherited variables
  BuildContext parentContext;
  Offer offer;
  Asset asset;
  bool forPurchase;
  Function? function;
  Contract? contract;
  HomeNavigationProvider? homeNavigationProvider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
            color: GlobalVariables.navigationBarColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              asset.name,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              offer.beginTimeSlot,
              style: TextStyle(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              if (function != null) {
                function!();
              } else if (homeNavigationProvider != null) {

                /*
                 * If a HomeNavigationProvider is provided, pop the current screen and update the navigation state.
                 * If a contract has been supplied, this is an offer that has been purchased,
                 * so add the contract status to the offer details screen.
                 */

                Navigator.pop(context);
                contract != null
                    ? parentContext.read<MainProvider>().setOfferAssetContractViewDetails(offer, asset, contract!)
                    : parentContext.read<MainProvider>().setOfferAndAssetViewDetails(offer, asset, forPurchase);
                homeNavigationProvider!.setIndexAndUpdateHeader(1);
              } else {
                /*
                 * If no HomeNavigationProvider, no need to pop the previous screen and use the context to navigate.
                 * If a contract has been supplied, this is an offer that has been purchased,
                 * so add the contract status to the offer details screen.
                 */
                contract != null
                ? parentContext.read<MainProvider>().setOfferAssetContractViewDetails(offer, asset, contract!)
                    : parentContext.read<MainProvider>().setOfferAndAssetViewDetails(offer, asset, forPurchase);
                parentContext.read<HomeNavigationProvider>().setIndexAndUpdateHeader(1);
              }
            },
            trailing: Container(
              width: constraints.maxWidth * 0.2,  // Constrain the width of the image container to 20% of the parent container
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: asset.images!.isEmpty ? Image(
                image: AssetImage(GlobalVariables.assetTypeImages[asset.assetType.toLowerCase().replaceAll(RegExp(r'[\d\s]+'), '')]!),
              ) : asset.images![0].toString().contains("https://") ? Image.network(
                asset.images!.first,
                fit: BoxFit.fill,
              ) : Transform.scale(
                alignment: Alignment.centerRight,
                scaleX: 1,
                child: Image.memory(
                  fit: BoxFit.fill,
                  context.read<MainProvider>().convertBase64ToImg(asset.images!.first),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
