/// Package imports
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Barcode imports
// ignore: depend_on_referenced_packages
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

  late bool _isLandscapeInMobileView;
  late _ColumnTypesDataGridSource _columnTypesDataGridSource;
  late List<Widget> _taxs;
  late List<String> _names;
  late List<List<double>> _winlossData;
  late List<Widget> _columnData;
  late List<String> _shipCountrys;

  @override
  void initState() {
    super.initState();
    _names = <String>[
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
      'FRANK',
    ];

    _winlossData = <List<double>>[
      <double>[0, 6, -4, 1, -3, 2, 5],
      <double>[5, -4, 6, 3, -1, 2, 0],
      <double>[6, 4, 0, 3, -2, 5, 1],
      <double>[4, -6, 3, 0, 1, -2, 5],
      <double>[3, 5, -6, -4, 0, 1, 2],
      <double>[1, -3, 4, -2, 5, 0, 6],
      <double>[2, 4, 0, -3, 5, -6, 1],
      <double>[5, 4, -6, 3, 1, -2, 0],
      <double>[0, -6, 4, 1, -3, 2, 5],
      <double>[6, 4, 0, -3, 2, -5, 1],
      <double>[4, 6, -3, 0, 1, 2, 5],
      <double>[3, -5, -6, 4, 0, 1, 2],
      <double>[1, 3, -4, -2, 5, 0, 6],
      <double>[2, -4, 0, -3, 5, 6, 1],
      <double>[5, 4, -6, 3, 1, -2, 0],
      <double>[0, 6, 4, -1, -3, 2, 5],
      <double>[6, -4, 0, -3, 2, 5, 1],
      <double>[4, 6, -3, 0, -1, 2, 5],
      <double>[6, 4, 0, -3, 2, -5, 1],
      <double>[3, 5, 6, -4, 0, 1, 2],
      <double>[1, 3, -4, 2, -5, 0, 6],
    ];
    _shipCountrys = <String>[
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

    _taxs = <Widget>[
      SfSparkLineChart(
        data: const <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[1, 3, 4, 2, 5, 0, 6],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[1, 3, 4, 2, 5, 0, 6],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[5, 4, 6, 3, 1, 2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[0, 6, 4, 1, 3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[6, 4, 0, 3, 2, 5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[4, 6, 3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[2, 4, 0, 3, 5, 6, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkLineChart(
        data: const <double>[3, 5, 6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
    ];

    _columnData = <Widget>[
      SfSparkBarChart(
        data: const <double>[0, 6, -4, 1, -3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[5, -4, 6, 3, -1, 2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[6, 4, 0, 3, -2, 5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[4, -6, 3, 0, 1, -2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[3, 5, -6, -4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[1, -3, 4, -2, 5, 0, 6],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[2, 4, 0, -3, 5, -6, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[5, 4, -6, 3, 1, -2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[0, -6, 4, 1, -3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[6, 4, 0, -3, 2, -5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[4, 6, -3, 0, 1, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[3, -5, -6, 4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[1, 3, -4, -2, 5, 0, 6],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[2, -4, 0, -3, 5, 6, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[5, 4, -6, 3, 1, -2, 0],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[0, 6, 4, -1, -3, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[6, -4, 0, -3, 2, 5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[4, 6, -3, 0, -1, 2, 5],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[6, 4, 0, -3, 2, -5, 1],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
      SfSparkBarChart(
        data: const <double>[3, 5, 6, -4, 0, 1, 2],
        axisLineWidth: 0,
        trackball: const SparkChartTrackball(),
      ),
    ];
    _columnTypesDataGridSource = _ColumnTypesDataGridSource(
      _generateList(20),
      model.isWebFullView,
    );
  }

  List<_Employee> _generateList(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(
        _Employee(
          1 + i,
          _names[i],
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _taxs[i],
          ),
          _shipCountrys[i],
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _columnData[i],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SfSparkWinLossChart(
              data: _winlossData[i],
              trackball: const SparkChartTrackball(),
            ),
          ),
        ),
      );
    }
    return employeeData;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: _columnTypesDataGridSource,
      columnWidthMode: model.isWebFullView
          ? ColumnWidthMode.fill
          : _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'id',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: const Text('ID'),
          ),
          width: 50,
        ),
        GridColumn(
          columnName: 'name',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Name'),
          ),
        ),
        GridColumn(
          columnName: 'shipCountry',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Ship country'),
          ),
        ),
        GridColumn(
          columnName: 'tax',
          width: model.isWebFullView ? double.nan : 130,
          label: Container(
            alignment: Alignment.center,
            child: const Text('Tax per annum'),
          ),
        ),
        GridColumn(
          columnName: 'column',
          width: model.isWebFullView ? double.nan : 130,
          label: Container(
            alignment: Alignment.center,
            child: const Text('One day index'),
          ),
        ),
        GridColumn(
          columnName: 'winloss',
          label: Container(
            alignment: Alignment.center,
            child: const Text('Year GR'),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !model.isWebFullView &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid());
  }
}

class _Employee {
  _Employee(
    this.id,
    this.name,
    this.tax,
    this.shipCountry,
    this.column,
    this.winloss,
  );
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
        .map<DataGridRow>(
          (_Employee e) => DataGridRow(
            cells: <DataGridCell<dynamic>>[
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                columnName: 'shipCountry',
                value: e.shipCountry,
              ),
              DataGridCell<Widget>(columnName: 'tax', value: e.tax),
              DataGridCell<Widget>(columnName: 'column', value: e.column),
              DataGridCell<Widget>(columnName: 'winloss', value: e.winloss),
            ],
          ),
        )
        .toList();
  }

  late List<DataGridRow> _employeeData;

  final bool isWeb;

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[0].value.toString()),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[1].value),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
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
        ),
      ],
    );
  }
}
