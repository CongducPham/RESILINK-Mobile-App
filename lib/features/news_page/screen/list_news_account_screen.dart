import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/providers/user_provider.dart';

import '../../../models/News.dart';
import '../widget/news_account_tile.dart';

class ListBookmarked extends StatefulWidget {
  ListBookmarked(
      {super.key, /*required this.fetchdedData,*/ required this.newsList, required this.maxLength, required this.fromProfil, required this.deletion});

  //DataReturn fetchdedData;
  List<News> newsList;
  int maxLength;
  bool fromProfil;
  bool deletion;

  @override
  State<StatefulWidget> createState() => ListBookmarkedState();
}

class ListBookmarkedState extends State<ListBookmarked> {

  void _removeItem(int index) {
    sleep(const Duration(seconds: 1));
    widget.newsList.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: List.generate (
                widget.newsList.length > widget.maxLength ? widget.maxLength : widget.newsList.length,
                    (index) {
                  return BookmarkTile(
                      news: widget.newsList[index],
                      context: context,
                      /*
                      fetchedData: widget.fetchdedData,
                      TODO replace it
                       */
                      isFromProfil: widget.fromProfil,
                      isDeletion: widget.deletion,
                      callBackAnimation: _removeItem,
                      index: index,
                      fromHomePage: false,
                  );
                }
            )
        )
    );
  }
}