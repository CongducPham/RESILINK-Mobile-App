import 'dart:async';
import 'dart:convert';
import 'package:resilink_mobile_application/constants/global_variables.dart';

import 'package:http/http.dart' as http;

import '../../../common/service/logger.dart';
import '../../../models/Asset.dart';
import '../../../models/Offer.dart';

class SearchServices {

  // Return the asset type with all numeric characters removed.
  String getCorrectAssetTypeRegex (String assetType) {
    String input = assetType.replaceAll(RegExp(r'\d+'), '');
    return input;
  }

  Future<void> fetchOfferFilteredWithAssets(
      List<Offer> searchedOffers,
      Map<String, Asset> offerAssets, // clé : "serverUrl|assetId"
      Map<String, dynamic> filter,
      String token,
      ) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}federated/all/filtered/";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("offerFilter - before sending data", data: {"data": filter});
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(filter),
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour récupérer les offres');
      });

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        info("offerFilter - success fetching offers+assets", data: {"data": jsonMap});

        jsonMap.forEach((serverUrl, serverData) {
          final List<dynamic> offersJson = serverData['offers'] ?? [];
          final Map<String, dynamic> assetsJson = serverData['assets'] ?? {};

          // Clé composite "serverUrl|assetId" pour éviter toute collision inter-serveurs
          assetsJson.forEach((_, assetJson) {
            final asset = Asset.fromJson(assetJson);
            offerAssets["$serverUrl|${asset.id}"] = asset;
          });

          // Offres avec serverUrl injecté directement dans l'objet
          for (final item in offersJson) {
            final offer = Offer.fromJson(item, serverUrl, serverData['serverName']);
            searchedOffers.add(offer);
          }
        });
      } else {
        error("offerFilter - error fetching offers", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to fetch filtered offers with assets");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("offerFilter - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Create a request from offer
   * An error is returned in the event of a problem
   */
  Future<int> createRequestWithId (Map<String, dynamic> data, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = GlobalVariables.pathAPIRequest;
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("createRequestWithId - before sending data", data: {"data": data});
      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(data)
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("createRequestWithId - success creating request", data: {"data": jsonMap});
        // Convert the json response into Map<dynamic, dynamic> and from this map, return the new request Id created.
        return jsonMap['requestId'];
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("createRequestWithId - error creating request", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to connect to the contract purchaseMaterial API");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("createRequestWithId - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Create a contract from offerId and RequestId
   * An error is returned in the event of a problem
   */
  Future<void>  createContract (int offerId, int requestId, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = GlobalVariables.pathAPIContract;
      final data = json.encode(<String, dynamic>{'offerId': offerId, 'requestId': requestId});
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("createContract - before sending data", data: {"data": data});
      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: data
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('The request has exceeded the 15-second time limit for retrieving offers.');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("createContract - success creating contract", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("createContract - error creating contract", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to connect to the contract purchaseMaterial API");
      }

    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("createContract - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Add an offerId in blockedOffer map by server of a prosumer
   * An error is returned in the event of a problem
   */
  Future<void> setOfferInBlockedOfferList (int offerId, String username, String token, String? serverUrl ) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}$username/blocked-offers/server";
      final data = json.encode(<String, String>{'serverName': serverUrl ?? "https://resilink-dp.org", 'offerId': offerId.toString()});
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("setOfferInBlockedOfferList - before sending data", data: {"data": data});
      late http.Response response;
      response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: data
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('The request has exceeded the 15-second time limit for retrieving offers.');
      });

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("setOfferInBlockedOfferList - success creating contract", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("setOfferInBlockedOfferList - error creating contract", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to connect to the addBlockedOffer request");
      }

    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("setOfferInBlockedOfferList - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

}