///Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///XlsIO import
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;

///Local imports
import '../../../model/sample_view.dart';
import '../helper/save_file_mobile.dart'
    if (dart.library.html) '../helper/save_file_web.dart';

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
      backgroundColor: model.cardThemeColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Attendance tracker or attendance sheet is essential to any organization. This attendance tracker is designed to keep one month data. In this application, Employee Name, Supervisor, Present Count, Absent Count, Leave Count, Unplanned%, Planned% and dates for a particular month are available.\r\n\r\nThis sample demonstrates following features:\r\n\r\n   * Import data from a string collection (List<string>) to Excel worksheet\r\n\r\n   * Advanced options of conditional formatting in Excel such as, color scales, data bars',
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              const SizedBox(height: 20, width: 30),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          model.backgroundColor),
                      padding: model.isMobile
                          ? null
                          : MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15)),
                    ),
                    onPressed: _generateExcel,
                    child: const Text('Generate Excel',
                        style: TextStyle(color: Colors.white)),
                  ))
            ],
          ),
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

    final List<Object> heading = <Object>[
      'Employee Name',
      'Supervisor',
      DateTime(2019, 1, 1),
      DateTime(2019, 1, 2),
      DateTime(2019, 1, 3),
      DateTime(2019, 1, 4),
      DateTime(2019, 1, 5),
      DateTime(2019, 1, 6),
      DateTime(2019, 1, 7),
      DateTime(2019, 1, 8),
      DateTime(2019, 1, 9),
      DateTime(2019, 1, 10),
      DateTime(2019, 1, 11),
      DateTime(2019, 1, 12),
      DateTime(2019, 1, 13),
      DateTime(2019, 1, 14),
      DateTime(2019, 1, 15),
      DateTime(2019, 1, 16),
      DateTime(2019, 1, 17),
      DateTime(2019, 1, 18),
      DateTime(2019, 1, 19),
      DateTime(2019, 1, 20),
      DateTime(2019, 1, 21),
      DateTime(2019, 1, 22),
      DateTime(2019, 1, 23),
      DateTime(2019, 1, 24),
      DateTime(2019, 1, 25),
      DateTime(2019, 1, 26),
      DateTime(2019, 1, 27),
      DateTime(2019, 1, 28),
      DateTime(2019, 1, 29),
      DateTime(2019, 1, 30),
      DateTime(2019, 1, 31)
    ];
    sheet.importList(heading, 1, 1, false);

    final List<String> attendance_1 = <String>[
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
      'L'
    ];
    final List<String> attendance_2 = <String>[
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
      'P'
    ];
    final List<String> attendance_3 = <String>[
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
      'A'
    ];
    final List<String> attendance_4 = <String>[
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
      'P'
    ];
    final List<String> attendance_5 = <String>[
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
      'P'
    ];
    final List<String> attendance_6 = <String>[
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
      'P'
    ];
    final List<String> attendance_7 = <String>[
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
      'A'
    ];
    final List<String> attendance_8 = <String>[
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
      'L'
    ];
    final List<String> attendance_9 = <String>[
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
      'P'
    ];
    // Import data to sheet.
    sheet.importList(attendance_1, 2, 1, false);
    sheet.importList(attendance_2, 3, 1, false);
    sheet.importList(attendance_3, 4, 1, false);
    sheet.importList(attendance_4, 5, 1, false);
    sheet.importList(attendance_5, 6, 1, false);
    sheet.importList(attendance_6, 7, 1, false);
    sheet.importList(attendance_7, 8, 1, false);
    sheet.importList(attendance_8, 9, 1, false);
    sheet.importList(attendance_9, 10, 1, false);

    // Insert column
    sheet.insertColumn(3, 5);

    sheet.getRangeByName('C1').setText('Present Count');
    sheet.getRangeByName('C2').setFormula('=COUNTIFS(H2:AL2,\'P\')');
    sheet.getRangeByName('C3').setFormula('=COUNTIFS(H3:AL3,\'P\')');
    sheet.getRangeByName('C4').setFormula('=COUNTIFS(H4:AL4,\'P\')');
    sheet.getRangeByName('C5').setFormula('=COUNTIFS(H5:AL5,\'P\')');
    sheet.getRangeByName('C6').setFormula('=COUNTIFS(H6:AL6,\'P\')');
    sheet.getRangeByName('C7').setFormula('=COUNTIFS(H7:AL7,\'P\')');
    sheet.getRangeByName('C8').setFormula('=COUNTIFS(H8:AL8,\'P\')');
    sheet.getRangeByName('C9').setFormula('=COUNTIFS(H9:AL9,\'P\')');
    sheet.getRangeByName('C10').setFormula('=COUNTIFS(H10:AL10,\'P\')');

    sheet.getRangeByName('D1').setText('Leave Count');
    sheet.getRangeByName('D2').setFormula('=COUNTIFS(H2:AL2,\'L\')');
    sheet.getRangeByName('D3').setFormula('=COUNTIFS(H3:AL3,\'L\')');
    sheet.getRangeByName('D4').setFormula('=COUNTIFS(H4:AL4,\'L\')');
    sheet.getRangeByName('D5').setFormula('=COUNTIFS(H5:AL5,\'L\')');
    sheet.getRangeByName('D6').setFormula('=COUNTIFS(H6:AL6,\'L\')');
    sheet.getRangeByName('D7').setFormula('=COUNTIFS(H7:AL7,\'L\')');
    sheet.getRangeByName('D8').setFormula('=COUNTIFS(H8:AL8,\'L\')');
    sheet.getRangeByName('D9').setFormula('=COUNTIFS(H9:AL9,\'L\')');
    sheet.getRangeByName('D10').setFormula('=COUNTIFS(H10:AL10,\'L\')');

    sheet.getRangeByName('E1').setText('Absent Count');
    sheet.getRangeByName('E2').setFormula('=COUNTIFS(H2:AL2,\'A\')');
    sheet.getRangeByName('E3').setFormula('=COUNTIFS(H3:AL3,\'A\')');
    sheet.getRangeByName('E4').setFormula('=COUNTIFS(H4:AL4,\'A\')');
    sheet.getRangeByName('E5').setFormula('=COUNTIFS(H5:AL5,\'A\')');
    sheet.getRangeByName('E6').setFormula('=COUNTIFS(H6:AL6,\'A\')');
    sheet.getRangeByName('E7').setFormula('=COUNTIFS(H7:AL7,\'A\')');
    sheet.getRangeByName('E8').setFormula('=COUNTIFS(H8:AL8,\'A\')');
    sheet.getRangeByName('E9').setFormula('=COUNTIFS(H9:AL9,\'A\')');
    sheet.getRangeByName('E10').setFormula('=COUNTIFS(H10:AL10,\'A\')');

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
    ConditionalFormats statusCondition =
        sheet.getRangeByName('H2:AL10').conditionalFormats;

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

    final ConditionalFormats presentSummaryCF =
        sheet.getRangeByName('C2:C10').conditionalFormats;
    final ConditionalFormat presentCountCF = presentSummaryCF.addCondition();
    presentCountCF.formatType = ExcelCFType.dataBar;
    DataBar dataBar = presentCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 61, 242, 142);

    final ConditionalFormats leaveSummaryCF =
        sheet.getRangeByName('D2:D10').conditionalFormats;
    final ConditionalFormat leaveCountCF = leaveSummaryCF.addCondition();
    leaveCountCF.formatType = ExcelCFType.dataBar;
    dataBar = leaveCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 242, 71, 23);

    final ConditionalFormats absentSummaryCF =
        sheet.getRangeByName('E2:E10').conditionalFormats;
    final ConditionalFormat absentCountCF = absentSummaryCF.addCondition();
    absentCountCF.formatType = ExcelCFType.dataBar;
    dataBar = absentCountCF.dataBar!;
    dataBar.barColorRgb = const Color.fromARGB(255, 255, 10, 69);

    final ConditionalFormats unplannedSummaryCF =
        sheet.getRangeByName('F2:F10').conditionalFormats;
    final ConditionalFormat unplannedCountCF =
        unplannedSummaryCF.addCondition();
    unplannedCountCF.formatType = ExcelCFType.dataBar;
    dataBar = unplannedCountCF.dataBar!;
    dataBar.maxPoint.type = ConditionValueType.highestValue;
    dataBar.barColorRgb = const Color.fromARGB(255, 142, 142, 142);

    final ConditionalFormats plannedSummaryCF =
        sheet.getRangeByName('G2:G10').conditionalFormats;
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

    sheet.getRangeByName('H1:AL1').numberFormat = 'd';
    sheet.getRangeByName('H2:AL10').cellStyle.borders.all.colorRgb =
        const Color.fromARGB(255, 255, 255, 255);

    sheet.getRangeByName('F2:G10').numberFormat = '.00%';

    sheet.getRangeByName('C12:C18').cellStyle = style;
    sheet.getRangeByName('C12:C18').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('C12:C18').cellStyle.borders.all.lineStyle =
        LineStyle.none;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'AttendanceTracker.xlsx');
  }
}
