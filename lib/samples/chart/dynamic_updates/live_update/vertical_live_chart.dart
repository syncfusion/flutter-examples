/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the vertical live update chart sample.
class VerticalLineLiveUpdate extends SampleView {
  const VerticalLineLiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

Timer timer;
int count = 0;
ChartSeriesController _chartSeriesController;
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

/// State class of the vertical live update chart.
class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState();

  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 10), setTime);
  }

  @override
  void dispose() {
    count = 0;
    chartData = <ChartSampleData>[];
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getVerticalLineUpdateChart();
  }

  /// Returns the vertical live update cartesian chart.
  SfCartesianChart getVerticalLineUpdateChart() {
    return SfCartesianChart(
      isTransposed: true,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        isInversed: false,
        title: AxisTitle(text: isCardView ? '' : 'Time(s)'),
        majorGridLines: MajorGridLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Velocity(m/s)'),
          minimum: -15,
          maximum: 15,
          isInversed: false),
      series: getVerticalLineSeries(),
    );
  }

  /// Returns the list of chart series which need to render on the vertical live update chart.
  List<LineSeries<ChartSampleData, num>> getVerticalLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
        dataSource: chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
      ),
    ];
  }

  void setTime(Timer timer) {
    if (isCardView != null) {
      chartData = getChartData();
      _chartSeriesController.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
        );
    }
  }

  num getRandomInt(num min, num max) {
    final Random _random = Random();
    return min + _random.nextInt(max - min);
  }

  List<ChartSampleData> getChartData() {
    count = count + 1;
    if (count > 350 || chartData.length > 350) {
      timer.cancel();
    } else if (count > 300) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(0, 1)));
    } else if (count > 250) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(-2, 1)));
    } else if (count > 180) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(-3, 2)));
    } else if (count > 100) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(-7, 6)));
    } else if (count < 50) {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(-3, 3)));
    } else {
      chartData
          .add(ChartSampleData(x: chartData.length, y: getRandomInt(-9, 9)));
    }
    return chartData;
  }
}
