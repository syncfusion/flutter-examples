import 'dart:io';

// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';

// import '../enum.dart';
// import '../helper/excel_header_row.dart';
// import '../models/budget.dart';
// import '../models/goal.dart';
// import '../models/saving.dart';
// import '../models/transaction.dart';
// import '../models/transactional_data.dart';
// import '../models/transactional_details.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';
import 'windows_path_file.dart' if (dart.library.html) 'web_path_file.dart';

Future<String> getFilePath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  // final Directory directory = Directory(r'D:\goals_savings_earlier');
  return '${directory.path}\\Expense Tracker Data.xlsx';
}

// List<TextCellValue> userDetailsCellValue(Profile profile) {
//   return <TextCellValue>[
//     TextCellValue(profile.userId),
//     TextCellValue(profile.firstName),
//     TextCellValue(profile.lastName),
//     TextCellValue(profile.gender ?? ''),
//     TextCellValue(profile.dateOfBirth.toString()),
//     TextCellValue(profile.currency),
//     TextCellValue(profile.dateFormat),
//     TextCellValue(profile.isDrawerExpanded.toString()),
//   ];
// }

// Future<void> writeUserDetails(Excel excel, List<CellValue> cellValue) async {
//   final Sheet sheet = excelSheet(excel, 'User Details');
//   sheet.insertRowIterables(cellValue, sheet.rows.length);
// }

// Future<void> writeTransactionalDetails(
//   Excel excel,
//   TransactionalDetails transactionDetails,
//   UserDetails userDetails,
// ) async {
//   final Sheet transactionsSheet = excelSheet(excel, 'Transactions');
//   final Sheet savingsSheet = excelSheet(excel, 'Savings');
//   final Sheet goalSheet = excelSheet(excel, 'Goals');
//   final Sheet budgetsSheet = excelSheet(excel, 'Budgets');
//   final Sheet categoriesSheet = excelSheet(excel, 'Categories');
//   final Profile userProfile = userDetails.userProfile;

//   if (transactionsSheet.rows.isNotEmpty) {
//     for (
//       int rowIndex = 1;
//       rowIndex < transactionsSheet.rows.length;
//       rowIndex++
//     ) {
//       transactionsSheet.removeRow(rowIndex);
//     }
//   }
//   if (savingsSheet.rows.isNotEmpty) {
//     for (int rowIndex = 1; rowIndex < savingsSheet.rows.length; rowIndex++) {
//       savingsSheet.removeRow(rowIndex);
//     }
//   }
//   if (goalSheet.rows.isNotEmpty) {
//     for (int rowIndex = 1; rowIndex < goalSheet.rows.length; rowIndex++) {
//       goalSheet.removeRow(rowIndex);
//     }
//   }
//   if (budgetsSheet.rows.isNotEmpty) {
//     for (int rowIndex = 1; rowIndex < budgetsSheet.rows.length; rowIndex++) {
//       budgetsSheet.removeRow(rowIndex);
//     }
//   }
//   if (categoriesSheet.rows.isNotEmpty) {
//     for (int rowIndex = 1; rowIndex < categoriesSheet.rows.length; rowIndex++) {
//       categoriesSheet.removeRow(rowIndex);
//     }
//   }

//   if (transactionDetails.transactions.isNotEmpty) {
//     for (final Transaction transaction in transactionDetails.transactions) {
//       final List<CellValue> cellValue = transactionsCellValue(
//         transaction,
//         userProfile,
//       );
//       transactionsSheet.insertRowIterables(
//         cellValue,
//         transactionsSheet.rows.length,
//       );
//     }
//   }
//   if (transactionDetails.budgets.isNotEmpty) {
//     for (final Budget budget in transactionDetails.budgets) {
//       final List<CellValue> cellValue = budgetsCellValue(budget, userProfile);
//       budgetsSheet.insertRowIterables(cellValue, budgetsSheet.rows.length);
//     }
//   }
//   if (transactionDetails.goals.isNotEmpty) {
//     for (final Goal goal in transactionDetails.goals) {
//       final List<CellValue> cellValue = goalsCellValue(goal, userProfile);
//       goalSheet.insertRowIterables(cellValue, goalSheet.rows.length);
//     }
//   }
//   if (transactionDetails.savings.isNotEmpty) {
//     for (final Saving saving in transactionDetails.savings) {
//       final List<CellValue> cellValue = savingsCellValue(saving, userProfile);
//       savingsSheet.insertRowIterables(cellValue, savingsSheet.rows.length);
//     }
//   }
// }

