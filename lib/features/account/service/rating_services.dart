/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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