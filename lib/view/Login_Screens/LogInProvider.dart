import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController _loginemailcontroller = TextEditingController();
  final TextEditingController _loginpasswordcontroller =
      TextEditingController();

  TextEditingController get loginemailcontroller => _loginemailcontroller;
  TextEditingController get loginpasswordcontroller => _loginpasswordcontroller;
}
