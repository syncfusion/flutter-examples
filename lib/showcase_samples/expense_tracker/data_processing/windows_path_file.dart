// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';

// import '../base.dart';
// import '../helper/excel_header_row.dart';

import '../base.dart';
import '../helper/predefined_data.dart';
// import '../models/budget.dart';
// import '../models/goal.dart';
// import '../models/saving.dart';
// import '../models/transaction.dart';
// import '../models/transactional_data.dart';
import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
// import 'utils.dart';

// Future<Excel> createOrGetExcelFile() async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Uint8List bytes = await file.readAsBytes();
//   if (bytes.isEmpty) {
//     final Excel excel = Excel.createExcel();
//     final Sheet userDetailsSheet = excelSheet(excel, 'User Details');
//     final Sheet transactionsSheet = excelSheet(excel, 'Transactions');
//     final Sheet savingsSheet = excelSheet(excel, 'Savings');
//     final Sheet goalSheet = excelSheet(excel, 'Goals');
//     final Sheet budgetsSheet = excelSheet(excel, 'Budgets');
//     // final Sheet categoriesSheet = excelSheet(excel, 'Categories');

//     userDetailsSheet.appendRow(userDetailsHeaderCellValue());
//     transactionsSheet.appendRow(transactionsHeaderCellValue());
//     savingsSheet.appendRow(savingsHeaderCellValue());
//     goalSheet.appendRow(goalsHeaderCellValue());
//     budgetsSheet.appendRow(budgetsHeaderCellValue());
//     // categoriesSheet.appendRow(categoriesHeaderCellValue());

//     final List<int>? saveBytes = excel.save();
//     await file.writeAsBytes(Uint8List.fromList(saveBytes!));
//     return Excel.decodeBytes(saveBytes);
//   }
//   return Excel.decodeBytes(bytes);
// }

// Future<UserDetails> readUserDetailsFromFile() async {
//   // final Excel excel = await createOrGetExcelFile();
//   Profile profile = Profile(firstName: '', lastName: '', userId: '');

//   // Assuming you have a sheet named 'Users'
//   // final Sheet userDetailsSheet = excelSheet(excel, 'User Details');
//   // final Sheet transactionsSheet = excelSheet(excel, 'Transactions');
//   // final Sheet savingsSheet = excelSheet(excel, 'Savings');
//   // final Sheet goalSheet = excelSheet(excel, 'Goals');
//   // final Sheet budgetsSheet = excelSheet(excel, 'Budgets');

//   final List<Transaction> transactions = <Transaction>[];
//   final List<Saving> savings = <Saving>[];
//   final List<Goal> goals = <Goal>[];
//   final List<Budget> budgets = <Budget>[];
//   TransactionalDetails transactionsDetails = TransactionalDetails(
//     transactions: [],
//     budgets: [],
//     goals: [],
//     savings: [],
//   );

//   for (final List<Data?> row in userDetailsSheet.rows.skip(1)) {
//     profile = userProfileDetails(row);
//     if (transactionsSheet.rows.isNotEmpty) {
//       for (final List<Data?> transaction in transactionsSheet.rows.skip(1)) {
//         if (!hasNull(transaction)) {
//           transactions.add(readTransactionDetails(transaction, profile));
//         }
//       }
//     }
//     if (savingsSheet.rows.isNotEmpty) {
//       for (final List<Data?> saving in savingsSheet.rows.skip(1)) {
//         if (!hasNull(saving)) {
//           savings.add(readSavingDetails(saving, profile));
//         }
//       }
//     }
//     if (goalSheet.rows.isNotEmpty) {
//       for (final List<Data?> goal in goalSheet.rows.skip(1)) {
//         if (!hasNull(goal)) {
//           goals.add(readGoalDetails(goal, profile));
//         }
//       }
//     }
//     if (budgetsSheet.rows.isNotEmpty) {
//       for (final List<Data?> budget in budgetsSheet.rows.skip(1)) {
//         if (!hasNull(budget)) {
//           budgets.add(readBudgetDetails(budget, profile));
//         }
//       }
//     }
//     transactionsDetails = TransactionalDetails(
//       transactions: transactions,
//       budgets: budgets,
//       goals: goals,
//       savings: savings,
//     );
//   }
//   return UserDetails.fromExcel(profile, transactionsDetails);
// }

