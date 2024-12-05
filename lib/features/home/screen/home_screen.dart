import 'dart:io';

import 'package:Resilink/features/home/screen/all_owner_blocked_offers.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/home/provider/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/news_page/provider/news_page_provider.dart';
import 'package:Resilink/features/news_page/widget/news_account_tile.dart';
import 'package:Resilink/providers/main_provider.dart';

import '../../../common/widget/offer_tile.dart';
import '../../../models/News.dart';
import '../../account/provider/account_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> {

  bool _isDispose = false;

  @override
  void dispose() {
    print("dispose un max");
    _isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Creating the Home & NewsPage provider in the tree structure
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => NewsPageProvider()),
      ],
      builder: (context, child) {
        return SingleChildScrollView(
          child: Consumer3<HomeProvider, NewsPageProvider, HomeNavigationProvider>( // Listening to Home and NewsPage providers to access/update their data
            builder: (context, homeProvider, newsProvider, homeNavigationProvider, child) {

              /*
               * Calls up functions to retrieve the latest published offers and, depending on whether the user is logged in or not,
               * to retrieve the latest news or news bookmarked by the user if the functions have not yet been started.
               */
              if (_isDispose == false && (!homeProvider.finishFetchOffer || (context.read<MainProvider>().connected && !homeProvider.finishFetchSuggestion) || !newsProvider.finishFetchNews)) {
                homeProvider.setLastOfferPublish(context);
                if (context.read<MainProvider>().connected) {
                  homeProvider.setLastSuggestedOffer(context);
                  newsProvider.setOwnerNews(context);
                } else {
                  newsProvider.setLastNews(context);
                }
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                  // Title changes if a user is logged in
                  Text(context.watch<MainProvider>().connected == true ? AppLocalizations.of(context)!.homeBookmarkConnected : AppLocalizations.of(context)!.homeBookmark, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),

                  // SizedBox for displaying news accounts
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * 0.15),
                    child: newsProvider.finishFetchNews && !newsProvider.waitingFetchNews ? // if waitingFetchNews is true, the asynchronous function is not completed and a waiting icon is displayed
                      newsProvider.listNews.isEmpty ? // if listNews is empty, there is no news in the list so a message is displayed
                      Center(
                        child: Text(AppLocalizations.of(context)!.newsNotFound),
                      ) : AnimatedList(
                        key: newsProvider.listKey,
                        scrollDirection: Axis.horizontal,
                        initialItemCount: newsProvider.listNews.length,
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: Container(
                              width: (MediaQuery.of(context).size.width * 0.8),
                              margin: EdgeInsets.only(right: 10),
                              child: BookmarkTile(
                                key: ValueKey(newsProvider.listNews[index].id),
                                news: newsProvider.listNews[index],
                                context: context,
                                isFromProfil: false,
                                isDeletion: context.read<MainProvider>().connected ? true : false,
                                callBackAnimation: (index) {
                                  // Supprimer l'élément avec animation
                                  News deletedNews = newsProvider.listNews[index];
                                  newsProvider.listNews.removeAt(index);
                                  newsProvider.listKey.currentState!.removeItem(
                                    index,
                                    (_, animation) => FadeTransition(
                                      opacity: animation,
                                      child: Container(
                                        width: (MediaQuery.of(context).size.width * 0.8),
                                        margin: EdgeInsets.only(right: 10),
                                        child: BookmarkTile(
                                          news: deletedNews,
                                          context: context,
                                          isFromProfil: false,
                                          isDeletion: true,
                                          callBackAnimation: null,
                                          index: index,
                                          fromHomePage: true,
                                          newsProvider: newsProvider,
                                        )
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 500),
                                  );
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    newsProvider.notifyListeners();
                                  });
                                },
                                index: index,
                                fromHomePage: true,
                                newsProvider: newsProvider,
                              ),
                            ),
                          );
                        },
                      )
                    /* ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: newsProvider.listNews.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: (MediaQuery.of(context).size.width * 0.8),
                                  margin: EdgeInsets.only(right: 10),
                                  child: BookmarkTile(
                                    key: ValueKey(newsProvider.listNews[index].id),  // Utilise une clé unique comme l'id de la news
                                    news: newsProvider.listNews[index],
                                    context: context,
                                    isFromProfil: false,
                                    isDeletion: context.read<MainProvider>().connected ? true : false,
                                    callBackAnimation: (i) {
                                      print(newsProvider.listNews.length);
                                    },
                                    index: index,
                                    fromHomePage: true,
                                    newsProvider: newsProvider,
                                  ),
                                );
                              },
                            ) */ : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                  ),

                  /*
                   * If the user is logged in, the suggested offers section is displayed.
                   * Height varies according to the number of items in the list, or if the function for retrieving the news has been terminated
                   */
                  if (context.watch<MainProvider>().connected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.homeSuggestedConnected, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.14,
                            maxHeight: 260
                          ),
                          height: MediaQuery.of(context).size.height * 0.14 * (homeProvider.listSuggestedOffer.length > 3 ? 3 : homeProvider.listSuggestedOffer.length) + 10 ,
                          child: homeProvider.finishFetchSuggestion && !homeProvider.loadingFetchSuggestion ? // if loadingFetchSuggestion is true, the asynchronous function is not completed and a waiting icon is displayed
                            homeProvider.listSuggestedOffer.isEmpty ? // if listLastOffer is empty, there is no news in the list so a message is displayed
                            Center(
                              child: Text(AppLocalizations.of(context)!.textNoOffer),
                            ) :
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeProvider.listSuggestedOffer.length > 3 ? 3 : homeProvider.listSuggestedOffer.length,
                              itemBuilder: (_, int index) {
                                return Column(
                                  children: [
                                    OfferTile(
                                        parentContext: context,
                                        offer: homeProvider.listSuggestedOffer[index],
                                        asset: homeProvider.listSuggestedOfferAsset[homeProvider.listSuggestedOffer[index].assetId]!,
                                        forPurchase: homeProvider.listSuggestedOffer[index].offerer != context.read<MainProvider>().userName
                                    ),
                                    if (index != homeProvider.listSuggestedOffer.length)
                                      SizedBox(height: 10)
                                  ],
                                );
                              }
                            ) :
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),

                        // clickable text for a complete list of all published offers in a new page
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AllOwnerBlockedOffers(homeProvider: homeProvider, homeNavigationProvider: homeNavigationProvider)));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.allBlockedOfferText,
                              style: const TextStyle(
                                  fontSize: 14, color: GlobalVariables.tertiaryColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  Text(AppLocalizations.of(context)!.homeLastOffer, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                    /*
                   * The last published offers section is displayed.
                   * Height varies according to the number of items in the list, or if the function for retrieving the news has been terminated
                   */
                  Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.15
                    ),
                    height: MediaQuery.of(context).size.height * 0.14 * homeProvider.listLastOffer.length,
                    child: homeProvider.finishFetchOffer && !homeProvider.loadingFetchOffer ? // if loadingFetchOffer is true, the asynchronous function is not completed and a waiting icon is displayed
                      homeProvider.listLastOffer.isEmpty ?  // if listLastOffer is empty, there are no offers in the list and a message is displayed.
                      Center(
                        child: Text(AppLocalizations.of(context)!.textNoOffer),
                      ) :
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: homeProvider.listLastOffer.length,
                        itemBuilder: (_, int index) {
                          return Column(
                            children: [
                              // Calls the generic tile for an offer
                              OfferTile(
                                  parentContext: context,
                                  offer: homeProvider.listLastOffer[index],
                                  asset: homeProvider.listOfferAsset[homeProvider.listLastOffer[index].assetId]!,
                                  forPurchase: (context.read<MainProvider>().connected && homeProvider.listLastOffer[index].offerer != context.read<MainProvider>().userName) ? true : false
                              ),
                              if (index != homeProvider.listLastOffer.length)
                                SizedBox(height: 10)
                            ],
                          );
                        }
                      )
                    : const Center(
                      child: CircularProgressIndicator(),
                    )
                  ),
                  /*GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          AppLocalizations.of(context)!.seeMoreText,
                          style: TextStyle(
                            color: GlobalVariables.unFocusBorderColor,
                            fontSize: 14
                          ),
                        ),
                      ),
                    )
                     */
                ],
              );
            },
          ),
        );
      },
    );
  }

}
