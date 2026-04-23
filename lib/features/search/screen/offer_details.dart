import 'package:resilink_mobile_application/common/widget/default_pop_up.dart';
import 'package:resilink_mobile_application/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/service/Launch_in_external_app.dart';
import '../provider/search_provider.dart';
import '../provider/update_contract.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key});

  // Helper widget: a row with icon + label + value
  Widget _infoRow({
    required BuildContext context,        // ← added to access the theme
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    FontWeight valueFontWeight = FontWeight.normal,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Text(
            label,
            style: textTheme.bodySmall!.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall!.copyWith(
                fontWeight: valueFontWeight,
                color: valueColor ?? Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Thin divider between sections
  Widget _sectionDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Consumer2<SearchProvider, HomeNavigationProvider>(
        builder: (context, searchProvider, homeNavigationProvider, child) {
          final offer = context.read<MainProvider>().offerDetails!;
          final asset = context.read<MainProvider>().assetDetails!;
          final bool isPublic = context.read<MainProvider>().actualUser!.username == "public";

          final String displayServer = (offer.serverName != null && offer.serverName!.isNotEmpty)
              ? offer.serverName!
              : (offer.serverUrl ?? '');

          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
                  color: GlobalVariables.navigationBarColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── HEADER ──────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Asset name + price badge + quantity
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.name,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Price badge
                                _StatBadge(
                                  icon: Icons.sell_outlined,
                                  label: offer.price != 0
                                      ? offer.price.toString()
                                      : AppLocalizations.of(context)!.offerDetailsNoPrice,
                                  color: GlobalVariables.primaryColor,
                                ),
                                const SizedBox(height: 6),
                                // Quantity as readable text
                                Row(
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 13, color: Colors.grey.shade500),
                                    const SizedBox(width: 5),
                                    Text(
                                      AppLocalizations.of(context)!.offerDetailsQuantity,
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Text(
                                      asset.totalQuantity != 0
                                          ? asset.totalQuantity.toString()
                                          : AppLocalizations.of(context)!.offerDetailsMaterial,
                                      style: textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Block button
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (context.read<MainProvider>().actualContract == null)
                                IconButton(
                                  onPressed: () {
                                    if (!isPublic) {
                                      DefaultPopUp.show(
                                        context,
                                            () async {
                                          final bool cameFromHome =
                                              context.read<MainProvider>().offerBlockedFromHome;
                                          await searchProvider.addBlockedOffer(
                                              context, offer, homeNavigationProvider);
                                          context.read<MainProvider>().pendingOnOfferBlocked?.call();
                                          context.read<MainProvider>().pendingOnOfferBlocked = null;
                                          context.read<MainProvider>().clearOfferDetails();
                                          context.read<MainProvider>().offerBlockedFromHome = false;
                                          if (cameFromHome) {
                                            homeNavigationProvider.setIndexAndUpdateHeader(0);
                                          }
                                        },
                                        null,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.block_outlined,
                                    color: isPublic ? Colors.grey.shade300 : Colors.red.shade400,
                                  ),
                                  iconSize: 22,
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    _sectionDivider(),

                    // ── IMAGE ────────────────────────────────────────────────
                    ClipRRect(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        color: Colors.grey.shade50,
                        child: Center(
                          child: asset.images!.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Image(
                              image: AssetImage(
                                GlobalVariables.assetTypeImages[
                                asset.assetType.toLowerCase().replaceAll(RegExp(r'[\d\s]+'), '') ??
                                    'noimage']!,
                              ),
                              fit: BoxFit.contain,
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: asset.images!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: asset.images![index].toString().contains("https://")
                                      ? Image.network(asset.images![index], fit: BoxFit.cover)
                                      : Image.memory(
                                    context
                                        .read<MainProvider>()
                                        .convertBase64ToImg(asset.images![index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    _sectionDivider(),

                    // ── INFOS ────────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Publisher
                          _infoRow(
                            context: context,
                            icon: Icons.person_outline,
                            label: AppLocalizations.of(context)!.offerDetailsPublisher,
                            value: offer.offerer,
                            valueFontWeight: FontWeight.w500,
                          ),
                          // Server
                          _infoRow(
                            context: context,
                            icon: Icons.dns_outlined,
                            label: "",
                            value: displayServer,
                            valueColor: GlobalVariables.tertiaryColor,
                            valueFontWeight: FontWeight.w500,
                          ),
                          // Start date
                          _infoRow(
                            context: context,
                            icon: Icons.calendar_today_outlined,
                            label: AppLocalizations.of(context)!.offerDetailsPeriod,
                            value: context.read<MainProvider>().changeDateFormatToInterface(
                                offer.beginTimeSlot,
                                context.read<LocaleProvider>().valueLocale),
                          ),
                          // End date
                          _infoRow(
                            context: context,
                            icon: Icons.event_outlined,
                            label: AppLocalizations.of(context)!.offerDetailsPeriodEnd,
                            value: context.read<MainProvider>().changeDateFormatToInterface(
                                offer.validityLimit,
                                context.read<LocaleProvider>().valueLocale),
                          ),
                          // Acheteur (si contrat)
                          if (context.read<MainProvider>().actualContract != null)
                            _infoRow(
                              context: context,
                              icon: Icons.handshake_outlined,
                              label: AppLocalizations.of(context)!.offerDetailsBuyer,
                              value: context.read<MainProvider>().actualContract!.requester,
                              valueFontWeight: FontWeight.w500,
                            ),
                        ],
                      ),
                    ),

                    // ── SPECIFIC ATTRIBUTES ───────────────────────────────────
                    if (asset.specificAttributes != null && asset.specificAttributes!.isNotEmpty)
                      ...[
                        _sectionDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              for (var attr in asset.specificAttributes!)
                                if (attr.value.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${attr.attributeName}  ',
                                            style: textTheme.labelSmall!.copyWith(
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: attr.value,
                                            style: textTheme.labelSmall!.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],

                    _sectionDivider(),

                    // ── DESCRIPTION ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.offerDetailsTitleDescription,
                            // bodyMedium + override taille/couleur/poids
                            style: textTheme.labelMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            constraints:
                            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.08),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              asset.description.isEmpty
                                  ? AppLocalizations.of(context)!.offerDetailsBodyDescription
                                  : asset.description,
                              style: textTheme.bodySmall!.copyWith(
                                color: asset.description.isEmpty
                                    ? Colors.grey.shade400
                                    : Colors.black87,
                                height: 1.5,
                              ),
                              textDirection: context.read<LocaleProvider>().valueLocale == "en"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── CONTACT BUTTON ───────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: DefaultButton(
                          label: AppLocalizations.of(context)!.buttonContact,
                          parentContext: context,
                          function: () => offer.ownerPhoneNumber != ""
                              ? launchInBrowser(
                              Uri.parse("https://wa.me/${offer.ownerPhoneNumber}"))
                              : null,
                          futureFunction: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── CONTRACT MANAGEMENT ───────────────────────────────────────
              if (context.read<MainProvider>().actualContract != null)
                ChangeNotifierProvider(
                  create: (_) => UpdateContractProvider(),
                  builder: (context, child) {
                    return Consumer<UpdateContractProvider>(
                      builder: (context, updateContractProvider, child) {
                        if (updateContractProvider.deliveryState.isEmpty) {
                          updateContractProvider.setInitialValue(
                            context.read<MainProvider>().actualContract!,
                            homeNavigationProvider.allAssetType[asset.assetType]!.nature,
                            context,
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
                            color: GlobalVariables.navigationBarColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.contractChangeStateText,
                                  // titleMedium (16, w500) + override w600
                                  style: textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.contractActualStateText,
                                // bodyMedium (14) + override couleur, taille proche de 13
                                style: textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  context.read<MainProvider>().actualContract!.state,
                                  // labelLarge (14, w500) + override bold
                                  style: textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.contractNewStateText,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: DropdownButton(
                                  value: updateContractProvider.deliveryValue,
                                  items: updateContractProvider.deliveryState
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        // bodyMedium (14) + override taille 13
                                        child: Text(value, style: textTheme.bodyMedium!.copyWith(fontSize: 13)));
                                  }).toList(),
                                  onChanged: (String? value) =>
                                      updateContractProvider.setDeliveryValue(value!),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DefaultButton(
                                    label: AppLocalizations.of(context)!.buttonDelete,
                                    parentContext: context,
                                    function: null,
                                    futureFunction: () => updateContractProvider.deleteContract(
                                        context,
                                        context.read<MainProvider>().actualContract!,
                                        homeNavigationProvider),
                                  ),
                                  const SizedBox(width: 10),
                                  DefaultButton(
                                    label: AppLocalizations.of(context)!.buttonModify,
                                    parentContext: context,
                                    function: null,
                                    futureFunction: () => updateContractProvider.updateContract(
                                      context,
                                      context.read<MainProvider>().actualContract!,
                                      homeNavigationProvider.allAssetType[asset.assetType]!.nature,
                                      homeNavigationProvider,
                                    ),
                                  ),
                                ],
                              ),
                              Stepper(
                                controller: ScrollController(keepScrollOffset: false),
                                currentStep: updateContractProvider.currentStep,
                                controlsBuilder: (context, details) => const SizedBox(),
                                steps: [
                                  Step(
                                      title: Text(AppLocalizations.of(context)!.contractStateProceeding),
                                      content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis),
                                      isActive: updateContractProvider.currentStep >= 0,
                                      state: updateContractProvider.currentStep >= 0 ? StepState.complete : StepState.disabled),
                                  Step(
                                      title: Text(AppLocalizations.of(context)!.contractActualStateText),
                                      content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis),
                                      isActive: updateContractProvider.currentStep >= 1,
                                      state: updateContractProvider.currentStep >= 1 ? StepState.complete : StepState.disabled),
                                  Step(
                                      title: Text(AppLocalizations.of(context)!.contractStateReceived),
                                      content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis),
                                      isActive: updateContractProvider.currentStep >= 2,
                                      state: updateContractProvider.currentStep >= 2 ? StepState.complete : StepState.disabled),
                                  Step(
                                      title: Text(AppLocalizations.of(context)!.contractStateDelivered),
                                      content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis),
                                      isActive: updateContractProvider.currentStep >= 3,
                                      state: updateContractProvider.currentStep >= 3 ? StepState.complete : StepState.disabled),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Compact badge: icon + text on a light colored background
class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}