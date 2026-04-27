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
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/publish/provider/publish_provider.dart';
import 'package:resilink_mobile_application/features/search/provider/search_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

// A card widget displaying an asset type with an icon and label.
class AssetTypeCard extends StatelessWidget {

  AssetTypeCard({
    super.key,
    required this.label,
    required this.icon,
    required this.parentContext,
    required this.publishProvider,
  });

  final String label;
  final String icon;
  final BuildContext parentContext;
  final PublishProvider? publishProvider;

  @override
  Widget build(BuildContext context) {
    return publishProvider != null
        ? buildCard(context, publishProvider)
        : Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return buildCard(context, searchProvider);
      },
    );
  }

  // Builds the card with appropriate behavior based on the provider.
  Widget buildCard(BuildContext context, dynamic provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Opacity(
          opacity: (provider.selected && (provider.runtimeType == PublishProvider ? provider.assetType == label : provider.filter.assetType == label))
              || !provider.selected ? 1 : 0.3,
          // Handles tap events on the card.
          // For `PublishProvider`, it toggles the selection state of the asset type.
          // For `SearchProvider`, it updates the selected asset type filter.
          child: GestureDetector(
            onTap: context.read<MainProvider>().offerDetails != null ? () {}
                : provider.runtimeType == PublishProvider ? () {
              provider.setAssetTypeAndIsSelected(
                  provider.assetType.isNotEmpty ? "" : label,
                  !provider.selected
              );
            } : () {
              provider.filter.setAssetType(provider.filter.assetType.isEmpty ? label : "");
              provider.setSelected(!provider.selected);
            },
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: (provider.selected && (provider.runtimeType == PublishProvider ? provider.assetType == label : provider.filter.assetType == label))
                    ? GlobalVariables.primaryColor : GlobalVariables.textDefaultColor),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      icon,
                      fit: BoxFit.fill,
                      height: constraints.maxHeight * 0.3,
                      color: (provider.selected && (provider.runtimeType == PublishProvider ? provider.assetType == label : provider.filter.assetType == label))
                          ? GlobalVariables.primaryColor : GlobalVariables.textDefaultColor,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                      parentContext.read<MainProvider>().getTradAssetType(label, parentContext),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(color: (provider.selected && (provider.runtimeType == PublishProvider ? provider.assetType == label : provider.filter.assetType == label))
                          ? GlobalVariables.primaryColor : GlobalVariables.textDefaultColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
