import 'package:flutter/material.dart';
import 'package:Resilink/features/account/provider/account_provider.dart';

import '../../constants/global_variables.dart';
import '../../models/Asset.dart';
import '../../models/Offer.dart';

/*
 * A customizable widget representing a touch-sensitive headband-like UI component.
 * The `DefaultTouchHeadband` widget displays the name of an `Asset` and an edit icon, with an optional warning icon if the associated `Offer` has expired.
 * The UI adapts based on the expiration status of the offer.
 */
class DefaultTouchHeadband extends StatelessWidget {
  DefaultTouchHeadband({super.key, required this.offer, required this.asset, required this.accountProvider});

  // inherited variables
  Offer offer;
  Asset asset;
  AccountProvider accountProvider;

  @override
  Widget build(BuildContext context) {
    bool expired = DateTime.parse(offer.validityLimit).isBefore(DateTime.now().toUtc().add(Duration(hours: 1)));

    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: GlobalVariables.navigationBarColor,
      ),
      child: Row(
        children: [
           Expanded(
              flex: 2,
              child: Center(
                child: expired ? const Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ) : Container(),
              )
          ),
          Expanded(
              flex: expired ? 8 : 9,
              child: Container(
                child: Text(
                  asset.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Icon(
                  Icons.mode_edit_outlined
                ),
              )
          ),
        ],
      ),
    );
  }


}