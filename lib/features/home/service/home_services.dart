import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resilink_mobile_application/constants/global_variables.dart';

import '../../../common/service/logger.dart';
import '../../../models/Asset.dart';
import '../../../models/News.dart';
import '../../../models/Offer.dart';

class HomeServices {

  /*
   * Retrieves the last published offers (paginated), as well as the assets linked to the offers.
   * New multi-server structure: map of serverUrl -> {offers, assets}
   * An error is returned in the event of a problem
   */
  Future<void> fetchLimitedOfferAsset(List<Offer> listOffer, Map<String, Asset> mapAsset, int iteration, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}LimitedOffer?offerNbr=3&iteration=$iteration&federated=true";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchLimitedOfferAsset - success fetching data", data: {"data": jsonDecode(response.body)});
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        List<Offer> tampListOffer = [];
        jsonMap.forEach((serverUrl, serverData) {
          // Assets indexés par clé composite "serverUrl|assetId"
          final Map<String, dynamic> assetsJson = serverData['assets'] ?? {};
          assetsJson.forEach((_, assetJson) {
            final asset = Asset.fromJson(assetJson);
            mapAsset["$serverUrl|${asset.id}"] = asset;
          });

          // Offres avec serverUrl injecté
          final List<dynamic> offersJson = serverData['offers'] ?? [];
          for (final data in offersJson) {
            tampListOffer.add(Offer.fromJson(data, serverUrl, serverData['serverName']));
          }
        });

        listOffer.insertAll(0, tampListOffer.reversed);
      } else {
        error("fetchLimitedOfferAsset - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get all offers");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("fetchLimitedOfferAsset - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Retrieves suggested offers, as well as the assets linked to the offers.
   * New multi-server structure: map of serverUrl -> {offers, assets}
   * An error is returned in the event of a problem
   */
  Future<void> fetchSuggestedOfferAsset(List<Offer> listOffer, Map<String, Asset> mapAsset, String owner, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}suggested/?offerNbr=3&iteration=0";
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
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        jsonMap.forEach((serverUrl, serverData) {
          // Assets indexés par clé composite "serverUrl|assetId"
          final Map<String, dynamic> assetsJson = serverData['assets'] ?? {};
          assetsJson.forEach((_, assetJson) {
            final asset = Asset.fromJson(assetJson);
            mapAsset["$serverUrl|${asset.id}"] = asset;
          });

          // Offres avec serverUrl injecté
          final List<dynamic> offersJson = serverData['offers'] ?? [];
          for (final data in offersJson) {
            listOffer.add(Offer.fromJson(data, serverUrl, serverData['serverName']));
          }
        });

      } else {
        error("fetchSuggestedOfferAsset - error fetching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get all offers");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
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
  Future<void> fetchBlockedOffer(List<Offer> listOffer, Map<String, Asset> mapAsset, String owner, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}owner/blockedOffer/federated?includeAssets=true";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchBlockedOffer - success fetching data", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        jsonMap.forEach((serverUrl, serverData) {
          // Assets indexés par clé composite "serverUrl|assetId"
          final Map<String, dynamic> assetsJson = serverData['assets'] ?? {};
          assetsJson.forEach((_, assetJson) {
            final asset = Asset.fromJson(assetJson);
            mapAsset["$serverUrl|${asset.id}"] = asset;
          });

          // Offres avec serverUrl injecté
          final List<dynamic> offersJson = serverData['offers'] ?? [];
          for (final data in offersJson) {
            listOffer.add(Offer.fromJson(data, serverUrl, serverData['serverName']));
          }
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

  Future<void> deleteOfferBlockedOfferList (int offerId, String username, String serverUrl, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}$username/blocked-offers/server/$offerId?serverName=$serverUrl";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.delete(
          Uri.parse(url),
          headers: headers,
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