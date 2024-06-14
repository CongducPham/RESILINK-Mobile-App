
import 'SpecificAttrModel.dart';

class AssetType {

  late String name;
  late String? description;
  late String nature;
  late String? unit;
  late bool regulated;
  late String? regulator;
  late bool sharingIncentive;
  late List<SpecificAttrModel>? specificAttrModel;

  AssetType ({
    required this.name,
    required this.description,
    required this.nature,
    required this.unit,
    required this.regulated,
    required this.regulator,
    required this.sharingIncentive,
    required this.specificAttrModel,
  });

  factory AssetType.fromJson(Map<String, dynamic> json) {
    List<SpecificAttrModel>? spec = [];
    if (json['specificAttributesModel'] != null) {
      json['specificAttributesModel'].forEach((element) {
        spec.add(SpecificAttrModel.fromJson(element));
      });
    }
    return AssetType (
      name: json['name'],
      description: json['description'],
      nature: json['nature'],
      unit:  json['unit'],
      regulated: json['regulated'],
      regulator: json['regulator'],
      sharingIncentive: json['sharingIncentive'],
      specificAttrModel: spec,
    );
  }
  
}