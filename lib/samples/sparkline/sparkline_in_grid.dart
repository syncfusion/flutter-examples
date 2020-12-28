///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../model/sample_view.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Renders column type data grid
class SparkLineGrid extends SampleView {
  /// Creates column type data grid
  const SparkLineGrid(Key key) : super(key: key);

  @override
  _SparkLineGridState createState() => _SparkLineGridState();
}

List<_Employee> _employeeData;

class _SparkLineGridState extends SampleViewState {
  _SparkLineGridState();
  //ignore: unused_field
  final math.Random _random = math.Random();
  bool _isLandscapeInMobileView;

  final _ColumnTypesDataGridSource _columnTypesDataGridSource =
      _ColumnTypesDataGridSource();

  List<_Employee> _generateList(int _count) {
    final List<_Employee> _employeeData = <_Employee>[];
    for (int i = 0; i < _count; i++) {
      _employeeData.add(_Employee(
          1 + i,
          _names[i],
          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0), child: _taxs[i]),
          _shipCountrys[i],
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: _columnData[i]),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SfSparkWinLossChart(
                  data: _winlossData[i],
                  trackball: SparkChartTrackball(
                      activationMode: SparkChartActivationMode.tap)))));
    }
    return _employeeData;
  }

  final List<Widget> _taxs = <Widget>[
    SfSparkLineChart(
        data: <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[1, 3, 4, 2, 5, 0, 6],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[1, 3, 4, 2, 5, 0, 6],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkLineChart(
        data: <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
  ];

  final List<String> _names = <String>[
    'VINET',
    'TOMSP',
    'HANAR',
    'VICTE',
    'SUPRD',
    'HANAR',
    'CHOPS',
    'RICSU',
    'WELLI',
    'HILAA',
    'ERNSH',
    'CENTC',
    'OTTIK',
    'QUEDE',
    'RATTC',
    'ERNSH',
    'FOLKO',
    'BLONP',
    'WARTH',
    'FRANK'
  ];

  final List<List<double>> _winlossData = <List<double>>[
    [0, 6, -4, 1, -3, 2, 5],
    [5, -4, 6, 3, -1, 2, 0],
    [6, 4, 0, 3, -2, 5, 1],
    [4, -6, 3, 0, 1, -2, 5],
    [3, 5, -6, -4, 0, 1, 2],
    [1, -3, 4, -2, 5, 0, 6],
    [2, 4, 0, -3, 5, -6, 1],
    [5, 4, -6, 3, 1, -2, 0],
    [0, -6, 4, 1, -3, 2, 5],
    [6, 4, 0, -3, 2, -5, 1],
    [4, 6, -3, 0, 1, 2, 5],
    [3, -5, -6, 4, 0, 1, 2],
    [1, 3, -4, -2, 5, 0, 6],
    [2, -4, 0, -3, 5, 6, 1],
    [5, 4, -6, 3, 1, -2, 0],
    [0, 6, 4, -1, -3, 2, 5],
    [6, -4, 0, -3, 2, 5, 1],
    [4, 6, -3, 0, -1, 2, 5],
    [6, 4, 0, -3, 2, -5, 1],
    [3, 5, 6, -4, 0, 1, 2],
    [1, 3, -4, 2, -5, 0, 6]
  ];
  final List<Widget> _columnData = <Widget>[
    SfSparkBarChart(
        data: <double>[0, 6, -4, 1, -3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[5, -4, 6, 3, -1, 2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[6, 4, 0, 3, -2, 5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[4, -6, 3, 0, 1, -2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[3, 5, -6, -4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[1, -3, 4, -2, 5, 0, 6],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[2, 4, 0, -3, 5, -6, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[5, 4, -6, 3, 1, -2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[0, -6, 4, 1, -3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[6, 4, 0, -3, 2, -5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[4, 6, -3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[3, -5, -6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[1, 3, -4, -2, 5, 0, 6],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[2, -4, 0, -3, 5, 6, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[5, 4, -6, 3, 1, -2, 0],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[0, 6, 4, -1, -3, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[6, -4, 0, -3, 2, 5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[4, 6, -3, 0, -1, 2, 5],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[6, 4, 0, -3, 2, -5, 1],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap)),
    SfSparkBarChart(
        data: <double>[3, 5, 6, -4, 0, 1, 2],
        axisLineWidth: 0,
        trackball:
            SparkChartTrackball(activationMode: SparkChartActivationMode.tap))
  ];

  //ignore: unused_field
  final List<DateTime> _orderDates = <DateTime>[
    DateTime(1996, 07, 04),
    DateTime(1996, 07, 05),
    DateTime(1996, 07, 08),
    DateTime(1996, 07, 08),
    DateTime(1996, 07, 09),
    DateTime(1996, 07, 10),
    DateTime(1996, 07, 11),
    DateTime(1996, 07, 12),
    DateTime(1996, 07, 15),
    DateTime(1996, 07, 16),
    DateTime(1996, 07, 17),
    DateTime(1996, 07, 18),
    DateTime(1996, 07, 19),
    DateTime(1996, 07, 19),
    DateTime(1996, 07, 22),
    DateTime(1996, 07, 23),
    DateTime(1996, 07, 24),
    DateTime(1996, 07, 25),
    DateTime(1996, 07, 26),
    DateTime(1996, 07, 29),
  ];

  final List<String> _shipCountrys = <String>[
    'France',
    'Germany',
    'Brazil',
    'France',
    'Belgium',
    'Brazil',
    'Switzerland',
    'Switzerland',
    'Brazil',
    'Venezuela',
    'Austria',
    'Mexico',
    'Germany',
    'Brazil',
    'USA',
    'Austria',
    'Sweden',
    'France',
    'Finland',
    'Germany',
  ];

  SfDataGrid _getDataGrid() {
    return SfDataGrid(
        source: _columnTypesDataGridSource,
        columnWidthMode: model.isWeb
            ? ColumnWidthMode.fill
            : _isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.auto,
        cellBuilder: (BuildContext context, GridColumn column, int rowIndex) {
          Widget widget;
          if (column.mappingName == 'tax') {
            widget = Container(
              padding: const EdgeInsets.all(3),
              child: _employeeData[rowIndex].tax,
            );
          }
          if (column.mappingName == 'column') {
            widget = Container(
              padding: const EdgeInsets.all(3),
              child: _employeeData[rowIndex].column,
            );
          }
          if (column.mappingName == 'winloss') {
            widget = Container(
              padding: const EdgeInsets.all(3),
              child: _employeeData[rowIndex].winloss,
            );
          }
          return widget;
        },
        columns: <GridColumn>[
          GridNumericColumn(
              mappingName: 'id',
              headerText: ' ID',
              columnWidthMode: ColumnWidthMode.header,
              headerTextAlignment: Alignment.centerRight),
          GridTextColumn(
              mappingName: 'name',
              headerText: 'Name',
              columnWidthMode: (model.isWeb || _isLandscapeInMobileView)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.cells,
              headerTextAlignment: Alignment.centerLeft),
          GridTextColumn(
              mappingName: 'shipCountry',
              headerText: 'Ship country',
              columnWidthMode: (model.isWeb || _isLandscapeInMobileView)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.header,
              headerTextAlignment: Alignment.centerLeft),
          GridWidgetColumn(
              columnWidthMode: (model.isWeb || _isLandscapeInMobileView)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.header,
              mappingName: 'tax',
              headerText: 'Tax per annum'),
          GridWidgetColumn(
              columnWidthMode: (model.isWeb || _isLandscapeInMobileView)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.header,
              mappingName: 'column',
              headerText: 'One day index'),
          GridWidgetColumn(
              columnWidthMode: (model.isWeb || _isLandscapeInMobileView)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.header,
              mappingName: 'winloss',
              headerText: 'Year GR'),
        ]);
  }

  @override
  void initState() {
    super.initState();
    _employeeData = _generateList(20);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getDataGrid());
  }
}

class _Employee {
  _Employee(this.id, this.name, this.tax, this.shipCountry, this.column,
      this.winloss);
  final int id;
  final String name;
  final String shipCountry;
  final Widget tax;
  final Widget column;
  final Widget winloss;
}

class _ColumnTypesDataGridSource extends DataGridSource<_Employee> {
  _ColumnTypesDataGridSource();
  @override
  List<_Employee> get dataSource => _employeeData;
  @override
  Object getValue(_Employee _employee, String columnName) {
    switch (columnName) {
      case 'id':
        return _employee.id;
        break;
      case 'name':
        return _employee.name;
        break;
      case 'shipCountry':
        return _employee.shipCountry;
        break;
      case 'tax':
        return _employee.tax;
        break;
      case 'column':
        return _employee.column;
        break;
      case 'winloss':
        return _employee.winloss;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
