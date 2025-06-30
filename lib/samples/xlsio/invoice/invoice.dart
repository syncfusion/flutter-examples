///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

/// Render XlsIO of invoice
class InvoiceXlsIO extends SampleView {
  /// Render XlsIO of invoice
  const InvoiceXlsIO(Key key) : super(key: key);
  @override
  _InvoiceXlsIOState createState() => _InvoiceXlsIOState();
}

class _InvoiceXlsIOState extends SampleViewState {
  _InvoiceXlsIOState();

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
              'This sample showcases on how to create a simple Excel invoice with data, image, formulas, named range and cell formatting using XlsIO.',
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
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Invoice';
    sheet.showGridlines = false;

    sheet.getRangeByName('A1').columnWidth = 4.09;
    sheet.getRangeByName('B1:C1').columnWidth = 13.09;
    sheet.getRangeByName('D1').columnWidth = 11.47;
    sheet.getRangeByName('E1').columnWidth = 7.77;
    sheet.getRangeByName('F1').columnWidth = 9;
    sheet.getRangeByName('G1').columnWidth = 8.09;
    sheet.getRangeByName('H1').columnWidth = 3.73;

    sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('B4:D6').merge();

    sheet.getRangeByName('B4').text = 'INVOICE';
    sheet.getRangeByName('B4').cellStyle.bold = true;
    sheet.getRangeByName('B4').cellStyle.fontSize = 32;

    final Style style1 = workbook.styles.add('style1');
    style1.borders.bottom.lineStyle = LineStyle.medium;
    style1.borders.bottom.color = '#AEAAAA';

    sheet.getRangeByName('B7:G7').merge();
    sheet.getRangeByName('B7:G7').cellStyle = style1;

    sheet.getRangeByName('B13:G13').merge();
    sheet.getRangeByName('B13:G13').cellStyle = style1;

    sheet.getRangeByName('B8').text = 'BILL TO:';
    sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet.getRangeByName('B9').text = 'Abraham Swearegin';
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;
    sheet.getRangeByName('B9').cellStyle.bold = true;

    sheet.getRangeByName('B10').text = 'United States, California, San Mateo,';
    sheet.getRangeByName('B10').cellStyle.fontSize = 9;

    sheet.getRangeByName('B11').text = '9920 BridgePointe Parkway,';
    sheet.getRangeByName('B11').cellStyle.fontSize = 9;

    sheet.getRangeByName('B12').number = 9365550136;
    sheet.getRangeByName('B12').cellStyle.fontSize = 9;
    sheet.getRangeByName('B12').cellStyle.hAlign = HAlignType.left;

    final Range range1 = sheet.getRangeByName('F8:G8');
    final Range range2 = sheet.getRangeByName('F9:G9');
    final Range range3 = sheet.getRangeByName('F10:G10');
    final Range range4 = sheet.getRangeByName('E11:G11');
    final Range range5 = sheet.getRangeByName('F12:G12');

    range1.merge();
    range2.merge();
    range3.merge();
    range4.merge();
    range5.merge();

    sheet.getRangeByName('F8').text = 'INVOICE#';
    range1.cellStyle.fontSize = 8;
    range1.cellStyle.bold = true;
    range1.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('F9').number = 2058557939;
    range2.cellStyle.fontSize = 9;
    range2.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('F10').text = 'DATE';
    range3.cellStyle.fontSize = 8;
    range3.cellStyle.bold = true;
    range3.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('E11').dateTime = DateTime(2020, 08, 31);
    sheet.getRangeByName('E11').numberFormat =
        r'[$-x-sysdate]dddd, mmmm dd, yyyy';
    range4.cellStyle.fontSize = 9;
    range4.cellStyle.hAlign = HAlignType.right;

    range5.cellStyle.fontSize = 8;
    range5.cellStyle.bold = true;
    range5.cellStyle.hAlign = HAlignType.right;

    final Range range6 = sheet.getRangeByName('B15:G15');
    range6.cellStyle.fontSize = 10;
    range6.cellStyle.bold = true;

