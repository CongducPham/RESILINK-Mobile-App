class News {

  late String id;
  late String institute;
  late String country;
  late String link;
  late String img;
  late String platform;
  late String public;

  News ({
    required this.id,
    required this.country,
    required this.institute,
    required this.link,
    required this.img,
    required this.platform,
    required this.public
  });

  factory News.fromJson(Map<String, dynamic> json){
    return News(
      id: json['_id'],
      country: json['country'],
      institute: json['institute'],
      link: json['url'],
      img: json['img'],
      platform: json['platform'],
      public: json['public']
    );
  }

}