import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/home/service/home_services.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../models/Asset.dart';
import '../../../models/News.dart';
import '../../../models/Offer.dart';

class HomeProvider extends ChangeNotifier {

  HomeServices _homeServices = HomeServices();

  bool _finishFetchOffer = false;
  bool _finishFetchSuggestion = false;
  bool _finishFetchBlockedOffer = false;
  bool _loadingFetchOffer = true;
  bool _loadingFetchSuggestion = true;
  bool _loadingFetchBlockedOffer = true;
  bool _loadingAddingOfferToList = false;
  bool _isDispose = false;
  int _iteration = 0;

  List<News> _listNews = [];
  List<Offer> _lastOfferPublish = [];
  Map<String, Asset> _offerAssets = {};
  List<Offer> _lastSuggestedOffer = [];
  Map<String, Asset> _suggestedOfferAssets = {};
  List<Offer> _blockedOffer = [];
  Map<String, Asset> _blockedOfferAssets = {};

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Getters
  List<News> get listNews => _listNews;
  List<Offer> get listLastOffer => _lastOfferPublish;
  Map<String, Asset> get listOfferAsset => _offerAssets;
  List<Offer> get listSuggestedOffer => _lastSuggestedOffer;
  Map<String, Asset> get listSuggestedOfferAsset => _suggestedOfferAssets;
  List<Offer> get blockedOffer => _blockedOffer;
  Map<String, Asset> get blockedOfferAssets => _blockedOfferAssets;
  bool get finishFetchOffer => _finishFetchOffer;
  bool get finishFetchSuggestion => _finishFetchSuggestion;
  bool get finishFetchBlockedOffer => _finishFetchBlockedOffer;
  bool get loadingFetchOffer => _loadingFetchOffer;
  bool get loadingFetchSuggestion => _loadingFetchSuggestion;
  bool get loadingFetchBlockedOffer => _loadingFetchBlockedOffer;
  int get iteration => _iteration;
  bool get loadingAddingOfferToList => _loadingAddingOfferToList;
  GlobalKey<AnimatedListState> get listKey => _listKey;

  // NEW: removes an offer from last offers + its asset in a single operation
  // before notifying → avoids rebuild with an inconsistent list
  void removeLastOffer(Offer offer) {
    final assetKey = "${offer.serverUrl}|${offer.assetId}";
    _lastOfferPublish.remove(offer);
    _offerAssets.remove(assetKey);
    notifyListeners();
  }

  // NOUVEAU : idem pour les suggestions
  void removeSuggestedOffer(Offer offer) {
    final assetKey = "${offer.serverUrl}|${offer.assetId}";
    _lastSuggestedOffer.remove(offer);
    _suggestedOfferAssets.remove(assetKey);
    notifyListeners();
  }

  Future<void> setLastOfferPublish(BuildContext context) async {
    if (!_isDispose) {
      try {
        _lastOfferPublish.clear();
        _finishFetchOffer = true;
        await _homeServices.fetchLimitedOfferAsset(
          _lastOfferPublish,
          _offerAssets,
          _iteration,
          context.read<MainProvider>().actualUser!.accessToken,
        );
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

  Future<void> loadMoreOffers(BuildContext context) async {
    try {
      _loadingAddingOfferToList = true;
      _iteration++;
      notifyListeners();
      await _homeServices.fetchLimitedOfferAsset(
        _lastOfferPublish,
        _offerAssets,
        _iteration,
        context.read<MainProvider>().actualUser!.accessToken,
      );
      _loadingAddingOfferToList = false;
    } catch (e) {
      debugPrint("Erreur lors du chargement des offres supplémentaires : $e");
    }
    notifyListeners();
  }

  Future<void> setLastSuggestedOffer(BuildContext context) async {
    if (!_isDispose) {
      try {
        _lastSuggestedOffer.clear();
        _finishFetchSuggestion = true;
        await _homeServices.fetchSuggestedOfferAsset(
          _lastSuggestedOffer,
          _suggestedOfferAssets,
          context.read<MainProvider>().actualUser!.username,
          context.read<MainProvider>().actualUser!.accessToken,
        );
        _loadingFetchSuggestion = false;
      } catch (e) {
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

  Future<void> setOwnerBlockedOffer(BuildContext context) async {
    try {
      _finishFetchBlockedOffer = true;
      await _homeServices.fetchBlockedOffer(
        _blockedOffer,
        _blockedOfferAssets,
        context.read<MainProvider>().actualUser!.username,
        context.read<MainProvider>().actualUser!.accessToken,
      );
      _loadingFetchBlockedOffer = false;
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

  Future<void> deleteIdBlockedOffer(BuildContext context, Offer offer) async {
    try {
      await _homeServices.deleteOfferBlockedOfferList(
        offer.id!,
        context.read<MainProvider>().actualUser!.username,
        offer.serverUrl!,
        context.read<MainProvider>().actualUser!.accessToken,
      );
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