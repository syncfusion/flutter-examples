import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';

class ConditionalStylingDataGrid extends SampleView {
  const ConditionalStylingDataGrid({Key key}) : super(key: key);

  @override
  _ConditionalStylingDataGridState createState() =>
      _ConditionalStylingDataGridState();
}

List<Stock> _stockData;

class _ConditionalStylingDataGridState extends SampleViewState {
  _ConditionalStylingDataGridState();

  Widget sampleWidget(SampleModel model) => const ConditionalStylingDataGrid();

  final math.Random _random = math.Random();

  final ConditionalStyleDataGridSource _conditionalStyleDataGridSource =
      ConditionalStyleDataGridSource();

  final List<String> _names = <String>[
    'Maciej',
    'Shelley',
    'Linda',
    'Shanon',
    'Jauna',
    'Michael',
    'Terry',
    'Julie',
    'Twanna',
    'Gary',
    'Carol',
    'James',
    'Martha'
  ];

  List<Stock> generateList(int count) {
    final List<Stock> stockData = <Stock>[];
    for (int i = 1; i < count; i++) {
      stockData.add(Stock(
        _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        1800.0 + _random.nextInt(2000),
        1500.0 + _random.nextInt(1000),
        2000.0 + _random.nextInt(3000),
        1400.0 + _random.nextInt(4000),
      ));
    }

    return stockData;
  }

  SfDataGrid _dataGridsample() {
    return SfDataGrid(
      source: _conditionalStyleDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      onQueryCellStyle: (QueryCellStyleArgs args) {
        if (args.column.mappingName == 'name') {
          return null;
        }
        if (args.column.mappingName == 'qs1') {
          if (double.parse(args.cellValue.toString()) > 2000 &&
              double.parse(args.cellValue.toString()) < 2500) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFF4C5B9),
                textStyle: TextStyle(color: Colors.black));
          } else if (double.parse(args.cellValue.toString()) > 2500) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFEB552C),
                textStyle: TextStyle(color: Colors.white));
          } else {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFEF8465),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          }
        } else if (args.column.mappingName == 'qs2') {
          if (double.parse(args.cellValue.toString()) > 2000 &&
              double.parse(args.cellValue.toString()) < 2500) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFF5BD16),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          } else if (double.parse(args.cellValue.toString()) > 2500) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFF8DBAE),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          } else {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFF8DBAE),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          }
        } else if (args.column.mappingName == 'qs3') {
          if (double.parse(args.cellValue.toString()) > 2000 &&
              double.parse(args.cellValue.toString()) < 4000) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFF8A3D94),
                textStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)));
          } else if (double.parse(args.cellValue.toString()) > 4000) {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFC390C1),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          } else {
            return const DataGridCellStyle(
                backgroundColor: Color(0xFFDEB6D5),
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)));
          }
        } else if (double.parse(args.cellValue.toString()) > 2000 &&
            double.parse(args.cellValue.toString()) < 3000) {
          return const DataGridCellStyle(
              backgroundColor: Color(0xFF7BC282),
              textStyle: TextStyle(color: Colors.black));
        } else if (double.parse(args.cellValue.toString()) > 3000) {
          return const DataGridCellStyle(
              backgroundColor: Color(0xFFC1DCA7),
              textStyle: TextStyle(color: Colors.black));
        } else {
          return const DataGridCellStyle(
              backgroundColor: Color(0xFF4CAC4C),
              textStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)));
        }
      },
      columns: <GridColumn>[
        GridTextColumn(mappingName: 'name')..headerText = 'Name',
        GridNumericColumn(mappingName: 'qs1')
          ..headerTextAlignment = Alignment.center
          ..headerText = 'Q1'
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..padding =
              kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(4),
        GridNumericColumn(mappingName: 'qs2')
          ..headerTextAlignment = Alignment.center
          ..headerText = 'Q2'
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..padding =
              kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(4),
        GridNumericColumn(mappingName: 'qs3')
          ..headerTextAlignment = Alignment.center
          ..headerText = 'Q3'
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..padding =
              kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(4),
        GridNumericColumn(mappingName: 'qs4')
          ..headerTextAlignment = Alignment.center
          ..headerText = 'Q4'
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..padding =
              kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(4),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _stockData = generateList(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _dataGridsample());
  }
}

class Stock {
  Stock(
    this.name,
    this.qs1,
    this.qs2,
    this.qs3,
    this.qs4,
  );
  final double qs1;
  final double qs2;
  final double qs3;
  final double qs4;
  final String name;
}

class ConditionalStyleDataGridSource extends DataGridSource {
  ConditionalStyleDataGridSource();
  @override
  List<Object> get dataSource => _stockData;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'name':
        return _stockData[rowIndex].name;
        break;
      case 'qs1':
        return _stockData[rowIndex].qs1;
        break;
      case 'qs2':
        return _stockData[rowIndex].qs2;
        break;
      case 'qs3':
        return _stockData[rowIndex].qs3;
        break;
      case 'qs4':
        return _stockData[rowIndex].qs4;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
