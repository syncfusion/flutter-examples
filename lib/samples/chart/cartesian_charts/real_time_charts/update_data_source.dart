/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the update data source chart sample.
class UpdateDataSource extends SampleView {
  /// Creates the update data source chart sample.
  const UpdateDataSource(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class for the update data source chart.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();

  List<ChartSampleData>? _chartData;
  Random? _random;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 1, y: 30),
      ChartSampleData(x: 3, y: 13),
      ChartSampleData(x: 5, y: 80),
      ChartSampleData(x: 7, y: 30),
      ChartSampleData(x: 9, y: 72),
    ];
    _random = Random.secure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomPadding = 60;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, bottomPadding),
        child: Container(child: _buildUpdateDataSourceChart()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _chartData = <ChartSampleData>[];
          _chartData = _buildChartData();
        }),
        backgroundColor: model.primaryColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  /// Returns the update data source cartesian
  /// column series chart.
  SfCartesianChart _buildUpdateDataSourceChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
        minimum: 0,
        interval: 1,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.additional,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        minorGridLines: MinorGridLines(width: 0),
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, num>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  /// Generates a random integer between the specified range.
  int _generateRandomInteger(int min, int max) {
    return min + _random!.nextInt(max - min);
  }

  List<ChartSampleData> _buildChartData() {
    _chartData!.add(ChartSampleData(x: 1, y: _generateRandomInteger(10, 100)));
    _chartData!.add(ChartSampleData(x: 3, y: _generateRandomInteger(10, 100)));
    _chartData!.add(ChartSampleData(x: 5, y: _generateRandomInteger(10, 100)));
    _chartData!.add(ChartSampleData(x: 7, y: _generateRandomInteger(10, 100)));
    _chartData!.add(ChartSampleData(x: 9, y: _generateRandomInteger(10, 100)));
    return _chartData!;
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
