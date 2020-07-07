/// Dart imports
import 'dart:async';
import 'dart:math'; 

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';


class AnimationRangeColumnDefault extends SampleView {
  const AnimationRangeColumnDefault(Key key) : super(key: key);
  
  @override
  _AnimationRangeColumnDefaultState createState() =>
      _AnimationRangeColumnDefaultState();
}

class _AnimationRangeColumnDefaultState
    extends SampleViewState {
  _AnimationRangeColumnDefaultState();
  Timer timer;

  @override
  Widget build(BuildContext context) {
        _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return getAnimationRangeColumnChart();
  }

/// The method range column series with animation.
SfCartesianChart getAnimationRangeColumnChart() {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(color: Colors.transparent),
          axisLine: AxisLine(width: 0),
          minimum: 0,
          maximum: 100),
      series: getDefaultRangeColumnSeries());
}

List<RangeColumnSeries<_ChartData, num>> getDefaultRangeColumnSeries() {
  return <RangeColumnSeries<_ChartData, num>>[
    RangeColumnSeries<_ChartData, num>(
        dataSource:  _chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        lowValueMapper: (_ChartData sales, _) => sales.y,
        highValueMapper: (_ChartData sales, _) => sales.z)
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
    for (int i = 1; i <= 7; i++) {
      _chartData
          .add(_ChartData(i, _getRandomInt(5, 45), _getRandomInt(46, 95)));
    }
    timer?.cancel();
  }
}

List<_ChartData> _chartData;

class _ChartData {
  _ChartData(this.x, this.y, this.z);
  final int x;
  final int y;
  final int z;
}
