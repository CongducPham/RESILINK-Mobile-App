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
import 'SpecificAttrAsset.dart';

class Asset {

  late int id;
  late String name;
  late String description;
  late String assetType;
  late String owner;
  late double? totalQuantity;
  late String unit;
  late double remainingQuantity;
  late String? regulatedId;
  late bool multiAccess;
  late List? images;
  late List<SpecificAttrAsset>? specificAttributes;

  Asset ({
    required this.id,
    required this.name,
    required this.description,
    required this.assetType,
    required this.owner,
    required this.totalQuantity,
    required this.unit,
    required this.remainingQuantity,
    required this.regulatedId,
    required this.multiAccess,
    required this.images,
    required this.specificAttributes
  });

  factory Asset.fromJson(Map<String, dynamic> json){
    List<SpecificAttrAsset>? spec = [];
      if (json["specificAttributes"] != null){
      json['specificAttributes'].forEach((element) {
        spec.add(SpecificAttrAsset.fromJson(element));
      });
    }
    return Asset(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      assetType: json['assetType'],
      owner: json['owner'],
      unit: json['unit'] ?? "",
      totalQuantity: json['totalQuantity'].toDouble(),
      remainingQuantity: json['remainingQuantity'].toDouble(),
      regulatedId: json['regulatedId'],
      multiAccess: json['multiAccess'],
      images: json['images'] ?? [],
      specificAttributes: spec
    );
  }

}