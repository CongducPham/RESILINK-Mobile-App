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

class PasswordChangingServices {

  Future<void> updateUserPassword(String token, Map<String, String> body) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIUser}password";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      // Request to the API to get the owner rating
      final responseRating = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body)).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (responseRating.statusCode == 200) {
        info("updatePassword - success updating password", data: {"body": jsonDecode(responseRating.body)});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("updatePassword - error fetching data", data: {"body": jsonDecode(responseRating.body)});
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