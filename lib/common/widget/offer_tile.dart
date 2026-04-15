import 'package:resilink_mobile_application/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/models/Contract.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

import '../../constants/global_variables.dart';
import '../../features/home_navigation/provider/home_navigation_provider.dart';
import '../../models/Asset.dart';
import '../../models/Offer.dart';

class OfferTile extends StatelessWidget {
  OfferTile({
    super.key,
    required this.parentContext,
    required this.offer,
    required this.asset,
    required this.forPurchase,
    this.serverUrl,
    this.function,
    this.contract,
    this.homeNavigationProvider,
    this.onOfferBlocked,
    this.fromHome = false,
  });

  BuildContext parentContext;
  Offer offer;
  Asset asset;
  bool forPurchase;
  String? serverUrl;
  Function? function;
  Contract? contract;
  HomeNavigationProvider? homeNavigationProvider;
  final VoidCallback? onOfferBlocked;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    // Display serverName if available, otherwise fall back to truncated serverUrl
    final String displayServer = (offer.serverName != null && offer.serverName!.isNotEmpty)
        ? offer.serverName!
        : (offer.serverUrl ?? '');

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
            color: GlobalVariables.backgroundTile,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Asset title
                Text(
                  asset.name,
                  // Compact bold label in a list row — titleMedium with bold weight
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Colored badge/chip with server name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: GlobalVariables.tertiaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: GlobalVariables.tertiaryColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dns_outlined,
                        size: 10,
                        color: GlobalVariables.tertiaryColor,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          displayServer,
                          // Small badge label — bodyMedium scaled down for chip context
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                parentContext.read<MainProvider>().changeDateFormatToInterface(
                    offer.beginTimeSlot, parentContext.read<LocaleProvider>().valueLocale),
                // Secondary metadata — bodyMedium scaled down for subtitle context
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: () {
              if (function != null) {
                function!();
              } else {
                if (forPurchase && parentContext.read<MainProvider>().userName != "public") {
                  parentContext.read<MainProvider>().incrementCountInterestForAssetType(
                    context.read<MainProvider>().actualUser!.accessToken,
                    context.read<MainProvider>().actualUser!.username,
                    asset.assetType,
                  );
                }

                parentContext.read<MainProvider>().pendingOnOfferBlocked = onOfferBlocked;
                parentContext.read<MainProvider>().offerBlockedFromHome = fromHome;

                if (homeNavigationProvider != null) {
                  Navigator.pop(context);
                  contract != null
                      ? parentContext.read<MainProvider>().setOfferAssetContractViewDetails(offer, asset, contract!)
                      : parentContext.read<MainProvider>().setOfferAndAssetViewDetails(offer, asset, forPurchase);
                  homeNavigationProvider!.setIndexAndUpdateHeader(1);
                } else {
                  contract != null
                      ? parentContext.read<MainProvider>().setOfferAssetContractViewDetails(offer, asset, contract!)
                      : parentContext.read<MainProvider>().setOfferAndAssetViewDetails(offer, asset, forPurchase);
                  parentContext.read<HomeNavigationProvider>().setIndexAndUpdateHeader(1);
                }
              }
            },
            trailing: Container(
              width: constraints.maxWidth * 0.2,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: asset.images!.isEmpty
                  ? Image(
                image: AssetImage(GlobalVariables.assetTypeImages[
                asset.assetType.toLowerCase().replaceAll(RegExp(r'[\d\s]+'), '')]!),
              )
                  : asset.images![0].toString().contains("https://") ||
                  asset.images![0].toString().contains("http://")
                  ? Image.network(asset.images!.first, fit: BoxFit.fill)
                  : Transform.scale(
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