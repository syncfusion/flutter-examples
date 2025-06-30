///Package imports
import 'package:flutter/material.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:syncfusion_officechart/officechart.dart';

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

/// Render XlsIO of yearly sales
class YearlySalesXlsIO extends SampleView {
  /// Render XlsIO of yearly sales
  const YearlySalesXlsIO(Key key) : super(key: key);
  @override
  _YearlySalesXlsIOState createState() => _YearlySalesXlsIOState();
}

class _YearlySalesXlsIOState extends SampleViewState {
  _YearlySalesXlsIOState();

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
              'This sample showcases on how to create a simple Excel report for yearly sales with data, chart, formulas, and cell formatting using XlsIO.',
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
    sheet.name = 'Sales Report';
    sheet.showGridlines = false;
    final Worksheet sheet2 = workbook.worksheets.addWithName('Data');
    sheet.enableSheetCalculations();

    sheet.getRangeByIndex(1, 1, 1, 7).merge();
    final Range range = sheet.getRangeByName('A1');
    range.rowHeight = 22.5;
    range.text = 'Yearly Sales';
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.bold = true;
    range.cellStyle.fontSize = 14;
    range.cellStyle.backColor = '#9BC2E6';

    sheet.getRangeByName('A1').columnWidth = 2.71;
    sheet.getRangeByName('B1').columnWidth = 10.27;
    sheet.getRangeByName('C1').columnWidth = 10.27;
    sheet.getRangeByName('D1').columnWidth = 0.19;
    sheet.getRangeByName('E1').columnWidth = 10.27;
    sheet.getRangeByName('F1').columnWidth = 10.27;
    sheet.getRangeByName('G1').columnWidth = 2.71;

    sheet.getRangeByIndex(1, 1, 1, 7).merge();

    sheet.getRangeByName('A13').rowHeight = 12;
    sheet.getRangeByName('A14').rowHeight = 21;
    sheet.getRangeByName('A15').rowHeight = 15;
    sheet.getRangeByName('A16').rowHeight = 3;
    sheet.getRangeByName('A17').rowHeight = 21;
    sheet.getRangeByName('A18').rowHeight = 15;
    sheet.getRangeByName('A19').rowHeight = 12;

    final Range range5 = sheet.getRangeByName('B14:C14');
    final Range range6 = sheet.getRangeByName('B15:C15');
    final Range range7 = sheet.getRangeByName('B17:C17');
    final Range range8 = sheet.getRangeByName('B18:C18');
    final Range range9 = sheet.getRangeByName('E14:F14');
    final Range range10 = sheet.getRangeByName('E15:F15');
    final Range range11 = sheet.getRangeByName('E17:F17');
    final Range range12 = sheet.getRangeByName('E18:F18');

    range5.text = r'$ 4.51 M';
    range9.formula = '=Data!D14';
    range7.formula = '=Data!C19';
    range11.formula = '=Data!E14';

    range5.merge();
    range6.merge();
    range7.merge();
    range8.merge();
    range9.merge();
    range10.merge();
    range11.merge();
    range12.merge();

    final List<Style> styles = createStyles(workbook);
    range5.cellStyle = styles[0];
    range9.cellStyle = styles[1];
    range7.cellStyle = styles[2];
    range11.cellStyle = styles[3];

    range6.cellStyle = styles[4];
    range6.text = 'Sales Amount';
    range10.cellStyle = styles[5];
    range10.text = 'Average Unit Price';
    range8.cellStyle = styles[6];
    range8.text = 'Gross Profit Margin';
    range12.cellStyle = styles[7];
    range12.text = 'Customer Count';

    sheet2.getRangeByName('B1').columnWidth = 22.27;
    sheet2.getRangeByName('C1').columnWidth = 22.27;
    sheet2.getRangeByName('D1').columnWidth = 9.27;
    sheet2.getRangeByName('E1').columnWidth = 9.27;

