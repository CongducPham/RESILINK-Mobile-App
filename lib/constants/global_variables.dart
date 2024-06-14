import 'package:flutter/material.dart';


class GlobalVariables {

  //API URL
  String uri = 'http://10.0.13.38:9000/';

  // COLORS
  static const backgroundColor = Colors.white;
  static const navigationBarColor = Color.fromARGB(255, 254, 247, 255);
  static const tersiaryColor = Color.fromARGB(255, 103, 80, 164);
  static const unFocusBorderColor = Color.fromARGB(255, 121, 116, 126);
  static const textHeaderColor = Color.fromARGB(255, 29, 27, 32);
  static const textDefaultColor = Colors.black;

  static const Map<String, String> assetTypeImages = {
    'crop': 'assets/images/assetType/Crop.png',
    'fruit': 'assets/images/assetType/Fruits.png',
    'machinery': 'assets/images/assetType/Machinery.png',
    'labor': 'assets/images/assetType/Labor.png',
    'noimage': 'assets/images/assetType/NoImage.png',
    'otherservices': 'assets/images/assetType/OtherServices.png',
    'storage': 'assets/images/assetType/Storage.png',
    'vegetable': 'assets/images/assetType/Vegetable.png',
  };

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
  };

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