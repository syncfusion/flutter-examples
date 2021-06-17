/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the vertical live update chart sample.
class VerticalLineLiveUpdate extends SampleView {
  /// Creates the vertical live update chart sample.
  const VerticalLineLiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

/// State class of the vertical live update chart.
class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState();
  Timer? timer;
  int count = 0;
  ChartSeriesController? _chartSeriesController;
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 0, y: -4),
    ChartSampleData(x: 1, y: 3),
    ChartSampleData(x: 2, y: -3),
    ChartSampleData(x: 3, y: 2),
    ChartSampleData(x: 4, y: -2),
    ChartSampleData(x: 5, y: 0),
    ChartSampleData(x: 6, y: -3),
    ChartSampleData(x: 7, y: 4),
    ChartSampleData(x: 8, y: 0),
    ChartSampleData(x: 9, y: 0),
    ChartSampleData(x: 10, y: 0)
  ];
  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 10), _updateData);
  }

  @override
  void dispose() {
    count = 0;
    chartData = <ChartSampleData>[];
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVerticalLineUpdateChart();
  }

  /// Returns the vertical live update cartesian chart.
  SfCartesianChart _buildVerticalLineUpdateChart() {
    return SfCartesianChart(
      isTransposed: true,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Time(s)'),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Velocity(m/s)'),
          minimum: -15,
          maximum: 15),
      series: _getVerticalLineSeries(),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the vertical live update chart.
  List<LineSeries<ChartSampleData, num>> _getVerticalLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        onRendererCreated: (ChartSeriesController controller) {
          _chartSeriesController = controller;
        },
        dataSource: chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData sales, _) => sales.x as num,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
      ),
    ];
  }

  ///Update the data points
  void _updateData(Timer timer) {
    if (isCardView != null) {
      chartData = _getChartData();
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
  }

  ///Get random value
  int _getRandomInt(int min, int max) {
    final Random _random = Random();
    return min + _random.nextInt(max - min);
  }

  ///Get the chart data points
  List<ChartSampleData> _getChartData() {
    count = count + 1;
    if (count > 350 || chartData.length > 350) {
      timer?.cancel();
    } else if (count > 300) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(0, 1)));
    } else if (count > 250) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(-2, 1)));
    } else if (count > 180) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(-3, 2)));
    } else if (count > 100) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(-7, 6)));
    } else if (count < 50) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(-3, 3)));
    } else {
      chartData
          .add(ChartSampleData(x: chartData.length, y: _getRandomInt(-9, 9)));
    }
    return chartData;
  }
}
