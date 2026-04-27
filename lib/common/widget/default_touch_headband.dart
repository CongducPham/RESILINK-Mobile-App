/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/features/account/provider/account_provider.dart';

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

  // Inherited variables
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
            ),
          ),
          Expanded(
            flex: expired ? 8 : 9,
            child: Text(
              asset.name,
              overflow: TextOverflow.ellipsis,
              // Asset name in a list row — titleMedium fits a compact label
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Icon(Icons.mode_edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}