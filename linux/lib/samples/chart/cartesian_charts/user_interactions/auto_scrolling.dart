/// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late List<Color> palette1;
  late List<Color> palette2;
  late List<_ChartData> chartData, chartDataTemp;
  bool havingPanDataSource = false;

  late bool isPointerMoved;
  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    chartData.clear();
    chartDataTemp.clear();
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
    palette1 = const <Color>[
      Color.fromRGBO(6, 174, 224, 1),
      Color.fromRGBO(99, 85, 199, 1),
      Color.fromRGBO(49, 90, 116, 1),
      Color.fromRGBO(255, 180, 0, 1),
      Color.fromRGBO(150, 60, 112, 1),
      Color.fromRGBO(33, 150, 245, 1),
      Color.fromRGBO(71, 59, 137, 1),
      Color.fromRGBO(236, 92, 123, 1),
      Color.fromRGBO(59, 163, 26, 1),
      Color.fromRGBO(236, 131, 23, 1)
    ];
    palette2 = const <Color>[
      Color.fromRGBO(255, 245, 0, 1),
      Color.fromRGBO(51, 182, 119, 1),
      Color.fromRGBO(218, 150, 70, 1),
      Color.fromRGBO(201, 88, 142, 1),
      Color.fromRGBO(77, 170, 255, 1),
      Color.fromRGBO(255, 157, 69, 1),
      Color.fromRGBO(178, 243, 46, 1),
      Color.fromRGBO(185, 60, 228, 1),
      Color.fromRGBO(48, 167, 6, 1),
      Color.fromRGBO(207, 142, 14, 1)
    ];
    isPointerMoved = false;
    chartData = <_ChartData>[
      _ChartData(DateTime(2020), 42),
      _ChartData(DateTime(2020, 01, 1, 00, 00, 01), 47),
    ];
    chartDataTemp = <_ChartData>[];
    timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      if (!isPointerMoved) {
        if (chartDataTemp.isNotEmpty) {
          chartData.addAll(chartDataTemp);
          chartDataTemp.clear();
          havingPanDataSource = true;
        }
        setState(() {
          chartData = _updateDataSource();
          havingPanDataSource = false;
        });
      } else {
        chartDataTemp = _updateTempDataSource();
      }
    });
  }

  SfCartesianChart _buildLiveLineChart() {
    final ThemeData themeData = model.themeData;
    palette = themeData.useMaterial3
        ? (themeData.brightness == Brightness.light ? palette1 : palette2)
        : palette;
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
        primaryYAxis: const NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0)),
        series: <ColumnSeries<_ChartData, DateTime>>[
          ColumnSeries<_ChartData, DateTime>(
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            pointColorMapper: (_ChartData data, _) => palette[_ % 10],
            animationDuration: 0,
          )
        ]);
  }

  List<_ChartData> _updateDataSource() {
    if (!havingPanDataSource) {
      chartData.add(_ChartData(
        chartData[chartData.length - 1].x.add(const Duration(seconds: 1)),
        _getRandomInt(30, 60),
      ));
    }
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
    ));
    return chartDataTemp;
  }

  int _getRandomInt(int min, int max) {
    final math.Random random = math.Random();
    return min + random.nextInt(max - min);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final num y;
}
