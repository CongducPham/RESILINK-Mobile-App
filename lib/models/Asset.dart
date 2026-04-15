import 'SpecificAttrAsset.dart';

class Asset {

  late int id;
  late String name;
  late String description;
  late String assetType;
  late String owner;
  late double? totalQuantity;
  late String unit;
  late double remainingQuantity;
  late String? regulatedId;
  late bool multiAccess;
  late List? images;
  late List<SpecificAttrAsset>? specificAttributes;

  Asset ({
    required this.id,
    required this.name,
    required this.description,
    required this.assetType,
    required this.owner,
    required this.totalQuantity,
    required this.unit,
    required this.remainingQuantity,
    required this.regulatedId,
    required this.multiAccess,
    required this.images,
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
      unit: json['unit'] ?? "",
      totalQuantity: json['totalQuantity'].toDouble(),
      remainingQuantity: json['remainingQuantity'].toDouble(),
      regulatedId: json['regulatedId'],
      multiAccess: json['multiAccess'],
      images: json['images'] ?? [],
      specificAttributes: spec
    );
  }

}