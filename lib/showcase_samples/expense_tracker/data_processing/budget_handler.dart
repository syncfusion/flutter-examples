import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../enum.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/excel_header_row.dart';
import '../models/budget.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';
import 'windows_path_file.dart';

List<Budget> readBudgets(UserDetails userDetails) {
  final List<Budget> overallBudgets = <Budget>[];

  final List<TransactionalDetails> allTransactionalDetails =
      readAllTransactionDetailCollections(userDetails);

  for (final TransactionalDetails transactionalDetails
      in allTransactionalDetails) {
    overallBudgets.addAll(transactionalDetails.budgets);
  }
  return overallBudgets;
}

Future<void> updateBudgets(
  BuildContext context,
  UserDetails userDetails,
  Budget budget,
  UserInteractions userInteraction, {
  bool isNewUser = false,
  int index = -1,
}) async {
  if (userInteraction == UserInteractions.add ||
      userInteraction == UserInteractions.edit) {
    await _writeBudgets(
      userInteraction,
      userDetails.userProfile,
      budget,
      index: index,
    );
  } else {
    await _deleteBudgets(budget, index: index);
  }
}

Future<void> _deleteBudgets(Budget currentBudget, {int index = -1}) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final budgetsSheet = getSheet(excel, 'Budgets');

  if (index != -1) {
    final int excelRowIndex = index + 1;
    budgetsSheet.removeRow(excelRowIndex);
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

Future<void> _writeBudgets(
  UserInteractions userInteractions,
  Profile profile,
  Budget currentBudget, {
  int index = -1,
}) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final budgetsSheet = getSheet(excel, 'Budgets');

  if (userInteractions == UserInteractions.add) {
    final List<TextCellValue> cellValue = budgetsCellValue(
      currentBudget,
      profile,
    );
    budgetsSheet.insertRow(1);
    budgetsSheet.insertRowIterables(cellValue, 1);
  } else {
    if (index != -1) {
      final int excelRowNumber = index + 2;
      budgetsSheet.updateCell(
        CellIndex.indexByString('B$excelRowNumber'),
        TextCellValue(formatDate(currentBudget.createdDate)),
      );
      budgetsSheet.updateCell(
        CellIndex.indexByString('C$excelRowNumber'),
        TextCellValue(currentBudget.name),
      );
      budgetsSheet.updateCell(
        CellIndex.indexByString('F$excelRowNumber'),
        TextCellValue(currentBudget.notes ?? ''),
      );
      budgetsSheet.updateCell(
        CellIndex.indexByString('D$excelRowNumber'),
        TextCellValue(currentBudget.target.toString()),
      );
    }
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

Future<void> updateBudgetExpense(
  BuildContext context,
  UserDetails userDetails,
  Budget budget,
  UserInteractions userInteraction, {
  bool isNewUser = false,
  int index = -1,
}) async {
  await _writeBudgetExpense(budget, index: index);
}

Future<void> _writeBudgetExpense(Budget currentBudget, {int index = -1}) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final Sheet budgetsSheet = getSheet(excel, 'Budgets');

  if (index > -1) {
    final int excelRowNumber = index + 2;
    budgetsSheet.updateCell(
      CellIndex.indexByString('E$excelRowNumber'),
      TextCellValue(currentBudget.expense.toString()),
    );
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}
