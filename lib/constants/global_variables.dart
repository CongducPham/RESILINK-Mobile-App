import 'package:flutter/material.dart';


class GlobalVariables {

  //API URL
  static const String pathAPIAsset = 'https://resilink-api.onrender.com/v1/assets/';
  static const String pathAPIOffer = 'https://resilink-api.onrender.com/v1/offers/';
  static const String pathAPIContract = 'https://resilink-api.onrender.com/v1/contracts/';
  static const String pathAPIRequest = 'https://resilink-api.onrender.com/v1/ODEP/requests/';
  static const String pathAPIProsumer = 'https://resilink-api.onrender.com/v1/prosumers/';
  static const String pathAPIAssetType = 'https://resilink-api.onrender.com/v1/assetTypes/';
  static const String pathAPIUser = 'https://resilink-api.onrender.com/v1/users/';
  static const String pathAPINews = 'https://resilink-api.onrender.com/v1/news/';

  // COLORS
  static const backgroundColor = Colors.white;
  static const navigationBarColor = Color.fromARGB(255, 254, 247, 255);
  static const tertiaryColor = Color.fromARGB(255, 103, 80, 164);
  static const unFocusBorderColor = Color.fromARGB(255, 121, 116, 126);
  static const textHeaderColor = Color.fromARGB(255, 29, 27, 32);
  static const textDefaultColor = Colors.black;

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
