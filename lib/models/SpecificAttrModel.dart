class SpecificAttrModel {

  late String name;
  late String type;
  late String mandatory;
  late String? valueList;

  SpecificAttrModel ({
    required this.name,
    required this.type,
    required this.mandatory,
    required this.valueList,
  });

  factory SpecificAttrModel.fromJson(Map<String, dynamic> json) {
    return SpecificAttrModel (
      name: json['name'],
      type: json['type'],
      mandatory: json['mandatory'],
      valueList: json['valueList'],
    );
  }
}