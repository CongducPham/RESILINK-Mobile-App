import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/news_page/screen/news_adding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/news_page/provider/news_page_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import '../../../models/News.dart';
import '../../../providers/main_provider.dart';
import '../widget/news_account_tile.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsPageProvider(),
      builder: (context, child) {
        return Consumer<NewsPageProvider>(
          builder: (context, newsPageProvider, child) {
            if (!newsPageProvider.finishFetchNews) {
              newsPageProvider.setLastNews(context);
            }

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.newsTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    if (!newsPageProvider.finishFetchNews || newsPageProvider.waitingFetchNews)
                      const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (newsPageProvider.listNews.isEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.newsNotFound,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: AnimatedList(
                          key: newsPageProvider.listKey,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          initialItemCount: newsPageProvider.listNews.length,
                          itemBuilder: (context, index, animation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: BookmarkTile(
                                  key: ValueKey(newsPageProvider.listNews[index].id),
                                  news: newsPageProvider.listNews[index],
                                  context: context,
                                  isFromProfil: false,
                                  isDeletion: false,
                                  callBackAnimation: (index) {
                                    _removeItemWithAnimation(newsPageProvider, index);
                                  },
                                  index: index,
                                  fromHomePage: true,
                                  newsProvider: newsPageProvider,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                // FloatingActionButton centered horizontally at the bottom
                if ( context.watch<MainProvider>().connected == true )
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.of(context).size.width / 2 - 44,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsAdding(parentContext: this.context)),
                        );
                      },
                      child: const Icon(Icons.add, size: 24),
                      backgroundColor: GlobalVariables.tertiaryColor,
                      shape: const CircleBorder(),
                      mini: true, // Rend le bouton plus petit
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeItemWithAnimation(NewsPageProvider newsPageProvider, int index) {
    final deletedNews = newsPageProvider.listNews[index];

    newsPageProvider.listNews.removeAt(index);

    newsPageProvider.listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: BookmarkTile(
          news: deletedNews,
          context: context,
          isFromProfil: false,
          isDeletion: false,
          isValid: true,
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
  }
}
