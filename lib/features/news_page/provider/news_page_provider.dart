import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/news_page/service/news_page_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/News.dart';
import '../../../providers/main_provider.dart';

class NewsPageProvider with ChangeNotifier {

  // Parameter variables
  NewsPageService _newsServices = NewsPageService();

  List<News> _listNews = [];
  bool _finishFetchNews = false;
  bool _waitingFetchNews = true;

  // Getters
  List<News> get listNews => _listNews;
  bool get finishFetchNews => _finishFetchNews;
  bool get waitingFetchNews => _waitingFetchNews;

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
    notifyListeners();
  }

  // Delete a new from the user bookmarked list
  Future<void> deleteNews(BuildContext context, News news) async {

    /*
     * Calls the deleting owner bookmarked news, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * Deleting the news from _listNews
     */
    try {
      await _newsServices.deleteNewsBookmarkedList(news.id, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
      _listNews.removeWhere((element) => element.id == news.id);
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
    notifyListeners();
  }

}