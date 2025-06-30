// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../enum.dart';
// import '../helper/currency_and_data_format/currency_format.dart';
// import '../helper/currency_and_data_format/date_format.dart';
// import '../helper/excel_header_row.dart';
// import '../models/saving.dart';
// import '../models/transactional_details.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';
// import 'utils.dart';
// import 'web_path_file.dart';

import '../models/saving.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import 'utils.dart';

List<Saving> readSavings(UserDetails userDetails) {
  final TransactionalDetails transactionalDetails =
      readAllTransactionDetailCollections(userDetails);
  final List<Saving> savings = <Saving>[];

  if (transactionalDetails.savings.isNotEmpty) {
    savings.addAll(transactionalDetails.savings);
  }
  return savings;
}

// TODO(Praveen): Replace this excel code with csv or xml format code.

// Future<void> updateSavings(
//   UserDetails userDetails,
//   Saving saving,
//   UserInteractions userInteraction,
//   List<int> indexes,
// ) async {
//   switch (userInteraction) {
//     case UserInteractions.add:
//     case UserInteractions.edit:
//       await _writeSavings(
//         saving,
//         userInteraction,
//         userDetails.userProfile,
//         indexes,
//       );
//       break;
//     case UserInteractions.delete:
//       _deleteSavings(saving, indexes);
//   }
// }

// Future<void> _deleteSavings(Saving currentSaving, List<int> indexes) async {
//   final SharedPreferences preferences = await SharedPreferences.getInstance();
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet savingsSheet = excelSheet(excel, 'Savings');

//   if (indexes.isNotEmpty) {
//     for (final int index in indexes) {
//       if (index != -1) {
//         final int excelRowIndex = index + 1;
//         savingsSheet.removeRow(excelRowIndex);
//       }
//     }
//   }

//   final List<int>? saveBytes = excel.save();
//   // Convert the bytes to a base64 string and save to SharedPreferences
//   if (saveBytes != null) {
//     final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
//     await preferences.setString(sharedPreferencesKey, base64Data);
//   }
// }

// Future<void> _writeSavings(
//   Saving saving,
//   UserInteractions userInteraction,
//   Profile userProfile,
//   List<int> indexes,
// ) async {
//   final SharedPreferences preferences = await SharedPreferences.getInstance();
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet savingsSheet = excelSheet(excel, 'Savings');

//   switch (userInteraction) {
//     case UserInteractions.add:
//       _handleAdd(savingsSheet, saving, userProfile);
//       break;
//     case UserInteractions.edit:
//       _handleEdit(savingsSheet, saving, userProfile, indexes);
//       break;
//     case UserInteractions.delete:
//       break;
//   }

//   final List<int>? saveBytes = excel.save();
//   // Convert the bytes to a base64 string and save to SharedPreferences
//   if (saveBytes != null) {
//     final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
//     await preferences.setString(sharedPreferencesKey, base64Data);
//   }
// }

// void _handleAdd(Sheet savingsSheet, Saving saving, Profile userProfile) {
//   final List<CellValue> cellValue = savingsCellValue(saving, userProfile);
//   savingsSheet.insertRow(1);
//   savingsSheet.insertRowIterables(cellValue, 1);
// }

// void _handleEdit(
//   Sheet savingsSheet,
//   Saving saving,
//   Profile userProfile,
//   List<int> indexes,
// ) {
//   final int index = indexes[0];
//   if (index != -1) {
//     final int excelRowNumber = index + 2;
//     _updateCell(
//       savingsSheet,
//       'B$excelRowNumber',
//       formatDate(saving.savingDate),
//     );
//     _updateCell(savingsSheet, 'C$excelRowNumber', saving.name);
//     _updateCell(savingsSheet, 'D$excelRowNumber', saving.type);
//     _updateCell(
//       savingsSheet,
//       'E$excelRowNumber',
//       toCurrency(saving.savedAmount, userProfile),
//     );
//     _updateCell(savingsSheet, 'F$excelRowNumber', saving.remark);
//   }
// }

// void _updateCell(Sheet savingsSheet, String cellIndex, String value) {
//   savingsSheet.updateCell(
//     CellIndex.indexByString(cellIndex),
//     TextCellValue(value),
//   );
// }
