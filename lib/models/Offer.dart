import 'SpecificRent.dart';

class Offer {

  late int? offerId;
  late String offerer;
  late int? assetId;
  late String beginTimeSlot;
  late String? endTimeSlot;
  late String validityLimit;
  late String? publicationDate;
  late num? offeredQuantity;
  late num? remainingQuantity;
  late num price;
  late num deposit;
  late num cancellationFee;
  late SpecificRent? rentInformation;

  Offer({
    required this.offerId,
    required this.offerer,
    required this.assetId,
    required this.beginTimeSlot,
    required this.endTimeSlot,
    required this.validityLimit,
    required this.publicationDate,
    required this.offeredQuantity,
    required this.remainingQuantity,
    required this.price,
    required this.deposit,
    required this.cancellationFee,
    required this.rentInformation
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    SpecificRent? rent;
    if (json['rentInformation'] != null) {
      rent = SpecificRent.fromJson(json['rentInformation']);
    }
    return Offer(
      offerId: json['offerId'],
      offerer: json['offerer'],
      assetId: json['assetId'],
      beginTimeSlot: json['beginTimeSlot'],
      endTimeSlot: json['endTimeSlot'],
      validityLimit: json['validityLimit'],
      publicationDate: json['publicationDate'],
      offeredQuantity: json['offeredQuantity'],
      remainingQuantity: json['remainingQuantity'],
      price: json['price'],
      deposit: json['deposit'],
      cancellationFee: json['cancellationFee'],
      rentInformation: rent
    );
  }
}