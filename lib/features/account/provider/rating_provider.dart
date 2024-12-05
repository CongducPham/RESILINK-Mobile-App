import 'dart:async';

import 'package:Resilink/features/account/service/rating_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/main_provider.dart';

class RatingProvider extends ChangeNotifier {

  double _userRating = 0;
  bool _firstTime = false;

  bool _finishFetchRating = false;
  bool _loadingFetchRating = true;

  RatingServices _ratingServices = RatingServices();

  double get userRating => _userRating;
  bool get finishFetchRating => _finishFetchRating;
  bool get loadingFetchRating => _loadingFetchRating;

  void updateCurrentRating(double newRating) {
    _userRating = newRating;
  }

  // Retrieves purchased user offers with assets and contract, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
  Future<void> getRatingUser(BuildContext context) async {

    // Set _finishFetchOffer to true to notify the parent calling the function that the function has run
    _finishFetchRating = true;

    /*
     * Calls the fetching purchased user offers with assets and contract function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
     * set _loadingFetchPurchase to false to notify the parent calling the function that the function has finished
     */
    try {
      double? tampRating = await _ratingServices.fetchUserRating(context.read<MainProvider>().actualUser!.accessToken, context.read<MainProvider>().actualUser!.username);
      tampRating != null ? _userRating = tampRating : _firstTime = true;
      // Set _loadingFetchPurchase to false to notify the parent calling the function that the function has finished
      _loadingFetchRating = false;
    } catch (e) {
      _loadingFetchRating = false;
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

  Future<void> updateRatingUser(BuildContext context) async {

    // Set a popup to wait for updating user data
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
                Text(AppLocalizations.of(context)!.titlePopUpUpdateUser),
              ],
            ),
          ),
        );
      },
    );

    // Calls the user data updating function, if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
    try {
      _firstTime ?
        await _ratingServices.createUserRating(
            context.read<MainProvider>().actualUser!.accessToken,
            context.read<MainProvider>().actualUser!.username,
            _userRating
        ) : await _ratingServices.updateUserRating(
          context.read<MainProvider>().actualUser!.accessToken,
          context.read<MainProvider>().actualUser!.username,
          _userRating
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemSetUpdateUser),
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