    sheet2.getRangeByName('A1').text = 'Months';
    sheet2.getRangeByName('B1').text = 'Internet Sales Amount';
    sheet2.getRangeByName('C1').text = 'Reseller Sales Amount';
    sheet2.getRangeByName('D1').text = 'Unit Price';
    sheet2.getRangeByName('E1').text = 'Customers';

    sheet2.getRangeByName('A2').text = 'Jan';
    sheet2.getRangeByName('A3').text = 'Feb';
    sheet2.getRangeByName('A4').text = 'Mar';
    sheet2.getRangeByName('A5').text = 'Apr';
    sheet2.getRangeByName('A6').text = 'May';
    sheet2.getRangeByName('A7').text = 'June';
    sheet2.getRangeByName('A8').text = 'Jul';
    sheet2.getRangeByName('A9').text = 'Aug';
    sheet2.getRangeByName('A10').text = 'Sep';
    sheet2.getRangeByName('A11').text = 'Oct';
    sheet2.getRangeByName('A12').text = 'Nov';
    sheet2.getRangeByName('A13').text = 'Dec';
    sheet2.getRangeByName('A14').text = 'Total';

    sheet2.getRangeByName('B2').number = 226170;
    sheet2.getRangeByName('B3').number = 212259;
    sheet2.getRangeByName('B4').number = 181079;
    sheet2.getRangeByName('B5').number = 188809;
    sheet2.getRangeByName('B6').number = 198195;
    sheet2.getRangeByName('B7').number = 235524;
    sheet2.getRangeByName('B8').number = 185786;
    sheet2.getRangeByName('B9').number = 196745;
    sheet2.getRangeByName('B10').number = 164897;
    sheet2.getRangeByName('B11').number = 175673;
    sheet2.getRangeByName('B12').number = 212896;
    sheet2.getRangeByName('B13').number = 325634;
    sheet2.getRangeByName('B14').formula = '=SUM(B2:B13)';

    sheet2.getRangeByName('C2').number = 170234;
    sheet2.getRangeByName('C3').number = 189456;
    sheet2.getRangeByName('C4').number = 168795;
    sheet2.getRangeByName('C5').number = 143567;
    sheet2.getRangeByName('C6').number = 163567;
    sheet2.getRangeByName('C7').number = 163546;
    sheet2.getRangeByName('C8').number = 143787;
    sheet2.getRangeByName('C9').number = 149898;
    sheet2.getRangeByName('C10').number = 153784;
    sheet2.getRangeByName('C11').number = 164289;
    sheet2.getRangeByName('C12').number = 172453;
    sheet2.getRangeByName('C13').number = 223430;
    sheet2.getRangeByName('C14').formula = '=SUM(C2:C13)';

    sheet2.getRangeByName('D2').number = 202;
    sheet2.getRangeByName('D3').number = 204;
    sheet2.getRangeByName('D4').number = 191;
    sheet2.getRangeByName('D5').number = 223;
    sheet2.getRangeByName('D6').number = 203;
    sheet2.getRangeByName('D7').number = 185;
    sheet2.getRangeByName('D8').number = 198;
    sheet2.getRangeByName('D9').number = 196;
    sheet2.getRangeByName('D10').number = 220;
    sheet2.getRangeByName('D11').number = 218;
    sheet2.getRangeByName('D12').number = 299;
    sheet2.getRangeByName('D13').number = 185;
    sheet2.getRangeByName('D14').formula = '=AVERAGE(D2:D13)';

    sheet2.getRangeByName('E2').number = 1861;
    sheet2.getRangeByName('E3').number = 1522;
    sheet2.getRangeByName('E4').number = 1410;
    sheet2.getRangeByName('E5').number = 1488;
    sheet2.getRangeByName('E6').number = 1781;
    sheet2.getRangeByName('E7').number = 2155;
    sheet2.getRangeByName('E8').number = 1657;
    sheet2.getRangeByName('E9').number = 1767;
    sheet2.getRangeByName('E10').number = 1448;
    sheet2.getRangeByName('E11').number = 1556;
    sheet2.getRangeByName('E12').number = 1928;
    sheet2.getRangeByName('E13').number = 2956;
    sheet2.getRangeByName('E14').formula = '=SUM(E2:E13)';

