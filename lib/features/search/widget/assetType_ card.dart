import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/publish/provider/publish_provider.dart';
import 'package:Resilink/features/search/provider/search_provider.dart';
import 'package:Resilink/providers/main_provider.dart';

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
              print(provider.filter.assetType);
            },
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      icon,
                      fit: BoxFit.fill,
                      height: constraints.maxHeight * 0.3,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                      publishProvider!.getTradAssetType(label, parentContext),
                      style: TextStyle(fontSize: 11),
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
