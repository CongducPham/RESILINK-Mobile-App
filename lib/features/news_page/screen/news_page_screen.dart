import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/news_page/provider/news_page_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

                          // Display a waiting screen if setLastNews is not finished
                          if (newsPageProvider.waitingFetchNews) {
                            return SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.5,
                                child: const Center(child: CircularProgressIndicator())
                            );
                          }

                          /*
                           * If setLastNews is finished and listNews is empty
                           * Else display listNews with ListBookmarked widget
                           */
                          if (!newsPageProvider.waitingFetchNews && newsPageProvider.listNews.isEmpty) {
                            return SizedBox(
                                width: MediaQuery
                                    .of(this.context)
                                    .size
                                    .width,
                                height: MediaQuery
                                    .of(this.context)
                                    .size
                                    .height / 1.5,
                                child: Center(child: Text(AppLocalizations.of(context)!.newsNotFound))
                            );
                          } else {
                            return ListBookmarked(newsList: newsPageProvider.listNews, maxLength: 5, fromProfil: false, deletion: false, newsProvider: newsPageProvider,);
                          }
                        }

                    )
                  ]
              )
          );
        }
    );
  }
}