    sheet2.getRangeByName('B17').text = '2018 Sales';
    sheet2.getRangeByName('B18').text = '2018 Sales';
    sheet2.getRangeByName('B19').text = 'Gain %';
    sheet2.getRangeByName('C17').number = 3845634;
    sheet2.getRangeByName('C18').formula = '=B14+C14';
    sheet2.getRangeByName('C19').formula = '=(C18-C17)/10000000';

    sheet2.getRangeByName('C19').numberFormat = '0.00%';
    sheet2.getRangeByName('C17:C18').numberFormat = r'_($ #,##0.00';
    sheet2.getRangeByName('B2:D14').numberFormat = r'_($ #,##0.00';

    sheet2.getRangeByName('A1:E1').cellStyle.backColor = '#C6E0B4';
    sheet2.getRangeByName('A1:E1').cellStyle.bold = true;
    sheet2.getRangeByName('A14:E14').cellStyle.backColor = '#C6E0B4';
    sheet2.getRangeByName('A14:E14').cellStyle.bold = true;
    sheet.getRangeByName('G30').text = '.';

    final ChartCollection charts = ChartCollection(sheet);
    final Chart chart1 = charts.add();
    chart1.chartType = ExcelChartType.column;
    chart1.dataRange = sheet2.getRangeByName('A1:B13');
    chart1.isSeriesInRows = false;
    chart1.chartTitleArea.bold = true;
    chart1.chartTitleArea.size = 12;
    chart1.legend!.position = ExcelLegendPosition.bottom;
    chart1.primaryValueAxis.numberFormat = r'$#,###';
    chart1.primaryValueAxis.hasMajorGridLines = false;
    chart1.topRow = 2;
    chart1.bottomRow = 13;
    chart1.leftColumn = 1;
    chart1.rightColumn = 8;

    final Chart chart2 = charts.add();
    chart2.chartType = ExcelChartType.lineMarkers;
    chart2.dataRange = sheet2.getRangeByName('A1:C13');
    chart2.isSeriesInRows = false;
    chart2.chartTitleArea.bold = true;
    chart2.chartTitleArea.size = 11;
    chart2.chartTitleArea.color = '#595959';
    chart2.chartTitleArea.text = 'Internet Sales vs Reseller Sales';
    chart2.legend!.position = ExcelLegendPosition.bottom;
    chart2.legend!.textArea.size = 9;
    chart2.legend!.textArea.color = '#595959';
    chart2.topRow = 20;
    chart2.bottomRow = 32;
    chart2.leftColumn = 1;
    chart2.rightColumn = 8;
    chart2.primaryValueAxis.numberFormat = r'$#,###';
    chart2.primaryValueAxis.hasMajorGridLines = false;
    chart2.primaryCategoryAxis.titleArea.size = 9;
    chart2.primaryCategoryAxis.titleArea.color = '#595959';
    chart2.primaryValueAxis.titleArea.size = 9;
    chart2.primaryValueAxis.titleArea.color = '#595959';

