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
import '../../../models/RegisteredServer.dart';
import 'package:http/http.dart' as http;

class ServerListServices {

  /// Fetches all registered servers from the central server
  Future<List<RegisteredServer>> fetchRegisteredServers() async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIRegisteredServer}global";
      final headers = <String, String>{
        "accept": "application/json",
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('Request timed out while fetching registered servers');
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final servers = jsonList.map((json) => RegisteredServer.fromJson(json)).toList();
        info("fetchRegisteredServers - success", data: {"count": servers.length});
        return servers;
      } else {
        error("fetchRegisteredServers - error", data: {"status": response.statusCode, "body": response.body});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching registered servers");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("fetchRegisteredServers - Cannot connect to server", data: {"error": e});
      }
      rethrow;
    }
  }

  /// Fetches the list of favorite server URLs for a given user
  Future<List<String>> fetchFavoriteServers(String username, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIFavoriteServers}$username";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('Request timed out while fetching favorite servers');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<String> servers = List<String>.from(json['servers'] ?? []);
        info("fetchFavoriteServers - success", data: {"count": servers.length});
        return servers;
      } else {
        error("fetchFavoriteServers - error", data: {"status": response.statusCode, "body": response.body});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching favorite servers");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("fetchFavoriteServers - Cannot connect to server", data: {"error": e});
      }
      rethrow;
    }
  }

  /// Adds a server to the user's favorites
  Future<void> addFavoriteServer(String username, String serverUrl, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      // serverUrl is used as serverName in the route
      String url = "${GlobalVariables.pathAPIFavoriteServers}$username/add?serverName=$serverUrl";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('Request timed out while adding favorite server');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        info("addFavoriteServer - success", data: {"serverUrl": serverUrl});
      } else {
        error("addFavoriteServer - error", data: {"status": response.statusCode, "body": response.body});
        exceptionAlreadyThrown = true;
        throw Exception("Error adding favorite server");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("addFavoriteServer - Cannot connect to server", data: {"error": e});
      }
      rethrow;
    }
  }

  /// Removes a server from the user's favorites
  Future<void> removeFavoriteServer(String username, String serverUrl, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIFavoriteServers}$username/remove?serverName=$serverUrl";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('Request timed out while removing favorite server');
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        info("removeFavoriteServer - success", data: {"serverUrl": serverUrl});
      } else {
        error("removeFavoriteServer - error", data: {"status": response.statusCode, "body": response.body});
        exceptionAlreadyThrown = true;
        throw Exception("Error removing favorite server");
      }
    } catch (e) {
      if (!exceptionAlreadyThrown) {
        error("removeFavoriteServer - Cannot connect to server", data: {"error": e});
      }
      rethrow;
    }
  }
}