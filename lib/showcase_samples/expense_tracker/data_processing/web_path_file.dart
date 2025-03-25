import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base.dart';
import '../helper/excel_header_row.dart';
import '../models/budget.dart';
import '../models/goal.dart';
import '../models/saving.dart';
import '../models/transaction.dart';
import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';

/// Key for storing the data in shared preferences
const String sharedPreferencesKey = 'excel_data';

// Store the Excel data (raw bytes) in SharedPreferences
Future<void> storeExcelDataInPreferences(Uint8List excelBytes) async {
  try {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      sharedPreferencesKey,
      base64Encode(excelBytes),
    );
    debugPrint('Excel data stored in SharedPreferences');
  } catch (e) {
    debugPrint('Error storing Excel data in SharedPreferences: $e');
  }
}

// Method to get the Excel data from SharedPreferences
Future<Excel> createOrGetExcelFile() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final String? excelString = sharedPreferences.getString(sharedPreferencesKey);
  if (excelString != null && excelString.isNotEmpty) {
    final Uint8List bytes = base64Decode(excelString);
    return Excel.decodeBytes(bytes);
  } else {
    final Excel excel = Excel.createExcel();
    final Sheet userDetailsSheet = getSheet(excel, 'User Details');
    final Sheet transactionsSheet = getSheet(excel, 'Transactions');
    final Sheet savingsSheet = getSheet(excel, 'Savings');
    final Sheet goalsSheet = getSheet(excel, 'Goals');
    final Sheet budgetsSheet = getSheet(excel, 'Budgets');
    // final Sheet categoriesSheet = getSheet(excel, 'Categories');
    userDetailsSheet.appendRow(userDetailsHeaderCellValue());
    transactionsSheet.appendRow(transactionsHeaderCellValue());
    savingsSheet.appendRow(savingsHeaderCellValue());
    goalsSheet.appendRow(goalsHeaderCellValue());
    budgetsSheet.appendRow(budgetsHeaderCellValue());
    // categoriesSheet.appendRow(categoriesHeaderCellValue());
    return excel;
  }
}

// Read user details from the Excel file stored in SharedPreferences
Future<UserDetails> readUserDetailsFromFile() async {
  final Excel excel = await createOrGetExcelFile();
  Profile profile = Profile(firstName: '', lastName: '', userId: '');

  final Sheet userDetailsSheet = getSheet(excel, 'User Details');
  final Sheet transactionsSheet = getSheet(excel, 'Transactions');
  final Sheet savingsSheet = getSheet(excel, 'Savings');
  final Sheet goalsSheet = getSheet(excel, 'Goals');
  final Sheet budgetsSheet = getSheet(excel, 'Budgets');
  getSheet(excel, 'Categories');
  final List<Transaction> transactions = <Transaction>[];
  final List<Saving> savings = <Saving>[];
  final List<Goal> goals = <Goal>[];
  final List<Budget> budgets = <Budget>[];
  final List<TransactionalDetails> transactionsDetails =
      <TransactionalDetails>[];
  for (final List<Data?> row in userDetailsSheet.rows.skip(1)) {
    profile = userProfileDetails(row);
    if (transactionsSheet.rows.isNotEmpty) {
      for (final List<Data?> transaction in transactionsSheet.rows.skip(1)) {
        if (!hasNull(transaction)) {
          transactions.add(readTransactionDetails(transaction, profile));
        }
      }
    }
    if (savingsSheet.rows.isNotEmpty) {
      for (final List<Data?> saving in savingsSheet.rows.skip(1)) {
        if (!hasNull(saving)) {
          savings.add(readSavingDetails(saving, profile));
        }
      }
    }
    if (goalsSheet.rows.isNotEmpty) {
      for (final List<Data?> goal in goalsSheet.rows.skip(1)) {
        if (!hasNull(goal)) {
          goals.add(readGoalDetails(goal, profile));
        }
      }
    }
    if (budgetsSheet.rows.isNotEmpty) {
      for (final List<Data?> budget in budgetsSheet.rows.skip(1)) {
        if (!hasNull(budget)) {
          budgets.add(readBudgetDetails(budget, profile));
        }
      }
    }
    transactionsDetails.add(
      TransactionalDetails(
        transactions: transactions,
        budgets: budgets,
        goals: goals,
        savings: savings,
      ),
    );
  }
  return UserDetails.fromExcel(profile, transactionsDetails);
}

