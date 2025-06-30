///Package imports
import 'package:flutter/material.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

/// Render XlsIO of data validation
class DataValidationXlsIO extends SampleView {
  /// Render XlsIO of data validation
  const DataValidationXlsIO(Key key) : super(key: key);
  @override
  _DataValidationXlsIOState createState() => _DataValidationXlsIOState();
}

class _DataValidationXlsIOState extends SampleViewState {
  _DataValidationXlsIOState();

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
              'This sample shows how to use the data validation feature in Excel to control the type of data entered into a cell. This feature supports the following data validation rules:\r\n\r\n  * Drop-down list\r\n\r\n  * Number validation\r\n\r\n  * Time validation\r\n\r\n  * Date validation\r\n\r\n  * Text length validation',
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
    final Worksheet sheet = workbook.worksheets.addWithName('DataValidation');

    sheet.getRangeByName('B7').text = 'Select an item from the drop down list';
    sheet.getRangeByName('C7').cellStyle.borders.all.lineStyle =
        LineStyle.medium;
    //Accessing the cell Range C7 and applying the list data validation
    final DataValidation listValidation = sheet
        .getRangeByName('C7')
        .dataValidation;
    listValidation.listOfValues = <String>['Product', 'Brand', 'Price'];
    listValidation.promptBoxText = 'Data Validation list';
    listValidation.showPromptBox = true;
    listValidation.showErrorBox = true;
    listValidation.errorBoxText = 'Select an item only from the list';
    listValidation.errorBoxTitle = 'Error';

    sheet.getRangeByName('B9').text = 'Enter a number between 0 and 10';
    sheet.getRangeByName('C9').cellStyle.borders.all.lineStyle =
        LineStyle.medium;
    //Accessing the cell Range C9 and applying the whole number data validation
    final DataValidation integerValidation = sheet
        .getRangeByName('C9')
        .dataValidation;
    integerValidation.allowType = ExcelDataValidationType.integer;
    integerValidation.comparisonOperator =
        ExcelDataValidationComparisonOperator.between;
    integerValidation.firstFormula = '0';
    integerValidation.secondFormula = '10';
    integerValidation.showErrorBox = true;
    integerValidation.errorBoxText = 'Enter a value between 0 and 10';
    integerValidation.errorBoxTitle = 'Error';
    integerValidation.promptBoxText = 'Number';
    integerValidation.showPromptBox = true;

    sheet.getRangeByName('B11').text =
        'Enter a date between 5/10/2003 and 5/10/2004';
    sheet.getRangeByName('C11').cellStyle.borders.all.lineStyle =
        LineStyle.medium;
    //Accessing the cell Range C11 and applying the date data validation
    final DataValidation dateValidation = sheet
        .getRangeByName('C11')
        .dataValidation;
    dateValidation.allowType = ExcelDataValidationType.date;
    dateValidation.comparisonOperator =
        ExcelDataValidationComparisonOperator.between;
    dateValidation.firstDateTime = DateTime(2003, 5, 10);
    dateValidation.secondDateTime = DateTime(2004, 5, 10);
    dateValidation.showErrorBox = true;
    dateValidation.errorBoxText =
        'Enter a date between 5/10/2003 and 5/10/2004 in mm/ddd/yyyy format';
    dateValidation.errorBoxTitle = 'Error';
    dateValidation.promptBoxText = 'Date';
    dateValidation.showPromptBox = true;

    sheet.getRangeByName('B13').text = 'Enter a text of 6 characters or less';
    sheet.getRangeByName('C13').cellStyle.borders.all.lineStyle =
        LineStyle.medium;
    //Accessing the cell Range C13 and applying the text length data validation
    final DataValidation textLengthValidation = sheet
        .getRangeByName('C13')
        .dataValidation;
    textLengthValidation.allowType = ExcelDataValidationType.textLength;
    textLengthValidation.comparisonOperator =
        ExcelDataValidationComparisonOperator.between;
    textLengthValidation.firstFormula = '1';
    textLengthValidation.secondFormula = '6';
    textLengthValidation.showErrorBox = true;
    textLengthValidation.errorBoxText =
        'Reduce the text length to 6 characters';
    textLengthValidation.errorBoxTitle = 'Error';
    textLengthValidation.promptBoxText = 'Text length';
    textLengthValidation.showPromptBox = true;

    sheet.getRangeByName('B15').text =
        'Enter a time between 10:00 AM and 12:00 PM';
    sheet.getRangeByName('C15').cellStyle.borders.all.lineStyle =
        LineStyle.medium;
    //Accessing the cell Range C15 and applying the time data validation
    final DataValidation timeValidation = sheet
        .getRangeByName('C15')
        .dataValidation;
    timeValidation.allowType = ExcelDataValidationType.time;
    timeValidation.comparisonOperator =
        ExcelDataValidationComparisonOperator.between;
    timeValidation.firstFormula = '10:00';
    timeValidation.secondFormula = '12:00';
    timeValidation.showErrorBox = true;
    timeValidation.errorBoxText = 'Enter a time between 10:00 AM and 12:00 PM';
    timeValidation.errorBoxTitle = 'Error';
    timeValidation.promptBoxText = 'Time';
    timeValidation.showPromptBox = true;

    sheet.getRangeByName('B2:C2').merge();
    sheet.getRangeByName('B2').text = 'Data validation';
    sheet.getRangeByName('B5').text = 'Validation criteria';
    sheet.getRangeByName('C5').text = 'Validation';
    sheet.getRangeByName('B5').cellStyle.bold = true;
    sheet.getRangeByName('C5').cellStyle.bold = true;
    sheet.getRangeByName('B2').cellStyle.bold = true;
    sheet.getRangeByName('B2').cellStyle.fontSize = 16;
    sheet.getRangeByName('B2').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1:C15').autoFit();

    //Save and dispose Workbook
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'DataValidation.xlsx');
  }
}
