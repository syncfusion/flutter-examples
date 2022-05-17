///Package imports
import 'package:flutter/material.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.html) '../../common/export/save_file_web.dart';

/// Render XlsIO of table
class TableXlsIO extends SampleView {
  /// Render XlsIO of table
  const TableXlsIO(Key key) : super(key: key);
  @override
  _TableXlsIOState createState() => _TableXlsIOState();
}

class _TableXlsIOState extends SampleViewState {
  _TableXlsIOState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.cardThemeColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'This sample showcases how to create a table in worksheets with header rows, banded rows & columns, total row and built-in styles.',
                style: TextStyle(fontSize: 16, color: model.textColor)),
            const SizedBox(height: 20, width: 30),
            Align(
                child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(model.backgroundColor),
                padding: model.isMobile
                    ? null
                    : MaterialStateProperty.all(const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15)),
              ),
              onPressed: _generateExcel,
              child: const Text('Generate Excel',
                  style: TextStyle(color: Colors.white)),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _generateExcel() async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook(0);
    //Adding a Sheet with name to workbook.
    final Worksheet sheet = workbook.worksheets.addWithName('Table');

    //Load data
    sheet.getRangeByName('A1').setText('Products');
    sheet.getRangeByName('B1').setText('Qtr1');
    sheet.getRangeByName('C1').setText('Qtr2');
    sheet.getRangeByName('D1').setText('Qtr3');
    sheet.getRangeByName('E1').setText('Qtr4');

    sheet.getRangeByName('A2').setText('Alfreds Futterkiste');
    sheet.getRangeByName('B2').setNumber(744.6);
    sheet.getRangeByName('C2').setNumber(162.56);
    sheet.getRangeByName('D2').setNumber(5079.6);
    sheet.getRangeByName('E2').setNumber(1249.2);

    sheet.getRangeByName('A3').setText('Antonio Moreno Taqueria');
    sheet.getRangeByName('B3').setNumber(5079.6);
    sheet.getRangeByName('C3').setNumber(1249.2);
    sheet.getRangeByName('D3').setNumber(943.89);
    sheet.getRangeByName('E3').setNumber(349.6);

    sheet.getRangeByName('A4').setText('Around the Horn');
    sheet.getRangeByName('B4').setNumber(1267.5);
    sheet.getRangeByName('C4').setNumber(1062.5);
    sheet.getRangeByName('D4').setNumber(744.6);
    sheet.getRangeByName('E4').setNumber(162.56);

    sheet.getRangeByName('A5').setText('Bon app');
    sheet.getRangeByName('B5').setNumber(1418);
    sheet.getRangeByName('C5').setNumber(756);
    sheet.getRangeByName('D5').setNumber(1267.5);
    sheet.getRangeByName('E5').setNumber(1062.5);

    sheet.getRangeByName('A6').setText('Eastern Connection');
    sheet.getRangeByName('B6').setNumber(4728);
    sheet.getRangeByName('C6').setNumber(4547.92);
    sheet.getRangeByName('D6').setNumber(1418);
    sheet.getRangeByName('E6').setNumber(756);

    sheet.getRangeByName('A7').setText('Ernst Handel');
    sheet.getRangeByName('B7').setNumber(943.89);
    sheet.getRangeByName('C7').setNumber(349.6);
    sheet.getRangeByName('D7').setNumber(4728);
    sheet.getRangeByName('E7').setNumber(4547.92);

    ///Create a table with the data in a range
    final ExcelTable table =
        sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:E7'));

    ///Formatting table with a built-in style
    table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium9;

    table.showTotalRow = true;
    table.showFirstColumn = true;
    table.showBandedColumns = true;
    table.showBandedRows = true;
    table.columns[0].totalRowLabel = 'Total';
    table.columns[1].totalFormula = ExcelTableTotalFormula.sum;
    table.columns[2].totalFormula = ExcelTableTotalFormula.sum;
    table.columns[3].totalFormula = ExcelTableTotalFormula.sum;
    table.columns[4].totalFormula = ExcelTableTotalFormula.sum;

    final Range range = sheet.getRangeByName('B2:E8');
    range.numberFormat = r'_($* #,##0.00_)';

    sheet.getRangeByName('A1:E7').autoFitColumns();

    //Save and dispose Workbook
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Table.xlsx');
  }
}
