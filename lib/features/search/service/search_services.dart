import 'dart:async';
import 'dart:convert';
import 'package:Resilink/constants/global_variables.dart';

import 'package:http/http.dart' as http;

import '../../../common/service/logger.dart';
import '../../../models/Asset.dart';
import '../../../models/Offer.dart';

class SearchServices {

  /*
   * Get the list of filtered offers
   * An error is returned in the event of a problem
   */
  Future<void> fetchOfferFiltered (List<Offer> searchOffer, Map<String, dynamic> filter, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}all/resilink/filtered/";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("offerFilter - before sending data", data: {"data": filter});
      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(filter)
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("offerFilter - success fetching offers", data: {"data": jsonMap});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List the corresponding Objects.
        jsonMap.forEach((item) =>
        {
          searchOffer.add(Offer.fromJson(item))
        });
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("offerFilter - error fetching offers", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to connect to the contract purchaseMaterial API");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("offerFilter - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  //TODO a supprimer plus tard je mélangerai les assets avec les offres dans une meme fonction
  /*
   * Get all asset
   * An error is returned in the event of a problem
   */
  Future<void> fetchAsset (Map<int, Asset> asset, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIAsset}all";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.get(
          Uri.parse(url),
          headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("fetchAsset - success fetching assets", data: {"data": jsonMap});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new Map the corresponding Objects.
        jsonMap.forEach((item) =>
        {
          asset[item['id']] = Asset.fromJson(item)
        });
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchAsset - error fetching assets", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to fetch all assets");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchAsset - Cannot connect to Resilink server", data: {"error": e});
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
      print("tentative création request, url: ${GlobalVariables.pathAPIRequest}");
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
   * Create a contract from offerId and RequestId
   * An error is returned in the event of a problem
   */
  Future<void> setOfferInBlockedOfferList (int offerId, String username, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}$username/addBlockedOffer";
      final data = json.encode(<String, dynamic>{'offerId': offerId.toString()});
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("setOfferInBlockedOfferList - before sending data", data: {"data": data});
      final response = await http.patch(
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