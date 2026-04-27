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

class Offer {

  late int? id;
  late String offerer;
  late int? assetId;
  late String transactionType;
  late String beginTimeSlot;
  late String? endTimeSlot;
  late String validityLimit;
  late String? publicationDate;
  late String? ownerPhoneNumber;
  late num? offeredQuantity;
  late num? remainingQuantity;
  late num price;
  late num deposit;
  late num cancellationFee;
  late String paymentMethod;
  late num paymentFrequency;
  late String? country;
  late String? serverUrl;
  late String? serverName;
  late bool acceptSharing;
  late SpecificRent? rentInformation;

  Offer({
    required this.id,
    required this.offerer,
    required this.assetId,
    required this.transactionType,
    required this.beginTimeSlot,
    required this.endTimeSlot,
    required this.validityLimit,
    required this.publicationDate,
    required this.ownerPhoneNumber,
    required this.offeredQuantity,
    required this.remainingQuantity,
    required this.price,
    required this.deposit,
    required this.cancellationFee,
    required this.paymentMethod,
    required this.paymentFrequency,
    required this.country,
    required this.serverUrl,
    required this.serverName,
    required this.acceptSharing,
    required this.rentInformation
  });

  factory Offer.fromJson(Map<String, dynamic> json, String? serverUrl, String? serverName) {
    SpecificRent? rent;
    if (json['rentInformation'] != null) {
      rent = SpecificRent.fromJson(json['rentInformation']);
    }
    return Offer(
      id: json['id'],
      offerer: json['offerer'],
      assetId: json['assetId'],
      transactionType: json['transactionType'],
      beginTimeSlot: json['beginTimeSlot'],
      endTimeSlot: json['endTimeSlot'],
      validityLimit: json['validityLimit'],
      publicationDate: json['publicationDate'],
      ownerPhoneNumber: json['phoneNumber'] ?? "",
      offeredQuantity: json['offeredQuantity'],
      remainingQuantity: json['remainingQuantity'],
      price: json['price'],
      deposit: json['deposit'],
      cancellationFee: json['cancellationFee'],
      paymentMethod: json['paymentMethod'],
      paymentFrequency: json['paymentFrequency'],
      country: json['country'] ?? "",
      serverUrl: serverUrl ?? "",
      serverName: serverName ?? "",
      acceptSharing: json['acceptSharing'],
      rentInformation: rent
    );
  }
}