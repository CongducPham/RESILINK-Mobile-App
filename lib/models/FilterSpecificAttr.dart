class FilterSpecificAttr {

  late String attributeName;
  late String value;
  late String comparisonType;

  FilterSpecificAttr({
    required this.attributeName,
    required this.value,
    required this.comparisonType
  });

  factory FilterSpecificAttr.fromJson(Map<String, dynamic> json) {
    return FilterSpecificAttr(
      attributeName: json['attributeName'],
      value: json['value'],
      comparisonType: json['comparisonType']
    );
  }

}