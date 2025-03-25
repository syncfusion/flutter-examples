import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import '../enum.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/excel_header_row.dart';
import '../models/transaction.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';
import 'windows_path_file.dart';

List<Transaction> readTransactions(UserDetails userDetails) {
  final List<TransactionalDetails> allTransactionalDetails =
      readAllTransactionDetailCollections(userDetails);
  final List<Transaction> transactions = [];

  if (allTransactionalDetails.isNotEmpty) {
    for (final TransactionalDetails transactionalDetails
        in allTransactionalDetails) {
      if (transactionalDetails.transactions.isNotEmpty) {
        transactions.addAll(transactionalDetails.transactions);
      }
    }
  }
  return transactions;
}

Future<void> updateTransactions(
  BuildContext context,
  UserDetails userDetails,
  Transaction transaction,
  UserInteractions userInteraction,
  List<int> indexes, {
  bool isNewUser = false,
}) async {
  if (userInteraction == UserInteractions.add ||
      userInteraction == UserInteractions.edit) {
    await _writeTransactions(
      transaction,
      userInteraction,
      userDetails.userProfile,
      indexes,
    );
  } else {
    _deleteTransactions(transaction, indexes);
  }
}

Future<void> _deleteTransactions(
  Transaction currentTransaction,
  List<int> indexes,
) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final Sheet transactionsSheet = getSheet(excel, 'Transactions');

  if (indexes.isNotEmpty) {
    for (final int index in indexes) {
      if (index != -1) {
        final int excelRowIndex = index + 1;
        transactionsSheet.removeRow(excelRowIndex);
      }
    }
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}

Future<void> _writeTransactions(
  Transaction transaction,
  UserInteractions userInteraction,
  Profile userProfile,
  List<int> indexes,
) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final transactionsSheet = getSheet(excel, 'Transactions');

  if (userInteraction == UserInteractions.add) {
    final List<CellValue> cellValue = transactionsCellValue(
      transaction,
      userProfile,
    );
    transactionsSheet.insertRow(1);
    transactionsSheet.insertRowIterables(cellValue, 1);
  } else {
    final int index = indexes[0];
    if (index != -1) {
      final int excelRowNumber = index + 2;
      transactionsSheet.updateCell(
        CellIndex.indexByString('B$excelRowNumber'),
        TextCellValue(transaction.transactionDate.toString()),
      );
      transactionsSheet.updateCell(
        CellIndex.indexByString('C$excelRowNumber'),
        TextCellValue(transaction.category),
      );
      transactionsSheet.updateCell(
        CellIndex.indexByString('D$excelRowNumber'),
        TextCellValue(transaction.subCategory),
      );
      transactionsSheet.updateCell(
        CellIndex.indexByString('E$excelRowNumber'),
        TextCellValue(transaction.type),
      );
      transactionsSheet.updateCell(
        CellIndex.indexByString('F$excelRowNumber'),
        TextCellValue(toCurrency(transaction.amount, userProfile)),
      );
      transactionsSheet.updateCell(
        CellIndex.indexByString('G$excelRowNumber'),
        TextCellValue(transaction.remark),
      );
    }
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}
