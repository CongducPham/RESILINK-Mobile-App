import 'dart:async';
import 'dart:convert';

import 'package:Resilink/models/AssetType.dart';

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