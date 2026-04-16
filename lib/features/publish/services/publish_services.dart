import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../../../common/service/logger.dart';
import '../../../constants/global_variables.dart';

import 'package:http/http.dart' as http;

class PublishServices {

  // Return the asset type with all numeric characters removed.
  String getCorrectAssetTypeRegex (String assetType) {
    String input = assetType.replaceAll(RegExp(r'\d+'), '');
    return input;
  }

  /*
   * Publishes a new offer.
   * It will create an offer, its asset and assetType
   * An error is returned in the event of a problem
   */
  Future<void> publishOffer (Map<String, dynamic> body, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}createOfferAsset";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      info("publishOffer - before sending data", data: {"data": body});
      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body)
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes pur récupérer les offres');
      });
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        info("publishOffer - success publishing offer", data: {"data": jsonMap});
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("publishOffer - error publishing offer", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to publishing offer");
      }
    } catch (e) {
      if(!exceptionAlreadyThrown) {
        error("createRequestWithId - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Update offer and asset data
   * An error is returned in the event of a problem
   */
  Future<void> updateOfferAsset (String token, Map<String, dynamic> map, int offerId) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIOffer}$offerId/updateOfferAsset";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'accept': 'application/json'
      };
      final body = json.encode(map);
      info("updateOfferAsset - before sending data", data: {"data": body});
      var response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: body
      ).timeout(
          const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException('La requête a dépassé le délai de 20 secondes');
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        info("updateOfferAsset - success updating offer", data: responseBody);
      }
      else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("updateOfferAsset - error updating offer",
            data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Failed to updating offer");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("updateOfferAsset - Cannot connect to Resilink server",
            data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Function to retrieve the image and convert it to base64
   * An error is returned in the event of a problem
   */
  Future<String> convertImageToBase64(String img) async {

    // Retrieve image from URL
    final response = await http.get(Uri.parse(img));

    if (response.statusCode == 200) {

      // Conversion en Base64
      Uint8List bytes = response.bodyBytes; // Retrieve the image bytes
      String base64String = base64Encode(bytes); // Encoder en Base64

      return base64String;

    } else {
      throw Exception("Failed to convert image to base64");
    }
  }
}