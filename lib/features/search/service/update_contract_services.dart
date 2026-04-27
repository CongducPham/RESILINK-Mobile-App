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

class UpdateContractServices {

  /*
   * Update a contract
   * An error is returned in the event of a problem
   */
  Future<void> updateContract (Map<String, dynamic> body, String token, String nature, String contractId) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = nature == "measurableByQuantity" ? "${GlobalVariables.pathAPIContract}measurableByQuantityContract/$contractId" : "${GlobalVariables.pathAPIContract}measurableByTimeContract/$contractId" ;
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("updateContract - before sending data", data: {"data": body});
      final response = await http.patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body)
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pour mettre à jour le contract');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("updateContract - success updating contract", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("updateContract - error updating contract", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception(jsonDecode(response.body)['message']);
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
   * Cancel a contract
   * An error is returned in the event of a problem
   */
  Future<void> cancelContract (String token, String contractId) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIContract}cancelContract/$contractId";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      info("cancelContract - before sending data");
      final response = await http.patch(
          Uri.parse(url),
          headers: headers,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("cancelContract - success updating contract", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("cancelContract - error updating contract", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("cancelContract - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

}