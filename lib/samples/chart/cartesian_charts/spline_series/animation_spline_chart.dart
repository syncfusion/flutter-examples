/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

class AnimationSplineDefault extends SampleView {
  const AnimationSplineDefault(Key key) : super(key: key);
  
  @override
  _AnimationSplineDefaultState createState() =>
      _AnimationSplineDefaultState();
}

class _AnimationSplineDefaultState extends SampleViewState {
  _AnimationSplineDefaultState();
  
Timer timer;
  @override
  Widget build(BuildContext context) {
        _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return getAnimationSplineChart();
  }

SfCartesianChart getAnimationSplineChart() {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(color: Colors.transparent),
          axisLine: AxisLine(width: 0),
          minimum: 0,
          maximum: 100),
      series: getDefaultSplineSeries());
}

List<SplineSeries<_ChartData, num>> getDefaultSplineSeries() {
  return <SplineSeries<_ChartData, num>>[
    SplineSeries<_ChartData, num>(
        dataSource: _chartData,
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
    for (int i = 0; i < 11; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(15, 85)));
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
