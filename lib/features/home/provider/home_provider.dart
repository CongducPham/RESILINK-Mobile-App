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
  bool _finishFetchBlockedOffer = false;
  bool _loadingFetchOffer = true;
  bool _loadingFetchSuggestion = true;
  bool _loadingFetchBlockedOffer = true;
  bool _isDispose = false;

  List<News> _listNews = [];
  List<Offer> _lastOfferPublish = [];
  Map<int, Asset> _offerAssets = {};
  List<Offer> _lastSuggestedOffer = [];
  Map<int, Asset> _suggestedOfferAssets = {};
  List<Offer> _blockedOffer = [];
  Map<int, Asset> _blockedOfferAssets = {};

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Getters
  List<News> get listNews => _listNews;
  List<Offer> get listLastOffer => _lastOfferPublish;
  Map<int, Asset> get listOfferAsset => _offerAssets;
  List<Offer> get listSuggestedOffer => _lastSuggestedOffer;
  Map<int, Asset> get listSuggestedOfferAsset => _suggestedOfferAssets;
  List<Offer> get blockedOffer => _blockedOffer;
  Map<int, Asset> get blockedOfferAssets => _blockedOfferAssets;
  bool get finishFetchOffer => _finishFetchOffer;
  bool get finishFetchSuggestion => _finishFetchSuggestion;
  bool get finishFetchBlockedOffer => _finishFetchBlockedOffer;
  bool get loadingFetchOffer => _loadingFetchOffer;
  bool get loadingFetchSuggestion => _loadingFetchSuggestion;
  bool get loadingFetchBlockedOffer => _loadingFetchBlockedOffer;
  GlobalKey<AnimatedListState> get listKey => _listKey;

  /*
   * Function to retrieve the latest job offers, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
   * WARNING for the moment, use this function to get suggested offers, once the suggestion function is done in the server, make a separate function
   */
  Future<void> setLastOfferPublish(BuildContext context) async {
    if (!_isDispose) {
      try {

        // Set _finishFetchOffer & _finishFetchSuggestion to true to notify the parent calling the function that the function has run
        _finishFetchOffer = true;
        await _homeServices.fetchLastThreeOfferAsset(_lastOfferPublish, _offerAssets, context.read<MainProvider>().actualUser!.accessToken);
        // Set _loadingFetchOffer to false to notify the parent calling the function that the function has finished
        _loadingFetchOffer = false;
      } catch (e) {
        _finishFetchOffer = true;
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
    }
    notifyListeners();
  }

  /*
   * Function to retrieve the suggested offers,
   * displays a popup giving a timeout error if the server doesn't respond or an internal server error.
   */
  Future<void> setLastSuggestedOffer(BuildContext context) async {
    if (!_isDispose) {
      try {
        // Set _finishFetchSuggestion to true to notify the parent calling the function that the function has run
        _finishFetchSuggestion = true;
        await _homeServices.fetchSuggestedOfferAsset(
            _lastSuggestedOffer, _suggestedOfferAssets, context
            .read<MainProvider>()
            .actualUser!
            .username, context
            .read<MainProvider>()
            .actualUser!
            .accessToken);
        // Set _loadingFetchSuggestion to false to notify the parent calling the function that the function has finished
        _loadingFetchSuggestion = false;
      } catch (e) {
        _finishFetchSuggestion = true;
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                    AppLocalizations.of(context)!.problemRetrievingLastOffers),
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

  Future<void> setOwnerBlockedOffer(BuildContext context) async {
      try {

      // Set _finishFetchSuggestion to true to notify the parent calling the function that the function has run
      _finishFetchBlockedOffer = true;
      await _homeServices.fetchBlockedOffer(_blockedOffer, _blockedOfferAssets, context.read<MainProvider>().actualUser!.username, context.read<MainProvider>().actualUser!.accessToken);
      // Set _loadingFetchSuggestion to false to notify the parent calling the function that the function has finished
      _loadingFetchBlockedOffer = false;
      print("fini");
    } catch (e) {
      _finishFetchBlockedOffer = true;
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

  // Call function to add an offer id in the prosumer blockedOffers list
  Future<void> deleteIdBlockedOffer (BuildContext context, Offer offer) async {

    try {
      await _homeServices.deleteOfferBlockedOfferList(offer.offerId!, context.read<MainProvider>().actualUser!.username, context.read<MainProvider>().actualUser!.accessToken);
    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemBlockingOffer),
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

}