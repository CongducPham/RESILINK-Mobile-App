import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/publish/provider/publish_provider.dart';
import 'package:resilink_design/features/search/provider/search_provider.dart';

class AssetTypeCard extends StatelessWidget {
  AssetTypeCard({super.key, required this.label, required this.icon, required this.parentContext, required this.publishProvider});

  String label;
  IconData icon;
  BuildContext parentContext;
  PublishProvider? publishProvider;

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

  Widget buildCard(BuildContext context, dynamic provider) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Opacity(
          opacity: (provider.selected && (provider.runtimeType == PublishProvider ? provider.assetType == label : provider.filter.assetType == label)) || !provider.selected ? 1 : 0.3 ,
          child: GestureDetector(
            onTap:
                provider.runtimeType == PublishProvider ?
                  () {
                    provider.setAssetTypeAndIsSelected( provider.assetType.isNotEmpty ? "" : label, provider.selected ? false : true);
                  }
                :
                  (provider.selected && provider.filter.assetType == label) || !provider.selected ? () {
                    provider.filter.setAssetType(provider.filter.assetType.isEmpty ? label : "");
                    provider.setSelected( provider.selected ? false : true);
                  } : () {},
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: constraints.maxHeight * 0.3,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                        label,
                        style: TextStyle(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
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