import 'package:flutter/material.dart';

import '../data_processing/windows_path_file.dart'
    if (dart.library.html) '../data_processing/web_path_file.dart';
import '../models/budget.dart';
import '../models/goal.dart';
import '../models/saving.dart';
import '../models/transaction.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';

class ImportNotifier extends ChangeNotifier {
  final List<Saving> _predefinedSavings = [
    // Existing data modified for the last six months
    Saving(
      name: 'Groceries Budget',
      savedAmount: 400.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2023-09-05T00:00:00.000Z'),
      remark: 'Essentials',
    ),
    Saving(
      name: 'Emergency Fund',
      savedAmount: 1200.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2023-10-10T00:00:00.000Z'),
      remark: 'Needs',
    ),
    Saving(
      name: 'Car Maintenance',
      savedAmount: 600.5,
      type: 'Withdraw',
      savingDate: DateTime.parse('2023-11-15T00:00:00.000Z'),
      remark: 'Repair',
    ),
    Saving(
      name: 'New Phone',
      savedAmount: 950.75,
      type: 'Withdraw',
      savingDate: DateTime.parse('2023-12-01T00:00:00.000Z'),
      remark: 'Gadget',
    ),
    Saving(
      name: 'Investment',
      savedAmount: 2500.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-01-20T00:00:00.000Z'),
      remark: 'Wealth',
    ),
    Saving(
      name: 'Health Insurance',
      savedAmount: 850.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-02-05T00:00:00.000Z'),
      remark: 'Medical',
    ),
    Saving(
      name: 'Emergency Fund',
      savedAmount: 1800.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-03-12T00:00:00.000Z'),
      remark: 'Needs',
    ),
    Saving(
      name: 'Travel Fund',
      savedAmount: 3000.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-04-07T00:00:00.000Z'),
      remark: 'Vacation',
    ),
    Saving(
      name: 'Laptop Upgrade',
      savedAmount: 1400.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2024-05-15T00:00:00.000Z'),
      remark: 'Work',
    ),
    Saving(
      name: 'Car Upgrade',
      savedAmount: 3200.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2024-06-20T00:00:00.000Z'),
      remark: 'Luxury',
    ),
    // Additional new data to reach 20 entries
    Saving(
      name: 'House Renovation',
      savedAmount: 5000.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-07-25T00:00:00.000Z'),
      remark: 'Home',
    ),
    Saving(
      name: 'Vacation Trip',
      savedAmount: 3200.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-08-05T00:00:00.000Z'),
      remark: 'Leisure',
    ),
    Saving(
      name: 'Gym Membership',
      savedAmount: 600.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2024-09-10T00:00:00.000Z'),
      remark: 'Fitness',
    ),
    Saving(
      name: 'Tech Gadget',
      savedAmount: 800.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2024-10-15T00:00:00.000Z'),
      remark: 'Entertainment',
    ),
    Saving(
      name: 'Medical Bills',
      savedAmount: 1300.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2024-11-10T00:00:00.000Z'),
      remark: 'Health',
    ),
    Saving(
      name: 'Furniture Upgrade',
      savedAmount: 1700.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2024-12-20T00:00:00.000Z'),
      remark: 'Home',
    ),
    Saving(
      name: 'Stock Investment',
      savedAmount: 4500.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2025-01-15T00:00:00.000Z'),
      remark: 'Finance',
    ),
    Saving(
      name: 'Pet Care',
      savedAmount: 750.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2025-02-05T00:00:00.000Z'),
      remark: 'Pets',
    ),
    Saving(
      name: 'Charity Donation',
      savedAmount: 1100.0,
      type: 'Deposit',
      savingDate: DateTime.parse('2025-03-10T00:00:00.000Z'),
      remark: 'Giving',
    ),
    Saving(
      name: 'Music Equipment',
      savedAmount: 1250.0,
      type: 'Withdraw',
      savingDate: DateTime.parse('2025-03-25T00:00:00.000Z'),
      remark: 'Hobby',
    ),
  ];

