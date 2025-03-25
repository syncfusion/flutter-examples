import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/excel_header_row.dart';
import '../models/transaction.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';
import 'web_path_file.dart';

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
  final SharedPreferences preferences = await SharedPreferences.getInstance();
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

  final List<int>? saveBytes = excel.encode();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel data.');
  }
  // Convert the bytes to a base64 string and save to SharedPreferences
  final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
  await preferences.setString(sharedPreferencesKey, base64Data);
}

Future<void> _writeTransactions(
  Transaction transaction,
  UserInteractions userInteraction,
  Profile userProfile,
  List<int> indexes,
) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
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

  final List<int>? saveBytes = excel.encode();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel data.');
  }
  // Convert the bytes to a base64 string and save to SharedPreferences
  final String base64Data = base64Encode(Uint8List.fromList(saveBytes));
  await preferences.setString(sharedPreferencesKey, base64Data);
}
