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

import 'SpecificAttrModel.dart';

class AssetType {

  late String name;
  late String? description;
  late String nature;
  late String? unit;
  late String? regulator;
  late bool subjectOfQuantity;
  late bool sharingIncentive;
  late List<SpecificAttrModel>? assetDataModel;

  AssetType ({
    required this.name,
    required this.description,
    required this.nature,
    required this.unit,
    required this.regulator,
    required this.subjectOfQuantity,
    required this.sharingIncentive,
    required this.assetDataModel,
  });

  factory AssetType.fromJson(Map<String, dynamic> json) {
    List<SpecificAttrModel>? spec = [];
    if (json['assetDataModel'] != null) {
      json['assetDataModel'].forEach((element) {
        spec.add(SpecificAttrModel.fromJson(element));
      });
    }
    return AssetType (
      name: json['name'],
      description: json['description'],
      nature: json['nature'],
      unit:  json['unit'],
      regulator: json['regulator'],
      subjectOfQuantity: json['subjectOfQuantity'],
      sharingIncentive: json['sharingIncentive'],
      assetDataModel: spec,
    );
  }
  
}