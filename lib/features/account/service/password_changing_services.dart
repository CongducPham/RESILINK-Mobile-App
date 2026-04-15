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