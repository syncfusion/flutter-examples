import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionNotifier extends ChangeNotifier {
  // Existing state
  int _cardCount = 0;
  int _dateRangeCount = 0;
  String? _selectedDate;
  String _selectedDuration = 'All';
  String? _selectedType;
  int _transactionCount = 0;
  String _selectedSegment = 'All';
  List<Transaction> _filteredTransactions = [];
  List<Transaction> _transactions = [];
  bool _isFirstTime = true;
  final List<int> _selectedIndexes = <int>[];
  bool _isValid = false;

  // Getters
  bool get isValid => _isValid;
  bool get isFirstTime => _isFirstTime;
  int get cardCount => _cardCount;
  int get dateRangeCount => _dateRangeCount;
  String? get selectedDate => _selectedDate;
  String get selectedDuration => _selectedDuration;
  String? get selectedType => _selectedType;
  int get transactionCount => _transactionCount;
  String get selectedSegment => _selectedSegment;
  List<Transaction> get filteredTransactions => _filteredTransactions;
  List<Transaction> get transactions => _transactions;
  List<int> get selectedIndexes => _selectedIndexes;

  TransactionTextFieldDetails? _transactionTextFieldDetails;
  TransactionTextFieldDetails? get transactionTextFieldDetails =>
      _transactionTextFieldDetails;
  set transactionTextFieldDetails(TransactionTextFieldDetails? value) {
    if (_transactionTextFieldDetails != value) {
      _transactionTextFieldDetails = value;
    }
  }

  void dateRangeCounting() {
    _dateRangeCount++;
    notifyListeners();
  }

  void updateTransactionCount() {
    _transactionCount++;
    notifyListeners();
  }

  void isTextButtonValid(
    String type,
    String category,
    String subcategory,
    String amount,
    String date,
  ) {
    _isValid =
        type.isNotEmpty &&
        category.isNotEmpty &&
        subcategory.isNotEmpty &&
        amount.isNotEmpty &&
        date.isNotEmpty;
    notifyListeners();
  }

  // Methods to update state
  void updateCardCount() {
    _cardCount++;
    notifyListeners();
  }

  void updateSelectedDate(String? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updateSelectedDuration(String duration) {
    _selectedDuration = duration;
    filterTransactionData(_selectedSegment);
    notifyListeners();
  }

  void updateSelectedType(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  void updateSelectedSegment(String segment) {
    _selectedSegment = segment;
    filterTransactionData(segment);
    notifyListeners();
  }

  void sorting() {
    _filteredTransactions.sort(
      (Transaction a, Transaction b) =>
          b.transactionDate.compareTo(a.transactionDate),
    );
  }

  void updateTransactions(List<Transaction> newTransactions) {
    _transactions = newTransactions;
    filterTransactionData(_selectedSegment);
    _isFirstTime = false;
    notifyListeners();
  }

  void deleteTransactions(List<int> selectedIndexes) {
    _selectedIndexes.clear();
    if (_filteredTransactions.isNotEmpty) {
      final List<Transaction> deletingTransactions = [];
      filterTransactionData(_selectedSegment);
      for (final int selectedIndex in selectedIndexes) {
        deletingTransactions.add(_filteredTransactions[selectedIndex]);
      }
      for (final Transaction transaction in deletingTransactions) {
        _selectedIndexes.add(_transactions.indexOf(transaction));
      }
      for (final Transaction transaction in deletingTransactions) {
        _selectedIndexes.add(_transactions.indexOf(transaction));
        _transactions.remove(transaction);
        _filteredTransactions.remove(transaction);
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void reset() {
    _isFirstTime = true;
  }

  void editTransaction(int selectedIndex, Transaction editedTransaction) {
    if (_filteredTransactions.isNotEmpty) {
      _selectedIndexes.clear();
      filterTransactionData(_selectedSegment);
      if (_transactions.isNotEmpty) {
        int count = 0;
        for (final Transaction transaction in _transactions) {
          if (_filteredTransactions[selectedIndex] == transaction) {
            _transactions.replaceRange(count, count + 1, [editedTransaction]);
            _selectedIndexes.add(count);
            break;
          }
          count++;
        }
      }
      _filteredTransactions.replaceRange(selectedIndex, selectedIndex + 1, [
        editedTransaction,
      ]);
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void filterTransactionData([String? selectedSegment]) {
    _filteredTransactions = [];

    List<Transaction> segmentFilteredTransactions = [];
    if (selectedSegment == 'All') {
      segmentFilteredTransactions = _transactions;
    } else if (selectedSegment == 'Income') {
      segmentFilteredTransactions = _transactions.where((transaction) {
        return transaction.type == 'Income';
      }).toList();
    } else if (selectedSegment == 'Expense') {
      segmentFilteredTransactions = _transactions.where((transaction) {
        return transaction.type == 'Expense';
      }).toList();
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
      case 'All':
        filterStartDate = DateTime(1900);
        filterEndDate = now;
        break;
      default:
        filterStartDate = DateTime(now.year, now.month, now.day);
        filterEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }

    _filteredTransactions.addAll(
      segmentFilteredTransactions.where((transaction) {
        final DateTime transactionDate = transaction.transactionDate;
        return transactionDate.isAfter(filterStartDate) &&
            transactionDate.isBefore(filterEndDate);
      }),
    );
    sorting();
  }
}

class TransactionDialog extends ChangeNotifier {
  void showTransactionDialog(BuildContext context) {
    notifyListeners();
  }
}

class TransactionSelectedCountNotifier extends ChangeNotifier {
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

class TransactionTextFieldDetails {
  TransactionTextFieldDetails({
    required this.type,
    required this.remarks,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.amount,
  });
  String type;
  String remarks;
  String category;
  String subCategory;
  DateTime date;
  double amount;
}
