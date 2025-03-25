import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import '../enum.dart';
import '../helper/excel_header_row.dart';
import '../models/goal.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'utils.dart';
import 'windows_path_file.dart' if (dart.library.html) 'web_path_file.dart';

List<Goal> readGoals(BuildContext context, UserDetails userDetails) {
  final List<TransactionalDetails> allTransactionDetails =
      readAllTransactionDetailCollections(userDetails);
  // final AppLocalizations localizations = AppLocalizations.of(context)!;
  final List<Goal> overallGoals = <Goal>[];
  for (final TransactionalDetails transactionalDetails
      in allTransactionDetails) {
    overallGoals.addAll(transactionalDetails.goals);
  }

  // for (final Goal currentGoal in overallGoals) {
  //   if (selectedSegment == localizations.completed && currentGoal.isCompleted) {
  //     filteredGoals.add(currentGoal);
  //   } else if (selectedSegment == localizations.currentGoals &&
  //       !currentGoal.isCompleted) {
  //     filteredGoals.add(currentGoal);
  //   }
  // }

  return overallGoals;
}

Future<void> updateGoals(
  BuildContext context,
  UserDetails userDetails,
  Goal goal,
  UserInteractions userInteraction, {
  bool isNewUser = false,
  int index = -1,
}) async {
  final List<Goal> goals = readGoals(context, userDetails);

  await _writeGoals(goals, userDetails.userProfile, index: index);
}

Future<void> _writeGoals(
  List<Goal> goals,
  Profile userProfile, {
  int index = -1,
}) async {
  final String filePath = await getFilePath();
  final File file = File(filePath);
  final Excel excel = await createOrGetExcelFile();
  final goalsSheet = getSheet(excel, 'Goals');

  if (goals.isNotEmpty) {
    for (final Goal goal in goals) {
      final List<CellValue> cellValue = goalsCellValue(goal, userProfile);
      goalsSheet.insertRowIterables(cellValue, goalsSheet.rows.length);
    }
  }

  final List<int>? saveBytes = excel.save();
  if (saveBytes == null) {
    throw Exception('Failed to save Excel file.');
  }
  await file.writeAsBytes(Uint8List.fromList(saveBytes));
}
