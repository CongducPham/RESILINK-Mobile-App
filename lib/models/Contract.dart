import 'SpecificRent.dart';

class Contract {

  late int idContract;
  late String offer;
  late String Request;
  late String asset;
  late String state;
  late num? quantityToDeliver;
  late num? deliveredQuantity;
  late num? consumedQuantity;
  late String creationDate;
  late String transactionType;
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
    required this.quantityToDeliver,
    required this.deliveredQuantity,
    required this.consumedQuantity,
    required this.creationDate,
    required this.transactionType,
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
        quantityToDeliver: json['quantityToDeliver'],
        deliveredQuantity: json['deliveredQuantity'],
        consumedQuantity: json['consumedQuantity'],
        creationDate: json['creationDate'],
        transactionType: json['transactionType'],
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