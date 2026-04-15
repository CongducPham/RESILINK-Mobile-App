import 'dart:async';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/account/service/account_services.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/models/Contract.dart';

import '../../../models/Asset.dart';
import '../../../models/Offer.dart';
import '../../../providers/main_provider.dart';

class AccountProvider with ChangeNotifier {

  // Variables and their initialization
  ScrollController _scrollController = ScrollController();
  GlobalKey _profileKey = GlobalKey();
  GlobalKey _offerKey = GlobalKey();
  GlobalKey _parametersKey = GlobalKey();

  List<Offer> _lastOfferPublish = [];
  Map<int, Asset> _offerAssets = {};
  Map<int, Offer> _offerPurchased = {};
  Map<int, Asset> _assetPurchased = {};
  List<Contract> _contractPurchased = [];

  bool _error = false;
  bool _finishFetchOffer = false;
  bool _finishFetchPurchase = false;
  bool _loadingFetchOffer = true;
  bool _loadingFetchPurchase = true;

  AccountServices _accountServices = AccountServices();

  // Getters
  ScrollController get scrollController => _scrollController;
  GlobalKey get profileKey => _profileKey;
  GlobalKey get offerKey => _offerKey;
  GlobalKey get parametersKey => _parametersKey;

  bool get error => _error;
  bool get finishFetchOffer => _finishFetchOffer;
  bool get finishFetchPurchase => _finishFetchPurchase;
  bool get loadingFetchOffer => _loadingFetchOffer;
  bool get loadingFetchPurchase => _loadingFetchPurchase;

  List<Offer> get lastOfferPublish => _lastOfferPublish;
  Map<int, Asset> get listOfferAsset => _offerAssets;
  Map<int, Offer> get offerPurchased => _offerPurchased;
  Map<int, Asset> get assetPurchased => _assetPurchased;
  List<Contract> get contractPurchased => _contractPurchased;

  // Setters
  void setError(bool newValue) async {
    Timer(const Duration(seconds: 5), () {
      _error = newValue;
    });
  }

  // Function to scroll to a section
  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
          context,
          duration: Duration(seconds: 1), curve: Curves.easeInOut
      );
    }
  }

  // Update in the main provider the actual offer, asset and ForPurchased boolean
  void toUpdateOffer(Offer offer, Asset asset, HomeNavigationProvider homeNavigationProvider, MainProvider mainProvider, BuildContext context) {
    mainProvider.setOfferAndAssetViewDetails(offer, asset, false);
    Navigator.of(context).pop();
    homeNavigationProvider.setIndexAndUpdateHeader(2);
  }

  // Checks whether an offer exists in the list of offers purchased with its id
  bool checkOfferIsPurchased(int offerId) {
    return _offerPurchased[offerId] != null;
  }

  // Retrieves offers with user assets, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> setLastOfferPublish(BuildContext context) async {
    // Set _finishFetchOffer to true to notify the parent calling the function that the function has run
    _finishFetchOffer = true;
    /*
     * Calls the fetching user offers and assets function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _loadingFetchOffer to false to notify the parent calling the function that the function has finished
     */
    try {
      await _accountServices.fetchOfferOwnerWithAssets(_lastOfferPublish, _offerAssets, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
      // Set _loadingFetchOffer to false to notify the parent calling the function that the function has finished
      _loadingFetchOffer = false;
    } catch (e) {
      _loadingFetchOffer = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemSetOwnerOffer),
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

  // Retrieves purchased user offers with assets and contract, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> setOfferPurchased(BuildContext context) async {

    // Set _finishFetchOffer to true to notify the parent calling the function that the function has run
    _finishFetchPurchase = true;

    /*
     * Calls the fetching purchased user offers with assets and contract function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _loadingFetchPurchase to false to notify the parent calling the function that the function has finished
     */
    try {
      await _accountServices.fetchOfferPurchasedWithAssetsContracts(_contractPurchased, _offerPurchased, _assetPurchased, context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
      // Set _loadingFetchPurchase to false to notify the parent calling the function that the function has finished
      _loadingFetchPurchase = false;
    } catch (e) {
      _loadingFetchPurchase = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemSetOwnerPurchased),
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

  // Delete a user offer with its asset, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> deleteOfferAsset(BuildContext context, int offerId, int assetId) async {

    // Set a popup to wait for deleting the offer and its asset
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
                Text(AppLocalizations.of(context)!.titlePopUpDeletingOffer),
              ],
            ),
          ),
        );
      },
    );

    /*
     * Calls the offer deleting function then the asset deleting function
     * if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     */
    try {
      await _accountServices.deleteOffer(offerId, context.read<MainProvider>().actualUser!.accessToken);
      await _accountServices.deleteAsset(assetId, context.read<MainProvider>().actualUser!.accessToken);

      /*
       * Remove the offer and the asset from their list
       * then close the waiting popup
       */
      _lastOfferPublish.removeWhere((offer) => offer.id == offerId);
      _offerAssets.remove(assetId);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemDeleteOwnerOffer),
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