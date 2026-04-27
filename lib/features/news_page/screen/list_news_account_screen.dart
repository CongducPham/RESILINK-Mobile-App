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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/features/news_page/provider/news_page_provider.dart';

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