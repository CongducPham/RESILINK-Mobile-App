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