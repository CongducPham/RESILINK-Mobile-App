import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_touch_headband.dart';
import 'package:resilink_design/common/widget/offer_tile.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/account/provider/account_provider.dart';
import 'package:resilink_design/features/account/screen/account_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:resilink_design/features/account/screen/parameters_language.dart';
import 'package:resilink_design/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_design/features/select_country/screen/select_country_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;
  @override
  State<StatefulWidget> createState() {
    return AccountScreenState();
  }

}

class AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountProvider(),
      builder: (context, child) {
        return SingleChildScrollView(
            controller: context.read<AccountProvider>().scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                GestureDetector(
                    onTap: () => context.read<AccountProvider>().scrollToSection(context.read<AccountProvider>().profileKey) ,
                    child: Text(
                      AppLocalizations.of(context)!.accountShiftToProfile,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.tersiaryColor
                      ),
                    ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => context.read<AccountProvider>().scrollToSection(context.read<AccountProvider>().offerKey) ,
                  child: Text(
                    AppLocalizations.of(context)!.accountShiftToOffer,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.tersiaryColor
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => context.read<AccountProvider>().scrollToSection(context.read<AccountProvider>().parametersKey) ,
                  child: Text(
                    AppLocalizations.of(context)!.accountShiftToParameters,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.tersiaryColor
                    ),
                  ),
                ),
                SizedBox(height: 10),
                AccountProfile(parentContext: context),
                const SizedBox(height: 5),
                Text(
                  key: context.read<AccountProvider>().offerKey,
                  AppLocalizations.of(context)!.accountPurchasesTitle,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13 * context.read<AccountProvider>().lastOfferPublish.length,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: context.read<AccountProvider>().lastOfferPublish.length,
                    itemBuilder: (_, int index) {
                      return Column(
                        children: [
                          OfferTile(parentContext: context, offer: context.read<AccountProvider>().lastOfferPublish[index], asset: context.read<AccountProvider>().listOfferAsset[context.read<AccountProvider>().lastOfferPublish[index].assetId]!),
                          if (index != context.read<AccountProvider>().lastOfferPublish.length)
                            SizedBox(height: 10)
                        ],
                      );
                    }
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.accountTitlePublish,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15),
                DefaultTouchHeadband(delete: true, update: true, parentContext: context),
                const SizedBox(height: 15),
                Text(
                  key: context.read<AccountProvider>().parametersKey,
                  AppLocalizations.of(context)!.accountTitleParameters,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ParametersLanguage(homeNavigationProvider: widget.homeNavigationProvider)));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 30,
                      ),
                      const SizedBox(width: 20),
                      Text(
                          AppLocalizations.of(context)!.accountSubTitleLanguage,
                          style: const TextStyle(
                            fontSize: 18
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                /*GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(
                        Icons.place_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 20),
                      Text("Localization", style: TextStyle(
                          fontSize: 15
                      )),
                    ],
                  ),
                ),
                 */
              ],
            )
        );
      },
    );
  }

}
