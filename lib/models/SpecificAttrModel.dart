class SpecificAttrModel {

  late String name;
  late String type;
  late String mandatory;
  late String hasValueList;
  late String? valueList;

  SpecificAttrModel ({
    required this.name,
    required this.type,
    required this.mandatory,
    required this.hasValueList,
    required this.valueList,
  });

  factory SpecificAttrModel.fromJson(Map<String, dynamic> json) {
    return SpecificAttrModel (
      name: json['name'],
      type: json['type'],
      mandatory: json['mandatory'],
      hasValueList:  json['hasValueList'],
      valueList: json['valueList'],
    );
  }
}