    sheet.getRangeByIndex(15, 2).text = 'Code';
    sheet.getRangeByIndex(16, 2).text = 'CA-1098';
    sheet.getRangeByIndex(17, 2).text = 'LJ-0192';
    sheet.getRangeByIndex(18, 2).text = 'So-B909-M';
    sheet.getRangeByIndex(19, 2).text = 'FK-5136';
    sheet.getRangeByIndex(20, 2).text = 'HL-U509';

    sheet.getRangeByIndex(15, 3).text = 'Description';
    sheet.getRangeByIndex(16, 3).text = 'AWC Logo Cap';
    sheet.getRangeByIndex(17, 3).text = 'Long-Sleeve Logo Jersey, M';
    sheet.getRangeByIndex(18, 3).text = 'Mountain Bike Socks, M';
    sheet.getRangeByIndex(19, 3).text = 'ML Fork';
    sheet.getRangeByIndex(20, 3).text = 'Sports-100 Helmet, Black';

    sheet.getRangeByIndex(15, 3, 15, 4).merge();
    sheet.getRangeByIndex(16, 3, 16, 4).merge();
    sheet.getRangeByIndex(17, 3, 17, 4).merge();
    sheet.getRangeByIndex(18, 3, 18, 4).merge();
    sheet.getRangeByIndex(19, 3, 19, 4).merge();
    sheet.getRangeByIndex(20, 3, 20, 4).merge();

    sheet.getRangeByIndex(15, 5).text = 'Quantity';
    sheet.getRangeByIndex(16, 5).number = 2;
    sheet.getRangeByIndex(17, 5).number = 3;
    sheet.getRangeByIndex(18, 5).number = 2;
    sheet.getRangeByIndex(19, 5).number = 6;
    sheet.getRangeByIndex(20, 5).number = 1;

    sheet.getRangeByIndex(15, 6).text = 'Price';
    sheet.getRangeByIndex(16, 6).number = 8.99;
    sheet.getRangeByIndex(17, 6).number = 49.99;
    sheet.getRangeByIndex(18, 6).number = 9.50;
    sheet.getRangeByIndex(19, 6).number = 175.49;
    sheet.getRangeByIndex(20, 6).number = 34.99;

    sheet.getRangeByIndex(15, 7).text = 'Total';
    sheet.getRangeByIndex(16, 7).formula = '=E16*F16+(E16*F16)';
    sheet.getRangeByIndex(17, 7).formula = '=E17*F17+(E17*F17)';
    sheet.getRangeByIndex(18, 7).formula = '=E18*F18+(E18*F18)';
    sheet.getRangeByIndex(19, 7).formula = '=E19*F19+(E19*F19)';
    sheet.getRangeByIndex(20, 7).formula = '=E20*F20+(E20*F20)';
    sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = r'$#,##0.00';

    sheet.getRangeByName('E15:G15').cellStyle.hAlign = HAlignType.right;
    sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
    sheet.getRangeByName('B15:G15').cellStyle.bold = true;
    sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;

    sheet.getRangeByName('E22:G22').merge();
    sheet.getRangeByName('E22:G22').cellStyle.hAlign = HAlignType.right;
    sheet.getRangeByName('E23:G24').merge();

    final Range range7 = sheet.getRangeByName('E22');
    final Range range8 = sheet.getRangeByName('E23');
    range7.text = 'TOTAL';
    range7.cellStyle.fontSize = 8;
    range7.cellStyle.fontColor = '#4D6575';
    final Range resultRange = sheet.getRangeByName('G16:G20');
    workbook.names.add('AmountPaid', resultRange);
    range8.formula = '=SUM(AmountPaid)';
    range8.numberFormat = r'$#,##0.00';
    range8.cellStyle.fontSize = 24;
    range8.cellStyle.hAlign = HAlignType.right;
    range8.cellStyle.bold = true;

    sheet.getRangeByIndex(26, 1).text =
        '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
    sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;

    final Range range9 = sheet.getRangeByName('A26:H27');
    range9.cellStyle.backColor = '#ACB9CA';
    range9.merge();
    range9.cellStyle.hAlign = HAlignType.center;
    range9.cellStyle.vAlign = VAlignType.center;

    final Picture picture = sheet.pictures.addStream(
      3,
      4,
      await _readImageData('invoice.jpeg'),
    );
    picture.lastRow = 7;
    picture.lastColumn = 8;

    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.xlsx');
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('images/xlsio/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
