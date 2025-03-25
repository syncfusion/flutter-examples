import 'package:flutter/material.dart';

class TextButtonValidNotifier extends ChangeNotifier {
  bool _isValid = false;
  bool get isValid => _isValid;

  void isTextButtonValid(bool isValidButton) {
    _isValid = isValidButton;
    notifyListeners();
  }

  void resetValidation() {
    _isValid = false;
  }
}
