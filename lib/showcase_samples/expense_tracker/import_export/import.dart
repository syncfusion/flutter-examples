// import 'dart:io';

// // import 'package:excel/excel.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import '../data_processing/utils.dart';
// import '../data_processing/windows_path_file.dart'
//     if (dart.library.html) '../data_processing/web_path_file.dart';
// import '../helper/excel_header_row.dart';
// import '../models/user_profile.dart';
// import '../notifiers/import_notifier.dart';

// class ExcelImporter {
//   ExcelImporter({required this.userProfile, required this.context});
//   final Profile userProfile;
//   final BuildContext context;

//   Future<void> importSettingsFromExcel(ImportNotifier import) async {
//     if (kIsWeb) {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: <String>['xlsx'],
//         withData: true,
//       );

//       if (result == null) {
//         throw Exception('No file selected');
//       }

//       // Extract file bytes (if available)
//       final Uint8List? fileBytes = result.files.first.bytes;
//       if (fileBytes != null) {
//         // TODO(sravan): Need to ensure whether to replace the whole excel file.
//         await storeExcelDataInPreferences(fileBytes);

//         if (context.mounted) {
//           final int fileSize = fileBytes.length;
//           final int fileSizeInKB = (fileSize / 1024).round();
//           import.validateFinishButton(
//             fileSizeInKb: fileSizeInKB,
//             fileName: result.files.first.name,
//             enable: true,
//           );
//         }
//       } else {}
//     } else {
//       try {
//         // Pick file using file_picker
//         final FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: <String>['xlsx'],
//         );

//         if (result == null) {
//           throw Exception('No file selected');
//         }

//         final String? filePath = result.files.single.path;
//         if (filePath == null) {
//           throw Exception('Invalid file path');
//         }

//         // Read the selected file
//         final File importFile = File(filePath);
//         final Uint8List bytes = await importFile.readAsBytes();
//         final Excel importExcel = Excel.decodeBytes(bytes);

//         // Get the target directory and create Excel file if it doesn't exist
//         final String targetFilePath = await getFilePath();
//         final File targetFile = File(targetFilePath);
//         final Excel targetExcel = await createOrGetExcelFile();

//         final List<String> sheetsToUpdate = <String>[
//           'Transactions',
//           'Savings',
//           'Goals',
//           'Budgets',
//           'Categories',
//         ];

//         for (final String sheetName in sheetsToUpdate) {
//           if (importExcel.sheets.containsKey(sheetName)) {
//             final Sheet importedSheet = importExcel.sheets[sheetName]!;

//             final Sheet targetSheet = excelSheet(targetExcel, sheetName);

//             if (targetSheet.rows.length > 1) {
//               for (int i = targetSheet.rows.length - 1; i > 0; i--) {
//                 targetSheet.removeRow(i);
//               }
//             }

//             for (
//               int rowIndex = 1;
//               rowIndex < importedSheet.rows.length;
//               rowIndex++
//             ) {
//               final List<Data?> row = importedSheet.rows[rowIndex];
//               if (row.isNotEmpty) {
//                 targetSheet.appendRow(
//                   row
//                       .map(
//                         (Data? cell) =>
//                             TextCellValue(cell?.value.toString() ?? ''),
//                       )
//                       .toList(),
//                 );
//               }
//             }
//           }
//         }
//         final List<int>? saveBytes = targetExcel.save();
//         if (saveBytes != null) {
//           await targetFile.writeAsBytes(saveBytes);
//         }

//         if (context.mounted) {
//           final int fileSize = await targetFile.length();
//           final int fileSizeInKB = (fileSize / 1024).round();
//           import.validateFinishButton(
//             fileSizeInKb: fileSizeInKB,
//             fileName: result.files.first.name,
//             enable: true,
//           );
//         }
//       } catch (e) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No file has been selected.')),
//           );
//         }
//       }
//     }
//   }
// }
