import 'package:flutter/material.dart';

class PasswordMngrProvider with ChangeNotifier {
  final TextEditingController _passAccountController = TextEditingController();
  final TextEditingController _passemailController = TextEditingController();
  final TextEditingController _passpswrdController = TextEditingController();

  TextEditingController get passAccountController => _passAccountController;
  TextEditingController get passemailController => _passemailController;
  TextEditingController get passpswrdController => _passpswrdController;
}
