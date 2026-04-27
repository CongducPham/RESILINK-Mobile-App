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
import 'package:resilink_mobile_application/features/home/screen/all_owner_blocked_offers.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/home/provider/home_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/news_page/provider/news_page_provider.dart';
import 'package:resilink_mobile_application/features/news_page/widget/news_account_tile.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

import '../../../common/widget/offer_tile.dart';
import '../../../models/News.dart';
import '../../account/provider/account_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  bool _isDispose = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => NewsPageProvider()),
      ],
      builder: (context, child) {
        return SingleChildScrollView(
          child: Consumer3<HomeProvider, NewsPageProvider, HomeNavigationProvider>(
            builder: (context, homeProvider, newsProvider, homeNavigationProvider, child) {

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // ── NEWS SECTION TITLE ───────────────────────────────────
                  Text(
                    context.watch<MainProvider>().connected
                        ? AppLocalizations.of(context)!.homeBookmarkConnected
                        : AppLocalizations.of(context)!.homeBookmark,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── NEWS LIST ────────────────────────────────────────────
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: newsProvider.finishFetchNews && !newsProvider.waitingFetchNews
                        ? newsProvider.listNews.isEmpty
                        ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.newsNotFound,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                        : AnimatedList(
                      key: newsProvider.listKey,
                      scrollDirection: Axis.horizontal,
                      initialItemCount: newsProvider.listNews.length,
                      itemBuilder: (context, index, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(right: 10),
                            child: BookmarkTile(
                              key: ValueKey(newsProvider.listNews[index].id),
                              news: newsProvider.listNews[index],
                              context: context,
                              isFromProfil: false,
                              isDeletion: context.read<MainProvider>().connected,
                              callBackAnimation: (index) {
                                News deletedNews = newsProvider.listNews[index];
                                newsProvider.listNews.removeAt(index);
                                newsProvider.listKey.currentState!.removeItem(
                                  index,
                                      (_, animation) => FadeTransition(
                                    opacity: animation,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: BookmarkTile(
                                        news: deletedNews,
                                        context: context,
                                        isFromProfil: false,
                                        isDeletion: true,
                                        isValid: true,
                                        callBackAnimation: null,
                                        index: index,
                                        fromHomePage: true,
                                        newsProvider: newsProvider,
                                      ),
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
                        : const Center(child: CircularProgressIndicator()),
                  ),

                  // ── SUGGESTED OFFERS SECTION ─────────────────────────────
                  if (context.watch<MainProvider>().connected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.homeSuggestedConnected,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.16,
                            maxHeight: 300,
                          ),
                          height: MediaQuery.of(context).size.height * 0.16 *
                              (homeProvider.listSuggestedOffer.length > 3
                                  ? 3
                                  : homeProvider.listSuggestedOffer.length) +
                                  10,
                          child: homeProvider.finishFetchSuggestion && !homeProvider.loadingFetchSuggestion
                                ? homeProvider.listSuggestedOffer.isEmpty
                                ? Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.textNoOffer,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                          : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: homeProvider.listSuggestedOffer.length > 3
                                ? 3
                                : homeProvider.listSuggestedOffer.length,
                            itemBuilder: (_, int index) {
                              final offer = homeProvider.listSuggestedOffer[index];
                              final assetKey = "${offer.serverUrl}|${offer.assetId}";
                              final asset = homeProvider.listSuggestedOfferAsset[assetKey];
                              if (asset == null) return const SizedBox.shrink();
                              return Column(
                                children: [
                                  OfferTile(
                                    parentContext: context,
                                    offer: offer,
                                    asset: asset,
                                    forPurchase: offer.offerer != context.read<MainProvider>().userName,
                                    fromHome: true,
                                    onOfferBlocked: () => homeProvider.removeSuggestedOffer(offer),
                                  ),
                                  if (index != homeProvider.listSuggestedOffer.length - 1)
                                    const SizedBox(height: 10),
                                ],
                              );
                            },
                          )
                              : const Center(child: CircularProgressIndicator()),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllOwnerBlockedOffers(
                                    homeProvider: homeProvider,
                                    homeNavigationProvider: homeNavigationProvider,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.allBlockedOfferText,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: GlobalVariables.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                  // ── LAST PUBLISHED OFFERS SECTION ────────────────────────
                  Text(
                    AppLocalizations.of(context)!.homeLastOffer,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.162,
                    ),
                    child: homeProvider.finishFetchOffer && !homeProvider.loadingFetchOffer
                        ? homeProvider.listLastOffer.isEmpty
                        ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.textNoOffer,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                    : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeProvider.listLastOffer.length,
                      itemBuilder: (_, int index) {
                        final reversedIndex = homeProvider.listLastOffer.length - 1 - index;
                        if (reversedIndex < 0 || reversedIndex >= homeProvider.listLastOffer.length) {
                          return const SizedBox.shrink();
                        }
                        final offer = homeProvider.listLastOffer[reversedIndex];
                        final assetKey = "${offer.serverUrl}|${offer.assetId}";
                        final asset = homeProvider.listOfferAsset[assetKey];
                        if (asset == null) return const SizedBox.shrink();
                        return Column(
                          children: [
                            OfferTile(
                              parentContext: context,
                              offer: offer,
                              asset: asset,
                              forPurchase: context.read<MainProvider>().connected &&
                                  offer.offerer != context.read<MainProvider>().userName,
                              fromHome: true,
                              onOfferBlocked: () => homeProvider.removeLastOffer(offer),
                            ),
                            if (index != homeProvider.listLastOffer.length - 1)
                              const SizedBox(height: 10),
                          ],
                        );
                      },
                    )
                        : const Center(child: CircularProgressIndicator()),
                  ),

                  if (homeProvider.loadingAddingOfferToList)
                    const Column(
                      children: [
                        SizedBox(height: 10),
                        Center(child: CircularProgressIndicator()),
                      ],
                    ),

                  // ── SEE MORE ─────────────────────────────────────────────
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => homeProvider.loadMoreOffers(context),
                    child: Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        AppLocalizations.of(context)!.seeMoreText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: GlobalVariables.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }
}