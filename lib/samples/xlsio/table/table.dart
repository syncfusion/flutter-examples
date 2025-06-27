///Package imports
import 'package:flutter/material.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

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
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This sample showcases how to create a table in worksheets with header rows, banded rows & columns, total row and built-in styles.',
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
    final Workbook workbook = Workbook(0);
    //Adding a Sheet with name to workbook.
    final Worksheet sheet = workbook.worksheets.addWithName('Table');

    //Load data
    sheet.getRangeByName('A1').setText('Products');
    sheet.getRangeByName('B1').setText('Qtr1');
    sheet.getRangeByName('C1').setText('Qtr2');
    sheet.getRangeByName('D1').setText('Qtr3');
    sheet.getRangeByName('E1').setText('Qtr4');

    sheet.getRangeByName('A2').setText('Phone Holder');
    sheet.getRangeByName('B2').setNumber(744.6);
    sheet.getRangeByName('C2').setNumber(162.56);
    sheet.getRangeByName('D2').setNumber(5079.6);
    sheet.getRangeByName('E2').setNumber(1249.2);

    sheet.getRangeByName('A3').setText('Digital Picture Frame');
    sheet.getRangeByName('B3').setNumber(5079.6);
    sheet.getRangeByName('C3').setNumber(1249.2);
    sheet.getRangeByName('D3').setNumber(943.89);
    sheet.getRangeByName('E3').setNumber(349.6);

    sheet.getRangeByName('A4').setText('USB Charging Cable');
    sheet.getRangeByName('B4').setNumber(1267.5);
    sheet.getRangeByName('C4').setNumber(1062.5);
    sheet.getRangeByName('D4').setNumber(744.6);
    sheet.getRangeByName('E4').setNumber(162.56);

    sheet.getRangeByName('A5').setText('Selfie Stick Tripod');
    sheet.getRangeByName('B5').setNumber(1418);
    sheet.getRangeByName('C5').setNumber(756);
    sheet.getRangeByName('D5').setNumber(1267.5);
    sheet.getRangeByName('E5').setNumber(1062.5);

    sheet.getRangeByName('A6').setText('MicroSD Card');
    sheet.getRangeByName('B6').setNumber(4728);
    sheet.getRangeByName('C6').setNumber(4547.92);
    sheet.getRangeByName('D6').setNumber(1418);
    sheet.getRangeByName('E6').setNumber(756);

    sheet.getRangeByName('A7').setText('HDMI Cable');
    sheet.getRangeByName('B7').setNumber(943.89);
    sheet.getRangeByName('C7').setNumber(349.6);
    sheet.getRangeByName('D7').setNumber(4728);
    sheet.getRangeByName('E7').setNumber(4547.92);

    sheet.getRangeByName('A8').setText('Key Finder');
    sheet.getRangeByName('B8').setNumber(149.33);
    sheet.getRangeByName('C8').setNumber(642.04);
    sheet.getRangeByName('D8').setNumber(1249.83);
    sheet.getRangeByName('E8').setNumber(7850.1);

    sheet.getRangeByName('A9').setText('Light Stand');
    sheet.getRangeByName('B9').setNumber(6534.22);
    sheet.getRangeByName('C9').setNumber(3201.95);
    sheet.getRangeByName('D9').setNumber(1002.25);
    sheet.getRangeByName('E9').setNumber(124.60);

    sheet.getRangeByName('A10').setText('External Hard Drive');
    sheet.getRangeByName('B10').setNumber(245.45);
    sheet.getRangeByName('C10').setNumber(955.2);
    sheet.getRangeByName('D10').setNumber(4655.99);
    sheet.getRangeByName('E10').setNumber(8745.45);

    sheet.getRangeByName('A11').setText('Laptop');
    sheet.getRangeByName('B11').setNumber(450.105);
    sheet.getRangeByName('C11').setNumber(1049.54);
    sheet.getRangeByName('D11').setNumber(1248.35);
    sheet.getRangeByName('E11').setNumber(204.1);

    sheet.getRangeByName('A12').setText('Graphic Card');
    sheet.getRangeByName('B12').setNumber(764.77);
    sheet.getRangeByName('C12').setNumber(955.2);
    sheet.getRangeByName('D12').setNumber(100.4);
    sheet.getRangeByName('E12').setNumber(8383.9);

    sheet.getRangeByName('A13').setText('Keyboard');
    sheet.getRangeByName('B13').setNumber(943.89);
    sheet.getRangeByName('C13').setNumber(349.6);
    sheet.getRangeByName('D13').setNumber(4728);
    sheet.getRangeByName('E13').setNumber(4547.92);

    sheet.getRangeByName('A14').setText('Mouse');
    sheet.getRangeByName('B14').setNumber(234.33);
    sheet.getRangeByName('C14').setNumber(982.6);
    sheet.getRangeByName('D14').setNumber(719.7);
    sheet.getRangeByName('E14').setNumber(7249);

    sheet.getRangeByName('A15').setText('Webcam');
    sheet.getRangeByName('B15').setNumber(749.11);
    sheet.getRangeByName('C15').setNumber(349.2);
    sheet.getRangeByName('D15').setNumber(743.09);
    sheet.getRangeByName('E15').setNumber(564.97);

    sheet.getRangeByName('A16').setText('eBook Reader');
    sheet.getRangeByName('B16').setNumber(3217.04);
    sheet.getRangeByName('C16').setNumber(652.5);
    sheet.getRangeByName('D16').setNumber(842.6);
    sheet.getRangeByName('E16').setNumber(242.56);

    sheet.getRangeByName('A17').setText('GPS Navigator');
    sheet.getRangeByName('B17').setNumber(843.5);
    sheet.getRangeByName('C17').setNumber(619.3);
    sheet.getRangeByName('D17').setNumber(167.56);
    sheet.getRangeByName('E17').setNumber(189.5);

    sheet.getRangeByName('A18').setText('Monitor');
    sheet.getRangeByName('B18').setNumber(952.8);
    sheet.getRangeByName('C18').setNumber(4547);
    sheet.getRangeByName('D18').setNumber(1418);
    sheet.getRangeByName('E18').setNumber(756);

    sheet.getRangeByName('A19').setText('Laptop Stand');
    sheet.getRangeByName('B19').setNumber(413.89);
    sheet.getRangeByName('C19').setNumber(349.6);
    sheet.getRangeByName('D19').setNumber(4728);
    sheet.getRangeByName('E19').setNumber(4547.92);

    sheet.getRangeByName('A20').setText('Smartwatch');
    sheet.getRangeByName('B20').setNumber(948.07);
    sheet.getRangeByName('C20').setNumber(642.04);
    sheet.getRangeByName('D20').setNumber(1249.83);
    sheet.getRangeByName('E20').setNumber(7850.1);

    sheet.getRangeByName('A21').setText('Bluetooth Earphones');
    sheet.getRangeByName('B21').setNumber(1134);
    sheet.getRangeByName('C21').setNumber(3201.95);
    sheet.getRangeByName('D21').setNumber(1002.25);
    sheet.getRangeByName('E21').setNumber(124.60);

    sheet.getRangeByName('A22').setText('Reader Case');
    sheet.getRangeByName('B22').setNumber(865.76);
    sheet.getRangeByName('C22').setNumber(955.2);
    sheet.getRangeByName('D22').setNumber(4655.99);
    sheet.getRangeByName('E22').setNumber(8745.45);

    sheet.getRangeByName('A23').setText('Smart Glass');
    sheet.getRangeByName('B23').setNumber(1450.5);
    sheet.getRangeByName('C23').setNumber(1049.54);
    sheet.getRangeByName('D23').setNumber(1248.35);
    sheet.getRangeByName('E23').setNumber(204.1);

    sheet.getRangeByName('A24').setText('Remote Controller');
    sheet.getRangeByName('B24').setNumber(877.75);
    sheet.getRangeByName('C24').setNumber(955.2);
    sheet.getRangeByName('D24').setNumber(100.4);
    sheet.getRangeByName('E24').setNumber(8383.9);

    sheet.getRangeByName('A25').setText('Game Console');
    sheet.getRangeByName('B25').setNumber(343.89);
    sheet.getRangeByName('C25').setNumber(349.6);
    sheet.getRangeByName('D25').setNumber(4728);
    sheet.getRangeByName('E25').setNumber(447.92);

    ///Create a table with the data in a range
    final ExcelTable table = sheet.tableCollection.create(
      'Table1',
      sheet.getRangeByName('A1:E25'),
    );

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

    final Range range = sheet.getRangeByName('B2:E26');
    range.numberFormat = r'_($* #,##0.00_)';

    sheet.getRangeByName('A1:E25').autoFitColumns();
    //Freezepane
    sheet.getRangeByName('A2').freezePanes();

    //Save and dispose Workbook
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Table.xlsx');
  }
}
