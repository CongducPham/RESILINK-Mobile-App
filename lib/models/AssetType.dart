
import 'SpecificAttrModel.dart';

class AssetType {

  late String name;
  late String? description;
  late String nature;
  late String? unit;
  late String? regulator;
  late bool subjectOfQuantity;
  late bool sharingIncentive;
  late List<SpecificAttrModel>? assetDataModel;

  AssetType ({
    required this.name,
    required this.description,
    required this.nature,
    required this.unit,
    required this.regulator,
    required this.subjectOfQuantity,
    required this.sharingIncentive,
    required this.assetDataModel,
  });

  factory AssetType.fromJson(Map<String, dynamic> json) {
    List<SpecificAttrModel>? spec = [];
    if (json['assetDataModel'] != null) {
      json['assetDataModel'].forEach((element) {
        spec.add(SpecificAttrModel.fromJson(element));
      });
    }
    return AssetType (
      name: json['name'],
      description: json['description'],
      nature: json['nature'],
      unit:  json['unit'],
      regulator: json['regulator'],
      subjectOfQuantity: json['subjectOfQuantity'],
      sharingIncentive: json['sharingIncentive'],
      assetDataModel: spec,
    );
  }
  
}