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
import 'RequestAssetType.dart';

class Request {

  late String requester;
  late String beginTimeSlot;
  late String? endTimeSlot;
  late String validityLimit;
  late String? publicationDate;
  late String paymentMethod;
  late num paymentFrequency;
  late num? requestId;
  late List<int>? offerIds;
  late List<RequestAssetType>? assetTypes;

  Request({
    required this.requestId,
    required this.requester,
    required this.beginTimeSlot,
    required this.endTimeSlot,
    required this.validityLimit,
    required this.publicationDate,
    required this.paymentMethod,
    required this.paymentFrequency,
    required this.offerIds,
    required this.assetTypes
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    List<RequestAssetType> assetTypes = [];
    if(json['assetTypes'] != null) {
      json['assetTypes'].forEach((content) => {
        assetTypes.add(RequestAssetType.fromJson(content))
      });
    }
    return Request(
        requester: json['requester'],
        requestId: json['requestId'],
        beginTimeSlot: json['beginTimeSlot'],
        endTimeSlot: json['endTimeSlot'],
        validityLimit: json['validityLimit'],
        publicationDate: json['publicationDate'],
        paymentMethod: json['paymentMethod'],
        paymentFrequency: json['paymentFrequency'],
        offerIds: json['offerIds'],
        assetTypes: assetTypes
    );
  }

}