  final List<Transaction> _predefinedTransactions = [
    // Income Transactions
    Transaction(
      category: 'Freelance',
      transactionDate: DateTime.parse('2024-06-10T00:00:00.000Z'),
      subCategory: 'Web development',
      type: 'Income',
      remark: 'Client website project',
      amount: 1500.0,
    ),
    Transaction(
      category: 'Salary',
      transactionDate: DateTime.parse('2024-07-01T00:00:00.000Z'),
      subCategory: 'Monthly salary',
      type: 'Income',
      remark: 'Monthly paycheck',
      amount: 3000.0,
    ),
    Transaction(
      category: 'Investments',
      transactionDate: DateTime.parse('2024-08-15T00:00:00.000Z'),
      subCategory: 'Stock dividends',
      type: 'Income',
      remark: 'Quarterly dividends',
      amount: 800.0,
    ),
    Transaction(
      category: 'Business',
      transactionDate: DateTime.parse('2024-09-05T00:00:00.000Z'),
      subCategory: 'Product sales',
      type: 'Income',
      remark: 'Online store sales',
      amount: 2500.0,
    ),
    Transaction(
      category: 'Freelance',
      transactionDate: DateTime.parse('2024-10-20T00:00:00.000Z'),
      subCategory: 'Graphic design',
      type: 'Income',
      remark: 'Logo design project',
      amount: 600.0,
    ),
    Transaction(
      category: 'Real Estate',
      transactionDate: DateTime.parse('2024-11-10T00:00:00.000Z'),
      subCategory: 'Rental income',
      type: 'Income',
      remark: 'Monthly rent payment',
      amount: 1200.0,
    ),
    Transaction(
      category: 'Bonus',
      transactionDate: DateTime.parse('2024-12-01T00:00:00.000Z'),
      subCategory: 'Performance bonus',
      type: 'Income',
      remark: 'Annual performance bonus',
      amount: 1000.0,
    ),
    Transaction(
      category: 'Gift',
      transactionDate: DateTime.parse('2025-01-25T00:00:00.000Z'),
      subCategory: 'Birthday gift',
      type: 'Income',
      remark: 'Gift from relatives',
      amount: 300.0,
    ),
    Transaction(
      category: 'Side Hustle',
      transactionDate: DateTime.parse('2025-02-10T00:00:00.000Z'),
      subCategory: 'Handmade crafts',
      type: 'Income',
      remark: 'Etsy shop earnings',
      amount: 700.0,
    ),
    Transaction(
      category: 'Investments',
      transactionDate: DateTime.parse('2025-03-01T00:00:00.000Z'),
      subCategory: 'Crypto gains',
      type: 'Income',
      remark: 'Profits from trading',
      amount: 900.0,
    ),

    // Expense Transactions
    Transaction(
      category: 'Groceries',
      transactionDate: DateTime.parse('2024-06-05T00:00:00.000Z'),
      subCategory: 'Weekly shopping',
      type: 'Expense',
      remark: 'Grocery store run',
      amount: 200.0,
    ),
    Transaction(
      category: 'Dining Out',
      transactionDate: DateTime.parse('2024-07-14T00:00:00.000Z'),
      subCategory: 'Anniversary dinner',
      type: 'Expense',
      remark: 'Dinner at a restaurant',
      amount: 150.0,
    ),
    Transaction(
      category: 'Transportation',
      transactionDate: DateTime.parse('2024-08-10T00:00:00.000Z'),
      subCategory: 'Gas refill',
      type: 'Expense',
      remark: 'Fuel for the car',
      amount: 80.0,
    ),
    Transaction(
      category: 'Utilities',
      transactionDate: DateTime.parse('2024-09-15T00:00:00.000Z'),
      subCategory: 'Water bill',
      type: 'Expense',
      remark: 'Monthly water bill',
      amount: 50.0,
    ),
    Transaction(
      category: 'Entertainment',
      transactionDate: DateTime.parse('2024-10-20T00:00:00.000Z'),
      subCategory: 'Movie night',
      type: 'Expense',
      remark: 'Cinema tickets',
      amount: 60.0,
    ),
    Transaction(
      category: 'Healthcare',
      transactionDate: DateTime.parse('2024-11-05T00:00:00.000Z'),
      subCategory: 'Doctor visit',
      type: 'Expense',
      remark: 'Routine check-up',
      amount: 120.0,
    ),
    Transaction(
      category: 'Shopping',
      transactionDate: DateTime.parse('2024-12-25T00:00:00.000Z'),
      subCategory: 'Clothing',
      type: 'Expense',
      remark: 'New winter outfits',
      amount: 250.0,
    ),
    Transaction(
      category: 'Home Maintenance',
      transactionDate: DateTime.parse('2025-01-30T00:00:00.000Z'),
      subCategory: 'Plumbing repair',
      type: 'Expense',
      remark: 'Fixing bathroom sink',
      amount: 300.0,
    ),
    Transaction(
      category: 'Education',
      transactionDate: DateTime.parse('2025-02-15T00:00:00.000Z'),
      subCategory: 'Online course',
      type: 'Expense',
      remark: 'Subscription to an online course',
      amount: 200.0,
    ),
    Transaction(
      category: 'Gifts',
      transactionDate: DateTime.parse('2025-03-01T00:00:00.000Z'),
      subCategory: 'Wedding gift',
      type: 'Expense',
      remark: 'Present for a friend’s wedding',
      amount: 150.0,
    ),
  ];

