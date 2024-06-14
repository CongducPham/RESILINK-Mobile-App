import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/providers/user_provider.dart';

import '../../constants/global_variables.dart';
import '../../features/home_navigation/provider/home_navigation_provider.dart';
import '../../models/Asset.dart';
import '../../models/Offer.dart';

class OfferTile extends StatelessWidget {
  OfferTile({super.key, required this.parentContext, required this.offer, required this.asset});

  BuildContext parentContext;
  Offer offer;
  Asset asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
        color: GlobalVariables.navigationBarColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
          title: Text(asset.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(offer.beginTimeSlot, style: TextStyle(fontSize: 11),maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            parentContext.read<UserProvider>().setOfferAndAssetViewDetails(offer, asset);
            parentContext.read<HomeNavigationProvider>().setIndexAndUpdateHeader(1);
          },
          trailing: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                )
            ),
            child: Image(
              image: AssetImage(GlobalVariables.assetTypeImages[asset.assetType.toLowerCase()] ?? GlobalVariables.assetTypeImages['noimage']!),
            )
          ),
      ),
    );
  }

}