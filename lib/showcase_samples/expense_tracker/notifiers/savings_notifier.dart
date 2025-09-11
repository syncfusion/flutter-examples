import 'package:flutter/material.dart';

import '../models/saving.dart';

class SavingsNotifier extends ChangeNotifier {
  // Existing state
  int _cardCount = 0;
  String? _selectedDate;
  String _selectedDuration = 'All';
  String? selectedType;
  int _savingsCount = 0;
  String _selectedSegment = 'All';
  List<Saving> _filteredSavings = [];
  List<Saving> _savings = [];
  final List<int> _selectedIndexes = <int>[];
  bool _isFirstTime = true;
  bool _isValid = false;

  // Getters
  bool get isValid => _isValid;
  bool get isFirstTime => _isFirstTime;
  int get cardCount => _cardCount;
  String? get selectedDate => _selectedDate;
  String get selectedDuration => _selectedDuration;
  int get savingsCount => _savingsCount;
  String get selectedSegment => _selectedSegment;
  List<Saving> get filteredSavings => _filteredSavings;
  List<Saving> get savings => _savings;
  List<int> get selectedIndexes => _selectedIndexes;

  SavingsTextFieldDetails? _savingsTextFieldDetails;
  SavingsTextFieldDetails? get savingsTextFieldDetails =>
      _savingsTextFieldDetails;
  set savingsTextFieldDetails(SavingsTextFieldDetails? value) {
    if (_savingsTextFieldDetails != value) {
      _savingsTextFieldDetails = value;
    }
  }

  void updateCardCount() {
    _cardCount++;
    notifyListeners();
  }

  void updateSelectedDate(String? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void isTextButtonValid(String name, String type, String amount, String date) {
    _isValid =
        name.isNotEmpty &&
        type.isNotEmpty &&
        amount.isNotEmpty &&
        date.isNotEmpty;
    notifyListeners();
  }

  void updateSelectedDuration(String duration) {
    _selectedDuration = duration;
    filterSavingsData(_selectedSegment);
    notifyListeners();
  }

  void updateSelectedSegment(String segment) {
    _selectedSegment = segment;
    filterSavingsData(segment);
    notifyListeners();
  }

  void sorting() {
    _filteredSavings.sort(
      (Saving a, Saving b) => b.savingDate.compareTo(a.savingDate),
    );
  }

  void updateSavings(List<Saving> newSavings) {
    _savings = newSavings;
    filterSavingsData(_selectedSegment);
    _isFirstTime = false;
    notifyListeners();
  }

  void deleteSavings(List<int> selectedIndexes) {
    _selectedIndexes.clear();
    if (_filteredSavings.isNotEmpty) {
      final List<Saving> deletingSavings = [];
      filterSavingsData(_selectedSegment);
      for (final int selectedIndex in selectedIndexes) {
        deletingSavings.add(_filteredSavings[selectedIndex]);
      }
      for (final Saving saving in deletingSavings) {
        _selectedIndexes.add(_savings.indexOf(saving));
      }
      for (final Saving saving in deletingSavings) {
        _savings.remove(saving);
        _filteredSavings.remove(saving);
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void editSavings(int selectedIndex, Saving editedSaving) {
    _selectedIndexes.clear();
    if (_filteredSavings.isNotEmpty) {
      filterSavingsData(_selectedSegment);
      if (_savings.isNotEmpty) {
        int count = 0;
        for (final Saving saving in _savings) {
          if (_filteredSavings[selectedIndex] == saving) {
            _savings.replaceRange(count, count + 1, [editedSaving]);
            _selectedIndexes.add(count);
            break;
          }
          count++;
        }
      }
      _filteredSavings.replaceRange(selectedIndex, selectedIndex + 1, [
        editedSaving,
      ]);
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void reset() {
    _isFirstTime = true;
  }

  void filterSavingsData([String? selectedSegment]) {
    List<Saving> segmentFilteredSavings = [];
    if (selectedSegment == 'All') {
      segmentFilteredSavings = _savings;
    } else if (selectedSegment == 'Deposit') {
      segmentFilteredSavings = _savings
          .where((saving) => saving.type == 'Deposit')
          .toList();
    } else if (selectedSegment == 'Withdraw') {
      segmentFilteredSavings = _savings
          .where((saving) => saving.type == 'Withdraw')
          .toList();
    }

    final DateTime now = DateTime.now();
    DateTime filterStartDate;
    DateTime filterEndDate;

    switch (_selectedDuration) {
      case 'Today':
        filterStartDate = DateTime(now.year, now.month, now.day);
        filterEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'Yesterday':
        filterStartDate = DateTime(now.year, now.month, now.day - 1);
        filterEndDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case 'This Week':
        final int daysSinceMonday = now.weekday - DateTime.monday;
        filterStartDate = DateTime(
          now.year,
          now.month,
          now.day - daysSinceMonday,
        );
        filterEndDate = filterStartDate.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        break;
      case 'This Month':
        filterStartDate = DateTime(now.year, now.month);
        filterEndDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'This Year':
        filterStartDate = DateTime(now.year);
        filterEndDate = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      default:
        filterStartDate = DateTime(1900);
        filterEndDate = now;
    }

    _filteredSavings = segmentFilteredSavings.where((saving) {
      final DateTime transactionDate = saving.savingDate;
      return transactionDate.isAfter(filterStartDate) &&
          transactionDate.isBefore(filterEndDate);
    }).toList();
    sorting();
    _savingsCount++;
  }
}

class SavingsSelectedCountNotifier extends ChangeNotifier {
  int _selectedCount = 0;
  int get selectedCount => _selectedCount;

  void countChecking(int count) {
    _selectedCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void reset() {
    _selectedCount = 0;
  }
}

class SavingsTextFieldDetails {
  SavingsTextFieldDetails({
    required this.name,
    required this.remarks,
    required this.type,
    required this.date,
    required this.amount,
  });
  String name;
  String remarks;
  String type;
  DateTime date;
  double amount;
}
