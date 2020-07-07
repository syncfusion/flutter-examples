/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

class AnimationColumnDefault extends SampleView {
  const AnimationColumnDefault(Key key) : super(key: key);
  
  @override
  _AnimationColumnDefaultState createState() =>
      _AnimationColumnDefaultState();
}

class _AnimationColumnDefaultState extends SampleViewState {
  _AnimationColumnDefaultState();
  Timer timer;
  
  @override
  Widget build(BuildContext context) {
    _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return getAnimationColumnChart();
  }

SfCartesianChart getAnimationColumnChart() {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(color: Colors.transparent),
          axisLine: AxisLine(width: 0),
          minimum: 0,
          maximum: 100),
      series: _getDefaultColumnSeries());
}

List<ColumnSeries<_ChartData, num>> _getDefaultColumnSeries() {
  return <ColumnSeries<_ChartData, num>>[
    ColumnSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y)
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
    for (int i = 1; i < 8; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(0, 100)));
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
