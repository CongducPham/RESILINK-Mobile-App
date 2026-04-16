import 'package:resilink_mobile_application/features/account/screen/about_us_screen.dart';
import 'package:resilink_mobile_application/features/account/screen/all_owner_offers_published.dart';
import 'package:resilink_mobile_application/features/account/screen/all_owner_offers_purchased.dart';
import 'package:resilink_mobile_application/features/account/screen/server_list_screen.dart';
import 'package:resilink_mobile_application/features/account/screen/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_touch_headband.dart';
import 'package:resilink_mobile_application/common/widget/offer_tile.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/account/provider/account_provider.dart';
import 'package:resilink_mobile_application/features/account/screen/account_profile.dart';
import 'package:resilink_mobile_application/features/onboarding/screen/onboarding_screen.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/account/screen/parameters_language.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

import '../../../common/widget/default_button.dart';
import '../../select_country/screen/select_country_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;

  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountProvider(),
      builder: (context, child) {
        return Consumer3<MainProvider, AccountProvider, HomeNavigationProvider>(
          builder: (context, mainProvider, accountProvider, homeNavigationProvider, child) {
            if (!accountProvider.finishFetchPurchase && !accountProvider.finishFetchOffer && homeNavigationProvider.selectedIndex == 4) {
              accountProvider.setLastOfferPublish(context);
            }

            return SingleChildScrollView(
              controller: accountProvider.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── NAVIGATION SHORTCUTS ────────────────────────────
                      GestureDetector(
                        onTap: () => accountProvider.scrollToSection(accountProvider.profileKey),
                        child: Text(
                          AppLocalizations.of(context)!.accountShiftToProfile,
                          // titleMedium (16, w500) + couleur
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => accountProvider.scrollToSection(accountProvider.offerKey),
                        child: Text(
                          AppLocalizations.of(context)!.accountShiftToOffer,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => accountProvider.scrollToSection(accountProvider.parametersKey),
                        child: Text(
                          AppLocalizations.of(context)!.accountShiftToParameters,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      AccountProfile(parentContext: context, accountProvider: accountProvider),
                      const SizedBox(height: 10),

                      Container(key: accountProvider.offerKey),

                      // ── PUBLISHED OFFERS TITLE ──────────────────────────
                      Text(
                        AppLocalizations.of(context)!.accountTitlePublish,
                        // titleMedium (16, w500) + override bold
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ── PUBLISHED OFFERS LIST ───────────────────────────
                      Container(
                        constraints: const BoxConstraints(maxHeight: 170),
                        height: MediaQuery.of(context).size.height * 0.08 *
                            (accountProvider.lastOfferPublish.isNotEmpty
                                ? accountProvider.lastOfferPublish.length > 3 ? 3 : accountProvider.lastOfferPublish.length
                                : 2),
                        child: accountProvider.finishFetchOffer && !accountProvider.loadingFetchOffer
                            ? accountProvider.lastOfferPublish.isNotEmpty
                            ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: accountProvider.lastOfferPublish.length > 3
                              ? 3
                              : accountProvider.lastOfferPublish.length,
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
                                          titlePadding: EdgeInsets.zero,
                                          title: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: IconButton(
                                                  icon: const Icon(Icons.arrow_back),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 12.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)!.titlePopUpModifyOffer,
                                                    // titleLarge (22) + override bold
                                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.25,
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    DateTime.parse(accountProvider.lastOfferPublish[index].validityLimit)
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
                                                          accountProvider.toUpdateOffer(
                                                            accountProvider.lastOfferPublish[index],
                                                            accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!,
                                                            homeNavigationProvider,
                                                            mainProvider,
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
                                                        futureFunction: () => accountProvider.deleteOfferAsset(
                                                          context,
                                                          accountProvider.lastOfferPublish[index].id!,
                                                          accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!.id,
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
                                    offer: accountProvider.lastOfferPublish[index],
                                    asset: accountProvider.listOfferAsset[accountProvider.lastOfferPublish[index].assetId]!,
                                    accountProvider: accountProvider,
                                  ),
                                ),
                                if (index != accountProvider.lastOfferPublish.length)
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

                  // ── SEE MORE PUBLISHED ────────────────────────────────
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllOwnerOfferPublished(
                              accountProvider: accountProvider,
                              homeNavigationProvider: homeNavigationProvider,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.seeMoreText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: GlobalVariables.tertiaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ── PARAMETERS TITLE ─────────────────────────────────
                  Text(
                    key: accountProvider.parametersKey,
                    AppLocalizations.of(context)!.accountTitleParameters,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ── PARAMETERS ITEMS ─────────────────────────────────
                  _ParameterItem(
                    icon: Icons.language,
                    label: AppLocalizations.of(context)!.accountSubTitleLanguage,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParametersLanguage())),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.dns,
                    label: AppLocalizations.of(context)!.ipAddressPageTitle,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerListPage())),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.flag_circle_outlined,
                    label: AppLocalizations.of(context)!.accountSubTitleLocalization,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SelectCountryScreen(fromParameters: true))),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.lightbulb_outline,
                    label: AppLocalizations.of(context)!.accountSubTitleOnboarding,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingScreen(fromParameters: true))),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.info_outline,
                    label: AppLocalizations.of(context)!.accountSubTitleAboutUs,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.star_border,
                    label: AppLocalizations.of(context)!.accountTitleRating,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RatingScreen())),
                  ),
                  const SizedBox(height: 10),
                  _ParameterItem(
                    icon: Icons.logout_outlined,
                    label: AppLocalizations.of(context)!.accountSubTitleLogOut,
                    onTap: () {
                      mainProvider.logOutUser();
                      homeNavigationProvider.setIndexAndUpdateHeader(0);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Extracted widget for parameter row items — avoids repeating
/// the same Row(Icon + Text) pattern 7 times.
class _ParameterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ParameterItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 20),
          Text(
            label,
            // titleLarge (22) for settings navigation items
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}