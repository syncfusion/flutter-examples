import 'package:flutter/material.dart';

class RestartAppNotifier extends ChangeNotifier {
  bool _isRestart = false;
  bool get isRestarted => _isRestart;

  void isRestartedAPP() {
    _isRestart = true;
    notifyListeners();
  }

  void endRestart() {
    _isRestart = false;
    notifyListeners();
  }
}
