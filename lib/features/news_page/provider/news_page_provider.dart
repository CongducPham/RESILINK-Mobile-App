import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/news_page/service/news_page_service.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../models/News.dart';
import '../../../providers/main_provider.dart';

class NewsPageProvider with ChangeNotifier {

  // Parameter variables
  NewsPageService _newsServices = NewsPageService();

  List<News> _listNews = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _finishFetchNews = false;
  bool _waitingFetchNews = true;
  bool _isOpeningNewsAdder = false;

  TextEditingController _url = TextEditingController(text: "");

  TextEditingController _instute = TextEditingController(text: "");

  // Getters
  List<News> get listNews => _listNews;
  GlobalKey<AnimatedListState> get listKey => _listKey;
  bool get finishFetchNews => _finishFetchNews;
  bool get waitingFetchNews => _waitingFetchNews;
  bool get isOpeningNewsAdder => _isOpeningNewsAdder;
  TextEditingController get instute => _instute;
  TextEditingController get url => _url;

  // Dispose of controllers
  @override
  void dispose() {
    _instute.dispose();
    _url.dispose();
    super.dispose();
  }

  void reset() {
    _listNews = [];
    _listKey = GlobalKey<AnimatedListState>();
    _finishFetchNews = false;
    _waitingFetchNews = true;
    notifyListeners();
  }

  void setOpeningNewsAdder(bool value) {
    _isOpeningNewsAdder = value;
    notifyListeners();
  }

  // Setters
  // Set the news list by removing news bookmarked by the logged-in user if there is one
  Future<void> setLastNews(BuildContext context) async {

    // Set _finishFetchNews to true to notify the parent calling the function that the function has run
    _finishFetchNews = true;

    /*
     * Calls the fetching news from country function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _waitingFetchNews to false to notify the parent calling the function that the function has finished
     */
    try {
      _listNews = [];
      await _newsServices.fetchNews(_listNews, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().country, context.read<MainProvider>().connected, context.read<MainProvider>().actualUser!.username);
      _waitingFetchNews = false;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemRetrievingNews),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.textOk),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  // Set news list in case a user is connected
  Future<void> setOwnerNews(BuildContext context) async {

    // Set _finishFetchNews to true to notify the parent calling the function that the function has run
    _finishFetchNews = true;

    /*
     * Calls the fetching owner bookmarked news, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _waitingFetchNews to false to notify the parent calling the function that the function has finished
     */
    try {
      _listNews = [];
      await _newsServices.fetchOwnerNews(_listNews, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
      _waitingFetchNews = false;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemRetrievingNews),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.textOk),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  // Remove a news from a list
  void removeItem(int index, List<News> newsList) {
    sleep(const Duration(seconds: 1));
    newsList.removeAt(index);
  }

  // Get image corresponding of the news (country related or customized image)
  Widget getNewsImage(News news) {
    return _newsServices.newsAccountTileImg(news);
  }

  // Add a news in the bookmarked list of the user (need user to be connected)
  Future<void> addNews(BuildContext context, News news) async {

    // Calls the adding owner bookmarked news, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      await _newsServices.addNewsBookmarkedList(news.id, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
    } catch (e) {
      //isAdding = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemAddingNews),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.textOk),
            ),
          ],
        ),
      );
    }
  }

  // Delete a new from the user bookmarked list
  Future<void> deleteNews(BuildContext context, News news) async {

    /*
     * Calls the deleting owner bookmarked news, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     */
    try {
      await _newsServices.deleteNewsBookmarkedList(news.id, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemDeletingNews),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : AppLocalizations.of(context)!.popupFailConnexionNoServer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.textOk),
            ),
          ],
        ),
      );
    }
  }

  Future<void> createNews(BuildContext parentContext, BuildContext context) async {

    if (_url.text.isEmpty && _instute.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("At least one field is empty"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {

      // Set a popup to wait for fetching offers
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Text(AppLocalizations.of(context)!.titlePopUpPublishOffer),
                ],
              ),
            ),
          );
        },
      );

      // Set _finishFetchNews to true to notify the parent calling the function that the function has run
      _finishFetchNews = true;

      /*
     * Calls the fetching owner bookmarked news, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _waitingFetchNews to false to notify the parent calling the function that the function has finished
     */
      try {
        Map<String, String> body = {
          "url" : _url.text,
          "country" : parentContext.read<MainProvider>().country,
          "institute" : _instute.text,
          "img" : "",
          "platform" : "web",
          "public" : "false"
        };
        await _newsServices.createNewsFromUser(parentContext.read<MainProvider>().actualUser!.username, body, parentContext.read<MainProvider>().actualUser!.accessToken);
        _waitingFetchNews = false;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.problemRetrievingNews),
            content: Text(e is TimeoutException
                ? AppLocalizations.of(context)!.popupFailConnexionTimeout
                : AppLocalizations.of(context)!.popupFailConnexionNoServer),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.textOk),
              ),
            ],
          ),
        );
      }
      notifyListeners();
    }
  }

}