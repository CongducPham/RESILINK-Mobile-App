class Prosumer {

  late String id;
  late num sharingAccount;
  late num balance;
  late String job;
  late String location;

  Prosumer({
    required this.id,
    required this.sharingAccount,
    required this.balance,
    required this.job,
    required this.location
  });

  factory Prosumer.fromJson(Map<String, dynamic> json) {
    return Prosumer(
        id: json['id'],
        sharingAccount: json['sharingAccount'],
        balance: json['balance'],
        job: json['job'] ?? "",
        location: json['location'] ?? ""
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sharingAccount': sharingAccount,
    'balance': balance,
    'job': job,
    'location': location,
  };

}