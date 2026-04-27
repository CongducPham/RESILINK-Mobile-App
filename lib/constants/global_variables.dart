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
import 'package:flutter/material.dart';


class GlobalVariables {

  //Link to important website
  static final String websiteUrl = "https://resilink.eu/";
  static final String privacyUrl = "https://resilink-dp.org/confidentialite";

  //API IP or domain  name + protocol http/https
  static const String ipAddressMasterServer = "resilink-dp.org";
  static String ipDomain = "resilink-dp.org";
  static String protocol = 'https';

  // API URLs with dynamics getters
  static String get pathAPIAsset => '$protocol://$ipDomain/v3/assets/';
  static String get pathAPIOffer => '$protocol://$ipDomain/v3/offers/';
  static String get pathAPIContract => '$protocol://$ipDomain/v3/contracts/';
  static String get pathAPIRequest => '$protocol://$ipDomain/v3/ODEP/requests/';
  static String get pathAPIProsumer => '$protocol://$ipDomain/v3/prosumers/';
  static String get pathAPIAssetType => '$protocol://$ipDomain/v3/assetTypes/';
  static String get pathAPIUser => '$protocol://$ipDomain/v3/users/';
  static String get pathAPINews => '$protocol://$ipDomain/v3/news/';
  static String get pathAPIRating => '$protocol://$ipDomain/v3/rating/';
  static String get pathAPIRecommendationStats => '$protocol://$ipDomain/v3/recommendationstats/';
  static String get pathAPIRegisteredServer => '$protocol://$ipDomain/v3/registeredservers/';
  static String get pathAPIFavoriteServers=> '$protocol://$ipDomain/v3/favoriteServers/';

