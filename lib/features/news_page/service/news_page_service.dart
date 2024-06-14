import 'package:flutter/material.dart';

import '../../../models/News.dart';

class NewsPageService {

  Widget newsAccountTileImg (News news) {
    late Widget img;
    if (news.img.isNotEmpty) {
      /*
      img = const FittedBox(
        fit: BoxFit.fill,
        /*
        child: fetchdata.convertBase64ToImg(news.img),
          TODO to change to new function of common/service
         */
      );
       */
      //pour le moment, mise en place d'une image obligatoire
      img = Image(image: AssetImage('assets/images/img/${news.platform}.png'), fit: BoxFit.fill);
    } else {
      img = Image(image: AssetImage('assets/images/img/${news.platform}.png'), fit: BoxFit.fill);
    }
    return img;
  }
}