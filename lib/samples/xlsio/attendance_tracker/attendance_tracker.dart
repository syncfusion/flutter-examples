///Package imports
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

/// Render XlsIO of balance sheet
class AttendanceTrackerXlsIO extends SampleView {
  /// Render XlsIO of balance sheet
  const AttendanceTrackerXlsIO(Key key) : super(key: key);
  @override
  _AttendanceTrackerXlsIOState createState() => _AttendanceTrackerXlsIOState();
}

class _AttendanceTrackerXlsIOState extends SampleViewState {
  _AttendanceTrackerXlsIOState();

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
              'Attendance tracker or attendance sheet is essential to any organization. This attendance tracker is designed to keep one month data. In this application, employee name, supervisor, present count, absent count, leave count, unplanned%, planned% and dates for a particular month are available.\r\n\r\nThis sample demonstrates following features:\r\n\r\n   * Import data from a collection objects to Excel worksheet\r\n\r\n   * Advanced options of conditional formatting in Excel such as, color scales, data bars',
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
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    final DateTime datetime = DateTime.now().toLocal();
    final DateFormat formatter = DateFormat('MMM');
    sheet.name = formatter.format(datetime) + '-' + datetime.year.toString();

    // Enable sheet calculation.
    sheet.enableSheetCalculations();

    // Import data to sheet.
    final List<ExcelDataRow> dataRows = _buildAttendanceReportDataRows();
    sheet.importData(dataRows, 1, 1);

    // Insert column
    sheet.insertColumn(3, 5);

    sheet.getRangeByName('C1').setText('Present Count');
    sheet.getRangeByName('C2').setFormula('=COUNTIFS(H2:AL2,"P")');
    sheet.getRangeByName('C3').setFormula('=COUNTIFS(H3:AL3,"P")');
    sheet.getRangeByName('C4').setFormula('=COUNTIFS(H4:AL4,"P")');
    sheet.getRangeByName('C5').setFormula('=COUNTIFS(H5:AL5,"P")');
    sheet.getRangeByName('C6').setFormula('=COUNTIFS(H6:AL6,"P")');
    sheet.getRangeByName('C7').setFormula('=COUNTIFS(H7:AL7,"P")');
    sheet.getRangeByName('C8').setFormula('=COUNTIFS(H8:AL8,"P")');
    sheet.getRangeByName('C9').setFormula('=COUNTIFS(H9:AL9,"P")');
    sheet.getRangeByName('C10').setFormula('=COUNTIFS(H10:AL10,"P")');

    sheet.getRangeByName('D1').setText('Leave Count');
    sheet.getRangeByName('D2').setFormula('=COUNTIFS(H2:AL2,"L")');
    sheet.getRangeByName('D3').setFormula('=COUNTIFS(H3:AL3,"L")');
    sheet.getRangeByName('D4').setFormula('=COUNTIFS(H4:AL4,"L")');
    sheet.getRangeByName('D5').setFormula('=COUNTIFS(H5:AL5,"L")');
    sheet.getRangeByName('D6').setFormula('=COUNTIFS(H6:AL6,"L")');
    sheet.getRangeByName('D7').setFormula('=COUNTIFS(H7:AL7,"L")');
    sheet.getRangeByName('D8').setFormula('=COUNTIFS(H8:AL8,"L")');
    sheet.getRangeByName('D9').setFormula('=COUNTIFS(H9:AL9,"L")');
    sheet.getRangeByName('D10').setFormula('=COUNTIFS(H10:AL10,"L")');

    sheet.getRangeByName('E1').setText('Absent Count');
    sheet.getRangeByName('E2').setFormula('=COUNTIFS(H2:AL2,"A")');
    sheet.getRangeByName('E3').setFormula('=COUNTIFS(H3:AL3,"A")');
    sheet.getRangeByName('E4').setFormula('=COUNTIFS(H4:AL4,"A")');
    sheet.getRangeByName('E5').setFormula('=COUNTIFS(H5:AL5,"A")');
    sheet.getRangeByName('E6').setFormula('=COUNTIFS(H6:AL6,"A")');
    sheet.getRangeByName('E7').setFormula('=COUNTIFS(H7:AL7,"A")');
    sheet.getRangeByName('E8').setFormula('=COUNTIFS(H8:AL8,"A")');
    sheet.getRangeByName('E9').setFormula('=COUNTIFS(H9:AL9,"A")');
    sheet.getRangeByName('E10').setFormula('=COUNTIFS(H10:AL10,"A")');

