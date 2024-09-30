class RequestSpecificAttr {

  late String attributeName;
  late String value;
  late String comparisonType;

  RequestSpecificAttr({
    required this.attributeName,
    required this.value,
    required this.comparisonType
  });

  factory RequestSpecificAttr.fromJson(Map<String, dynamic> json) {
    return RequestSpecificAttr(
      attributeName: json['attributeName'],
      value: json['value'],
      comparisonType: json['comparisonType']
    );
  }

}