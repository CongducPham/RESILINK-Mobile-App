import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_touch_headband.dart';
import 'package:resilink_design/common/widget/offer_tile.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/account/provider/account_provider.dart';
import 'package:resilink_design/features/account/screen/account_profile.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text("Profile >>>"),
                SizedBox(height: 20),
                Text("Offers >>>"),
                SizedBox(height: 20),
                Text("Parameters >>>"),
                SizedBox(height: 20),

                 */
                AccountProfile(parentContext: context),
                const SizedBox(height: 5),
                const Text(
                  "Ongoing purchases",
                  style: TextStyle(
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
                const Text(
                  "Offers published",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15),
                DefaultTouchHeadband(delete: true, update: true, parentContext: context),
                const SizedBox(height: 15),
                const Text(
                  "Parameters",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 20,
                      ),
                      const SizedBox(width: 20),
                      const Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 15
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
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
              ],
            )
        );
      },
    );
  }

}