    sheet.getRangeByName('F1').setText('Unplanned %');
    sheet.getRangeByName('F2').setFormula('=E2/(C2+D2+E2)');
    sheet.getRangeByName('F3').setFormula('=E3/(C3+D3+E3)');
    sheet.getRangeByName('F4').setFormula('=E4/(C4+D4+E4)');
    sheet.getRangeByName('F5').setFormula('=E5/(C5+D5+E5)');
    sheet.getRangeByName('F6').setFormula('=E6/(C6+D6+E6)');
    sheet.getRangeByName('F7').setFormula('=E7/(C7+D7+E7)');
    sheet.getRangeByName('F8').setFormula('=E8/(C8+D8+E8)');
    sheet.getRangeByName('F9').setFormula('=E9/(C9+D9+E9)');
    sheet.getRangeByName('F10').setFormula('=E10/(C10+D10+E10)');

    sheet.getRangeByName('G1').setText('Planned %');
    sheet.getRangeByName('G2').setFormula('=D2/(C2+D2+E2)');
    sheet.getRangeByName('G3').setFormula('=D3/(C3+D3+E3)');
    sheet.getRangeByName('G4').setFormula('=D4/(C4+D4+E4)');
    sheet.getRangeByName('G5').setFormula('=D5/(C5+D5+E5)');
    sheet.getRangeByName('G6').setFormula('=D6/(C6+D6+E6)');
    sheet.getRangeByName('G7').setFormula('=D7/(C7+D7+E7)');
    sheet.getRangeByName('G8').setFormula('=D8/(C8+D8+E8)');
    sheet.getRangeByName('G9').setFormula('=D9/(C9+D9+E9)');
    sheet.getRangeByName('G10').setFormula('=D10/(C10+D10+E10)');

    //Apply conditional Formatting.
    ConditionalFormats statusCondition = sheet
        .getRangeByName('H2:AL10')
        .conditionalFormats;

    ConditionalFormat leaveCondition = statusCondition.addCondition();
    leaveCondition.formatType = ExcelCFType.cellValue;
    leaveCondition.operator = ExcelComparisonOperator.equal;
    leaveCondition.firstFormula = '"L"';
    leaveCondition.backColorRgb = const Color.fromARGB(255, 253, 167, 92);

    ConditionalFormat absentCondition = statusCondition.addCondition();
    absentCondition.formatType = ExcelCFType.cellValue;
    absentCondition.operator = ExcelComparisonOperator.equal;
    absentCondition.firstFormula = '"A"';
    absentCondition.backColorRgb = const Color.fromARGB(255, 255, 105, 124);

    ConditionalFormat presentCondition = statusCondition.addCondition();
    presentCondition.formatType = ExcelCFType.cellValue;
    presentCondition.operator = ExcelComparisonOperator.equal;
    presentCondition.firstFormula = '"P"';
    presentCondition.backColorRgb = const Color.fromARGB(255, 67, 233, 123);

    ConditionalFormat weekendCondition = statusCondition.addCondition();
    weekendCondition.formatType = ExcelCFType.cellValue;
    weekendCondition.operator = ExcelComparisonOperator.equal;
    weekendCondition.firstFormula = '"WE"';
    weekendCondition.backColorRgb = const Color.fromARGB(255, 240, 240, 240);

