import 'SpecificAttrAsset.dart';

class Asset {

  late int id;
  late String name;
  late String description;
  late String assetType;
  late String owner;
  late String transactionType;
  late double? totalQuantity;
  late String unit;
  late double availableQuantity;
  late String? regulatedId;
  late String? regulator;
  late String? image;
  late List<SpecificAttrAsset>? specificAttributes;

  Asset ({
    required this.id,
    required this.name,
    required this.description,
    required this.assetType,
    required this.owner,
    required this.transactionType,
    required this.totalQuantity,
    required this.unit,
    required this.availableQuantity,
    required this.regulatedId,
    required this.regulator,
    required this.image,
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
      transactionType: json['transactionType'],
      unit: json['unit'] ?? "",
      totalQuantity: json['totalQuantity'].toDouble(),
      availableQuantity: json['availableQuantity'].toDouble(),
      regulatedId: json['regulatedId'],
      regulator: json['regulator'],
      image: json['image'],
      specificAttributes: spec
    );
  }

}