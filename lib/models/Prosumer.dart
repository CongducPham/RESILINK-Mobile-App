class Prosumer {

  late String id;
  late num sharingAccount;
  late num balance;
  late String? activityDomain;
  late String? specificActivity;
  late String location;

  Prosumer({
    required this.id,
    required this.sharingAccount,
    required this.balance,
    required this.activityDomain,
    required this.specificActivity,
    required this.location
  });

  factory Prosumer.fromJson(Map<String, dynamic> json) {
    return Prosumer(
        id: json['id'],
        sharingAccount: json['sharingAccount'],
        balance: json['balance'],
        activityDomain: json['activityDomain'] ?? "",
        specificActivity: json['specificActivity'] ?? "",
        location: json['location'] ?? ""
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sharingAccount': sharingAccount,
    'balance': balance,
    'activityDomain': activityDomain,
    'specificActivity': specificActivity,
    'location': location,
  };

}