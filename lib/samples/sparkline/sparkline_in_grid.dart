///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../model/sample_view.dart';

/// Renders column type data grid
class SparkLineGrid extends SampleView {
  /// Creates column type data grid
  const SparkLineGrid(Key key) : super(key: key);

  @override
  _SparkLineGridState createState() => _SparkLineGridState();
}

class _SparkLineGridState extends SampleViewState {
  _SparkLineGridState();
  //ignore: unused_field
  final math.Random _random = math.Random();
  late bool _isLandscapeInMobileView;

  late _ColumnTypesDataGridSource _columnTypesDataGridSource;

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

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
        source: _columnTypesDataGridSource,
        columnWidthMode: model.isWebFullView
            ? ColumnWidthMode.fill
            : _isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none,
        columns: <GridColumn>[
          GridTextColumn(
              columnName: 'id',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.centerRight,
                  child: Text('ID')),
              width: 50),
          GridTextColumn(
            columnName: 'name',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text('Name')),
          ),
          GridTextColumn(
            columnName: 'shipCountry',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text('Ship country')),
          ),
          GridTextColumn(
              columnName: 'tax',
              width: model.isWebFullView ? double.nan : 130,
              label: Container(
                  alignment: Alignment.center, child: Text('Tax per annum'))),
          GridTextColumn(
              columnName: 'column',
              width: model.isWebFullView ? double.nan : 130,
              label: Container(
                  alignment: Alignment.center, child: Text('One day index'))),
          GridTextColumn(
              columnName: 'winloss',
              label: Container(
                  alignment: Alignment.center, child: Text('Year GR'))),
        ]);
  }

  @override
  void initState() {
    super.initState();
    _columnTypesDataGridSource =
        _ColumnTypesDataGridSource(_generateList(20), model.isWebFullView);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWebFullView &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid());
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

class _ColumnTypesDataGridSource extends DataGridSource {
  _ColumnTypesDataGridSource(List<_Employee> employees, this.isWeb) {
    _employeeData = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'shipCountry', value: e.shipCountry),
              DataGridCell<Widget>(columnName: 'tax', value: e.tax),
              DataGridCell<Widget>(columnName: 'column', value: e.column),
              DataGridCell<Widget>(columnName: 'winloss', value: e.winloss),
            ]))
        .toList();
  }

  late List<DataGridRow> _employeeData;

  final bool isWeb;

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all((8.0)),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all((8.0)),
        child: Text(row.getCells()[1].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all((8.0)),
        child: Text(row.getCells()[2].value),
      ),
      Container(
        padding: const EdgeInsets.all(3),
        child: row.getCells()[3].value,
      ),
      Container(
        padding: const EdgeInsets.all(3),
        child: row.getCells()[4].value,
      ),
      Container(
        padding: const EdgeInsets.all(3),
        child: row.getCells()[5].value,
      )
    ]);
  }
}
