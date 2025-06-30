// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';
// import 'package:flutter/foundation.dart';

// import '../enum.dart';
// import '../helper/currency_and_data_format/date_format.dart';
// import '../helper/excel_header_row.dart';
// import '../models/goal.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';
// import 'utils.dart';
// import 'windows_path_file.dart' if (dart.library.html) 'web_path_file.dart';

import '../models/goal.dart';
import '../models/user.dart';

List<Goal> readGoals(UserDetails userDetails) {
  return userDetails.transactionalData.data.goals;
}

// TODO(Praveen): Replace this excel code with csv or xml format code.

// Future<void> updateGoals(
//   UserDetails userDetails,
//   Goal goal,
//   UserInteractions userInteraction, {
//   int index = -1,
// }) async {
//   switch (userInteraction) {
//     case UserInteractions.add:
//     case UserInteractions.edit:
//       await _writeGoals(
//         userInteraction,
//         userDetails.userProfile,
//         goal,
//         index: index,
//       );
//       break;
//     case UserInteractions.delete:
//       await _deleteGoals(goal, index: index);
//   }
// }

// Future<void> _deleteGoals(Goal currentGoal, {int index = -1}) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet goalSheet = excelSheet(excel, 'Goals');

//   if (index != -1) {
//     final int excelRowIndex = index + 1;
//     goalSheet.removeRow(excelRowIndex);
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// Future<void> _writeGoals(
//   UserInteractions userInteractions,
//   Profile profile,
//   Goal currentGoal, {
//   int index = -1,
// }) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet goalSheet = excelSheet(excel, 'Goals');

//   switch (userInteractions) {
//     case UserInteractions.add:
//       _handleAdd(goalSheet, currentGoal, profile);
//       break;
//     case UserInteractions.edit:
//       _handleEdit(goalSheet, currentGoal, profile, index);
//       break;
//     case UserInteractions.delete:
//       break;
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// void _handleAdd(Sheet goalSheet, Goal currentGoal, Profile profile) {
//   final List<TextCellValue> cellValue = goalsCellValue(currentGoal, profile);
//   goalSheet.insertRow(1);
//   goalSheet.insertRowIterables(cellValue, 1);
// }

// void _handleEdit(
//   Sheet goalSheet,
//   Goal currentGoal,
//   Profile profile,
//   int index,
// ) {
//   if (index != -1) {
//     final int excelRowNumber = index + 2;
//     _updateCell(goalSheet, 'C$excelRowNumber', currentGoal.name);
//     _updateCell(goalSheet, 'D$excelRowNumber', currentGoal.category);
//     _updateCell(goalSheet, 'E$excelRowNumber', currentGoal.priority ?? 'Low');
//     _updateCell(goalSheet, 'F$excelRowNumber', formatDate(currentGoal.date));
//     _updateCell(goalSheet, 'G$excelRowNumber', currentGoal.amount.toString());
//     _updateCell(goalSheet, 'I$excelRowNumber', currentGoal.notes ?? '');
//   }
// }

// void _updateCell(Sheet goalSheet, String cellIndex, String value) {
//   goalSheet.updateCell(
//     CellIndex.indexByString(cellIndex),
//     TextCellValue(value),
//   );
// }

// Future<void> updateGoalFund(Goal goal, int index) async {
//   await _writeGoalFund(goal, index);
// }

// Future<void> _writeGoalFund(Goal currentGoal, int index) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet goalSheet = excelSheet(excel, 'Goals');

//   if (index > -1) {
//     final int excelRowNumber = index + 2;
//     goalSheet.updateCell(
//       CellIndex.indexByString('H$excelRowNumber'),
//       TextCellValue(currentGoal.fund.toString()),
//     );
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }
