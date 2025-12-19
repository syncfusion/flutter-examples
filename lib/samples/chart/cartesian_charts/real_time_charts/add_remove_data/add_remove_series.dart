/// Dart import
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with add and remove series options sample.
class AddSeries extends SampleView {
  /// Creates the chart with add and remove series options sample.
  const AddSeries(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class for the chart with add and remove series options.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();

  /// List holding the collection of chart series data points.
  List<ChartSampleData>? _chartData1;
  List<ChartSampleData>? _chartData2;

  late int count;
  late List<CartesianSeries<ChartSampleData, int>> _series;

  @override
  void initState() {
    count = 0;
    _chartData1 = _buildChartData1();
    _chartData2 = _buildChartData2();
    _series = <LineSeries<ChartSampleData, int>>[
      LineSeries<ChartSampleData, int>(
        dataSource: _chartData1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
      ),
      LineSeries<ChartSampleData, int>(
        dataSource: _chartData2,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
      ),
    ];
    super.initState();
  }

  List<ChartSampleData> _buildChartData1() {
    return [
      ChartSampleData(x: 0, y: 10),
      ChartSampleData(x: 1, y: 13),
      ChartSampleData(x: 2, y: 20),
      ChartSampleData(x: 3, y: 10),
      ChartSampleData(x: 4, y: 32),
      ChartSampleData(x: 5, y: 19),
    ];
  }

  List<ChartSampleData> _buildChartData2() {
    return [
      ChartSampleData(x: 0, y: 22),
      ChartSampleData(x: 1, y: 22),
      ChartSampleData(x: 2, y: 53),
      ChartSampleData(x: 3, y: 28),
      ChartSampleData(x: 4, y: 39),
      ChartSampleData(x: 5, y: 48),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const double bottomPadding = 45;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
        child: Container(child: _buildAddRemoveSeriesChart()),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the floating action button for adding and removing series.
  Widget _buildFloatingActionButton() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
            child: SizedBox(
              height: 45,
              width: model.isWebFullView ? 140 : 110,
              child: InkWell(
                splashColor: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: model.isWebFullView ? 65 : 45,
                      height: 50,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.add_circle,
                          size: 50,
                          color: model.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _addSeries();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: model.isWebFullView ? 65 : 45,
                        height: 50,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.remove_circle,
                            size: 50,
                            color: model.primaryColor,
                          ),
                          onPressed: () => setState(() {
                            _removeSeries();
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the chart with add and remove series options.
  SfCartesianChart _buildAddRemoveSeriesChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _series,
    );
  }

  /// Generates a random integer between the specified
  /// minimum and maximum values.
  int _generateRandomInteger(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  /// Removes the last series from the chart if available.
  void _removeSeries() {
    if (_series != null && _series.isNotEmpty) {
      _series.removeLast();
    }
  }

  /// Adds a new series to the chart with random data points.
  void _addSeries() {
    final List<ChartSampleData> chartData1 = <ChartSampleData>[];
    for (int i = 0; i <= 6; i++) {
      chartData1.add(ChartSampleData(x: i, y: _generateRandomInteger(10, 50)));
    }
    _series.add(
      LineSeries<ChartSampleData, int>(
        key: ValueKey<String>('${_series.length}'),
        dataSource: chartData1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
      ),
    );
    count++;
    if (count == 8) {
      count = 0;
    }
  }

  @override
  void dispose() {
    _chartData1!.clear();
    _chartData2!.clear();
    _series.clear();
    super.dispose();
  }
}
