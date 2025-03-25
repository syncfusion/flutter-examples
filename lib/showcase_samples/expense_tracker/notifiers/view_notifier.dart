import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  Set<String> _selections = {'GridView'};
  Set<String> get selections => _selections;

  bool _isCompletedBudget = false;
  bool get isCompletedBudget => _isCompletedBudget;

  bool _isActiveGoal = false;
  bool get isActiveGoal => _isActiveGoal;

  void notifyBudgetVisibilityChange({bool isCompleted = false}) {
    _isCompletedBudget = isCompleted;
    notifyListeners();
  }

  void notifyActiveGoalsChange({bool isActive = false}) {
    _isActiveGoal = isActive;
    notifyListeners();
  }

  void updateSelectionView(Set<String> selectionView) {
    _selections = selectionView;
    notifyListeners();
  }
}
