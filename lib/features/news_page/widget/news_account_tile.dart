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
import 'package:resilink_mobile_application/common/service/Launch_in_external_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/news_page/provider/news_page_provider.dart';
import 'package:resilink_mobile_application/features/news_page/service/news_page_service.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

import '../../../models/News.dart';

class BookmarkTile extends StatefulWidget {
  BookmarkTile({
    super.key,
    required this.news,
    required this.context,
    required this.isFromProfil,
    required this.isDeletion,
    this.isValid = false,
    required this.callBackAnimation,
    required this.index,
    required this.fromHomePage,
    required this.newsProvider,
  });

  final News news;
  final BuildContext context;
  final bool isFromProfil;
  bool isDeletion;
  final bool fromHomePage;
  bool isValid;
  final Function? callBackAnimation;
  final int index;
  NewsPageProvider newsProvider;

  @override
  State<StatefulWidget> createState() => BookmarkTileState();
}

class BookmarkTileState extends State<BookmarkTile> {
  bool _isLoading = false;
  bool _isAdding = false;
  NewsPageService newsPageService = NewsPageService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.index.isEven && !widget.fromHomePage)
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: GlobalVariables.backgroundTile,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: GlobalVariables.unFocusBorderColor,
              width: 1,
            ),
          ),
          child: ListTile(
            // ── IMAGE (leading) ──────────────────────────────────────────
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: newsPageService.newsAccountTileImg(widget.news),
              ),
            ),

            // ── CONTENT ──────────────────────────────────────────────────
            title: Text(
              widget.news.institute,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: GestureDetector(
                onTap: () async {
                  await launchInBrowser(Uri.parse(widget.news.link));
                },
                child: Text(
                  widget.news.link,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: GlobalVariables.tertiaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: GlobalVariables.tertiaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // ── ACTION (trailing) ─────────────────────────────────────────
            trailing: !widget.isFromProfil
                ? SizedBox(
              width: 32,
              child: _buildTrailingAction(context),
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingAction(BuildContext context) {
    // end animation
    if (widget.isValid) {
      return const Icon(
        Icons.check_circle_rounded,
        size: 26,
        color: Colors.green,
      );
    }

    // still loading
    if (_isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.lightGreen,
        ),
      );
    }

    // delete mode
    if (widget.isDeletion) {
      return GestureDetector(
        onTap: () async {
          setState(() {
            widget.isDeletion = false;
            _isLoading = true;
          });
          try {
            await widget.newsProvider.deleteNews(context, widget.news);
          } catch (e) {
            setState(() {
              widget.isDeletion = true;
              _isLoading = false;
            });
          } finally {
            setState(() {
              widget.isValid = true;
              _isLoading = false;
            });
          }
          widget.callBackAnimation!(widget.index);
        },
        child: const Icon(
          Icons.delete_forever,
          color: Colors.deepOrange,
          size: 26,
        ),
      );
    }

    // add mode
    if (context.read<MainProvider>().connected && !_isAdding) {
      return GestureDetector(
        onTap: () async {
          setState(() {
            _isAdding = true;
            _isLoading = true;
          });
          try {
            await widget.newsProvider.addNews(context, widget.news);
          } catch (e) {
            setState(() {
              _isAdding = true;
              _isLoading = false;
            });
          } finally {
            setState(() {
              widget.isValid = true;
              _isLoading = false;
            });
          }
          widget.callBackAnimation!(widget.index);
        },
        child: const Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.lightGreen,
          size: 26,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}