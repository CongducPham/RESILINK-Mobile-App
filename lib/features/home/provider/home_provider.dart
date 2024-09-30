import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/home/service/home_services.dart';
import 'package:Resilink/models/SpecificRent.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/Asset.dart';
import '../../../models/News.dart';
import '../../../models/Offer.dart';

class HomeProvider extends ChangeNotifier {

  // Variables and their initialization
  HomeServices _homeServices = HomeServices();

  bool _finishFetchOffer = false;
  bool _finishFetchSuggestion = false;
  bool _loadingFetchOffer = true;
  bool _loadingFetchSuggestion = true;

  List<News> _listNews = [];
  List<Offer> _lastOfferPublish = [];
  Map<int, Asset> _offerAssets = {};

  // Getters
  List<News> get listNews => _listNews;
  List<Offer> get listLastOffer => _lastOfferPublish;
  Map<int, Asset> get listOfferAsset => _offerAssets;
  bool get finishFetchOffer => _finishFetchOffer;
  bool get finishFetchSuggestion => _finishFetchSuggestion;
  bool get loadingFetchOffer => _loadingFetchOffer;
  bool get loadingFetchSuggestion => _loadingFetchSuggestion;

  /*
   * Function to retrieve the latest job offers, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
   * WARNING for the moment, use this function to get suggested offers, once the suggestion function is done in the server, make a separate function
   */
  Future<void> setLastOfferPublish(BuildContext context) async {
    try {

      // Set _finishFetchOffer & _finishFetchSuggestion to true to notify the parent calling the function that the function has run
      _finishFetchOffer = true;
      _finishFetchSuggestion = true;
      await _homeServices.fetchLastThreeOfferAsset(_lastOfferPublish, _offerAssets, context.read<MainProvider>().actualUser!.accessToken);
      // Set _loadingFetchOffer & _loadingFetchSuggestion to false to notify the parent calling the function that the function has finished
      _loadingFetchOffer = false;
      _loadingFetchSuggestion = false;
    } catch (e) {
      _finishFetchOffer = true;
      _finishFetchSuggestion = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemRetrievingLastOffers),
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