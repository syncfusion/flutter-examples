import 'dart:convert';
import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// import '../data_processing/budget_handler.dart';
// import '../data_processing/goal_handler.dart'
//     if (dart.library.html) '../data_processing/goal_web_handler.dart';
// import '../data_processing/saving_handler.dart'
//     if (dart.library.html) '../data_processing/saving_web_handler.dart';
// import '../data_processing/transaction_handler.dart';
import '../data_processing/utils.dart';
// import '../data_processing/windows_path_file.dart';
// import '../models/budget.dart';
// import '../models/goal.dart';
// import '../models/saving.dart';
// import '../models/transaction.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';

class ExportService {
  Future<Map<String, dynamic>?> readDataFromJson() async {
    try {
      final String path = await getFilePath();

      // Android
      // final Directory directory = await getApplicationDocumentsDirectory();
      // final String path = '${directory.path}/expense__analysis_data.json';

      final File file = File(path);

      if (!file.existsSync()) {
        return null;
      }

      final String jsonString = await file.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Export settings to an Excel file
  // Future<String?> exportSettingsToExcel(
  //   BuildContext context, {
  //   List<String>? sheetsToExport,
  // }) async {
  //   try {
  //     final UserDetails userDetails = await readUserDetailsFromFile();

  //     final xlsio.Workbook workbook = xlsio.Workbook();
  //     workbook.worksheets.clear();
  //     String? exportPathName;

  //     // Add sheets based on the export options
  //     if (sheetsToExport == null || sheetsToExport.contains('User Details')) {
  //       _addUserDetailsSheet(workbook, userDetails.userProfile);
  //       exportPathName = 'expense_tracker_data';
  //     }
  //     if (sheetsToExport == null || sheetsToExport.contains('Transactions')) {
  //       _addTransactionSheet(workbook, userDetails);
  //       exportPathName = 'expense_tracker_transactions_data';
  //     }
  //     // if (sheetsToExport == null || sheetsToExport.contains('Categories')) {
  //     //   _addCategorySheet(workbook, userDetails);
  //     //   exportPathName = 'expense_tracker_categories_data';
  //     // }
  //     if (sheetsToExport == null || sheetsToExport.contains('Goals')) {
  //       if (context.mounted) {
  //         _addGoalSheet(workbook, userDetails, context);
  //         exportPathName = 'expense_tracker_goals_data';
  //       }
  //     }
  //     if (sheetsToExport == null || sheetsToExport.contains('Savings')) {
  //       if (context.mounted) {
  //         _addSavingsSheet(workbook, userDetails, context);
  //         exportPathName = 'expense_tracker_savings_data';
  //       }
  //     }
  //     if (sheetsToExport == null || sheetsToExport.contains('Budgets')) {
  //       if (context.mounted) {
  //         _addBudgetSheet(workbook, userDetails, context);
  //         exportPathName = 'expense_tracker_budgets_data';
  //       }
  //     }

  //     final List<int> bytes = workbook.saveAsStream();
  //     workbook.dispose();

  //     final Directory directory = await getApplicationDocumentsDirectory();

  //     // Ensure directory is created
  //     if (!directory.existsSync()) {
  //       directory.createSync(recursive: true);
  //     }

  //     int fileIndex = 0;
  //     String path;
  //     do {
  //       path =
  //           '${directory.path}/$exportPathName${fileIndex == 0 ? '' : '($fileIndex)'}.xlsx';
  //       fileIndex++;
  //     } while (File(path).existsSync()); // Ensure a new file is named

  //     final File file = File(path);
  //     await file.writeAsBytes(
  //       bytes,
  //       flush: true,
  //     ); // This will create the file if it doesn't exist

  //     return path;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // void _addUserDetailsSheet(xlsio.Workbook workbook, Profile userProfile) {
  //   final xlsio.Worksheet userProfileSheet = workbook.worksheets.add();
  //   userProfileSheet.name = 'User Details';

  //   userProfileSheet.getRangeByName('A1').setText('Key');
  //   userProfileSheet.getRangeByName('B1').setText('Value');
  //   userProfileSheet.getRangeByName('A2').setText('Name');
  //   userProfileSheet
  //       .getRangeByName('B2')
  //       .setText('${userProfile.firstName} ${userProfile.lastName}');
  //   userProfileSheet.getRangeByName('A3').setText('Date of Birth');
  //   userProfileSheet
  //       .getRangeByName('B3')
  //       .setText(_formatDate(userProfile.dateOfBirth.toString()));
  //   userProfileSheet.getRangeByName('A4').setText('Gender');
  //   userProfileSheet.getRangeByName('B4').setText(userProfile.gender);

  //   userProfileSheet.autoFitColumn(1);
  //   userProfileSheet.autoFitColumn(2);
  // }

  // void _addTransactionSheet(xlsio.Workbook workbook, UserDetails userDetails) {
  //   final xlsio.Worksheet transactionSheet = workbook.worksheets.add();
  //   transactionSheet.name = 'Transactions';

  //   transactionSheet.getRangeByName('A1').setText('Type');
  //   transactionSheet.getRangeByName('B1').setText('Category');
  //   transactionSheet.getRangeByName('C1').setText('SubCategory');
  //   transactionSheet.getRangeByName('D1').setText('Amount');
  //   transactionSheet.getRangeByName('E1').setText('Date');
  //   int row = 2;

  //   final List<Transaction> transactions = readTransactions(userDetails);
  //   for (final Transaction transaction in transactions) {
  //     transactionSheet.getRangeByIndex(row, 1).setText(transaction.type);
  //     transactionSheet.getRangeByIndex(row, 2).setText(transaction.category);
  //     transactionSheet.getRangeByIndex(row, 3).setText(transaction.subCategory);
  //     transactionSheet.getRangeByIndex(row, 4).setNumber(transaction.amount);
  //     transactionSheet
  //         .getRangeByIndex(row, 5)
  //         .setText(_formatDate(transaction.transactionDate.toString()));
  //     row++;
  //   }

  //   for (int i = 1; i <= 5; i++) {
  //     transactionSheet.autoFitColumn(i);
  //   }
  // }

  // void _addCategorySheet(xlsio.Workbook workbook, UserDetails userDetails) {
  //   final xlsio.Worksheet categorySheet = workbook.worksheets.add();
  //   categorySheet.name = 'Categories';

  //   categorySheet.getRangeByName('A1').setText('Type');
  //   categorySheet.getRangeByName('B1').setText('Category');
  //   categorySheet.getRangeByName('C1').setText('SubCategory');
  //   categorySheet.getRangeByName('D1').setText('Date');
  //   int row = 2;

  //   final List<Category> categories = readCategories(userDetails);
  //   for (final Category category in categories) {
  //     categorySheet.getRangeByIndex(row, 1).setText(category.type);
  //     categorySheet.getRangeByIndex(row, 2).setText(category.category);
  //     categorySheet
  //         .getRangeByIndex(row, 3)
  //         .setText(category.subCategories.join(', '));
  //     categorySheet
  //         .getRangeByIndex(row, 4)
  //         .setText(_formatDate(category.addedDateTime.toString()));
  //     row++;
  //   }

  //   for (int i = 1; i <= 4; i++) {
  //     categorySheet.autoFitColumn(i);
  //   }
  // }

  // void _addGoalSheet(
  //   xlsio.Workbook workbook,
  //   UserDetails userDetails,
  //   BuildContext context,
  // ) {
  //   final xlsio.Worksheet goalSheet = workbook.worksheets.add();
  //   goalSheet.name = 'Goals';

  //   goalSheet.getRangeByName('A1').setText('Goal Name');
  //   goalSheet.getRangeByName('B1').setText('Target Amount');
  //   goalSheet.getRangeByName('C1').setText('Target Date');
  //   int row = 2;

  //   final List<Goal> goals = readGoals(userDetails);
  //   for (final Goal goal in goals) {
  //     goalSheet.getRangeByIndex(row, 1).setText(goal.name);
  //     goalSheet.getRangeByIndex(row, 2).setNumber(goal.amount);
  //     goalSheet
  //         .getRangeByIndex(row, 3)
  //         .setText(_formatDate(goal.date.toString()));

  //     row++;
  //   }

  //   for (int i = 1; i <= 3; i++) {
  //     goalSheet.autoFitColumn(i);
  //   }
  // }

  // void _addSavingsSheet(
  //   xlsio.Workbook workbook,
  //   UserDetails userDetails,
  //   BuildContext context,
  // ) {
  //   final xlsio.Worksheet savingsSheet = workbook.worksheets.add();
  //   savingsSheet.name = 'Savings';

  //   savingsSheet.getRangeByName('A1').setText('Savings Name');
  //   savingsSheet.getRangeByName('B1').setText('Amount');
  //   savingsSheet.getRangeByName('C1').setText('Date');
  //   int row = 2;

  //   final List<Saving> savings = readSavings(userDetails);
  //   for (final Saving saving in savings) {
  //     savingsSheet.getRangeByIndex(row, 1).setText(saving.name);
  //     savingsSheet.getRangeByIndex(row, 2).setNumber(saving.savedAmount);
  //     savingsSheet
  //         .getRangeByIndex(row, 3)
  //         .setText(_formatDate(saving.savingDate.toString()));

  //     row++;
  //   }
  // }

  // void _addBudgetSheet(
  //   xlsio.Workbook workbook,
  //   UserDetails userDetails,
  //   BuildContext context,
  // ) {
  //   final xlsio.Worksheet budgetSheet = workbook.worksheets.add();
  //   budgetSheet.name = 'Budgets';

  //   budgetSheet.getRangeByName('A1').setText('Budget Name');
  //   budgetSheet.getRangeByName('B1').setText('Target Amount');
  //   budgetSheet.getRangeByName('C1').setText('Category');
  //   budgetSheet.getRangeByName('D1').setText('SubCategory');
  //   int row = 2;

  //   final List<Budget> budgets = readBudgets(userDetails);
  //   for (final Budget budget in budgets) {
  //     budgetSheet.getRangeByIndex(row, 1).setText(budget.name);
  //     budgetSheet.getRangeByIndex(row, 2).setNumber(budget.target);
  //     row++;
  //   }

  //   for (int i = 1; i <= 4; i++) {
  //     budgetSheet.autoFitColumn(i);
  //   }
  // }

  // String _formatDate(String date) {
  //   return date.split('T').first;
  // }
}