    final ConditionalFormats presentSummaryCF = sheet
        .getRangeByName('C2:C10')
        .conditionalFormats;
    final ConditionalFormat presentCountCF = presentSummaryCF.addCondition();
    presentCountCF.formatType = ExcelCFType.dataBar;
    DataBar dataBar = presentCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 61, 242, 142);

    final ConditionalFormats leaveSummaryCF = sheet
        .getRangeByName('D2:D10')
        .conditionalFormats;
    final ConditionalFormat leaveCountCF = leaveSummaryCF.addCondition();
    leaveCountCF.formatType = ExcelCFType.dataBar;
    dataBar = leaveCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 242, 71, 23);

    final ConditionalFormats absentSummaryCF = sheet
        .getRangeByName('E2:E10')
        .conditionalFormats;
    final ConditionalFormat absentCountCF = absentSummaryCF.addCondition();
    absentCountCF.formatType = ExcelCFType.dataBar;
    dataBar = absentCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 255, 10, 69);

    final ConditionalFormats unplannedSummaryCF = sheet
        .getRangeByName('F2:F10')
        .conditionalFormats;
    final ConditionalFormat unplannedCountCF = unplannedSummaryCF
        .addCondition();
    unplannedCountCF.formatType = ExcelCFType.dataBar;
    dataBar = unplannedCountCF.dataBar!;
    dataBar.maxPoint.type = ConditionValueType.highestValue;
    dataBar.barColorRgb = const Color.fromARGB(255, 142, 142, 142);

    final ConditionalFormats plannedSummaryCF = sheet
        .getRangeByName('G2:G10')
        .conditionalFormats;
    final ConditionalFormat plannedCountCF = plannedSummaryCF.addCondition();
    plannedCountCF.formatType = ExcelCFType.dataBar;
    dataBar = plannedCountCF.dataBar!;
    dataBar.maxPoint.type = ConditionValueType.highestValue;
    dataBar.barColorRgb = const Color.fromARGB(255, 56, 136, 254);

    statusCondition = sheet.getRangeByName('C12:C18').conditionalFormats;
    leaveCondition = statusCondition.addCondition();
    leaveCondition.formatType = ExcelCFType.cellValue;
    leaveCondition.operator = ExcelComparisonOperator.equal;
    leaveCondition.firstFormula = '"L"';
    leaveCondition.backColorRgb = const Color.fromARGB(255, 253, 167, 92);

    absentCondition = statusCondition.addCondition();
    absentCondition.formatType = ExcelCFType.cellValue;
    absentCondition.operator = ExcelComparisonOperator.equal;
    absentCondition.firstFormula = '"A"';
    absentCondition.backColorRgb = const Color.fromARGB(255, 255, 105, 124);

    presentCondition = statusCondition.addCondition();
    presentCondition.formatType = ExcelCFType.cellValue;
    presentCondition.operator = ExcelComparisonOperator.equal;
    presentCondition.firstFormula = '"P"';
    presentCondition.backColorRgb = const Color.fromARGB(255, 67, 233, 123);

    weekendCondition = statusCondition.addCondition();
    weekendCondition.formatType = ExcelCFType.cellValue;
    weekendCondition.operator = ExcelComparisonOperator.equal;
    weekendCondition.firstFormula = '"WE"';
    weekendCondition.backColorRgb = const Color.fromARGB(255, 240, 240, 240);

    sheet.getRangeByIndex(12, 3).setText('P');
    sheet.getRangeByIndex(14, 3).setText('L');
    sheet.getRangeByIndex(16, 3).setText('A');
    sheet.getRangeByIndex(18, 3).setText('WE');
    sheet.getRangeByIndex(12, 4).setText('Present');
    sheet.getRangeByIndex(14, 4).setText('Leave');
    sheet.getRangeByIndex(16, 4).setText('Absent');
    sheet.getRangeByIndex(18, 4).setText('Weekend');

    // Row height and column width.
    sheet.getRangeByName('A1:AL1').rowHeight = 24;
    sheet.getRangeByName('A2:AL10').rowHeight = 20;
    sheet.getRangeByName('A1:B1').columnWidth = 19.64;
    sheet.getRangeByName('C1:G1').columnWidth = 15.64;
    sheet.getRangeByName('H1:AL10').columnWidth = 3.64;
    sheet.getRangeByIndex(13, 1).rowHeight = 3.8;
    sheet.getRangeByIndex(15, 1).rowHeight = 3.8;
    sheet.getRangeByIndex(17, 1).rowHeight = 3.8;

    //Apply styles
    final Style style = workbook.styles.add('Style');
    style.fontSize = 12;
    style.fontColorRgb = const Color.fromARGB(255, 64, 64, 64);
    style.bold = true;
    style.borders.all.lineStyle = LineStyle.medium;
    style.borders.all.colorRgb = const Color.fromARGB(255, 195, 195, 195);
    style.vAlign = VAlignType.center;
    style.hAlign = HAlignType.left;

    sheet.getRangeByName('A1:AL10').cellStyle = style;

    sheet.getRangeByName('A1:AL1').cellStyle.backColorRgb =
        const Color.fromARGB(255, 58, 56, 56);
    sheet.getRangeByName('A1:AL1').cellStyle.fontColorRgb =
        const Color.fromARGB(255, 255, 255, 255);

    sheet.getRangeByName('C2:AL10').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('H1:AL1').cellStyle.hAlign = HAlignType.center;

    sheet.getRangeByName('A2:B10').cellStyle.indent = 1;
    sheet.getRangeByName('A1:G1').cellStyle.indent = 1;

    sheet.getRangeByName('H2:AL10').cellStyle.borders.all.colorRgb =
        const Color.fromARGB(255, 255, 255, 255);

    sheet.getRangeByName('F2:G10').numberFormat = '.00%';

    sheet.getRangeByName('C12:C18').cellStyle = style;
    sheet.getRangeByName('C12:C18').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('C12:C18').cellStyle.borders.all.lineStyle =
        LineStyle.none;

    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'AttendanceTracker.xlsx');
  }

  List<ExcelDataRow> _buildAttendanceReportDataRows() {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    final List<_Attendance> reports = _getAttendanceReports();

    excelDataRows = reports.map<ExcelDataRow>((_Attendance dataRow) {
      return ExcelDataRow(
        cells: <ExcelDataCell>[
          ExcelDataCell(
            columnHeader: 'Employee Name',
            value: dataRow.employeeName,
          ),
          ExcelDataCell(columnHeader: 'Supervisor', value: dataRow.supervisor),
          ExcelDataCell(columnHeader: 1, value: dataRow.day1),
          ExcelDataCell(columnHeader: 2, value: dataRow.day2),
          ExcelDataCell(columnHeader: 3, value: dataRow.day3),
          ExcelDataCell(columnHeader: 4, value: dataRow.day4),
          ExcelDataCell(columnHeader: 5, value: dataRow.day5),
          ExcelDataCell(columnHeader: 6, value: dataRow.day6),
          ExcelDataCell(columnHeader: 7, value: dataRow.day7),
          ExcelDataCell(columnHeader: 8, value: dataRow.day8),
          ExcelDataCell(columnHeader: 9, value: dataRow.day9),
          ExcelDataCell(columnHeader: 10, value: dataRow.day10),
          ExcelDataCell(columnHeader: 11, value: dataRow.day11),
          ExcelDataCell(columnHeader: 12, value: dataRow.day12),
          ExcelDataCell(columnHeader: 13, value: dataRow.day13),
          ExcelDataCell(columnHeader: 14, value: dataRow.day14),
          ExcelDataCell(columnHeader: 15, value: dataRow.day15),
          ExcelDataCell(columnHeader: 16, value: dataRow.day16),
          ExcelDataCell(columnHeader: 17, value: dataRow.day17),
          ExcelDataCell(columnHeader: 18, value: dataRow.day18),
          ExcelDataCell(columnHeader: 19, value: dataRow.day19),
          ExcelDataCell(columnHeader: 20, value: dataRow.day20),
          ExcelDataCell(columnHeader: 21, value: dataRow.day21),
          ExcelDataCell(columnHeader: 22, value: dataRow.day22),
          ExcelDataCell(columnHeader: 23, value: dataRow.day23),
          ExcelDataCell(columnHeader: 24, value: dataRow.day24),
          ExcelDataCell(columnHeader: 25, value: dataRow.day25),
          ExcelDataCell(columnHeader: 26, value: dataRow.day26),
          ExcelDataCell(columnHeader: 27, value: dataRow.day27),
          ExcelDataCell(columnHeader: 28, value: dataRow.day28),
          ExcelDataCell(columnHeader: 29, value: dataRow.day29),
          ExcelDataCell(columnHeader: 30, value: dataRow.day30),
          ExcelDataCell(columnHeader: 31, value: dataRow.day31),
        ],
      );
    }).toList();

    return excelDataRows;
  }

  List<_Attendance> _getAttendanceReports() {
    final List<_Attendance> reports = <_Attendance>[];
    reports.add(
      _Attendance(
        'Maria Anders',
        'Michael Holz',
        'P',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'P',
        'A',
        'P',
        'A',
        'A',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'P',
        'A',
        'WE',
        'WE',
        'P',
        'P',
        'L',
        'A',
        'L',
        'WE',
        'WE',
        'P',
        'P',
        'A',
        'L',
      ),
    );
    reports.add(
      _Attendance(
        'Ana Trujillo',
        'Michael Holz',
        'P',
        'P',
        'P',
        'L',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'P',
        'A',
        'WE',
        'WE',
        'P',
        'P',
        'L',
        'L',
        'P',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'P',
        'L',
        'WE',
        'WE',
        'P',
        'P',
        'L',
        'P',
      ),
    );
    reports.add(
      _Attendance(
        'Antonio Moreno',
        'Liz Nixon',
        'A',
        'P',
        'L',
        'L',
        'WE',
        'WE',
        'P',
        'A',
        'A',
        'P',
        'L',
        'WE',
        'WE',
        'A',
        'P',
        'L',
        'A',
        'P',
        'WE',
        'WE',
        'P',
        'L',
        'L',
        'P',
        'P',
        'WE',
        'WE',
        'L',
        'P',
        'A',
        'A',
      ),
    );
    reports.add(
      _Attendance(
        'Thomas Hardy',
        'Liu Wong',
        'L',
        'A',
        'L',
        'p',
        'WE',
        'WE',
        'P',
        'A',
        'A',
        'P',
        'A',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'L',
        'P',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'L',
        'P',
        'WE',
        'WE',
        'L',
        'A',
        'P',
        'P',
      ),
    );
    reports.add(
      _Attendance(
        'Christina Berglund',
        'Mary Saveley',
        'P',
        'P',
        'P',
        'L',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'L',
        'P',
        'WE',
        'WE',
        'A',
        'A',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'A',
        'A',
        'P',
        'P',
      ),
    );
    reports.add(
      _Attendance(
        'Hanna Moos',
        'Liu Wong',
        'L',
        'P',
        'P',
        'A',
        'WE',
        'WE',
        'P',
        'P',
        'A',
        'P',
        'L',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'L',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'P',
        'L',
        'WE',
        'WE',
        'P',
        'L',
        'L',
        'P',
      ),
    );
    reports.add(
      _Attendance(
        'Frederique Citeaux',
        'Mary Saveley',
        'A',
        'A',
        'A',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'L',
        'A',
        'P',
        'WE',
        'WE',
        'P',
        'P',
        'L',
        'P',
        'P',
        'WE',
        'WE',
        'A',
        'A',
        'P',
        'P',
        'L',
        'WE',
        'WE',
        'L',
        'P',
        'A',
        'A',
      ),
    );
    reports.add(
      _Attendance(
        'Martin Sommer',
        'Michael Holz',
        'L',
        'P',
        'L',
        'A',
        'WE',
        'WE',
        'P',
        'L',
        'P',
        'L',
        'A',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'A',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'A',
        'P',
        'L',
        'WE',
        'WE',
        'A',
        'L',
        'L',
        'L',
      ),
    );
    reports.add(
      _Attendance(
        'Laurence Lebihan',
        'Mary Saveley',
        'P',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'P',
        'P',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'P',
        'P',
        'WE',
        'WE',
        'A',
        'P',
        'P',
        'P',
        'A',
        'WE',
        'WE',
        'L',
        'P',
        'P',
        'P',
      ),
    );
    return reports;
  }
}

class _Attendance {
  _Attendance(
    this.employeeName,
    this.supervisor,
    this.day1,
    this.day2,
    this.day3,
    this.day4,
    this.day5,
    this.day6,
    this.day7,
    this.day8,
    this.day9,
    this.day10,
    this.day11,
    this.day12,
    this.day13,
    this.day14,
    this.day15,
    this.day16,
    this.day17,
    this.day18,
    this.day19,
    this.day20,
    this.day21,
    this.day22,
    this.day23,
    this.day24,
    this.day25,
    this.day26,
    this.day27,
    this.day28,
    this.day29,
    this.day30,
    this.day31,
  );
  late String employeeName;
  late String supervisor;
  late String day1;
  late String day2;
  late String day3;
  late String day4;
  late String day5;
  late String day6;
  late String day7;
  late String day8;
  late String day9;
  late String day10;
  late String day11;
  late String day12;
  late String day13;
  late String day14;
  late String day15;
  late String day16;
  late String day17;
  late String day18;
  late String day19;
  late String day20;
  late String day21;
  late String day22;
  late String day23;
  late String day24;
  late String day25;
  late String day26;
  late String day27;
  late String day28;
  late String day29;
  late String day30;
  late String day31;
}
