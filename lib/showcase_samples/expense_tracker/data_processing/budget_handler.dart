// TODO(Praveen): Replace this excel code with csv or xml format code.

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';
// import 'package:flutter/foundation.dart';

// import '../enum.dart';
// import '../helper/currency_and_data_format/date_format.dart';
// import '../helper/excel_header_row.dart';
// import '../models/budget.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';
// import 'utils.dart';
// import 'windows_path_file.dart';

// List<Budget> readBudgets(UserDetails userDetails) {
//   return userDetails.transactionalData.data.budgets;
// }

// Future<void> updateBudgets(
//   UserDetails userDetails,
//   Budget budget,
//   UserInteractions userInteraction, {
//   int index = -1,
// }) async {
//   switch (userInteraction) {
//     case UserInteractions.add:
//     case UserInteractions.edit:
//       await _writeBudgets(
//         userInteraction,
//         userDetails.userProfile,
//         budget,
//         index: index,
//       );
//       break;
//     case UserInteractions.delete:
//       await _deleteBudgets(budget, index: index);
//   }
// }

// Future<void> _deleteBudgets(Budget currentBudget, {int index = -1}) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet budgetsSheet = excelSheet(excel, 'Budgets');

//   if (index != -1) {
//     final int excelRowIndex = index + 1;
//     budgetsSheet.removeRow(excelRowIndex);
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// Future<void> _writeBudgets(
//   UserInteractions userInteractions,
//   Profile profile,
//   Budget currentBudget, {
//   int index = -1,
// }) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet budgetsSheet = excelSheet(excel, 'Budgets');

//   switch (userInteractions) {
//     case UserInteractions.add:
//       _handleAdd(budgetsSheet, currentBudget, profile);
//       break;
//     case UserInteractions.edit:
//       _handleEdit(budgetsSheet, currentBudget, index);
//       break;
//     case UserInteractions.delete:
//       break;
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// void _handleAdd(Sheet budgetsSheet, Budget currentBudget, Profile profile) {
//   final List<TextCellValue> cellValue = budgetsCellValue(
//     currentBudget,
//     profile,
//   );
//   budgetsSheet.insertRow(1);
//   budgetsSheet.insertRowIterables(cellValue, 1);
// }

// void _handleEdit(Sheet budgetsSheet, Budget currentBudget, int index) {
//   final int excelRowNumber = index + 2;

//   _updateCell(
//     budgetsSheet,
//     'B$excelRowNumber',
//     formatDate(currentBudget.createdDate),
//   );
//   _updateCell(budgetsSheet, 'C$excelRowNumber', currentBudget.name);
//   _updateCell(budgetsSheet, 'D$excelRowNumber', currentBudget.category);
//   _updateCell(
//     budgetsSheet,
//     'E$excelRowNumber',
//     currentBudget.target.toString(),
//   );
//   _updateCell(budgetsSheet, 'G$excelRowNumber', currentBudget.notes ?? '');
// }

// void _updateCell(Sheet sheet, String cellIndex, String value) {
//   sheet.updateCell(CellIndex.indexByString(cellIndex), TextCellValue(value));
// }

// Future<void> updateBudgetExpense(Budget budget, int index) async {
//   await _writeBudgetExpense(budget, index);
// }

// Future<void> _writeBudgetExpense(Budget currentBudget, int index) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet budgetsSheet = excelSheet(excel, 'Budgets');

//   if (index > -1) {
//     final int excelRowNumber = index + 2;
//     budgetsSheet.updateCell(
//       CellIndex.indexByString('F$excelRowNumber'),
//       TextCellValue(currentBudget.expense.toString()),
//     );
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }
