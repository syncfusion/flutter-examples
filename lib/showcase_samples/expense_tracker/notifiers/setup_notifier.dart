import 'package:flutter/material.dart';

import '../base.dart';
import '../data_processing/windows_path_file.dart'
    if (dart.library.html) '../data_processing/web_path_file.dart';
import '../models/user.dart';

class SetupNotifier extends ChangeNotifier {
  UserDetails? _userDetails;
  UserDetails? get userDetails => _userDetails;

  Future<void> setUserDetails(BuildContext context) async {
    final UserDetails currentUserDetails = await readUserDetailsFromFile();
    _userDetails = currentUserDetails;
    notifyListeners();
  }

  bool enableNextButton(String firstName, String lastName, String currency) {
    return firstName.isNotEmpty && lastName.isNotEmpty && currency.isNotEmpty;
  }

  void validateNextButton() {
    notifyListeners();
  }
}

class VerifyUserNotifier extends ChangeNotifier {
  bool _isNewUser = true;
  bool get isNewUser => _isNewUser;

  void setNewUser() {
    _isNewUser = false;
  }

  Future<FirstTimeUserDetails> isFirstTimeUser() async {
    final FirstTimeUserDetails newUser = await isVerifyFirstTimeUser();
    _isNewUser = newUser.isFirstTimeUser;
    return newUser;
  }
}
