class User {

   late String id;
   late String? Password;
   late String Username;
   late String FirstName;
   late String LastName;
   late String Role;
   late String Email;
   late String Provider;
   late String Account;
   late String CreatedAt;
   late String UpdateAt;
   late String AccesToken;
   late String PhoneNumber;

  User ({
    required this.id,
    required this.Username,
    required this.FirstName,
    required this.LastName,
    required this.Role,
    required this.Email,
    required this.Provider,
    required this.Account,
    required this.CreatedAt,
    required this.UpdateAt,
    required this.AccesToken,
    required this.Password,
    required this.PhoneNumber
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User (
      id: json['_id'],
      Username: json['userName'],
      FirstName: json['firstName'],
      LastName:  json['lastName'],
      Role: json['roleOfUser'],
      Email: json['email'],
      Provider: json['provider'],
      Account: json['account'],
      CreatedAt:  json['createdAt'],
      UpdateAt:  json['updatedAt'],
      AccesToken: json['accessToken'],
      Password: json['passWord'],
      PhoneNumber: json['phoneNumber'] ?? "",
    );
  }

  Map<String, dynamic> ToJson() => {
    '_id': id,
    'userName': Username,
    'firstName': FirstName,
    'lastName': LastName,
    'roleOfUser': Role,
    'email': Email,
    'provider': Provider,
    'account': Account,
    'createdAt': CreatedAt,
    'updatedAt': UpdateAt,
    'accessToken': AccesToken,
    'passWord': Password,
    'phoneNumber': PhoneNumber ?? "",
  };

}