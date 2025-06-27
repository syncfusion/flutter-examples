// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';

// import '../enum.dart';
// import '../helper/currency_and_data_format/currency_format.dart';
// import '../helper/excel_header_row.dart';
// import '../models/transaction.dart';
// import '../models/transactional_details.dart';
// import '../models/user.dart';
// import '../models/user_profile.dart';
// import 'utils.dart';
// import 'windows_path_file.dart';

import '../models/transaction.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import 'utils.dart';

List<Transaction> readTransactions(UserDetails userDetails) {
  final TransactionalDetails transactionalDetails =
      readAllTransactionDetailCollections(userDetails);
  final List<Transaction> transactions = [];

  if (transactionalDetails.transactions.isNotEmpty) {
    transactions.addAll(transactionalDetails.transactions);
  }
  return transactions;
}

// TODO(Praveen): Replace this excel code with csv or xml format code.

// Future<void> updateTransactions(
//   UserDetails userDetails,
//   Transaction transaction,
//   UserInteractions userInteraction,
//   List<int> indexes,
// ) async {
//   switch (userInteraction) {
//     case UserInteractions.add:
//     case UserInteractions.edit:
//       await _writeTransactions(
//         transaction,
//         userInteraction,
//         userDetails.userProfile,
//         indexes,
//       );
//       break;
//     case UserInteractions.delete:
//       _deleteTransactions(transaction, indexes);
//   }
// }

// Future<void> _deleteTransactions(
//   Transaction currentTransaction,
//   List<int> indexes,
// ) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet transactionsSheet = excelSheet(excel, 'Transactions');

//   if (indexes.isNotEmpty) {
//     for (final int index in indexes) {
//       if (index != -1) {
//         final int excelRowIndex = index + 1;
//         transactionsSheet.removeRow(excelRowIndex);
//       }
//     }
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// Future<void> _writeTransactions(
//   Transaction transaction,
//   UserInteractions userInteraction,
//   Profile userProfile,
//   List<int> indexes,
// ) async {
//   final String filePath = await getFilePath();
//   final File file = File(filePath);
//   final Excel excel = await createOrGetExcelFile();
//   final Sheet transactionsSheet = excelSheet(excel, 'Transactions');

//   switch (userInteraction) {
//     case UserInteractions.add:
//       _handleAdd(transactionsSheet, transaction, userProfile);
//       break;
//     case UserInteractions.edit:
//       _handleEdit(transactionsSheet, transaction, userProfile, indexes);
//       break;
//     case UserInteractions.delete:
//       break;
//   }

//   final List<int>? saveBytes = excel.save();
//   if (saveBytes != null) {
//     await file.writeAsBytes(Uint8List.fromList(saveBytes));
//   }
// }

// void _handleAdd(
//   Sheet transactionsSheet,
//   Transaction transaction,
//   Profile userProfile,
// ) {
//   final List<CellValue> cellValue = transactionsCellValue(
//     transaction,
//     userProfile,
//   );
//   transactionsSheet.insertRow(1);
//   transactionsSheet.insertRowIterables(cellValue, 1);
// }

// void _handleEdit(
//   Sheet transactionsSheet,
//   Transaction transaction,
//   Profile userProfile,
//   List<int> indexes,
// ) {
//   final int index = indexes[0];
//   if (index != -1) {
//     final int excelRowNumber = index + 2;
//     _updateCell(
//       transactionsSheet,
//       'B$excelRowNumber',
//       transaction.transactionDate.toString(),
//     );
//     _updateCell(transactionsSheet, 'C$excelRowNumber', transaction.category);
//     _updateCell(transactionsSheet, 'D$excelRowNumber', transaction.subCategory);
//     _updateCell(transactionsSheet, 'E$excelRowNumber', transaction.type);
//     _updateCell(
//       transactionsSheet,
//       'F$excelRowNumber',
//       toCurrency(transaction.amount, userProfile),
//     );
//     _updateCell(transactionsSheet, 'G$excelRowNumber', transaction.remark);
//   }
// }

// void _updateCell(Sheet sheet, String cellIndex, String value) {
//   sheet.updateCell(CellIndex.indexByString(cellIndex), TextCellValue(value));
// }
