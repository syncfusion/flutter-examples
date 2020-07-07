/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Render the animation area chart.
class AnimationAreaDefault extends SampleView {
  const AnimationAreaDefault(Key key) : super(key: key);
  
  @override
  _AnimationAreaDefaultState createState() =>
      _AnimationAreaDefaultState();
}

/// State class of animation area chart.
class _AnimationAreaDefaultState extends SampleViewState {
  
  _AnimationAreaDefaultState();
  Timer timer;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });   
    return getAnimationAreaChart();
  }

/// Return the cartesian chart with animation.
SfCartesianChart getAnimationAreaChart() {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis:
          NumericAxis(interval: 1, majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(color: Colors.transparent),
          axisLine: AxisLine(width: 0),
          minimum: 0,
          maximum: 100),
      series: getDefaultAreaSeries());
}

/// Return the list of  area series which need to be animated.
List<AreaSeries<_ChartData, num>> getDefaultAreaSeries() {
  return <AreaSeries<_ChartData, num>>[
    AreaSeries<_ChartData, num>(
        dataSource:  _chartData,
        color: const Color.fromRGBO(75, 135, 185, 0.6),
        borderColor: const Color.fromRGBO(75, 135, 185, 1),
        borderWidth: 2,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y)
  ];
}

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

/// Return the random value in area series.
  num _getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 8; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(10, 95)));
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
