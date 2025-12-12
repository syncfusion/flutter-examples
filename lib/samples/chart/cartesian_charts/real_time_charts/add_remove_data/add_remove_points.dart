/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the line series chart with add and remove
/// data points options sample.
class AddDataPoints extends SampleView {
  /// Renders the line series chart with add and
  /// remove data points options.
  const AddDataPoints(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class for the line series chart with add and
/// remove data points options.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();
  late int _count;

  ChartSeriesController<ChartSampleData, num>? _chartSeriesController;

  /// List for storing the chart series data points.
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _count = 11;
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 0, y: 10),
      ChartSampleData(x: 1, y: 13),
      ChartSampleData(x: 2, y: 80),
      ChartSampleData(x: 3, y: 30),
      ChartSampleData(x: 4, y: 72),
      ChartSampleData(x: 5, y: 19),
      ChartSampleData(x: 6, y: 30),
      ChartSampleData(x: 7, y: 92),
      ChartSampleData(x: 8, y: 48),
      ChartSampleData(x: 9, y: 20),
      ChartSampleData(x: 10, y: 51),
    ];

    if (_chartData!.length > 11) {
      _chartData!.removeRange(10, _chartData!.length - 1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomPadding = 40;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
        child: Container(child: _buildAddRemovePointsChart()),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the floating action button with both the add and remove buttons.
  Widget _buildFloatingActionButton() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
            child: SizedBox(
              height: isCardView ? 40 : 45,
              width: model.isWebFullView
                  ? 140
                  : isCardView
                  ? 100
                  : 110,
              child: InkWell(
                splashColor: Colors.transparent,
                child: Row(
                  children: <Widget>[_buildAddButton(), _buildRemoveButton()],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the add button to add a data point to the chart.
  Widget _buildAddButton() {
    return SizedBox(
      width: model.isWebFullView ? 65 : 45,
      height: 50,
      child: IconButton(
        onPressed: () {
          _chartData = _addDataPoint();
          _chartSeriesController?.updateDataSource(
            addedDataIndexes: <int>[_chartData!.length - 1],
          );
        },
        icon: Icon(
          Icons.add_circle,
          size: isCardView ? 40 : 50,
          color: model.primaryColor,
        ),
      ),
    );
  }

  /// Builds the remove button to remove a data point from the chart.
  Widget _buildRemoveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: SizedBox(
        width: model.isWebFullView ? 65 : 45,
        height: 50,
        child: IconButton(
          onPressed: () {
            if (_chartData!.length > 1) {
              _chartData = _removeDataPoint();
              _chartSeriesController?.updateDataSource(
                updatedDataIndexes: <int>[_chartData!.length - 1],
                removedDataIndexes: <int>[_chartData!.length - 1],
              );
            }
          },
          icon: Icon(
            Icons.remove_circle,
            size: isCardView ? 40 : 50,
            color: model.primaryColor,
          ),
        ),
      ),
    );
  }

  /// Returns a cartesian line chart with add and
  /// remove data points options.
  SfCartesianChart _buildAddRemovePointsChart() {
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
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        onRendererCreated:
            (ChartSeriesController<ChartSampleData, num> controller) {
              _chartSeriesController = controller;
            },
      ),
    ];
  }

  /// Generates a random integer within the specified range.
  int _generateRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  /// Adds a data point to the line series.
  List<ChartSampleData> _addDataPoint() {
    _chartData!.add(ChartSampleData(x: _count, y: _generateRandomInt(10, 100)));
    _count = _count + 1;
    return _chartData!;
  }

  /// Removes the last data point from the line series.
  List<ChartSampleData> _removeDataPoint() {
    if (_chartData != null && _chartData!.isNotEmpty) {
      _chartData!.removeAt(_chartData!.length - 1);
    }
    _count = _count - 1;
    return _chartData!;
  }

  @override
  void dispose() {
    _chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }
}