// Future<void> updateUserProfile(
//   BuildContext context,
//   Profile updatedUserProfile, {
//   bool isNewUser = false,
// }) async {
//   if (isNewUser) {
//     await writeNewUserDetailsToFile(
//       UserDetails(
//         userProfile: updatedUserProfile,
//         transactionalData: TransactionalData(
//           data: TransactionalDetails(
//             transactions: [],
//             budgets: [],
//             goals: [],
//             savings: [],
//           ),
//         ),
//       ),
//     );
//   } else {
//     final UserDetails userDetails = await readUserDetailsFromFile();
//     // if (context.mounted) {
//     //   // updatedUserProfile.isDrawerExpanded =
//     //   //     Provider.of<DrawerNotifier>(context, listen: false).isExpanded;
//     // }
//     userDetails.userProfile = updatedUserProfile;
//     await updateUserDetailsToFile(userDetails);
//   }
// }

TransactionalData readTransactionDataFromFile(UserDetails userDetails) {
  return userDetails.transactionalData;
}

Future<void> writeTransactionDataToFile(
  BuildContext context,
  TransactionalData transactionalData, {
  int editIndex = -1,
}) async {
  final UserDetails userDetails = await readUserDetailsFromFile();

  userDetails.transactionalData = transactionalData;
  // writeUserDetailsToFile(userDetails);
}

TransactionalDetails readAllTransactionDetailCollections(
  UserDetails userDetails, {
  bool isNewUser = false,
}) {
  final TransactionalData transactionalData = readTransactionDataFromFile(
    userDetails,
  );
  return transactionalData.data;
}

// Future<void> writeTransactionalDetailsToFile(
//   BuildContext context,
//   UserDetails userDetails,
//   UserInteractions userInteraction, {
//   required DateTime? addedDateTime,
//   bool isNewUser = false,
//   int? index,
//   List<int>? indexes,
//   bool? isCategory,
//   Transaction? transaction,
//   Budget? budget,
//   Goal? goal,
//   Saving? saving,
//   Category? category,
//   FinancialPages? currentFinancialPage,
// }) async {
//   final TransactionalDetails transactionalDetails =
//       readAllTransactionDetailCollections(userDetails);
//   final List<Transaction> transactions = <Transaction>[];
//   final List<Budget> budgets = <Budget>[];
//   final List<Goal> goals = <Goal>[];
//   final List<Saving> savings = <Saving>[];
//   final List<Category> categories = <Category>[];

//   transactions.addAll(transactionalDetails.transactions);
//   budgets.addAll(transactionalDetails.budgets);
//   goals.addAll(transactionalDetails.goals);
//   savings.addAll(transactionalDetails.savings);
//   // categories.addAll(transactionalDetails.categories);

//   if (transaction != null) {
//     transactions.add(transaction);
//   }
//   if (budget != null) {
//     budgets.add(budget);
//   }
//   if (goal != null) {
//     goals.add(goal);
//   }
//   if (saving != null) {
//     savings.add(saving);
//   }
//   if (category != null) {
//     categories.add(category);
//   }

//   final TransactionalData transactionalData = TransactionalData(
//     data: TransactionalDetails(
//       transactions: transactions,
//       budgets: budgets,
//       goals: goals,
//       savings: savings,
//       // categories: categories,
//     ),
//   );

//   final TransactionalDetails currentDetails = transactionalData.data;

//   if (!isNewUser) {
//     switch (userInteraction) {
//       case UserInteractions.add:
//         _addDetails(
//           currentDetails,
//           transaction,
//           budget,
//           goal,
//           saving,
//           category,
//         );
//         break;
//       case UserInteractions.edit:
//         _editDetails(
//           currentDetails,
//           transaction,
//           budget,
//           goal,
//           saving,
//           category,
//           index,
//         );
//         break;
//       case UserInteractions.delete:
//         _deleteDetails(
//           currentDetails,
//           currentFinancialPage,
//           index,
//           indexes,
//           isCategory,
//         );
//         break;
//     }
//   }

//   await writeTransactionDataToFile(context, transactionalData);
// }

// void _addDetails(
//   TransactionalDetails currentDetails,
//   Transaction? transaction,
//   Budget? budget,
//   Goal? goal,
//   Saving? saving,
//   Category? category,
// ) {
//   if (transaction != null) {
//     final int existingIndex = currentDetails.transactions.indexWhere((
//       Transaction existingTransaction,
//     ) {
//       return existingTransaction.category == transaction.category &&
//           existingTransaction.type == transaction.type &&
//           existingTransaction.subCategory == transaction.subCategory &&
//           existingTransaction.addedDateTime == transaction.addedDateTime;
//     });
//     if (existingIndex == -1) {
//       currentDetails.transactions.add(transaction);
//     } else {
//       currentDetails.transactions[existingIndex] = transaction.copyWith(
//         transactionDate: transaction.transactionDate,
//         amount: transaction.amount,
//         remark: transaction.remark,
//       );
//     }
//   }

