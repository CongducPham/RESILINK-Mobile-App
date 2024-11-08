import 'RequestAssetType.dart';

class Request {

  late String requestor;
  late String beginTimeSlot;
  late String? endTimeSlot;
  late String validityLimit;
  late String transactionType;
  late List<int>? offerIds;
  late List<RequestAssetType>? assetTypes;

  Request({
    required this.requestor,
    required this.beginTimeSlot,
    required this.endTimeSlot,
    required this.validityLimit,
    required this.transactionType,
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
        requestor: json['requestor'],
        beginTimeSlot: json['beginTimeSlot'],
        endTimeSlot: json['endTimeSlot'],
        validityLimit: json['validityLimit'],
        transactionType: json['transactionType'],
        offerIds: json['offerIds'],
        assetTypes: assetTypes
    );
  }

}