import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/news_page/service/news_page_service.dart';
import 'package:resilink_design/providers/user_provider.dart';

import '../../../models/News.dart';

class BookmarkTile extends StatefulWidget {

  BookmarkTile({super.key, required this.news, required this.context, /*required this.fetchedData,*/required this.isFromProfil, required this.isDeletion, required this.callBackAnimation, required this.index, required this.fromHomePage});

  final News news;
  final BuildContext context;
  /*
  final DataReturn fetchedData;
  TODO to change to new function of news_page_service
   */
  final bool isFromProfil;
  final bool isDeletion;
  final bool fromHomePage;
  final Function? callBackAnimation;
  final int index;

  @override
  State<StatefulWidget> createState() {
    return BookmarkTileState();
  }
}

class BookmarkTileState extends State<BookmarkTile> {

  bool _isLoading = false;
  bool _isValid = false;
  NewsPageService newsPageService = NewsPageService();

  /*
  DataReturn fetchdata = DataReturn();
    TODO to change to new function of news_page_service
   */

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
        if (!widget.index.isEven & _isExpanded & !widget.fromHomePage)
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
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
                  flex: !_isExpanded ? 0 : widget.isFromProfil ? 9 : 7,
                  child: !_isExpanded ? Container() : Container(
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
                          onTap: () async {
                            /*
                            await LaunchInBrowser(Uri.parse(widget.news.link));
                              TODO to change to new function of somthing in common/service
                             */
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
                      child: _isValid ?  !_isExpanded ? Container() :
                      const Icon(
                          Icons.check_circle_rounded,
                          size: 30,
                          color: Colors.green
                      )
                          : widget.isDeletion ?
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            /*
                            await widget.fetchedData.deleteNewsBookmarkedList(widget.news.id);
                              TODO to change to new function of news_page_service

                             */
                            setState(() {
                              _isLoading = false;
                              _isValid = true;
                              _isExpanded = !_isExpanded;
                            });
                            widget.callBackAnimation!(widget.index) ?? true ;
                          },
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.deepOrange,
                            size: 30,
                          )
                      )
                          : _isLoading ?
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const Center(child: CircularProgressIndicator(
                            color: Colors.lightGreen,
                          ))
                      )
                          : context.read<UserProvider>().connected ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            /*
                            await widget.fetchedData.addNewsBookmarkedList(widget.news.id);
                              TODO to change to new function of news_page_service
                             */
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
                      ) : Container(),
                    ),
                  )
              ],
            )
        ),
      ],
    );
  }
}