import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/home/provider/home_provider.dart';
import 'package:resilink_design/features/news_page/widget/news_account_tile.dart';
import 'package:resilink_design/providers/user_provider.dart';

import '../../../common/widget/offer_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height * 0.01)),
              Text(context.watch<UserProvider>().connected == true ? "Your bookmarked news accounts" : "Last news accounts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.15),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.read<HomeProvider>().listNews.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: (MediaQuery.of(context).size.width * 0.8),
                      margin: EdgeInsets.only(right: 10),
                      child: BookmarkTile(
                          news: context.read<HomeProvider>().listNews[index],
                          context: context,
                          isFromProfil: true,
                          isDeletion: false,
                          callBackAnimation: null,
                          index: index,
                          fromHomePage: true),
                    );
                  },
                ),
              ),
              if (context.watch<UserProvider>().connected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suggested offers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.13 * context.read<HomeProvider>().listLastOffer.length,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.39
                      ),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: context.read<HomeProvider>().listLastOffer.length > 3 ? 3 : context.read<HomeProvider>().listLastOffer.length,
                          itemBuilder: (_, int index) {
                            return Column(
                              children: [
                                OfferTile(parentContext: context, offer: context.read<HomeProvider>().listLastOffer[index], asset: context.read<HomeProvider>().listOfferAsset[context.read<HomeProvider>().listLastOffer[index].assetId]!),
                                if (index != context.read<HomeProvider>().listLastOffer.length)
                                  SizedBox(height: 10)
                              ],
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              Text("Last offers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13 * context.read<HomeProvider>().listLastOffer.length,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: context.read<HomeProvider>().listLastOffer.length,
                    itemBuilder: (_, int index) {
                      return Column(
                        children: [
                          OfferTile(parentContext: context, offer: context.read<HomeProvider>().listLastOffer[index], asset: context.read<HomeProvider>().listOfferAsset[context.read<HomeProvider>().listLastOffer[index].assetId]!),
                          if (index != context.read<HomeProvider>().listLastOffer.length)
                            SizedBox(height: 10)
                        ],
                      );
                    }
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
