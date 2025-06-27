import 'package:flutter/material.dart';

enum MobileDialogs { savings, transactions, budgets, goals }

class MobileAppBarUpdate extends ChangeNotifier {
  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;

  MobileDialogs? _currentMobileDialog;
  MobileDialogs? get currentMobileDialog => _currentMobileDialog;

  set currentMobileDialog(MobileDialogs? mobileDialog) {
    if (mobileDialog != null) {
      _currentMobileDialog = mobileDialog;
    }
  }

  bool _isEditButton = false;
  bool get isEdit => _isEditButton;

  set isEdit(bool isEdit) {
    _isEditButton = false;
  }

  void openDialog({required bool isDialogOpen}) {
    _isDialogOpen = isDialogOpen;
    notifyListeners();
  }
}
