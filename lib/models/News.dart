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