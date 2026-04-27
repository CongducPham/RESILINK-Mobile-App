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

import 'package:resilink_mobile_application/models/AssetType.dart';

import '../../../common/service/logger.dart';
import '../../../constants/global_variables.dart';

import 'package:http/http.dart' as http;


class HomeNavigationServices {

//TODO a supprimer plus tard je mélangerai les assets avec les offres dans une meme fonction
  // Retrieves all assetTypes from API
  Future<void> fetchAllAssetTypes (Map<String, AssetType> assetTypeList, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIAssetType}all";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les assetTypes');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("fetchAllAssetTypes - success fetching assetTypes", data: {"data": jsonMap});
        jsonMap.forEach((item) =>
        {
          assetTypeList[item['name']] = AssetType.fromJson(item)
        });
      }
      else {
        error("fetchAllAssetTypes - error fetching assetTypes", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to fetch all assets");
      }
    } catch (e) {
      if(!exceptionAlreadyThrown) {
        error("fetchAllAssetTypes - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }
}