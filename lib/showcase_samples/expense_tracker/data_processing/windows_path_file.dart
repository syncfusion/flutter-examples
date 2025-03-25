import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';

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

Future<Excel> createOrGetExcelFile() async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Uint8List bytes = await file.readAsBytes();
  if (bytes.isEmpty) {
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

    final List<int>? saveBytes = excel.save();
    await file.writeAsBytes(Uint8List.fromList(saveBytes!));
    return Excel.decodeBytes(saveBytes);
  }
  return Excel.decodeBytes(bytes);
}

Future<UserDetails> readUserDetailsFromFile() async {
  final Excel excel = await createOrGetExcelFile();
  Profile profile = Profile(firstName: '', lastName: '', userId: '');

  // Assuming you have a sheet named 'Users'
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

// Function used to write the users list into the JSON file.
Future<void> writeUserDetailsToFile(
  UserDetails userDetails, {
  bool isNewUser = false,
  int editIndex = -1,
}) async {
  final String filePath =
      await getFilePath(); // Ensure it points to an .xlsx file
  final File file = File(filePath);
  final Excel excel =
      await createOrGetExcelFile(); // Create or get a sheet named 'Users'
  final Profile profile = userDetails.userProfile;
  final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

  // await _writeUserDetails(excel, textCellValue);
  if (isNewUser) {
    await writeUserDetails(excel, textCellValue);
  }

  if (userDetails.transactionalData.data.isNotEmpty) {
    await writeTransactionalDetails(
      excel,
      userDetails.transactionalData.data[0],
      userDetails,
    );
  }

  // Save the Excel file
  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }

  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

Future<void> storeExcelDataInPreferences(Uint8List excelBytes) async {}

Future<FirstTimeUserDetails> isVerifyFirstTimeUser() async {
  final String filePath = await getFilePath();
  final File file = File(filePath);

  if (file.existsSync()) {
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
}

Future<void> updateUserDetailsToFile(UserDetails userDetails) async {
  final String filePath =
      await getFilePath(); // Ensure it points to an .xlsx file
  final File file = File(filePath);
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
  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }

  // final File file = File(filePath);
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

Future<void> writeNewUserDetailsToFile(UserDetails userDetails) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);

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

  final Profile profile = userDetails.userProfile;
  final List<TextCellValue> textCellValue = userDetailsCellValue(profile);

  if (userDetails.userProfile.isNewUser) {
    await writeUserDetails(excel, textCellValue);
    // for (final Category category in predefinedCategory()) {
    //   final List<CellValue> cellValue = categoriesCellValue(category);
    //   categoriesSheet.insertRowIterables(
    //     cellValue,
    //     categoriesSheet.rows.length,
    //   );
    // }
  }

  // Save the Excel file
  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }

  // final File file = File(filePath);
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

void selectExcelFile() {}
