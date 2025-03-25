import 'package:flutter/material.dart';
import '../enum.dart';

/// Notifier for handling page state changes.
class WelcomeScreenNotifier extends ChangeNotifier {
  WelcomeScreens currentPage = WelcomeScreens.setupPage;

  WelcomeScreens get _currentPage => currentPage;

  void switchPage(WelcomeScreens page) {
    if (_currentPage != page) {
      currentPage = page;
      notifyListeners();
    }
  }
}
