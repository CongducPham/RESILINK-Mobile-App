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

}