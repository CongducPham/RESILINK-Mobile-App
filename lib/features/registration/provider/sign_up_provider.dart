import 'dart:async';

import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  TextEditingController _firstname = TextEditingController(text: "");
  TextEditingController _lastname = TextEditingController(text: "");
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _job = TextEditingController(text: "");
  TextEditingController _phoneNumber = TextEditingController(text: "");
  bool _error = false;

  TextEditingController get username => _username;
  TextEditingController get password => _password;
  TextEditingController get firstname => _firstname;
  TextEditingController get lastname => _lastname;
  TextEditingController get email => _email;
  TextEditingController get job => _job;
  TextEditingController get phoneNumber => _phoneNumber;
  bool get error => _error;

  void setUsername(String newValue) {
    _username.text = newValue;
  }

  void setPassword(String newValue) {
    _password.text = newValue;
  }

  void checkValueValid (BuildContext context ) {
  }

  void setError(bool newValue) async {
    Timer(const Duration(seconds: 5), () {
      _error = newValue;
    });
  }
}