Future<UserDetails> readUserDetailsFromFile() async {
  // final Excel excel = await createOrGetExcelFile();
  final Profile profile = Profile(firstName: '', lastName: '', userId: '');

  final TransactionalDetails transactionalDetails = TransactionalDetails(
    transactions: predefinedTransactions,
    budgets: predefinedBudgets,
    goals: predefinedGoals,
    savings: predefinedSavings,
  );
  return UserDetails.fromExcel(profile, transactionalDetails);
}

// // Function used to write the users list into the JSON file.
// Future<void> writeUserDetailsToFile(
//   UserDetails userDetails, {
//   bool isNewUser = false,
//   int editIndex = -1,
// }) async {
//   final String filePath =
//       await getFilePath(); // Ensure it points to an .xlsx file
//   final File file = File(filePath);
//   final Excel excel =
//       await createOrGetExcelFile(); // Create or get a sheet named 'Users'
//   final Profile profile = userDetails.userProfile;
//   final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

//   // await _writeUserDetails(excel, textCellValue);
//   if (isNewUser) {
//     await writeUserDetails(excel, textCellValue);
//   }

//   if (userDetails.transactionalData.data != null) {
//     await writeTransactionalDetails(
//       excel,
//       userDetails.transactionalData.data,
//       userDetails,
//     );
//   }

//   // Save the Excel file
//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// Future<void> storeExcelDataInPreferences(Uint8List excelBytes) async {}

Future<FirstTimeUserDetails> isVerifyFirstTimeUser() async {
  return FirstTimeUserDetails(
    true,
    UserDetails(
      userProfile: Profile(firstName: '', lastName: '', userId: ''),
      transactionalData: TransactionalData(
        data: TransactionalDetails(
          transactions: [],
          budgets: [],
          goals: [],
          savings: [],
        ),
      ),
    ),
  );
}

// Future<void> updateUserDetailsToFile(UserDetails userDetails) async {
//   final String filePath =
//       await getFilePath(); // Ensure it points to an .xlsx file
//   final File file = File(filePath);
//   final Excel excel =
//       await createOrGetExcelFile(); // Create or get a sheet named 'Users'
//   final Profile profile = userDetails.userProfile;
//   final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

//   final Sheet sheet = excelSheet(excel, 'User Details');
//   const int rowIndex = 1;

//   final List<Data?> row = sheet.row(rowIndex + 1);

//   for (int i = 0; i < row.length; i++) {
//     sheet
//             .cell(
//               CellIndex.indexByColumnRow(
//                 columnIndex: i,
//                 rowIndex: rowIndex + 1,
//               ),
//             )
//             .value =
//         textCellValue[i];
//   }

//   // Save the Excel file
//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// Future<void> writeNewUserDetailsToFile(UserDetails userDetails) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);

//   final Excel excel = Excel.createExcel();
//   final Sheet userDetailsSheet = excelSheet(excel, 'User Details');
//   final Sheet transactionsSheet = excelSheet(excel, 'Transactions');
//   final Sheet savingsSheet = excelSheet(excel, 'Savings');
//   final Sheet goalSheet = excelSheet(excel, 'Goals');
//   final Sheet budgetsSheet = excelSheet(excel, 'Budgets');
//   // final Sheet categoriesSheet = excelSheet(excel, 'Categories');

//   userDetailsSheet.appendRow(userDetailsHeaderCellValue());
//   transactionsSheet.appendRow(transactionsHeaderCellValue());
//   savingsSheet.appendRow(savingsHeaderCellValue());
//   goalSheet.appendRow(goalsHeaderCellValue());
//   budgetsSheet.appendRow(budgetsHeaderCellValue());
//   // categoriesSheet.appendRow(categoriesHeaderCellValue());

//   final Profile profile = userDetails.userProfile;
//   final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

//   if (userDetails.userProfile.isNewUser) {
//     await writeUserDetails(excel, textCellValue);
//     // for (final Category category in predefinedCategory()) {
//     //   final List<CellValue> cellValue = categoriesCellValue(category);
//     //   categoriesSheet.insertRowIterables(
//     //     cellValue,
//     //     categoriesSheet.rows.length,
//     //   );
//     // }
//   }

//   // Save the Excel file
//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// void selectExcelFile() {}
