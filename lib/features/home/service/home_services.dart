import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Resilink/constants/global_variables.dart';

import '../../../common/service/logger.dart';
import '../../../models/Asset.dart';
import '../../../models/News.dart';
import '../../../models/Offer.dart';

class HomeServices {

  /*
   * Retrieves the last 3 published offers, as well as the assets linked to the offers.
   * An error is returned in the event of a problem
   */
  Future<void> fetchLastThreeOfferAsset(List<Offer> listOffer, Map<int, Asset> mapAsset, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      const String url = "${GlobalVariables.pathAPIOffer}lastThree/";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchLastThreeOfferAsset - success fetching data", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap['offers'].forEach((data) =>
        {
          listOffer.add(Offer.fromJson(data)),
        });
        jsonMap['assets'].forEach((key, data) =>
        {
          mapAsset[int.parse(key)] = Asset.fromJson(data),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchLastThreeOfferAsset - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get all offers");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchLastThreeOfferAsset - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Retrieves the last 3 published offers, as well as the assets linked to the offers.
   * An error is returned in the event of a problem
   */
  Future<void> fetchSuggestedOfferAsset(List<Offer> listOffer, Map<int, Asset> mapAsset, String owner, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}suggested/$owner";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchSuggestedOfferAsset - success fetching data", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap['offers'].forEach((data) =>
        {
          listOffer.add(Offer.fromJson(data)),
        });
        jsonMap['assets'].forEach((key, data) =>
        {
          mapAsset[int.parse(key)] = Asset.fromJson(data),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchSuggestedOfferAsset - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get all offers");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchSuggestedOfferAsset - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * If a user is connected, retrieve news bookmarked by the user
   * Else, retrieve news from the country selected by the user
   * An error is returned in the event of a problem
   */
  Future<void> fetchLastThreeNews(List<News> listNews, String token, String country, bool connected, String username) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = connected ? "${GlobalVariables.pathAPINews}owner/$username" : "${GlobalVariables.pathAPINews}country?country=$country";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchLastThreeNews - success fetching data", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap["NewsList"].forEach((data) =>
        {
          listNews.add(News.fromJson(data)),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchLastThreeNews - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get news");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchLastThreeNews - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Retrieves the blocked offers, as well as the assets linked to the offers.
   * An error is returned in the event of a problem
   */
  Future<void> fetchBlockedOffer(List<Offer> listOffer, Map<int, Asset> mapAsset, String owner, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}owner/blockedOffer/$owner";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchSuggestedOfferAsset - success fetching data", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap['offers'].forEach((data) =>
        {
          listOffer.add(Offer.fromJson(data)),
        });
        jsonMap['assets'].forEach((key, data) =>
        {
          mapAsset[int.parse(key)] = Asset.fromJson(data),
          print(mapAsset),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchBlockedOffer - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get blocked offers");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchBlockedOffer - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  Future<void> deleteOfferBlockedOfferList (int offerId, String username, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}delBlockedOffer/id?id=$offerId&owner=$username";
      final data = json.encode(<String, dynamic>{'offerId': offerId.toString()});
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("deleteOfferBlockedOfferList - before sending data", data: {"data": data});
      final response = await http.delete(
          Uri.parse(url),
          headers: headers,
          body: data
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('The request has exceeded the 15-second time limit for retrieving offers.');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("deleteOfferBlockedOfferList - success creating contract", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("deleteOfferBlockedOfferList - error creating contract", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to connect to the addBlockedOffer request");
      }

    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("deleteOfferBlockedOfferList - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

}