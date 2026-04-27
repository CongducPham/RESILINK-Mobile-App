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

import 'package:flutter/material.dart';

import '../../../common/service/logger.dart';
import '../../../constants/global_variables.dart';
import '../../../models/News.dart';

import 'package:http/http.dart' as http;

class NewsPageService {

  // Associate an image with a news item
  Widget newsAccountTileImg (News news) {
    late Widget img;
    if (news.img.isNotEmpty) {
      /*
      img = const FittedBox(
        fit: BoxFit.fill,
        /*
        child: fetchdata.convertBase64ToImg(news.img),
          TODO to change to new function of common/service
          UPDATE To simplify development, there is no need to manage multiple news platforms

         */
      );
       */
      // for the moment, compulsory image set-up
      img = Image(image: AssetImage('assets/images/img/web.png'), fit: BoxFit.fill);
    } else {
      // image per default
      img = Image(image: AssetImage('assets/images/img/web.png'), fit: BoxFit.fill);
    }
    return img;
  }

  /*
   * Retrieve owner bookmarked news
   * An error is returned in the event of a problem
   */
  Future<void> fetchNews(List<News> listNews, String token, String country, bool connected, String username) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = connected ? "${GlobalVariables.pathAPINews}countryOwner?country=$country&owner=$username" : "${GlobalVariables.pathAPINews}country?country=$country";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchNews - success fetching news", data: {"data": jsonDecode(response.body)});
        // Convert the json responses into List<Map<dynamic, dynamic>> and from these lists, put in a new List the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap["NewsList"].forEach((data) =>
        {
          if (data['public'] == "true") {
            listNews.add(News.fromJson(data)),
          }
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchNews - error fetching news", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get news");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchNews - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Retrieve owner bookmarked news
   * An error is returned in the event of a problem
   */
  Future<void> fetchOwnerNews(List<News> listNews, String token, String username) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPINews}owner/$username" ;
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        info("fetchOwnerNews - success fetching news", data: {"data": jsonDecode(response.body)});
        // Convert the json response into List<Map<dynamic, dynamic>> and from these lists, put in a new List the corresponding Objects.
        final jsonMap = jsonDecode(response.body);
        jsonMap["NewsList"].forEach((data) =>
        {
          listNews.add(News.fromJson(data)),
        });
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("fetchOwnerNews - error fetching news", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error fetching from API to get news");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("fetchOwnerNews - Cannot connect to Resilink server", data: {"error": e});
      }
      rethrow;
    }
  }

  /*
   * Add a news in the user bookmarked news
   * An error is returned in the event of a problem
   */
  Future<void> addNewsBookmarkedList(String id, String token, String username) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}$username/addBookmark";
      final body = jsonEncode(<String, String>{
        "bookmarkId": id
      });
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      late http.Response response;
      response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body);
        info("addNewsBookmarkedList - success patching data", data: {"data": jsonList});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("addNewsBookmarkedList - error patching data", data: {"data": jsonDecode(response.body)});
        exceptionAlreadyThrown = true;
        throw Exception("Error patching from API addNewsBookmarkedList");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("addNewsBookmarkedList - Cannot connect to Resilink server", data: {"error": e});
      }
      exceptionAlreadyThrown = false;
      rethrow;
    }
  }

  /*
   * Delete a news in the user bookmarked news
   * An error is returned in the event of a problem
   */
  Future<void> deleteNewsBookmarkedList(String id, String token, String username) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPIProsumer}delBookmark/id?id=$id&owner=$username";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final response = await http.delete(
          Uri.parse(url),
          headers: headers
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        exceptionAlreadyThrown = true;
        throw TimeoutException('La requête a dépassé le délai de 10 secondes');
      });
      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        info("deleteNewsBookmarkedList - success patching data", data: {"data": jsonMap});
      } else {
        // response code != 200 => error, writes to logs the answer and returns an exception
        error("deleteNewsBookmarkedList - error patching data", data: {"data": jsonMap});
        exceptionAlreadyThrown = true;
        throw Exception("Error patching from API addNewsBookmarkedList");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("deleteNewsBookmarkedList - Cannot connect to Resilink server", data: {"error": e});
      }
      exceptionAlreadyThrown = false;
      rethrow;
    }
  }

  /*
   * Crate a news
   * An error is returned in the event of a problem
   */
  Future<void> createNewsFromUser(String userName, Map<String, String> map, String token) async {
    bool exceptionAlreadyThrown = false;
    try {
      String url = "${GlobalVariables.pathAPINews}$userName";
      final headers = <String, String>{
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      final body = json.encode(map);
      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        ).timeout(const Duration(seconds: 10), onTimeout: () {
          exceptionAlreadyThrown = true;
          throw TimeoutException('La requête a dépassé le délai de 10 secondes');
        });
      if (response.statusCode == 200) {
        info("createNewsFromUser - success creating a news");
      }
    } catch (e) {
      // If a problem hasn't already occurred, write an error in the logs
      if(!exceptionAlreadyThrown) {
        error("createNewsFromUser - Cannot connect to Resilink server", data: {"error": e});
      }
      exceptionAlreadyThrown = false;
      rethrow;
    }
  }

}