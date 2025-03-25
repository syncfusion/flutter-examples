import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/excel_header_row.dart';
import '../models/saving.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';
import 'web_path_file.dart';

List<Saving> readSavings(UserDetails userDetails) {
  final List<TransactionalDetails> allTransactionalDetails =
      readAllTransactionDetailCollections(userDetails);
  final List<Saving> savings = <Saving>[];

  if (allTransactionalDetails.isNotEmpty) {
    for (final TransactionalDetails transactionalDetails
        in allTransactionalDetails) {
      if (transactionalDetails.savings.isNotEmpty) {
        savings.addAll(transactionalDetails.savings);
      }
    }
  }
  return savings;
}

Future<void> updateSavings(
  BuildContext context,
  UserDetails userDetails,
  Saving saving,
  UserInteractions userInteraction,
  List<int> indexes, {
  bool isNewUser = false,
}) async {
  if (userInteraction == UserInteractions.add ||
      userInteraction == UserInteractions.edit) {
    await _writeSavings(
      saving,
      userInteraction,
      userDetails.userProfile,
      indexes,
    );
  } else {
    _deleteSavings(saving, indexes);
  }
}

Future<void> _deleteSavings(Saving currentSaving, List<int> indexes) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final Excel excel = await createOrGetExcelFile();
  final Sheet savingsSheet = getSheet(excel, 'Savings');

  if (indexes.isNotEmpty) {
    for (final int index in indexes) {
      if (index != -1) {
        final int excelRowIndex = index + 1;
        savingsSheet.removeRow(excelRowIndex);
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

Future<void> _writeSavings(
  Saving saving,
  UserInteractions userInteraction,
  Profile userProfile,
  List<int> indexes,
) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final Excel excel = await createOrGetExcelFile();
  final savingsSheet = getSheet(excel, 'Savings');

  if (userInteraction == UserInteractions.add) {
    final List<CellValue> cellValue = savingsCellValue(saving, userProfile);
    savingsSheet.insertRow(1);
    savingsSheet.insertRowIterables(cellValue, 1);
  } else {
    final int index = indexes[0];
    if (index != -1) {
      final int excelRowNumber = index + 2;
      savingsSheet.updateCell(
        CellIndex.indexByString('B$excelRowNumber'),
        TextCellValue(saving.savingDate.toString()),
      );
      savingsSheet.updateCell(
        CellIndex.indexByString('C$excelRowNumber'),
        TextCellValue(saving.name),
      );
      savingsSheet.updateCell(
        CellIndex.indexByString('D$excelRowNumber'),
        TextCellValue(saving.type),
      );
      savingsSheet.updateCell(
        CellIndex.indexByString('E$excelRowNumber'),
        TextCellValue(toCurrency(saving.savedAmount, userProfile)),
      );
      savingsSheet.updateCell(
        CellIndex.indexByString('F$excelRowNumber'),
        TextCellValue(saving.remark),
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
