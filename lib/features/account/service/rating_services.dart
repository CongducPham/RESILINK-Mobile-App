import 'dart:async';
import 'dart:convert';

import '../../../common/service/logger.dart';
import '../../../constants/global_variables.dart';

import 'package:http/http.dart' as http;

class RatingServices {

  /*
   * Retrieves the user's current rating.
   * An error is returned in the event of a problem
   */
  Future<double?> fetchUserRating(String token, String owner) async {
    bool exceptionAlreadyThrown = false;
    try {
      String urlRating = "${GlobalVariables.pathAPIRating}$owner";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      // Request to the API to get the owner rating
      final responseRating = await http.get(Uri.parse(urlRating), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (responseRating.statusCode == 200) {
        info("fetchUserRating - success fetching data", data: {"body": jsonDecode(responseRating.body)});
        // Convert the json responses into List<Map<dynamic, dynamic>> and from these lists, put in a new List and Map the corresponding Objects.
        final jsonMapRatingUser = jsonDecode(responseRating.body);
        return jsonMapRatingUser['rating'] != null ? jsonMapRatingUser['rating']: null;
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchUserRating - error fetching data", data: {"body": jsonDecode(responseRating.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get owner's rating");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchUserRating - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  Future<void> createUserRating(String token, String owner, double rating) async {
    bool exceptionAlreadyThrown = false;
    try {
      String urlRating = GlobalVariables.pathAPIRating;
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
    };
      final data = json.encode(<String, dynamic>{
        "userId": owner,
        "rating": rating
      });
      // Request to the API to get the owner rating
      final responseRating = await http.post(
          Uri.parse(urlRating),
          headers: headers,
          body: data).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (responseRating.statusCode == 200) {
        info("fetchUserRating - success fetching data", data: {"body": jsonDecode(responseRating.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchUserRating - error fetching data", data: {"body": jsonDecode(responseRating.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get owner's rating");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchUserRating - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Update the user's current rating.
   * An error is returned in the event of a problem
   */
  Future<void> updateUserRating(String token, String owner, double rating) async {
    bool exceptionAlreadyThrown = false;
    try {
      String urlRating = "${GlobalVariables.pathAPIRating}$owner";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      final data = json.encode(<String, double>{
        "rating": rating
      });
      // Request to the API to get the owner rating
      final responseRating = await http.put(
          Uri.parse(urlRating),
          headers: headers,
          body: data).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (responseRating.statusCode == 200) {
        info("fetchUserRating - success fetching data", data: {"body": jsonDecode(responseRating.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchUserRating - error fetching data", data: {"body": jsonDecode(responseRating.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get owner's rating");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchUserRating - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }
}