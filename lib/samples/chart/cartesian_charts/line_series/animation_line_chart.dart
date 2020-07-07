/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

class AnimationLineDefault extends SampleView {
  const AnimationLineDefault(Key key) : super(key: key);
  @override
  _AnimationLineDefaultState createState() =>
      _AnimationLineDefaultState();
}

class _AnimationLineDefaultState extends SampleViewState {
  _AnimationLineDefaultState();
  
Timer timer;
  @override
  Widget build(BuildContext context) {
    _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    
    return getAnimationLineChart();
  }

SfCartesianChart getAnimationLineChart() {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        majorTickLines: MajorTickLines(color: Colors.transparent),
        axisLine: AxisLine(width: 0),
        minimum: 0, maximum: 100),
      series: _getDefaultLineSeries());
}

/// The method returns line series to chart.
List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        dataSource:  _chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  num _getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i < 11; i++){
      _chartData.add(_ChartData(i, _getRandomInt(5, 95)));
    }
    timer?.cancel();
  }
}

List<_ChartData> _chartData;

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
