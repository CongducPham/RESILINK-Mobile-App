import 'dart:async';
import 'dart:convert';

import 'package:Resilink/models/Contract.dart';

import '../../../common/service/logger.dart';
import '../../../constants/global_variables.dart';

import 'package:http/http.dart' as http;

import '../../../models/Asset.dart';
import '../../../models/Offer.dart';

class AccountServices {

  /*
   * Retrieves the user's current offer in a query, as well as the assets linked to the offers.
   * An error is returned in the event of a problem
   */
  Future<void> fetchOfferOwnerWithAssets(List<Offer> listOffer, Map<int, Asset> mapAsset, String token, String owner) async {
    bool exceptionAlreadyThrown = false;
    try {
      String urlOffer = "${GlobalVariables.pathAPIOffer}owner/$owner";
      String urlAsset = "${GlobalVariables.pathAPIAsset}owner?idOwner=$owner";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      // Request to the API to get the owner offers
      final responseOffer = await http.get(Uri.parse(urlOffer), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      // Request to the API to get the owner assets
      final responseAsset = await http.get(Uri.parse(urlAsset), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour récupérer les assets');
      });
      if (responseOffer.statusCode == 200 && responseAsset.statusCode == 200) {
        info("fetchOfferOwnerWithAssets - success fetching data", data: {"offer": jsonDecode(responseOffer.body), "asset": jsonDecode(responseAsset.body)});
        // Convert the json responses into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMapOffer = jsonDecode(responseOffer.body);
        final jsonListAsset = jsonDecode(responseAsset.body);
        jsonMapOffer.forEach((key, data) =>
        {
          listOffer.insert(0, Offer.fromJson(data)),
        });
        jsonListAsset.forEach((data) =>
        {
          mapAsset[data['id']] = Asset.fromJson(data),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchOfferOwnerWithAssets - error fetching data", data: {"offer": jsonDecode(responseOffer.body), "asset": jsonDecode(responseAsset.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get owner's offers and assets");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchOfferOwnerWithAssets - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Retrieves the user's current contracts in a query, as well as the assets and offers linked to the contracts.
   * An error is returned in the event of a problem
   */
  Future<void> fetchOfferPurchasedWithAssetsContracts(List<Contract> listContract, Map<int, Offer> listOffer, Map<int, Asset> mapAsset, String token, String owner) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}owner/$owner/purchase";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 20), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (response.statusCode == 200) {
        info("fetchOfferPurchasedWithAssetsContracts - success fetching data", data: {"offer": jsonDecode(response.body)['offers'], "asset": jsonDecode(response.body)['assets']});
        // Convert the json response into 3 List<Map<dynamic, dynamic>> and from these lists, put in new lists the corresponding Objects.
        final jsonListOffer = jsonDecode(response.body)['offers'];
        final jsonListAsset = jsonDecode(response.body)['assets'];
        final jsonList = jsonDecode(response.body)['contracts'];
        jsonListOffer.forEach((data) =>
        {
          listOffer[data['offerId']] = Offer.fromJson(data),
        });
        jsonListAsset.forEach((data) =>
        {
          mapAsset[data['id']] = Asset.fromJson(data),
        });
        jsonList.forEach((data) =>
        {
          listContract.add(Contract.fromJson(data)),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchOfferPurchasedWithAssetsContracts - error fetching data", data: {"offer": jsonDecode(response.body)['offers'], "asset": jsonDecode(response.body)['assets']});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get owner's contracts with theirs offers and assets");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchOfferPurchasedWithAssetsContracts - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Update the user data, knowing it'll also update the user prosumer data
   * An error is returned in the event of a problem
   */
  Future<void> updateUserAndProsumerData(Map<String, Map<String, String>> data, String token, String userId) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}$userId";
      info("updateUserData - before sending data", data: {"data": data});
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
    };
      final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(data)).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour modifier l\'utilisateur');
      });
      if (response.statusCode == 200) {
        info("updateUserData - success updating user data", data: {"data": jsonDecode(response.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("updateUserData - error updating user data", data: {"offer": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error updating user data");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("updateUserData - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Delete an existing offer in ODEP
   * An error is returned in the event of a problem
   */
  Future<void> deleteOffer(int offerId, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}$offerId";
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour supprimer l\'offre');
      });
      if (response.statusCode == 200) {
        info("deleteOffer - success delete offer", data: {"data": jsonDecode(response.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("deleteOffer - error delete offer", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("failed to delete the offer, error message : ${response.body}");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("deleteOffer - Cannot connect to Resilink server", data: {"error": e});
      }
      exceptionAlreadyThrown = false;
      rethrow;
    }
  }

  /*
   * Delete an existing asset in ODEP
   * An error is returned in the event of a problem
   */
  Future<void> deleteAsset(int assetId, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIAsset}$assetId";
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour supprimer l\'offre');
      });
      if (response.statusCode == 200) {
        info("deleteDataODEPasset - success delete asset", data: {"data": jsonDecode(response.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("deleteDataODEPasset - error delete asset", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("failed to delete the asset, error message : ${jsonDecode(response.body)}");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("deleteDataODEPasset - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

}