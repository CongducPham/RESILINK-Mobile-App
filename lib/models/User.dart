/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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