import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/news_page/provider/news_page_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/News.dart';
import '../widget/news_account_tile.dart';
import 'list_news_account_screen.dart';

// Widget for news page
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewsScreenState();
  }
}

class NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        // Creating the Account provider in the tree structure
        create: (_) => NewsPageProvider(),
        builder: (context, child) {
          return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                  Center(
                      child: Text(
                        AppLocalizations.of(context)!.newsTitle,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      )
                  ),
                  const SizedBox(height: 15),

                  // Listening to Account, HomeNavigation and Main providers to access their data
                  Consumer<NewsPageProvider>(
                    builder: (context, newsPageProvider, child) {

                      // Calls function to retrieve a list of news if functions have not yet started
                      if (!newsPageProvider.finishFetchNews) {
                        newsPageProvider.setLastNews(context);
                      }

                      return Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.14
                        ),
                        // Height varies according to the number of items in the list, or if the function for retrieving purchased offers has been terminated
                        height: MediaQuery.of(context).size.height * 0.14 * (newsPageProvider.listNews.isNotEmpty ? newsPageProvider.listNews.length : 2),
                        width: MediaQuery.of(context).size.width,
                        child: newsPageProvider.finishFetchNews && !newsPageProvider.waitingFetchNews ? // if loadingFetchOffer is true, the asynchronous function is not completed and a waiting icon is displayed
                        newsPageProvider.listNews.isNotEmpty ? // if lastOfferPublish is empty, there is no offers in the list so a message is displayed
                        AnimatedList(
                            key: newsPageProvider.listKey,
                            scrollDirection: Axis.vertical,
                            initialItemCount: newsPageProvider.listNews.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      key: ValueKey(newsPageProvider.listNews[index].id),
                                      child: BookmarkTile(
                                        key: ValueKey(newsPageProvider.listNews[index].id),
                                        news: newsPageProvider.listNews[index],
                                        context: context,
                                        isFromProfil: false,
                                        isDeletion: false,
                                        callBackAnimation: (index) {
                                          // Supprimer l'élément avec animation
                                          News deletedNews = newsPageProvider.listNews[index];
                                          newsPageProvider.listNews.removeAt(index);
                                          newsPageProvider.listKey.currentState!.removeItem(
                                            index,
                                            (_, animation) => SizeTransition(
                                              axis: Axis.vertical,
                                              sizeFactor: animation,
                                              child: BookmarkTile(
                                                news: deletedNews,
                                                context: context,
                                                isFromProfil: false,
                                                isDeletion: false,
                                                callBackAnimation: null,
                                                index: index,
                                                fromHomePage: true,
                                                newsProvider: newsPageProvider,
                                              ),
                                            ),
                                            duration: const Duration(milliseconds: 500),
                                          );
                                          Future.delayed(const Duration(milliseconds: 500), () {
                                            newsPageProvider.notifyListeners();
                                          });
                                        },
                                        index: index,
                                        fromHomePage: true,
                                        newsProvider: newsPageProvider,
                                      ),
                                    ),
                                    if (index != newsPageProvider.listNews.length)
                                      SizedBox(height: 10)
                                  ],
                                ),
                              );
                            }
                        )
                            : Center(
                          child: Text(AppLocalizations.of(context)!.newsNotFound),
                        )
                            : const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  )
                ]
              )
          );
        }
    );
  }
}