  final List<Budget> _predefinedBudgets = [
    Budget(
      name: 'Birthday expense',
      target: 30000.0,
      createdDate: DateTime.parse('2024-12-20T00:00:00.000Z'),
      expense: 2000.0,
      notes: 'My birthday',
    ),
    Budget(
      name: 'Vacation to Hawaii',
      target: 15000.0,
      createdDate: DateTime.parse('2024-08-15T00:00:00.000Z'),
      expense: 0.0,
      notes: 'Family trip',
    ),
    Budget(
      name: 'Wedding Anniversary',
      target: 20000.0,
      createdDate: DateTime.parse('2025-01-09T00:00:00.000Z'),
      expense: 2000.0,
      notes: 'Anniversary event',
    ),
    Budget(
      name: 'Car Maintenance',
      target: 5000.0,
      createdDate: DateTime.parse('2024-11-10T00:00:00.000Z'),
      expense: 0.0,
      notes: 'Annual service',
    ),
    Budget(
      name: 'Home Renovation',
      target: 50000.0,
      createdDate: DateTime.parse('2024-10-01T00:00:00.000Z'),
      expense: 10000.0,
      notes: 'Kitchen and living room remodeling',
    ),
    Budget(
      name: 'Christmas Shopping',
      target: 10000.0,
      createdDate: DateTime.parse('2024-12-10T00:00:00.000Z'),
      expense: 500.0,
      notes: 'Gifts for family and friends',
    ),
    Budget(
      name: 'New Year Celebration',
      target: 7000.0,
      createdDate: DateTime.parse('2024-12-31T00:00:00.000Z'),
      expense: 2000.0,
      notes: 'Party and fireworks',
    ),
    Budget(
      name: 'Medical Emergency Fund',
      target: 20000.0,
      createdDate: DateTime.parse('2025-02-15T00:00:00.000Z'),
      expense: 0.0,
      notes: 'Emergency medical expenses',
    ),
    Budget(
      name: 'Back to School',
      target: 8000.0,
      createdDate: DateTime.parse('2025-01-01T00:00:00.000Z'),
      expense: 1000.0,
      notes: 'School supplies and tuition fees',
    ),
    Budget(
      name: 'Gym Membership',
      target: 3000.0,
      createdDate: DateTime.parse('2025-02-01T00:00:00.000Z'),
      expense: 0.0,
      notes: 'Annual gym subscription',
    ),
  ];

