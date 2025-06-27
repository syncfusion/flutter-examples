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

/// Render xlsio of expenses report
class ExpensesReportXlsIO extends SampleView {
  /// Render xlsio of expenses report
  const ExpensesReportXlsIO(Key key) : super(key: key);
  @override
  _ExpensesReportXlsIOState createState() => _ExpensesReportXlsIOState();
}

class _ExpensesReportXlsIOState extends SampleViewState {
  _ExpensesReportXlsIOState();

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
              'The XlsIO package is a non-UI and reusable flutter library to create Excel reports programmatically with formatted text, numbers, datetime, number formats, cell styles, images, charts and more.\r\n\r\nThis sample showcases on how to create a simple Excel report for expenses with data, chart, formulas, and cell formatting using XlsIO.',
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
    final Worksheet sheet1 = workbook.worksheets.addWithName('Budget');
    sheet1.showGridlines = false;

    sheet1.enableSheetCalculations();
    sheet1.getRangeByIndex(1, 1).columnWidth = 19.13;
    sheet1.getRangeByIndex(1, 2).columnWidth = 13.65;
    sheet1.getRangeByIndex(1, 3).columnWidth = 12.25;
    sheet1.getRangeByIndex(1, 4).columnWidth = 11.35;
    sheet1.getRangeByIndex(1, 5).columnWidth = 8.09;
    sheet1.getRangeByName('A1:A18').rowHeight = 19.47;

    //Adding cell style.
    final Style style1 = workbook.styles.add('Style1');
    style1.backColor = '#D9E1F2';
    style1.hAlign = HAlignType.left;
    style1.vAlign = VAlignType.center;
    style1.bold = true;

    final Style style2 = workbook.styles.add('Style2');
    style2.backColor = '#8EA9DB';
    style2.vAlign = VAlignType.center;
    style2.numberFormat = r'[Red]($#,###)';
    style2.bold = true;

    sheet1.getRangeByName('A10').cellStyle = style1;
    sheet1.getRangeByName('B10:D10').cellStyle.backColor = '#D9E1F2';
    sheet1.getRangeByName('B10:D10').cellStyle.hAlign = HAlignType.right;
    sheet1.getRangeByName('B10:D10').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('B10:D10').cellStyle.bold = true;

    sheet1.getRangeByName('A11:A17').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.lineStyle =
        LineStyle.thin;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.color = '#BFBFBF';

    sheet1.getRangeByName('D18').cellStyle = style2;
    sheet1.getRangeByName('D18').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.backColor = '#8EA9DB';
    sheet1.getRangeByName('A18:C18').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.bold = true;
    sheet1.getRangeByName('A18:C18').numberFormat = r'$#,###';

    sheet1.getRangeByIndex(10, 1).text = 'Category';
    sheet1.getRangeByIndex(10, 2).text = 'Expected cost';
    sheet1.getRangeByIndex(10, 3).text = 'Actual Cost';
    sheet1.getRangeByIndex(10, 4).text = 'Difference';
    sheet1.getRangeByIndex(11, 1).text = 'Venue';
    sheet1.getRangeByIndex(12, 1).text = 'Seating & Decor';
    sheet1.getRangeByIndex(13, 1).text = 'Technical team';
    sheet1.getRangeByIndex(14, 1).text = 'Performers';
    sheet1.getRangeByIndex(15, 1).text = "Performer's transport";
    sheet1.getRangeByIndex(16, 1).text = "Performer's stay";
    sheet1.getRangeByIndex(17, 1).text = 'Marketing';
    sheet1.getRangeByIndex(18, 1).text = 'Total';

    sheet1.getRangeByName('B11:D17').numberFormat = r'$#,###';
    sheet1.getRangeByName('D11').numberFormat = r'[Red]($#,###)';
    sheet1.getRangeByName('D12').numberFormat = r'[Red]($#,###)';
    sheet1.getRangeByName('D14').numberFormat = r'[Red]($#,###)';

    sheet1.getRangeByName('B11').number = 6250;
    sheet1.getRangeByName('B12').number = 4600;
    sheet1.getRangeByName('B13').number = 7000;
    sheet1.getRangeByName('B14').number = 8400;
    sheet1.getRangeByName('B15').number = 3750;
    sheet1.getRangeByName('B16').number = 4500;
    sheet1.getRangeByName('B17').number = 5600;
    sheet1.getRangeByName('B18').formula = '=SUM(B11:B17)';

    sheet1.getRangeByName('C11').number = 17500;
    sheet1.getRangeByName('C12').number = 1828;
    sheet1.getRangeByName('C13').number = 800;
    sheet1.getRangeByName('C14').number = 14000;
    sheet1.getRangeByName('C15').number = 2600;
    sheet1.getRangeByName('C16').number = 4464;
    sheet1.getRangeByName('C17').number = 2700;
    sheet1.getRangeByName('C18').formula = '=SUM(C11:C17)';

    sheet1.getRangeByName('D11').formula = '=IF(C11>B11,C11-B11,B11-C11)';
    sheet1.getRangeByName('D12').formula = '=IF(C12>B12,C12-B12,B12-C12)';
    sheet1.getRangeByName('D13').formula = '=IF(C13>B13,C13-B13,B13-C13)';
    sheet1.getRangeByName('D14').formula = '=IF(C14>B14,C14-B14,B14-C14)';
    sheet1.getRangeByName('D15').formula = '=IF(C15>B15,C15-B15,B15-C15)';
    sheet1.getRangeByName('D16').formula = '=IF(C16>B16,C16-B16,B16-C16)';
    sheet1.getRangeByName('D17').formula = '=IF(C17>B17,C17-B17,B17-C17)';
    sheet1.getRangeByName('D18').formula = '=IF(C18>B18,C18-B18,B18-C18)';

    final ChartCollection charts = ChartCollection(sheet1);
    final Chart chart = charts.add();
    chart.chartType = ExcelChartType.doughnut;
    chart.dataRange = sheet1.getRangeByName('A11:B17');
    chart.isSeriesInRows = false;
    chart.chartTitle = 'Event Expenses';
    chart.chartTitleArea.bold = true;
    chart.chartTitleArea.size = 16;
    chart.topRow = 1;
    chart.bottomRow = 10;
    chart.leftColumn = 1;
    chart.rightColumn = 5;
    chart.series[0].dataLabels.isValue = true;
    chart.series[0].serieFormat.commonSerieOptions.holeSizePercent = 40;
    sheet1.charts = charts;

    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'ExpensesReport.xlsx');
  }
}