  // ThemeData
  static final TextTheme appTextTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 36,        // displaySmall Material 3 standard
      height: 44 / 36,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
    ),
    // Main section title in content pages (e.g. aboutUsFirstTitle)
    headlineMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 28,
      height: 36 / 28,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
    ),
    // Sub-section title (e.g. aboutUsSecondTitle)
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 22,
      height: 28 / 22,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
    ),
    // Form labels, card titles
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
    ),
    // Main body text
    bodyLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.normal,
    ),
    // Secondary text, metadata
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.25,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.normal,
    ),
    // Button text
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.5,
      fontWeight: FontWeight.normal,
    ),
  );
  // COLORS
  /*
  static const backgroundColor = Colors.white;
  static Color backgroundTile = Color.fromARGB(255, 254, 247, 255);
  static Color navigationBarColor = Color.fromARGB(255, 254, 247, 255);
  static const tertiaryColor = Color.fromARGB(255, 103, 80, 164);
  static const unFocusBorderColor = Color.fromARGB(255, 121, 116, 126);
  static const headerBackgroundColor = Color.fromARGB(255, 254, 247, 255);
  static const textHeaderColor = Color.fromARGB(255, 29, 27, 32);
  static const textDefaultColor = Colors.black;
  static const unFocusNavigationBarColor = Colors.black54;
  static const focusNavigationBarColor = Colors.deepPurple;
  static const primaryColor = Color.fromARGB(255, 121, 116, 126);

   */
  /*
  // From figma, sample n°2
  static const backgroundColor = Colors.white;
  static const backgroundTile = Color.fromARGB(255, 255, 241, 194);
  static const navigationBarColor = Color.fromARGB(255, 251, 176, 41);
  static const tertiaryColor = Color.fromARGB(255, 103, 80, 164);
  static const unFocusBorderColor = Color.fromARGB(255, 121, 116, 126);
  static const headerBackgroundColor = Color.fromARGB(255, 251, 176, 41);
  static const textHeaderColor = Color.fromARGB(255, 29, 27, 32);
  static const textDefaultColor = Colors.black;
  static const unFocusNavigationBarColor = Colors.white;
  static const focusNavigationBarColor = Colors.white;
  static const primaryColor = Color.fromARGB(255, 251, 176, 41);
   */
  // From figma, sample n°3
  static const backgroundColor = Colors.white;
  static const backgroundTile = Color.fromARGB(255, 255, 241, 194);
  static const navigationBarColor = Colors.white;
  static const tertiaryColor = Color.fromARGB(255, 103, 80, 164);
  static const unFocusBorderColor = Color.fromARGB(255, 121, 116, 126);
  static const headerBackgroundColor = Color.fromARGB(255, 251, 176, 41);
  static const textHeaderColor = Color.fromARGB(255, 29, 27, 32);
  static const textDefaultColor = Colors.black;
  static const unFocusNavigationBarColor = Colors.black;
  static const focusNavigationBarColor = Color.fromARGB(255, 251, 176, 41);
  static const primaryColor = Color.fromARGB(255, 251, 176, 41);

  //AssetType usable by the application
  static const List<String> allowedAndOrderedAssetTypes = [
    "Fruit",
    "Vegetable",
    "Crop",
    "Livestock",
    "Machinery",
    "Transport",
    "Inputs",
    "Storage",
    "Labor",
    "Other services",
  ];

  //AssetTypes images
  static const Map<String, String> assetTypeImages = {
    'crop': 'assets/images/assetType/Crop.png',
    'fruit': 'assets/images/assetType/Fruits.png',
    'machinery': 'assets/images/assetType/Machinery.png',
    'labor': 'assets/images/assetType/Labor.png',
    'noimage': 'assets/images/assetType/NoImage.png',
    'otherservices': 'assets/images/assetType/OtherServices.png',
    'storage': 'assets/images/assetType/Storage.png',
    'vegetable': 'assets/images/assetType/Vegetable.png',
    'inputs': 'assets/images/assetType/Inputs.png',
    'transport': 'assets/images/assetType/Transport.png',
    'livestock': 'assets/images/assetType/Livestock.png',
  };

  //SVG icons
  static const Map<String, String> svgImage = {
    'account_management': 'assets/images/svg/account_management.svg',
    'book': 'assets/images/svg/book.svg',
    'information': 'assets/images/svg/information.svg',
    'menu': 'assets/images/svg/menu.svg',
    'money': 'assets/images/svg/money.svg',
    'notification': 'assets/images/svg/notification.svg',
    'planet': 'assets/images/svg/planet.svg',
    'profile': 'assets/images/svg/profile.svg',
    'whatsapp': 'assets/images/svg/whatsapp.svg',
    'crop': 'assets/images/svg/Crop.svg',
    'fruit': 'assets/images/svg/Fruits.svg',
    'machinery': 'assets/images/svg/Machinery.svg',
    'transport': 'assets/images/svg/Transport.svg',
    'inputs': 'assets/images/svg/Inputs.svg',
    'labor': 'assets/images/svg/Labor.svg',
    'otherservices': 'assets/images/svg/OtherServices.svg',
    'storage': 'assets/images/svg/Storage.svg',
    'vegetable': 'assets/images/svg/Vegetable.svg',
    'livestock': 'assets/images/svg/Vegetable.svg',
  };

  //Default images available to publish an offer
  static const Map<String, String> othersImage = {
    'apple': 'assets/images/img/apple.jpg',
    'banana': 'assets/images/img/banana.jpg',
    'beet': 'assets/images/img/beet.jpg',
    'cucumber': 'assets/images/img/cucumber.jpeg',
    'eggplant': 'assets/images/img/eggplant.jpg',
    'potato': 'assets/images/img/potato.png',
    'resilinkLogo': 'assets/images/img/resilink-logo-hr.png',
    'splashArt': 'assets/images/img/SplashArt.png',
    'strawberry': 'assets/images/img/strawberry.jpg',
    'tomato': 'assets/images/img/tomato.jpeg',
    'web': 'assets/images/img/web.png',
  };
  
}