Future<FirstTimeUserDetails> isVerifyFirstTimeUser() async {
  try {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString(sharedPreferencesKey) != null) {
      final UserDetails userDetails = await readUserDetailsFromFile();
      return FirstTimeUserDetails(false, userDetails);
    } else {
      return FirstTimeUserDetails(
        true,
        UserDetails(
          userProfile: Profile(firstName: '', lastName: '', userId: ''),
          transactionalData: TransactionalData(data: <TransactionalDetails>[]),
        ),
      );
    }
  } catch (e) {
    // Log the error or handle it appropriately
    return FirstTimeUserDetails(
      false,
      UserDetails(
        userProfile: Profile(firstName: '', lastName: '', userId: ''),
        transactionalData: TransactionalData(data: <TransactionalDetails>[]),
      ),
    );
  }
}

Future<void> writeUserDetailsToFile(
  UserDetails user, {
  bool isNewUser = false,
  int editIndex = -1,
}) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  // Retrieve the existing Excel file or create a new one
  Excel excel;
  if (preferences.containsKey('excel_data')) {
    // Load the existing Excel data from SharedPreferences
    final String? base64Data = preferences.getString('excel_data');
    if (base64Data != null) {
      final Uint8List bytes = base64Decode(base64Data);
      excel = Excel.decodeBytes(bytes);
    } else {
      throw Exception('Failed to load existing Excel data.');
    }
  } else {
    // Create a new Excel file
    excel = Excel.createExcel();
  }
  final Profile profile = user.userProfile;
  final List<TextCellValue> textCellValue = userDetailsCellValue(profile);
  // Write user details
  if (isNewUser) {
    await writeUserDetails(excel, textCellValue);
  }
  // Write transactional details if available
  if (user.transactionalData.data.isNotEmpty) {
    await writeTransactionalDetails(
      excel,
      user.transactionalData.data[0],
      user,
    );
  }
  // Save the Excel data to SharedPreferences
  // final List<int>? saveBytes = excel.save();
  final List<int>? saveBytes = excel.encode();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel data.');
  }
  // Convert the bytes to a base64 string and save to SharedPreferences
  final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
  await preferences.setString(sharedPreferencesKey, base64Data);
}

Future<void> updateUserDetailsToFile(UserDetails userDetails) async {
  final SharedPreferences preferences =
      await SharedPreferences.getInstance(); // Ensure it points to an .xlsx file

  final Excel excel =
      await createOrGetExcelFile(); // Create or get a sheet named 'Users'
  final Profile profile = userDetails.userProfile;
  final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

  final Sheet sheet = getSheet(excel, 'User Details');
  const int rowIndex = 1;

  final List<Data?> row = sheet.row(rowIndex + 1);

  for (int i = 0; i < row.length; i++) {
    sheet
        .cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex + 1),
        )
        .value = textCellValue[i];
  }

  // Save the Excel file
  final List<int>? saveBytes = excel.encode();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }

  // final File file = File(filePath);
  final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
  await preferences.setString(sharedPreferencesKey, base64Data);
}

Future<void> writeNewUserDetailsToFile(UserDetails userDetails) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final Excel excel = Excel.createExcel();
  final userDetailsSheet = getSheet(excel, 'User Details');
  final transactionsSheet = getSheet(excel, 'Transactions');
  final savingsSheet = getSheet(excel, 'Savings');
  final goalsSheet = getSheet(excel, 'Goals');
  final budgetsSheet = getSheet(excel, 'Budgets');
  // final categoriesSheet = getSheet(excel, 'Categories');

  userDetailsSheet.appendRow(userDetailsHeaderCellValue());
  transactionsSheet.appendRow(transactionsHeaderCellValue());
  savingsSheet.appendRow(savingsHeaderCellValue());
  goalsSheet.appendRow(goalsHeaderCellValue());
  budgetsSheet.appendRow(budgetsHeaderCellValue());
  // categoriesSheet.appendRow(categoriesHeaderCellValue());

  final Profile profile = userDetails.userProfile;
  final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

  if (userDetails.userProfile.isNewUser) {
    await writeUserDetails(excel, textCellValue);
  }

  // Save the Excel file
  final List<int>? saveBytes = excel.encode();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }

  // final File file = File(filePath);
  final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
  await sharedPreferences.setString(sharedPreferencesKey, base64Data);
}
