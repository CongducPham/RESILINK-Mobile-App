import 'RequestSpecificAttr.dart';

class RequestAssetType {

  late String assetType;
  late num maximumPrice;
  late num maximumDeposit;
  late num? requestedQuantity;
  late List<RequestSpecificAttr> requestSpecificAttr;

  RequestAssetType({
    required this.assetType,
    required this.maximumPrice,
    required this.maximumDeposit,
    required this.requestedQuantity,
    required this.requestSpecificAttr
  });

  factory RequestAssetType.fromJson(Map<String, dynamic> json) {
    List<RequestSpecificAttr> requestSA = [];
    if (json['requestedSpecificAttributes'] != null){
      json['requestedSpecificAttributes'].forEach((content) => {
        requestSA.add(RequestSpecificAttr.fromJson(content))
      });
    }
    return RequestAssetType(
        assetType: json['assetType'],
        maximumPrice: json['maximumPrice'],
        maximumDeposit: json['maximumDeposit'],
        requestedQuantity: json['requestedQuantity'],
        requestSpecificAttr: requestSA
    );
  }

}