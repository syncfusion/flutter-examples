import 'package:flutter/material.dart';

import '../data_processing/goal_handler.dart'
    if (dart.library.html) '../data_processing/goal_web_handler.dart';
import '../data_processing/saving_handler.dart'
    if (dart.library.html) '../data_processing/saving_web_handler.dart';
import '../data_processing/transaction_handler.dart';
import '../helper/common_helper.dart';
import '../layouts/dashboard/dashboard_layout.dart';
import '../layouts/dashboard/dashboard_sections/common_finance_widget.dart';
import '../models/goal.dart';
import '../models/saving.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage(this.userDetails, {super.key});

  final UserDetails userDetails;
  @override
  State<StatefulWidget> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final List<ExpenseDetails> _expenseDetails = <ExpenseDetails>[];
  final List<IncomeDetails> _incomeDetails = <IncomeDetails>[];

  final Map<String, List<ExpenseDetails>> _expenseCategories =
      <String, List<ExpenseDetails>>{};
  final Map<String, List<IncomeDetails>> _incomeCategories =
      <String, List<IncomeDetails>>{};
  final Map<String, ExpenseDetails> _expenseCategoriesMap =
      <String, ExpenseDetails>{};
  final Map<String, IncomeDetails> _incomeCategoriesMap =
      <String, IncomeDetails>{};

  final TimeFrameNotifier accountTimeFrameNotifier = TimeFrameNotifier(
    'This Year',
  );
  // For savings chart
  final TimeFrameNotifier savingsTimeFrameNotifier = TimeFrameNotifier(
    'Last 6 Month',
  );

  double _totalExpense = 0;
  double _totalIncome = 0;
  double _totalSavings = 0;
  List<Color>? _cardAvatarColors;
  List<MapEntry<String, ExpenseDetails>> _topExpenseCategories =
      <MapEntry<String, ExpenseDetails>>[];
  List<MapEntry<String, IncomeDetails>> _topIncomeCategories =
      <MapEntry<String, IncomeDetails>>[];

  late UserDetails _userDetails;
  late List<Transaction> _transactions;
  late List<Goal> _goals;
  late List<Saving> _savings;
  late TextEditingController _accountBalanceDropDownController;

  @override
  void initState() {
    updateUserAndTransactionalDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    if (oldWidget.userDetails != widget.userDetails) {
      updateUserAndTransactionalDetails();
    }
    super.didUpdateWidget(oldWidget);
  }

  void resetValues() {
    _incomeDetails.clear();
    _expenseDetails.clear();
    _totalIncome = 0;
    _totalExpense = 0;
    _totalSavings = 0;
  }

  void updateUserAndTransactionalDetails() {
    resetValues();
    _userDetails = widget.userDetails;
    _accountBalanceDropDownController = TextEditingController();

    _transactions = readTransactions(_userDetails);
    for (final Transaction transaction in _transactions) {
      if (transaction.type == 'Expense') {
        _totalExpense += transaction.amount.toInt();
      } else if (transaction.type == 'Income') {
        _totalIncome += transaction.amount.toInt();
      }
    }
    for (final Transaction transaction in _transactions) {
      if (transaction.type == 'Income') {
        _incomeDetails.add(
          IncomeDetails(
            category: transaction.category,
            date: transaction.transactionDate,
            amount: transaction.amount,
          ),
        );
      } else if (transaction.type == 'Expense') {
        _expenseDetails.add(
          ExpenseDetails(
            category: transaction.category,
            date: transaction.transactionDate,
            amount: transaction.amount,
            budgetAmount: 0,
          ),
        );
      }
    }
    if (_expenseDetails.isNotEmpty) {
      for (final ExpenseDetails expenseDetails in _expenseDetails) {
        if (_expenseCategoriesMap.containsKey(expenseDetails.category) &&
            _expenseCategoriesMap[expenseDetails.category] != null) {
          _expenseCategoriesMap[expenseDetails.category]!.amount +=
              expenseDetails.amount;
        } else {
          _expenseCategoriesMap[expenseDetails.category] = ExpenseDetails(
            category: expenseDetails.category,
            date: expenseDetails.date,
            amount: expenseDetails.amount,
            budgetAmount: 0,
          );
        }
      }
      final List<MapEntry<String, ExpenseDetails>> sortedExpenseCategories =
          _expenseCategoriesMap.entries.toList()..sort((
            MapEntry<String, ExpenseDetails> previousAmount,
            MapEntry<String, ExpenseDetails> currentAmount,
          ) {
            return currentAmount.value.amount.compareTo(
              previousAmount.value.amount,
            );
          });
      _topExpenseCategories = sortedExpenseCategories.take(5).toList();
      for (int index = 0; index < _topExpenseCategories.length; index++) {
        if (!_expenseCategories.containsKey(_topExpenseCategories[index].key)) {
          _expenseCategories[_topExpenseCategories[index].key] =
              <ExpenseDetails>[_topExpenseCategories[index].value];
        }
      }
    }
    if (_incomeDetails.isNotEmpty) {
      for (final IncomeDetails incomeDetails in _incomeDetails) {
        if (_incomeCategoriesMap.containsKey(incomeDetails.category) &&
            _incomeCategoriesMap[incomeDetails.category] != null) {
          _incomeCategoriesMap[incomeDetails.category]!.amount +=
              incomeDetails.amount;
        } else {
          _incomeCategoriesMap[incomeDetails.category] = IncomeDetails(
            category: incomeDetails.category,
            date: incomeDetails.date,
            amount: incomeDetails.amount,
          );
        }
      }
    }
    final List<MapEntry<String, IncomeDetails>> sortedIncomeCategories =
        _incomeCategoriesMap.entries.toList()..sort((
          MapEntry<String, IncomeDetails> previousAmount,
          MapEntry<String, IncomeDetails> currentAmount,
        ) {
          return currentAmount.value.amount.compareTo(
            previousAmount.value.amount,
          );
        });
    _topIncomeCategories = sortedIncomeCategories.take(5).toList();
    for (int index = 0; index < _topIncomeCategories.length; index++) {
      if (!_incomeCategories.containsKey(_topIncomeCategories[index].key)) {
        _incomeCategories[_topIncomeCategories[index].key] = <IncomeDetails>[
          _topIncomeCategories[index].value,
        ];
      }
    }

    _goals = readGoals(_userDetails);
    _savings = readSavings(_userDetails);
    for (final Saving saving in _savings) {
      if (saving.type == 'Deposit') {
        _totalSavings += saving.savedAmount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _cardAvatarColors ??= randomColors(context);
    return DashboardLayout(
      buildContext: context,
      userDetails: _userDetails,
      incomeDetails: _incomeDetails,
      expenseDetails: _expenseDetails,
      transactions: _transactions,
      goals: _goals,
      savings: _savings,
      cardAvatarColors: _cardAvatarColors,
      accountBalanceController: _accountBalanceDropDownController,
      filteredTimeFrame: accountTimeFrameNotifier,
      filteredSavingTimeFrame: savingsTimeFrameNotifier,
      title: 'Total Income',
      totalExpense: _totalExpense,
      totalIncome: _totalIncome,
      totalSavings: _totalSavings,
      expenseCategories: _expenseCategories,
      incomeCategories: _incomeCategories,
    );
  }
}

class IncomeDetails {
  IncomeDetails({
    required this.category,
    required this.date,
    required this.amount,
  });

  final String category;
  final DateTime date;
  double amount;
}

class ExpenseDetails {
  ExpenseDetails({
    required this.category,
    required this.date,
    required this.amount,
    required this.budgetAmount,
  });

  final String category;
  final DateTime date;
  double amount;
  double budgetAmount;
}
