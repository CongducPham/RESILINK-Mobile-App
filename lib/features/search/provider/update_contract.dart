import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/search/service/update_contract_services.dart';

import '../../../common/service/date_manager.dart';
import '../../../models/Contract.dart';
import '../../../providers/main_provider.dart';
import '../../home_navigation/provider/home_navigation_provider.dart';

class UpdateContractProvider extends ChangeNotifier {

  // Variables and their initialization
  String _stepperText = "";
  String _deliveryValue = "";
  int _currentStep = 0;
  List<String> _deliveryState = [];
  UpdateContractServices _updateContractServices = UpdateContractServices();

  // Getters
  String get stepperText => _stepperText;
  String get deliveryValue => _deliveryValue;
  int get currentStep => _currentStep;
  List<String> get deliveryState => _deliveryState;

  // Setters
  void setDeliveryValue(String newValue) {
    _deliveryValue = newValue;
    notifyListeners();
  }

  //Set the initial values for the possible delivery states, the Stepper widget step and his text
  void setInitialValue (Contract contract, String nature, BuildContext context) async {
    switch (nature) {

      case "immaterial": {
        _deliveryState = ["beginDelivery", "endDelivery", "endOfConsumption"];
        switch (contract.state) {
          case "beginDelivery" :
            {
              _stepperText = "Your order is yet to be delivered";
              _currentStep = 1;
              break;
            }
          case "endDelivery" :
            {
              _stepperText = "Your order has been delivered, thank you to confirm your reception";
              _currentStep = 2;
              break;
            }
          case "endOfConsumption" :
            {
              _stepperText = "End of your order";
              _currentStep = 3;
              break;
            }
          default :
            {
              _stepperText = "your order is still in process";
              break;
            }
        }
        _deliveryValue = _deliveryState[0];
        break;
      }

      case "material": {
        if(contract.transactionType == "rent"){
          _deliveryState = [ "assetDeliveredByTheOfferer", "assetReceivedByTheRequestor", "assetNotReceivedByTheRequestor", "assetReturnedByTheRequestor", "assetReturnedToTheOfferer", "assetNotReturnedToTheOfferer" ];
          _deliveryValue = _deliveryState[0];

          switch (contract.state) {
            case "assetDeliveredByTheOfferer" :
              {
                _stepperText = "Your order is being delivered";
                _currentStep = 1;
                break;
              }
            case "assetReceivedByTheRequestor" :
              {
                _stepperText = "Your order has been delivered and picked up";
                _currentStep = 2;
                break;
              }
            case "assetNotReceivedByTheRequestor" :
              {
                _stepperText = "Your order has not been received";
                _currentStep = 3;
                break;
              }
            case "assetReturnedByTheRequestor" :
              {
                _stepperText = "Your order has not been received and getting returned";
                _currentStep = 2;
                break;
              }
            case "assetReturnedToTheOfferer" :
              {
                _stepperText = "Your order has not been received and has been delievered to the offerer";
                _currentStep = 3;
                break;
              }
            case "assetReturnedToTheOfferer" :
              {
                _stepperText = "Your order has not been received and has been received by the offerer";
                _currentStep = 3;
                break;
              }
            default :
              {
                _stepperText = "your order is still in process";
                break;
              }
          }
        } else {
          _deliveryState = [ "assetDeliveredByTheOfferer", "assetReceivedByTheRequestor", "assetNotReceivedByTheRequestor" ];
          _deliveryValue = _deliveryState[0];
          switch (contract.state) {
            case "assetDeliveredByTheOfferer" :
              {
                _stepperText = "Your order is being delivered";
                _currentStep = 1;
                break;
              }
            case "assetReceivedByTheRequestor" :
              {
                _stepperText = "Your order has been delivered and picked up";
                _currentStep = 2;
                break;
              }
            case "assetNotReceivedByTheRequestor" :
              {
                _stepperText = "Your order has not been received";
                _currentStep = 3;
                break;
              }
            default :
              {
                _stepperText = "your order is still in process";
                break;
              }
          }
        }
      }
    }
  }

  /*
   * Method to update a contract
   * If contract new state doesn't meet the requirement, show a warning SnackBar
   */
  Future<void> updateContract(BuildContext context, Contract contract, String nature, HomeNavigationProvider homeNavigationProvider) async {
    Map<String, dynamic> _mapJson = {};
    if(_deliveryState.indexOf(_deliveryValue) <= _deliveryState.indexOf(contract.state)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.snackBarContractNotGood)),
      );
    } else if (!isOneMinutePassed(contract.beginTimeSlot)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.snackBarContractTooEarly)),
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
                  Text(AppLocalizations.of(context)!.titlePopUpUpdatingContract),
                ],
              ),
            ),
          );
        },
      );

      /*
       * Calls the updating contract function
       * if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
       */
      try {
        _mapJson['state'] = _deliveryValue;
        await _updateContractServices.updateContract(_mapJson, context.read<MainProvider>().actualUser!.accessToken, nature, contract.transactionType, contract.idContract.toString());
        Navigator.of(context).pop();
        homeNavigationProvider.setIndexAndUpdateHeader(4);

      } catch (e) {
        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.problemUpdatingContract),
            content: Text(e is TimeoutException
                ? AppLocalizations.of(context)!.popupFailConnexionTimeout
                : e.toString()),
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

  Future<void> deleteContract(BuildContext context, Contract contract, HomeNavigationProvider homeNavigationProvider) async {

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
                Text(AppLocalizations.of(context)!.titlePopUpCancelContract),
              ],
            ),
          ),
        );
      },
    );

    /*
       * Calls the canceling contract function
       * if an error occurs, displays a popup giving a timeout error if the server doesn't respond or an internal server error.
       */
    try {
      await _updateContractServices.cancelContract(context.read<MainProvider>().actualUser!.accessToken, contract.idContract.toString());
      Navigator.of(context).pop();
      homeNavigationProvider.setIndexAndUpdateHeader(4);

    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemUpdatingContract),
          content: Text(e is TimeoutException
              ? AppLocalizations.of(context)!.popupFailConnexionTimeout
              : e.toString()),
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