import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  final TextEditingController _signupuserController = TextEditingController();
  final TextEditingController _signupemailController = TextEditingController();
  final TextEditingController _signuppasswordController =
      TextEditingController();
  TextEditingController get signupuserController => _signupuserController;
  TextEditingController get signupemailController => _signupemailController;
  TextEditingController get signuppasswordController =>
      _signuppasswordController;
}
