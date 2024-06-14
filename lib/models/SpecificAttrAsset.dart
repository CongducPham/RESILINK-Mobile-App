class SpecificAttrAsset {

  late String attributeName;
  late String value;

  SpecificAttrAsset({
    required this.attributeName,
    required this.value
  });

  factory SpecificAttrAsset.fromJson(Map<String, dynamic> json){
    return SpecificAttrAsset(
        attributeName: json['attributeName'],
        value: json['value']
    );
  }

}