    sheet.charts = charts;

    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'YearlySale.xlsx');
  }

  // Create styles for worksheet
  List<Style> createStyles(Workbook workbook) {
    final Style style1 = workbook.styles.add('style1');
    style1.backColor = '#9BC2E6';
    style1.fontSize = 18;
    style1.bold = true;
    style1.numberFormat = r'$#,##0.00';
    style1.hAlign = HAlignType.center;
    style1.vAlign = VAlignType.center;
    style1.borders.top.lineStyle = LineStyle.thin;
    style1.borders.top.color = '#757171';
    style1.borders.right.lineStyle = LineStyle.thin;
    style1.borders.right.color = '#757171';
    style1.borders.left.lineStyle = LineStyle.thin;
    style1.borders.left.color = '#757171';

    final Style style2 = workbook.styles.add('style2');
    style2.backColor = '#F4B084';
    style2.fontSize = 18;
    style2.bold = true;
    style2.numberFormat = r'$#,##0.00';
    style2.hAlign = HAlignType.center;
    style2.vAlign = VAlignType.center;
    style2.borders.top.lineStyle = LineStyle.thin;
    style2.borders.top.color = '#757171';
    style2.borders.right.lineStyle = LineStyle.thin;
    style2.borders.right.color = '#757171';
    style2.borders.left.lineStyle = LineStyle.thin;
    style2.borders.left.color = '#757171';

    final Style style3 = workbook.styles.add('style3');
    style3.backColor = '#FFD966';
    style3.fontSize = 18;
    style3.bold = true;
    style3.numberFormat = '0.00%';
    style3.hAlign = HAlignType.center;
    style3.vAlign = VAlignType.center;
    style3.borders.top.lineStyle = LineStyle.thin;
    style3.borders.top.color = '#757171';
    style3.borders.right.lineStyle = LineStyle.thin;
    style3.borders.right.color = '#757171';
    style3.borders.left.lineStyle = LineStyle.thin;
    style3.borders.left.color = '#757171';

    final Style style4 = workbook.styles.add('style4');
    style4.backColor = '#A9D08E';
    style4.fontSize = 18;
    style4.bold = true;
    style4.numberFormat = '#,###';
    style4.hAlign = HAlignType.center;
    style4.vAlign = VAlignType.center;
    style4.borders.top.lineStyle = LineStyle.thin;
    style4.borders.top.color = '#757171';
    style4.borders.right.lineStyle = LineStyle.thin;
    style4.borders.right.color = '#757171';
    style4.borders.left.lineStyle = LineStyle.thin;
    style4.borders.left.color = '#757171';

    final Style style5 = workbook.styles.add('style5');
    style5.backColor = '#9BC2E6';
    style5.fontColor = '#757171';
    style5.hAlign = HAlignType.center;
    style5.vAlign = VAlignType.center;
    style5.borders.bottom.lineStyle = LineStyle.thin;
    style5.borders.bottom.color = '#757171';
    style5.borders.right.lineStyle = LineStyle.thin;
    style5.borders.right.color = '#757171';
    style5.borders.left.lineStyle = LineStyle.thin;
    style5.borders.left.color = '#757171';

    final Style style6 = workbook.styles.add('style6');
    style6.backColor = '#F4B084';
    style6.fontColor = '#757171';
    style6.hAlign = HAlignType.center;
    style6.vAlign = VAlignType.center;
    style6.borders.bottom.lineStyle = LineStyle.thin;
    style6.borders.bottom.color = '#757171';
    style6.borders.right.lineStyle = LineStyle.thin;
    style6.borders.right.color = '#757171';
    style6.borders.left.lineStyle = LineStyle.thin;
    style6.borders.left.color = '#757171';

    final Style style7 = workbook.styles.add('style7');
    style7.backColor = '#FFD966';
    style7.fontColor = '#757171';
    style7.hAlign = HAlignType.center;
    style7.vAlign = VAlignType.center;
    style7.borders.bottom.lineStyle = LineStyle.thin;
    style7.borders.bottom.color = '#757171';
    style7.borders.right.lineStyle = LineStyle.thin;
    style7.borders.right.color = '#757171';
    style7.borders.left.lineStyle = LineStyle.thin;
    style7.borders.left.color = '#757171';

    final Style style8 = workbook.styles.add('style8');
    style8.backColor = '#A9D08E';
    style8.fontColor = '#757171';
    style8.hAlign = HAlignType.center;
    style8.vAlign = VAlignType.center;
    style8.borders.bottom.lineStyle = LineStyle.thin;
    style8.borders.bottom.color = '#757171';
    style8.borders.right.lineStyle = LineStyle.thin;
    style8.borders.right.color = '#757171';
    style8.borders.left.lineStyle = LineStyle.thin;
    style8.borders.left.color = '#757171';

    return <Style>[
      style1,
      style2,
      style3,
      style4,
      style5,
      style6,
      style7,
      style8,
    ];
  }
}
