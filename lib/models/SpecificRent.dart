import 'dart:ffi';

class SpecificRent {

  late num delayMargin;
  late num lateRestitutionPenality;
  late num deteriorationPenality;
  late num nonRestitutionPenality;

  SpecificRent({
    required this.delayMargin,
    required this.lateRestitutionPenality,
    required this.deteriorationPenality,
    required this.nonRestitutionPenality
  });

  factory SpecificRent.fromJson(Map<String, dynamic> json) {
    return SpecificRent(
        delayMargin: json['delayMargin']!,
        lateRestitutionPenality: json['lateRestitutionPenalty']!,
        deteriorationPenality: json['deteriorationPenalty']!,
        nonRestitutionPenality: json['nonRestitutionPenalty']!
    );
  }
}