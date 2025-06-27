///Package imports
import 'package:flutter/material.dart' as material;

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

///Local imports
import '../../../model/sample_view.dart';
import '../../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../../common/export/save_file_web.dart';

///Renders box whisker chart sample
class AutoFilterXlsIO extends SampleView {
  /// Creates the box whisker chart
  const AutoFilterXlsIO(material.Key key) : super(key: key);

  @override
  _AutoFilterXlsIOState createState() => _AutoFilterXlsIOState();
}

class _AutoFilterXlsIOState extends SampleViewState {
  _AutoFilterXlsIOState();
  late String _selectMode;
  late List<String>? _modeType;

  @override
  void initState() {
    _selectMode = 'Text filter';

    _modeType = <String>[
      'Text filter',
      'Custom filter',
      'Date filter',
      'Dynamic filter',
      'Font color filter',
      'Cell color filter',
    ].toList();
    super.initState();
  }

  @override
  void dispose() {
    _modeType!.clear();
    super.dispose();
  }

  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: material.Padding(
        padding: const material.EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: material.Column(
          crossAxisAlignment: material.CrossAxisAlignment.start,
          children: <material.Widget>[
            material.Text(
              'This feature allows filtering data to display only rows that meet criteria specified by the user and hide rows that do not. Syncfusion Flutter Excel creation library supports different filter types such as text, number, date, color, and custom.\r\n',
              style: material.TextStyle(fontSize: 16, color: model.textColor),
            ),
            material.Row(
              children: <material.Widget>[
                material.Text(
                  'Select the filter type ',
                  style: material.TextStyle(
                    fontSize: 16.0,
                    color: model.textColor,
                  ),
                ),
                material.Container(
                  padding: const material.EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: material.DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: material.Colors.transparent,
                    underline: material.Container(
                      color: const material.Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectMode,
                    items: _modeType!.map((String value) {
                      return material.DropdownMenuItem<String>(
                        value: (value != null) ? value : 'Text filter',
                        child: material.Padding(
                          padding: const material.EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          child: material.Text(
                            value,
                            style: material.TextStyle(color: model.textColor),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _onModeChange(value.toString());
                    },
                  ),
                ),
              ],
            ),
            material.Align(
              child: material.TextButton(
                style: material.ButtonStyle(
                  backgroundColor:
                      material.WidgetStateProperty.all<material.Color>(
                        model.primaryColor,
                      ),
                  padding: model.isMobile
                      ? null
                      : material.WidgetStateProperty.all(
                          const material.EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                        ),
                ),
                onPressed: _generateExcel,
                child: const material.Text(
                  'Generate Excel',
                  style: material.TextStyle(color: material.Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onModeChange(String item) {
    setState(() {
      _selectMode = item;
    });
  }

  Future<void> _generateExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    String fileName = '';
    sheet.getRangeByName('A1').setText('Title');
    sheet.getRangeByName('A2').setText('Sales Representative');
    sheet.getRangeByName('A3').setText('Owner');
    sheet.getRangeByName('A4').setText('Owner');
    sheet.getRangeByName('A5').setText('Sales Representative');
    sheet.getRangeByName('A6').setText('Order Administrator');
    sheet.getRangeByName('A7').setText('Sales Representative');
    sheet.getRangeByName('A8').setText('Marketing Manager');
    sheet.getRangeByName('A9').setText('Owner');
    sheet.getRangeByName('A10').setText('Owner');

    sheet.getRangeByName('B1').setText('DOJ');
    sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
    sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
    sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
    sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
    sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
    sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
    sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
    sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
    sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

    sheet.getRangeByName('C1').setText('City');
    sheet.getRangeByName('C2').setText('Berlin');
    sheet.getRangeByName('C3').setText('México D.F.');
    sheet.getRangeByName('C4').setText('México D.F.');
    sheet.getRangeByName('C5').setText('London');
    sheet.getRangeByName('C6').setText('Luleå');
    sheet.getRangeByName('C7').setText('Mannheim');
    sheet.getRangeByName('C8').setText('Strasbourg');
    sheet.getRangeByName('C9').setText('Madrid');
    sheet.getRangeByName('C10').setText('Marseille');
    if (_selectMode == 'Text filter') {
      _onModeChange(_selectMode);

      //Initialize Filter Range
      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
      final AutoFilter autofilter = sheet.autoFilters[0];
      autofilter.addTextFilter(<String>{'Owner'});
      sheet.getRangeByName('A1:C10').autoFitColumns();

      fileName = 'TextFilter.xlsx';
    } else if (_selectMode == 'Custom filter') {
      //Initialize Filter Range
      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
      final AutoFilter autofilter = sheet.autoFilters[0];
      final AutoFilterCondition firstCondition = autofilter.firstCondition;
      firstCondition.conditionOperator = ExcelFilterCondition.equal;
      firstCondition.textValue = 'Owner';

      final AutoFilterCondition secondCondition = autofilter.secondCondition;
      secondCondition.conditionOperator = ExcelFilterCondition.equal;
      secondCondition.textValue = 'Sales Representative';

      fileName = 'CustomFilter.xlsx';
    } else if (_selectMode == 'Date filter') {
      //Initialize Filter Range
      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
      final AutoFilter autofilter = sheet.autoFilters[1];
      autofilter.addDateFilter(DateTime(2002), DateTimeFilterType.year);
      autofilter.addDateFilter(DateTime(2009, 5), DateTimeFilterType.year);

      fileName = 'DateFilter.xlsx';
    } else if (_selectMode == 'Dynamic filter') {
      //Initialize Filter Range
      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
      final AutoFilter autofilter = sheet.autoFilters[1];
      autofilter.addDynamicFilter(DynamicFilterType.quarter2);
      sheet.getRangeByName('A1:C10').autoFitColumns();

      fileName = 'DynamicFilter.xlsx';
    } else if (_selectMode == 'Font color filter' ||
        _selectMode == 'Cell color filter') {
      sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
      sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
      sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
      sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
      sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
      sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
      sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
      sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
      sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

      sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
      sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
      sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
      sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
      sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
      sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
      sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
      sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
      sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

      if (_selectMode == 'Font color filter') {
        //Initialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[2];
        autofilter.addColorFilter('#0000FF', ExcelColorFilterType.fontColor);

        fileName = 'FontColorFilter.xlsx';
      } else {
        //Initialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[0];
        autofilter.addColorFilter('#FF0000', ExcelColorFilterType.cellColor);

        fileName = 'CellColorFilter.xlsx';
      }
    }
    //saving Sheet
    sheet.getRangeByName('A1:C10').autoFitColumns();
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, fileName);
  }
}
