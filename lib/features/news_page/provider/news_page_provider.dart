import 'package:flutter/material.dart';

import '../../../models/News.dart';

class NewsPageProvider with ChangeNotifier {
  //Pour le moment Page news n'a pas de fonction pure donc mise en place de fausse news
  List<News> _listNews = [News(id: "0", country: "Egypt", institute: "Daily News Egypt", link: "https://www.dailynewsegypt.com/", img: "", platform: "web"),
    News(id: "1", country: "Egypt", institute: "Ministry of Agriculture and Land Reclamation", link: "https://moa.gov.eg/", img: "", platform: "web"),];

  bool _isLoading = false;

  List<News> get listNews => _listNews;
  bool get isLoading => _isLoading;

}