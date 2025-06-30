///Package imports
import 'package:flutter/material.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

/// Render save as CSV
class SaveAsCSV extends SampleView {
  /// Render save as CSV
  const SaveAsCSV(Key key) : super(key: key);
  @override
  _SaveAsCSV createState() => _SaveAsCSV();
}

class _SaveAsCSV extends SampleViewState {
  _SaveAsCSV();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This sample shows how to export data to CSV format with text, date time, and numbers with number formatting. This feature also allows exporting the data to CSV format with custom separators instead of the default comma separator.',
              style: TextStyle(fontSize: 16, color: model.textColor),
            ),
            const SizedBox(height: 20, width: 30),
            Align(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    model.primaryColor,
                  ),
                  padding: model.isMobile
                      ? null
                      : WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                        ),
                ),
                onPressed: _generateExcel,
                child: const Text(
                  'Generate Excel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateExcel() async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();

    final Worksheet worksheet = workbook.worksheets[0];
    worksheet.name = 'csv format';
    worksheet.showGridlines = false;

    worksheet.enableSheetCalculations();
    worksheet.getRangeByName('A1').setText('Date');
    worksheet.getRangeByName('B1').setText('Region');
    worksheet.getRangeByName('C1').setText('Employee');
    worksheet.getRangeByName('D1').setText('Item');
    worksheet.getRangeByName('E1').setText('Units');
    worksheet.getRangeByName('F1').setText('Unit Cost');
    worksheet.getRangeByName('G1').setText('Total');

    worksheet.getRangeByName('A2').setDateTime(DateTime(2007, 12, 15));
    worksheet.getRangeByName('A3').setDateTime(DateTime(2007, 12, 18));
    worksheet.getRangeByName('A4').setDateTime(DateTime(2007, 12, 21));
    worksheet.getRangeByName('A5').setDateTime(DateTime(2007, 12, 24));
    worksheet.getRangeByName('A6').setDateTime(DateTime(2007, 12, 27));
    worksheet.getRangeByName('A7').setDateTime(DateTime(2007, 12, 30));
    worksheet.getRangeByName('A8').setDateTime(DateTime(2008, 1, 2));

    worksheet.getRangeByName('B2').setText('Central');
    worksheet.getRangeByName('B3').setText('Wast');
    worksheet.getRangeByName('B4').setText('Central');
    worksheet.getRangeByName('B5').setText('East');
    worksheet.getRangeByName('B6').setText('East');
    worksheet.getRangeByName('B7').setText('East');
    worksheet.getRangeByName('B8').setText('East');

    worksheet.getRangeByName('C2').setText('Jones');
    worksheet.getRangeByName('C3').setText('Kivell');
    worksheet.getRangeByName('C4').setText('Howard');
    worksheet.getRangeByName('C5').setText('Gill');
    worksheet.getRangeByName('C6').setText('Anderson');
    worksheet.getRangeByName('C7').setText('Anderson');
    worksheet.getRangeByName('C8').setText('Anderson');

    worksheet.getRangeByName('D2').setText('Pen Set');
    worksheet.getRangeByName('D3').setText('Binder');
    worksheet.getRangeByName('D4').setText('Pen & Pencil');
    worksheet.getRangeByName('D5').setText('Pen');
    worksheet.getRangeByName('D6').setText('Binder');
    worksheet.getRangeByName('D7').setText('Pen Set');
    worksheet.getRangeByName('D8').setText('Pen Set');

    worksheet.getRangeByName('E2').number = 700;
    worksheet.getRangeByName('E3').number = 85;
    worksheet.getRangeByName('E4').number = 62;
    worksheet.getRangeByName('E5').number = 58;
    worksheet.getRangeByName('E6').number = 10;
    worksheet.getRangeByName('E7').number = 19;
    worksheet.getRangeByName('E8').number = 6;

    worksheet.getRangeByName('F2').number = 1.99;
    worksheet.getRangeByName('F3').number = 19.99;
    worksheet.getRangeByName('F4').number = 4.99;
    worksheet.getRangeByName('F5').number = 19.99;
    worksheet.getRangeByName('F6').number = 4.99;
    worksheet.getRangeByName('F7').number = 2.99;
    worksheet.getRangeByName('F8').number = 1.99;

    worksheet.getRangeByName('F2:F8').numberFormat = r"'$'#,##0.00";

    worksheet.getRangeByName('G2').formula = 'E2*F2';
    worksheet.getRangeByName('G3').formula = 'E3*F3';
    worksheet.getRangeByName('G4').formula = 'E4*F4';
    worksheet.getRangeByName('G5').formula = 'E5*F5';
    worksheet.getRangeByName('G6').formula = 'E6*F6';
    worksheet.getRangeByName('G7').formula = 'E7*F7';
    worksheet.getRangeByName('G8').formula = 'E8*F8';

    worksheet.getRangeByName('G2:G8').numberFormat = r"'$'#,##0_)";

    final List<int> bytes = workbook.saveAsCSV(',');
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'SaveAsCSV.csv');
  }
}
