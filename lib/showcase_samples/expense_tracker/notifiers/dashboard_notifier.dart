import 'package:flutter/material.dart';

class DashboardNotifier extends ChangeNotifier {
  String _financialOverviewType = 'Income';
  String _timeFrame = 'This Year';

  String get financialOverviewType => _financialOverviewType;
  String get timeFrame => _timeFrame;

  void updateFinancialView(String value) {
    _financialOverviewType = value;
    notifyListeners();
  }

  void updateTimeFrame(String value) {
    if (_timeFrame != value) {
      _timeFrame = value;
      notifyListeners();
    }
  }
}
