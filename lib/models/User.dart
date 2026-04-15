class User {

   late String id;
   late String? password;
   late String username;
   late String firstName;
   late String lastName;
   late String role;
   late String email;
   late String provider;
   late String account;
   late String createdAt;
   late String updateAt;
   late String accessToken;
   late String phoneNumber;
   late String gps;

  User ({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.provider,
    required this.account,
    required this.createdAt,
    required this.updateAt,
    required this.accessToken,
    required this.password,
    required this.phoneNumber,
    required this.gps
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User (
      id: json['_id'],
      username: json['userName'],
      firstName: json['firstName'],
      lastName:  json['lastName'],
      role: json['roleOfUser'],
      email: json['email'],
      provider: json['provider'] ?? "",
      account: json['account'] ?? "",
      createdAt:  json['createdAt'],
      updateAt:  json['updatedAt'],
      accessToken: json['accessToken'],
      password: json['password'],
      phoneNumber: json['phoneNumber'] ?? "",
      gps: json['gps'] ?? ""
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userName': username,
    'firstName': firstName,
    'lastName': lastName,
    'roleOfUser': role,
    'email': email,
    'provider': provider,
    'account': account,
    'createdAt': createdAt,
    'updatedAt': updateAt,
    'accessToken': accessToken,
    'password': password,
    'phoneNumber': phoneNumber ?? "",
    'gps': gps
  };

}