//   if (budget != null && !currentDetails.budgets.contains(budget)) {
//     currentDetails.budgets.add(budget);
//   }
//   if (goal != null && !currentDetails.goals.contains(goal)) {
//     currentDetails.goals.add(goal);
//   }
//   if (saving != null && !currentDetails.savings.contains(saving)) {
//     currentDetails.savings.add(saving);
//   }
//   // if (category != null && !currentDetails.categories.contains(category)) {
//   //   currentDetails.categories.add(category);
//   // }
// }

// void _editDetails(
//   TransactionalDetails currentDetails,
//   Transaction? transaction,
//   Budget? budget,
//   Goal? goal,
//   Saving? saving,
//   Category? category,
//   int? index,
// ) {
//   if (index == null) {
//     return; // Ensure index is provided for edit
//   }

//   if (transaction != null && index < currentDetails.transactions.length) {
//     currentDetails.transactions[index] = transaction;
//   }
//   if (budget != null && index < currentDetails.budgets.length) {
//     currentDetails.budgets[index] = budget;
//   }
//   if (goal != null && index < currentDetails.goals.length) {
//     currentDetails.goals[index] = goal;
//   }
//   if (saving != null && index < currentDetails.savings.length) {
//     currentDetails.savings[index] = saving;
//   }
//   // if (category != null && index < currentDetails.categories.length) {
//   //   currentDetails.categories[index] = category;
//   // }
// }

// void _deleteDetails(
//   TransactionalDetails currentDetails,
//   FinancialPages? currentFinancialPage,
//   int? index,
//   List<int>? indexes,
//   bool? isCategory,
// ) {
//   if (currentFinancialPage != null && index != null) {
//     switch (currentFinancialPage) {
//       case FinancialPages.goals:
//         if (index < currentDetails.goals.length) {
//           currentDetails.goals.removeAt(index);
//         }
//         break;
//       // case FinancialPages.savings:
//       //   if (index < currentDetails.savings.length) {
//       //     currentDetails.savings.removeAt(index);
//       //   }
//       //   break;
//       case FinancialPages.budgets:
//         if (index < currentDetails.budgets.length) {
//           currentDetails.budgets.removeAt(index);
//         }
//         break;
//     }
//   } else if (indexes != null && isCategory != null) {
//     if (isCategory) {
//       // for (int i = indexes.length - 1; i >= 0; i--) {
//       //   final int currentIndex = indexes[i];
//       //   if (currentIndex < currentDetails.categories.length) {
//       //     currentDetails.categories.removeAt(currentIndex);
//       //   }
//       // }
//     } else {
//       for (int i = indexes.length - 1; i >= 0; i--) {
//         final int currentIndex = indexes[i];
//         if (currentIndex < currentDetails.transactions.length) {
//           currentDetails.transactions.removeAt(currentIndex);
//         }
//       }
//     }
//   }
// }

// Future<void> removeCommonData(
//   BuildContext context,
//   UserDetails userDetails,
//   int index,
//   UserInteractions userInteraction, {
//   required DateTime? addedDateTime,
//   FinancialPages? currentFinancialPage,
// }) async {
//   await writeTransactionalDetailsToFile(
//     context,
//     userDetails,
//     UserInteractions.delete,
//     index: index,
//     currentFinancialPage: currentFinancialPage,
//     addedDateTime: addedDateTime ?? DateTime.now(),
//   );
// }

// Future<void> removeSelectedDataGridRows(
//   BuildContext context,
//   UserDetails userDetails,
//   UserInteractions userInteraction, {
//   required bool isCategory,
//   int? index,
//   List<int>? indexes,
// }) async {
//   await writeTransactionalDetailsToFile(
//     context,
//     userDetails,
//     userInteraction,
//     isCategory: isCategory,
//     index: index,
//     indexes: indexes,
//     addedDateTime: DateTime.now(),
//   );
// }

// String _findMonthName(int monthIndex) {
//   switch (monthIndex) {
//     case 1:
//       return 'January';
//     case 2:
//       return 'February';
//     case 3:
//       return 'March';
//     case 4:
//       return 'April';
//     case 5:
//       return 'May';
//     case 6:
//       return 'June';
//     case 7:
//       return 'July';
//     case 8:
//       return 'August';
//     case 9:
//       return 'September';
//     case 10:
//       return 'October';
//     case 11:
//       return 'November';
//     case 12:
//       return 'December';
//     default:
//       return '';
//   }
// }
