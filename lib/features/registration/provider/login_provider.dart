import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  bool _error = false;

  TextEditingController get username => _username;
  TextEditingController get password => _password;
  bool get error => _error;

  void setUsername(String newValue) {
    _username.text = newValue;
  }

  void setPassword(String newValue) {
    _password.text = newValue;
  }

  void checkValueValid (BuildContext context ) {

  }
}