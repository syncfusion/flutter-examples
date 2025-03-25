import 'package:flutter/material.dart';

import '../data_processing/budget_handler.dart';
import '../models/budget.dart';
import '../models/user.dart';

class BudgetNotifier extends ChangeNotifier {
  List<Budget> _budgets = <Budget>[];
  List<Budget> get budgets => _budgets;
  set budgets(List<Budget> value) {
    if (_budgets != value) {
      _budgets = value;
      // notifyListeners();
    }
  }

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  bool _isValid = false;
  bool get isValid => _isValid;

  int _currentIndex = -1;
  int get currentIndex => _currentIndex;

  List<Budget> visibleBudgets = <Budget>[];

  BudgetTextFieldDetails? _budgetTextFieldDetails;
  BudgetTextFieldDetails? get budgetTextFieldDetails => _budgetTextFieldDetails;
  set budgetTextFieldDetails(BudgetTextFieldDetails? value) {
    if (_budgetTextFieldDetails != value) {
      _budgetTextFieldDetails = value;
    }
  }

  List<Budget> read(UserDetails user) {
    _budgets = readBudgets(user);
    return _budgets;
  }

  void createBudget(Budget budget) {
    _budgets.add(budget);
    _isFirstTime = false;
    notifyListeners();
  }

  void isTextButtonValid(bool isValidButton) {
    _isValid = isValidButton;
    notifyListeners();
  }

  void addExpense(Budget currentBudget, double addedExpense) {
    for (int index = 0; index < budgets.length; index++) {
      if (currentBudget == budgets[index]) {
        _currentIndex = index;
        budgets[index].expense += addedExpense;
        break;
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void editBudget(
    Budget currentBudget,
    Budget editedBudget,
    int selectedIndex,
  ) {
    if (currentBudget != editedBudget) {
      for (int index = 0; index < budgets.length; index++) {
        if (currentBudget == budgets[index]) {
          _currentIndex = index;
          _budgets.replaceRange(index, index + 1, [editedBudget]);
          break;
        }
      }
      _isFirstTime = false;
      notifyListeners();
    }
  }

  void deleteBudget(Budget budget) {
    for (int index = 0; index < budgets.length; index++) {
      if (budget == budgets[index]) {
        _currentIndex = index;
        _budgets.remove(budget);
        break;
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }
}

class BudgetTextFieldDetails {
  BudgetTextFieldDetails({
    required this.name,
    required this.remarks,
    required this.date,
    required this.amount,
  });

  String name;
  String remarks;
  DateTime date;
  double amount;
}
