import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Resilink/features/news_page/provider/news_page_provider.dart';

import '../../../models/News.dart';
import '../widget/news_account_tile.dart';

// Widget to display a news list
class ListBookmarked extends StatefulWidget {
  ListBookmarked(
      {super.key, required this.newsList, required this.maxLength, required this.fromProfil, required this.deletion, required this.newsProvider});

  List<News> newsList;
  int maxLength;
  bool fromProfil;
  bool deletion;
  NewsPageProvider newsProvider;

  @override
  State<StatefulWidget> createState() => ListBookmarkedState();
}

class ListBookmarkedState extends State<ListBookmarked> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: List.generate (
              // Generates a list with the max size passed in parameter
                widget.newsList.length > widget.maxLength ? widget.maxLength : widget.newsList.length,
                    (index) {
                  // Default container for displaying a news item
                  return BookmarkTile(
                      news: widget.newsList[index],
                      context: context,
                      isFromProfil: widget.fromProfil,
                      isDeletion: widget.deletion,
                      callBackAnimation: widget.newsProvider.removeItem,
                      index: index,
                      fromHomePage: false,
                      newsProvider: widget.newsProvider,
                  );
                }
            )
        )
    );
  }
}