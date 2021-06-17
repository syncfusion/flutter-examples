/// Dart imports
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the auto scrolling chart
class AutoScrollingChart extends SampleView {
  /// Creates the auto scrolling chart
  const AutoScrollingChart(Key key) : super(key: key);

  @override
  _AutoScrollingChartState createState() => _AutoScrollingChartState();
}

class _AutoScrollingChartState extends SampleViewState {
  _AutoScrollingChartState();

  Timer? timer;
  late List<Color> palette;
  late List<_ChartData> chartData, chartDataTemp;
  ChartSeriesController? _chartSeriesController;

  late bool isPointerMoved;
  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  void _initializeVariables() {
    palette = const <Color>[
      Color.fromRGBO(75, 135, 185, 1),
      Color.fromRGBO(192, 108, 132, 1),
      Color.fromRGBO(246, 114, 128, 1),
      Color.fromRGBO(248, 177, 149, 1),
      Color.fromRGBO(116, 180, 155, 1),
      Color.fromRGBO(0, 168, 181, 1),
      Color.fromRGBO(73, 76, 162, 1),
      Color.fromRGBO(255, 205, 96, 1),
      Color.fromRGBO(255, 240, 219, 1),
      Color.fromRGBO(238, 238, 238, 1)
    ];
    isPointerMoved = false;
    chartData = <_ChartData>[
      _ChartData(DateTime(2020, 01, 1, 00, 00, 00), 42, palette[0]),
      _ChartData(DateTime(2020, 01, 1, 00, 00, 01), 47, palette[1]),
    ];
    chartDataTemp = <_ChartData>[];
    timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      if (!isPointerMoved) {
        if (chartDataTemp.isNotEmpty) {
          chartData.addAll(chartDataTemp);
          chartDataTemp.clear();
        }
        setState(() {
          chartData = _updateDataSource();
        });
      } else {
        chartDataTemp = _updateTempDataSource();
      }
    });
  }

  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
        onChartTouchInteractionMove: (ChartTouchInteractionArgs args) {
          isPointerMoved = true;
        },
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          isPointerMoved = false;
        },
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          dateFormat: DateFormat.Hms(),
          intervalType: DateTimeIntervalType.seconds,
          autoScrollingDelta: 10,
          autoScrollingDeltaType: DateTimeIntervalType.seconds,
        ),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: <ColumnSeries<_ChartData, DateTime>>[
          ColumnSeries<_ChartData, DateTime>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            pointColorMapper: (_ChartData data, _) => data.color,
            animationDuration: 0,
          )
        ]);
  }

  List<_ChartData> _updateDataSource() {
    chartData.add(_ChartData(
        chartData[chartData.length - 1].x.add(const Duration(seconds: 1)),
        _getRandomInt(30, 60),
        palette[chartData.length % 10]));
    _chartSeriesController?.updateDataSource(
      addedDataIndexes: <int>[chartData.length - 1],
    );
    return chartData;
  }

  List<_ChartData> _updateTempDataSource() {
    chartDataTemp.add(_ChartData(
        chartDataTemp.isEmpty
            ? chartData[chartData.length - 1].x.add(const Duration(seconds: 1))
            : chartDataTemp[chartDataTemp.length - 1]
                .x
                .add(const Duration(seconds: 1)),
        _getRandomInt(30, 60),
        palette[(chartDataTemp.isEmpty
                ? chartData.length
                : chartData.length + chartDataTemp.length) %
            10]));
    return chartDataTemp;
  }

  int _getRandomInt(int min, int max) {
    final math.Random _random = math.Random();
    return min + _random.nextInt(max - min);
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);
  final DateTime x;
  final num y;
  final Color color;
}
