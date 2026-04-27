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
import 'SpecificRent.dart';

class Contract {

  late int idContract;
  late String offer;
  late String Request;
  late String asset;
  late String state;
  late String assetType;
  late num? quantityToDeliver;
  late num? deliveredQuantity;
  late num? consumedQuantity;
  late String creationDate;
  late String offerer;
  late String requester;
  late num price;
  late num deposit;
  late num cancellationFee;
  late String beginTimeSlot;
  late String? endTimeSlot;
  late String effectiveBeginTimeSlot;
  late String effectiveEndTimeSlot;
  SpecificRent? rentInformation;

  Contract({
    required this.idContract,
    required this.offer,
    required this.Request,
    required this.asset,
    required this.state,
    required this.assetType,
    required this.quantityToDeliver,
    required this.deliveredQuantity,
    required this.consumedQuantity,
    required this.creationDate,
    required this.offerer,
    required this.requester,
    required this.price,
    required this.deposit,
    required this.cancellationFee,
    required this.beginTimeSlot,
    required this.endTimeSlot,
    required this.effectiveBeginTimeSlot,
    required this.effectiveEndTimeSlot,
    required this.rentInformation
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    SpecificRent? rent;
    if (json['rentInformation'] != null) {
      rent = SpecificRent.fromJson(json['rentInformation']);
    }
    return Contract(
        idContract: json['idContract'],
        offer: json['offer'],
        Request: json['Request'],
        asset: json['asset'],
        state: json['state'],
        assetType: json['assetType'],
        quantityToDeliver: json['quantityToDeliver'],
        deliveredQuantity: json['deliveredQuantity'],
        consumedQuantity: json['consumedQuantity'],
        creationDate: json['creationDate'],
        offerer: json['offerer'],
        requester: json['requester'],
        price: json['price'],
        deposit: json['deposit'],
        cancellationFee: json['cancellationFee'],
        beginTimeSlot: json['beginTimeSlot'],
        endTimeSlot: json['endTimeSlot'],
        effectiveBeginTimeSlot: json['effective beginTimeSlot'],
        effectiveEndTimeSlot: json['effective endTimeSlot'],
        rentInformation: rent
    );
  }
}