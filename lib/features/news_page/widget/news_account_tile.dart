import 'package:Resilink/common/service/Launch_in_external_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/news_page/provider/news_page_provider.dart';
import 'package:Resilink/features/news_page/service/news_page_service.dart';
import 'package:Resilink/providers/main_provider.dart';

import '../../../models/News.dart';

class BookmarkTile extends StatefulWidget {

  BookmarkTile({super.key, required this.news, required this.context, required this.isFromProfil, required this.isDeletion, required this.callBackAnimation, required this.index, required this.fromHomePage, required this.newsProvider});

  final News news;
  final BuildContext context;
  final bool isFromProfil;
  final bool isDeletion;
  final bool fromHomePage;
  final Function? callBackAnimation;
  final int index;
  NewsPageProvider newsProvider;

  @override
  State<StatefulWidget> createState() {
    return BookmarkTileState();
  }
}

class BookmarkTileState extends State<BookmarkTile> {

  // Locale variable needed in
  bool _isLoading = false;
  bool _isValid = false;
  NewsPageService newsPageService = NewsPageService();

  //Bool to toggle animation
  bool _isExpanded = true;

  void _toggleAnimation() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(context) {
    return  Column(
      children: [
        // If this container is not the last one, is in an even position and is not called in page 0, add a space
        if (!widget.index.isEven & _isExpanded & !widget.fromHomePage)
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        /*
         * AnimatedContainer to launch an animation when
         * A news item is deleted from the list in parameter (case of page 0) => deletion from the bookmarked list
         * A news item is added to the list set in parameter (case of page 3) => added to the bookmarked list
         * _isExpanded is the boolean defining whether the container must have a size. After the animation, _isExpanded takes true to mean that the container must no longer have a size.
         */
        AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            // If animation is toggle, height and width = 0 for container to disappear.
            height: !_isExpanded ? 0
                : MediaQuery.of(this.context).size.height * 0.1 ,
            width: !_isExpanded ? 0
                : MediaQuery.of(this.context).size.width,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: !_isExpanded ? 0 : 1,
                    child: !_isExpanded ? Container() : newsPageService.newsAccountTileImg(widget.news)
                ),
                Expanded(
                  // isFromProfil change flex to add an icon if false
                  flex: !_isExpanded ? 0 : widget.isFromProfil ? 9 : 7,
                  child: !_isExpanded ? Container()
                  // news data to display
                  : Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.news.institute,
                          style: TextStyle(
                              fontSize: MediaQuery.of(this.context).size.height * 0.019,
                              fontWeight: FontWeight.bold
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: MediaQuery.of(this.context).size.height * 0.003),
                        GestureDetector(
                          
                          // Launch the url in the default browser
                          onTap: () async {
                            await launchInBrowser(Uri.parse(widget.news.link));
                          },
                          child: Text(
                            widget.news.link,
                            style: TextStyle(
                                fontSize: MediaQuery.of(this.context).size.height * 0.018,
                                color: Colors.grey
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!widget.isFromProfil)
                  Expanded(
                    flex: !_isExpanded ? 0 : 2,
                    child: !_isExpanded ? Container() : Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0), // Coin haut droit arrondi
                          bottomRight: Radius.circular(12.0), // Coin bas droit arrondi
                        ),
                      ),
                      child: _isValid ? !_isExpanded ? Container() :
                      // Icon when animation is running and finished
                      const Icon(
                          Icons.check_circle_rounded,
                          size: 30,
                          color: Colors.green
                      )
                      : widget.isDeletion ?
                      // When the function to delete a news item from the bookmarked list is available (as in page 0 with the user's bookmarked news list)
                      GestureDetector(
                          // Calls the function to activate animation and remove a news item from the bookmarked list and also the container itself
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            widget.newsProvider.deleteNews(context, widget.news);
                            setState(() {
                              _isLoading = false;
                              _isValid = true;
                              _isExpanded = !_isExpanded;
                            });
                            widget.callBackAnimation!(widget.index) ?? true ;
                          },
                          // Icon to delete a news from bookmarked list
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.deepOrange,
                            size: 30,
                          )
                      )
                      : _isLoading ?
                      // Case where animation is in progress (display waiting icon)
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const Center(child: CircularProgressIndicator(
                            color: Colors.lightGreen,
                          )
                        )
                      )
                      // Case where in page 3 and user connected => can add news in bookmarked list
                      : context.read<MainProvider>().connected ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            await widget.newsProvider.addNews(context, widget.news);
                            setState(() {
                              _isLoading = false;
                              _isValid = true;
                            });
                          },
                          child: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: Colors.lightGreen,
                            size: 30,
                          )
                      )
                      // Case where news is not valid
                      : Container(),
                    ),
                  )
              ],
            )
        ),
      ],
    );
  }
}