  final List<Goal> _predefinedGoals = [
    Goal(
      name: 'Entertainment',
      targetDate: DateTime.parse('2025-07-20T00:00:00.000Z'),
      targetAmount: 45000.0,
      priority: 'Low',
      savedAmount: 5000.0,
      notes: 'Live entertainment',
    ),
    Goal(
      name: 'Save for Vacation',
      targetDate: DateTime.parse('2025-12-15T00:00:00.000Z'),
      targetAmount: 60000.0,
      priority: 'High',
      notes: 'Family trip',
    ),
    Goal(
      name: 'Home Renovation',
      targetDate: DateTime.parse('2026-04-30T00:00:00.000Z'),
      targetAmount: 200000.0,
      priority: 'High',
      savedAmount: 16000.0,
      notes: 'Kitchen remodel',
    ),
    Goal(
      name: 'Buy New Car',
      targetDate: DateTime.parse('2026-01-01T00:00:00.000Z'),
      targetAmount: 120000.0,
      priority: 'High',
      savedAmount: 5000.0,
      notes: 'Electric vehicle',
    ),
    Goal(
      name: 'Emergency Fund',
      targetDate: DateTime.parse('2025-06-30T00:00:00.000Z'),
      targetAmount: 50000.0,
      priority: 'Medium',
      savedAmount: 10000.0,
      notes: 'Unexpected expenses',
    ),
    Goal(
      name: 'Tech Upgrade',
      targetDate: DateTime.parse('2025-09-15T00:00:00.000Z'),
      targetAmount: 20000.0,
      priority: 'Low',
      savedAmount: 5000.0,
      notes: 'New laptop and smartphone',
    ),
    Goal(
      name: 'Wedding Gift Savings',
      targetDate: DateTime.parse('2025-11-01T00:00:00.000Z'),
      targetAmount: 15000.0,
      priority: 'Medium',
      savedAmount: 2000.0,
      notes: 'Gift for a friend’s wedding',
    ),
    Goal(
      name: 'Charity Contribution',
      targetDate: DateTime.parse('2025-08-20T00:00:00.000Z'),
      targetAmount: 10000.0,
      priority: 'Low',
      savedAmount: 3000.0,
      notes: 'Donations to local charities',
    ),
    Goal(
      name: 'Fitness & Health',
      targetDate: DateTime.parse('2025-05-10T00:00:00.000Z'),
      targetAmount: 12000.0,
      priority: 'Medium',
      savedAmount: 2000.0,
      notes: 'Gym membership and wellness programs',
    ),
  ];

  UserDetails? _user;
  UserDetails? get user => _user;

  bool _isFileAdded = false;
  bool get isFileAdded => _isFileAdded;

  bool _isFileDownloaded = false;
  bool get isFileDownloaded => _isFileDownloaded;

  String _fileName = 'Expense Tracker Data.xlsx';
  String get fileName => _fileName;

  final String _downloadedFileName = 'ExcelTemplate.xlsx';
  String get downloadedFileName => _downloadedFileName;

  String _fileSize = '';
  String get fileSize => _fileSize;

  Future<void> updateUserDetails(UserDetails userDetails) async {
    _user = userDetails;
    notifyListeners();
  }

  void validateDownloadFile({bool isDownloaded = false}) {
    _isFileDownloaded = isDownloaded;
    notifyListeners();
  }

  void validateFinishButton({
    required int fileSizeInKb,
    required String fileName,
    bool enable = false,
  }) {
    _isFileDownloaded = false;
    _isFileAdded = enable;
    _fileName = fileName;
    _fileSize = '$fileSizeInKb KB';
    notifyListeners();
  }

  Future<void> updateDetails(BuildContext context) async {
    final UserDetails userDetails = await readUserDetailsFromFile();
    _user = userDetails;
    notifyListeners();
  }

  Future<void> updateDefaultTemplateDetails(BuildContext context) async {
    final UserDetails userDetails = await readUserDetailsFromFile();
    userDetails.transactionalData.data.clear();
    userDetails.transactionalData.data.add(
      _defaultTransactionalDetails(userDetails),
    );
    await writeUserDetailsToFile(userDetails);
    _user = userDetails;
    notifyListeners();
  }

  TransactionalDetails _defaultTransactionalDetails(UserDetails user) {
    return TransactionalDetails(
      transactions: _predefinedTransactions,
      budgets: _predefinedBudgets,
      goals: _predefinedGoals,
      savings: _predefinedSavings,
    );
  }
}

Future<ImportNotifier> initializeImportNotifier() async {
  // Simulate some asynchronous task
  await Future<ImportNotifier>.delayed(const Duration(seconds: 20));
  return ImportNotifier();
}
