///Dart import
// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/model.dart';
import '../model/dealer.dart';

/// Set dealer's data collection to data grid source.
class DealerDataGridSource extends DataGridSource {
  /// Creates the dealer data source class with required details.
  DealerDataGridSource(this.sampleModel) {
    _textStyle =
        sampleModel.themeData.colorScheme.brightness == Brightness.light
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black87,
          )
        : const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(255, 255, 255, 1),
          );
    _dealers = _obtainDealerDetails(100);
    _buildDataGridRows();
  }

  /// Helps to change the widget appearance based on the sample browser theme.
  SampleModel sampleModel;

  /// Collection of dealer info.
  late List<Dealer> _dealers;

  /// Collection of [DataGridRow].
  late List<DataGridRow> _dataGridRows;

  /// Helps to change the [TextStyle] of editable widget.
  /// Decide the text appearance of editable widget based on [Brightness].
  late TextStyle _textStyle;

  /// Help to generate the random number.
  final Random _random = Random.secure();

  /// Help to control the editable text in [TextField] widget.
  final TextEditingController _editingController = TextEditingController();

  /// Helps to hold the new value of all editable widget.
  /// Based on the new value we will commit the new value into the corresponding
  /// [DataGridCell] on [onSubmitCell] method.
  dynamic _newCellValue;

  /// Helps to prevent the multiple time calling of [showDatePicker] when focus
  /// get into it.By default, datagrid sets the focus to editable widget. As
  /// Date picker showing when the container got focused, this flag helps to
  /// prevent to show the date picker again after date is picked from popup.
  bool _isDatePickerVisible = false;

  /// Building the [DataGridRow]'s.
  void _buildDataGridRows() {
    _dataGridRows = _dealers
        .map<DataGridRow>((Dealer dealer) => dealer.obtainDataGridRow())
        .toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((DataGridCell dataGridCell) {
        final bool isRightAlign =
            dataGridCell.columnName == 'Product No' ||
            dataGridCell.columnName == 'Shipped Date' ||
            dataGridCell.columnName == 'Price';

        String value = dataGridCell.value.toString();

        if (dataGridCell.columnName == 'Price') {
          value = NumberFormat.currency(
            locale: 'en_US',
            symbol: r'$',
          ).format(dataGridCell.value);
        } else if (dataGridCell.columnName == 'Shipped Date') {
          value = DateFormat('MM/dd/yyyy').format(dataGridCell.value);
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: isRightAlign
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(value, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // Text going to display on editable widget
    final String displayText =
        dataGridRow
            .getCells()
            .firstWhereOrNull(
              (DataGridCell dataGridCell) =>
                  dataGridCell.columnName == column.columnName,
            )
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    _newCellValue = null;

    if (column.columnName == 'Shipped Date') {
      return _buildDateTimePicker(displayText, submitCell);
    } else if (column.columnName == 'Ship Country') {
      return _buildDropDownWidget(displayText, submitCell, _shipCountry);
    } else if (column.columnName == 'Ship City') {
      final String shipCountry =
          dataGridRow
              .getCells()
              .firstWhereOrNull(
                (DataGridCell dataGridCell) =>
                    dataGridCell.columnName == 'Ship Country',
              )
              ?.value
              ?.toString() ??
          '';

      return _buildDropDownWidget(
        displayText == '' ? null : displayText,
        submitCell,
        _shipCity[shipCountry]!,
      );
    } else {
      return _buildTextFieldWidget(displayText, column, submitCell);
    }
  }

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue =
        dataGridRow
            .getCells()
            .firstWhereOrNull(
              (DataGridCell dataGridCell) =>
                  dataGridCell.columnName == column.columnName,
            )
            ?.value ??
        '';

    final int dataRowIndex = _dataGridRows.indexOf(dataGridRow);

    if (_newCellValue == null || oldValue == _newCellValue) {
      return;
    }

    if (column.columnName == 'Shipped Date') {
      _dataGridRows[dataRowIndex]
          .getCells()[rowColumnIndex.columnIndex] = DataGridCell<DateTime>(
        columnName: 'Shipped Date',
        value: _newCellValue,
      );
      _dealers[dataRowIndex].shippedDate = _newCellValue as DateTime;
    } else if (column.columnName == 'Product No') {
      _dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'Product No', value: _newCellValue);
      _dealers[dataRowIndex].productNo = _newCellValue as int;
    } else if (column.columnName == 'Price') {
      _dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'Price', value: _newCellValue);
      _dealers[dataRowIndex].productPrice = _newCellValue as double;
    } else if (column.columnName == 'Dealer Name') {
      _dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Dealer Name', value: _newCellValue);
      _dealers[dataRowIndex].dealerName = _newCellValue.toString();
    } else if (column.columnName == 'Ship Country') {
      _dataGridRows[dataRowIndex]
          .getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(
        columnName: 'Ship Country',
        value: _newCellValue,
      );
      final dynamic dataGridCell = _dataGridRows[dataRowIndex]
          .getCells()
          .firstWhereOrNull(
            (DataGridCell element) => element.columnName == 'Ship City',
          );
      final int dataCellIndex = _dataGridRows[dataRowIndex].getCells().indexOf(
        dataGridCell,
      );
      _dataGridRows[dataRowIndex].getCells()[dataCellIndex] =
          const DataGridCell<String>(columnName: 'Ship City', value: '');
      _dealers[dataRowIndex].shipCountry = _newCellValue.toString();
    } else {
      _dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Ship City', value: _newCellValue);
      _dealers[dataRowIndex].shipCity = _newCellValue.toString();
    }
  }

  RegExp _makeRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard
        ? columnName == 'Price'
              ? RegExp('[0-9.]')
              : RegExp('[0-9]')
        : RegExp('[a-zA-Z ]');
  }

  /// Building a [TextField] for numeric and text column.
  Widget _buildTextFieldWidget(
    String displayText,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    final bool isTextAlignRight =
        column.columnName == 'Product No' ||
        column.columnName == 'Shipped Date' ||
        column.columnName == 'Price';

    final bool isNumericKeyBoardType =
        column.columnName == 'Product No' || column.columnName == 'Price';

    // Holds regular expression pattern based on the column type.
    final RegExp regExp = _makeRegExp(isNumericKeyBoardType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isTextAlignRight
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: _editingController..text = displayText,
        textAlign: isTextAlignRight ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        keyboardAppearance: sampleModel.themeData.colorScheme.brightness,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: sampleModel.primaryColor),
          ),
        ),
        style: _textStyle,
        cursorColor: sampleModel.primaryColor,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericKeyBoardType
            ? TextInputType.number
            : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericKeyBoardType) {
              _newCellValue = column.columnName == 'Price'
                  ? double.parse(value)
                  : int.parse(value);
            } else {
              _newCellValue = value;
            }
          } else {
            _newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  /// Building a [DatePicker] for datetime column.
  Widget _buildDateTimePicker(String displayText, CellSubmit submitCell) {
    final DateTime selectedDate = DateTime.parse(displayText);
    final DateTime firstDate = DateTime.parse('1999-01-01');
    final DateTime lastDate = DateTime.parse('2016-12-31');

    // To restrict the multiple time calls for the datepicker.
    _isDatePickerVisible = false;
    displayText = DateFormat('MM/dd/yyyy').format(DateTime.parse(displayText));
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Focus(
            autofocus: true,
            focusNode: FocusNode()
              ..addListener(() async {
                if (!_isDatePickerVisible) {
                  _isDatePickerVisible = true;
                  await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme:
                              sampleModel.themeData.colorScheme.brightness ==
                                  Brightness.light
                              ? ColorScheme.light(
                                  primary: sampleModel.primaryColor,
                                )
                              : ColorScheme.dark(
                                  primary: sampleModel.primaryColor,
                                ),
                        ),
                        child: child!,
                      );
                    },
                  ).then((DateTime? value) {
                    _newCellValue = value;

                    /// Call [CellSubmit] callback to fire the canSubmitCell and
                    /// onCellSubmit to commit the new value in single place.
                    submitCell();
                  });
                }
              }),
            child: Text(
              displayText,
              textAlign: TextAlign.right,
              style: _textStyle,
            ),
          ),
        );
      },
    );
  }

  //// Drop down color of items
  Color _dropDownColor() {
    if (sampleModel.themeData.useMaterial3) {
      return sampleModel.themeData.brightness == Brightness.light
          ? const Color(0xFFEEE8F4)
          : const Color(0xFF302D38);
    } else {
      return sampleModel.themeData.canvasColor;
    }
  }

  /// Building a [DropDown] for combo box column.
  Widget _buildDropDownWidget(
    String? displayText,
    CellSubmit submitCell,
    List<String> dropDownMenuItems,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        dropdownColor: _dropDownColor(),
        value: displayText,
        autofocus: true,
        focusColor: Colors.transparent,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        isExpanded: true,
        style: _textStyle,
        onChanged: (String? value) {
          _newCellValue = value;

          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
        items: dropDownMenuItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  // ------------- Populating the dealer info collection's. ----------------
  // ------------------------------------------------------------------------

  List<Dealer> _obtainDealerDetails(int count) {
    final List<Dealer> dealerDetails = <Dealer>[];
    final List<DateTime> shippedDate = _rangeOfDates(2001, 2016, count);
    for (int i = 1; i <= count; i++) {
      final String selectedShipCountry = _shipCountry[_random.nextInt(5)];
      final List<String> selectedShipCities = _shipCity[selectedShipCountry]!;
      final Dealer ord = Dealer(
        _productNo[_random.nextInt(15)],
        i.isEven
            ? _customersMale[_random.nextInt(15)]
            : _customersFemale[_random.nextInt(14)],
        shippedDate[i - 1],
        selectedShipCountry,
        selectedShipCities[_random.nextInt(selectedShipCities.length - 1)],
        next(2000, 10000).toDouble(),
      );
      dealerDetails.add(ord);
    }

    return dealerDetails;
  }

  /// Helps to populate the random number between the [min] and [max] value.
  int next(int min, int max) => min + _random.nextInt(max - min);

  /// Populate the random date between the [startYear] and [endYear]
  List<DateTime> _rangeOfDates(int startYear, int endYear, int count) {
    final List<DateTime> date = <DateTime>[];
    for (int i = 0; i < count; i++) {
      final int year = next(startYear, endYear);
      final int month = _random.nextInt(12);
      final int day = _random.nextInt(30);
      date.add(DateTime(year, month, day));
    }

    return date;
  }

  final Map<String, List<String>> _shipCity = <String, List<String>>{
    'Argentina': <String>['Rosario', 'Catamarca', 'Formosa', 'Salta'],
    'Austria': <String>['Graz', 'Salzburg', 'Linz', 'Wels'],
    'Belgium': <String>['Bruxelles', 'Charleroi', 'Namur', 'Mons'],
    'Brazil': <String>['Campinas', 'Resende', 'Recife', 'Manaus'],
    'Canada': <String>['Alberta', 'Montreal', 'Tsawwassen', 'Vancouver'],
    'Denmark': <String>['Svendborg', 'Farum', 'Åarhus', 'København'],
    'Finland': <String>['Helsinki', 'Espoo', 'Oulu'],
    'France': <String>[
      'Lille',
      'Lyon',
      'Marseille',
      'Nantes',
      'Paris',
      'Reims',
      'Strasbourg',
      'Toulouse',
      'Versailles',
    ],
    'Germany': <String>[
      'Aachen',
      'Berlin',
      'Brandenburg',
      'Cunewalde',
      'Frankfurt',
      'Köln',
      'Leipzig',
      'Mannheim',
      'München',
      'Münster',
      'Stuttgart',
    ],
    'Ireland': <String>['Cork', 'Waterford', 'Bray', 'Athlone'],
    'Italy': <String>['Bergamo', 'Reggio Calabria', 'Torino', 'Genoa'],
    'Mexico': <String>['Mexico City', 'Puebla', 'León', 'Zapopan'],
    'Norway': <String>['Stavern', 'Hamar', 'Harstad', 'Narvik'],
    'Poland': <String>['Warszawa', 'Gdynia', 'Rybnik', 'Legnica'],
    'Portugal': <String>['Lisboa', 'Albufeira', 'Elvas', 'Estremoz'],
    'Spain': <String>['Barcelona', 'Madrid', 'Sevilla', 'Bilboa'],
    'Sweden': <String>['Bräcke', 'Piteå', 'Robertsfors', 'Luleå'],
    'Switzerland': <String>['Bern', 'Genève', 'Charrat', 'Châtillens'],
    'UK': <String>['Colchester', 'Hedge End', 'London', 'Bristol'],
    'USA': <String>[
      'Albuquerque',
      'Anchorage',
      'Boise',
      'Butte',
      'Elgin',
      'Eugene',
      'Kirkland',
      'Lander',
      'Portland',
      'San Francisco',
      'Seattle',
    ],
    'Venezuela': <String>[
      'Barquisimeto',
      'Caracas',
      'Isla de Margarita',
      'San Cristóbal',
      'Cantaura',
    ],
  };

  final List<String> _customersMale = <String>[
    'Adams',
    'Owens',
    'Thomas',
    'Doran',
    'Jefferson',
    'Spencer',
    'Vargas',
    'Grimes',
    'Edwards',
    'Stark',
    'Cruise',
    'Fitz',
    'Chief',
    'Blanc',
    'Stone',
    'Williams',
    'Jobs',
    'Holmes',
  ];

  final List<String> _customersFemale = <String>[
    'Crowley',
    'Waddell',
    'Irvine',
    'Keefe',
    'Ellis',
    'Gable',
    'Mendoza',
    'Rooney',
    'Lane',
    'Landry',
    'Perry',
    'Perez',
    'Newberry',
    'Betts',
    'Fitzgerald',
  ];

  final List<int> _productNo = <int>[
    1803,
    1345,
    4523,
    4932,
    9475,
    5243,
    4263,
    2435,
    3527,
    3634,
    2523,
    3652,
    3524,
    6532,
    2123,
  ];

  final List<String> _shipCountry = <String>[
    'Argentina',
    'Austria',
    'Belgium',
    'Brazil',
    'Canada',
    'Denmark',
    'Finland',
    'France',
    'Germany',
    'Ireland',
    'Italy',
    'Mexico',
    'Norway',
    'Poland',
    'Portugal',
    'Spain',
    'Sweden',
    'UK',
    'USA',
  ];
}
