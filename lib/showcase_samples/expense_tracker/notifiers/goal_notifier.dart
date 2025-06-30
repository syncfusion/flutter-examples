import 'package:flutter/material.dart';

// import '../data_processing/goal_handler.dart'
// if (dart.library.html) '../data_processing/goal_web_handler.dart';
import '../models/goal.dart';
import '../models/user.dart';

class GoalNotifier extends ChangeNotifier {
  List<Goal> _goals = <Goal>[];
  List<Goal> get goals => _goals;
  set goals(List<Goal> value) {
    if (_goals != value) {
      _goals = value;
    }
  }

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  bool _isValid = false;
  bool get isValid => _isValid;

  int _currentIndex = -1;
  int get currentIndex => _currentIndex;

  List<Goal> visibleGoals = <Goal>[];

  GoalTextFieldDetails? _goalTextFieldDetails;
  GoalTextFieldDetails? get goalTextFieldDetails => _goalTextFieldDetails;
  set goalTextFieldDetails(GoalTextFieldDetails? value) {
    if (_goalTextFieldDetails != value) {
      _goalTextFieldDetails = value;
    }
  }

  List<Goal> read(UserDetails user) {
    // _goals = readGoals(user);
    // return _goals;
    return user.transactionalData.data.goals;
  }

  void createGoal(Goal goal) {
    _goals.insert(0, goal);
    _isFirstTime = false;
    notifyListeners();
  }

  void isTextButtonValid(bool isValidButton) {
    _isValid = isValidButton;
    notifyListeners();
  }

  void addFund(Goal currentGoal, double addedFund) {
    for (int index = 0; index < goals.length; index++) {
      if (currentGoal == goals[index]) {
        _currentIndex = index;
        goals[index].fund += addedFund;
        break;
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void editGoal(Goal currentGoal, Goal editedGoal, int selectedIndex) {
    if (currentGoal != editedGoal) {
      for (int index = 0; index < goals.length; index++) {
        if (currentGoal == goals[index]) {
          _currentIndex = index;
          _goals.replaceRange(index, index + 1, [editedGoal]);
          break;
        }
      }
      _isFirstTime = false;
      notifyListeners();
    }
  }

  void deleteGoal(Goal goal) {
    for (int index = 0; index < goals.length; index++) {
      if (goal == goals[index]) {
        _currentIndex = index;
        _goals.remove(goal);
        break;
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void reset() {
    _isFirstTime = true;
  }
}

class GoalTextFieldDetails {
  GoalTextFieldDetails({
    required this.name,
    required this.remarks,
    required this.category,
    required this.date,
    required this.amount,
    required this.priority,
  });

  String name;
  String remarks;
  String category;
  DateTime date;
  double amount;
  String priority;
}
