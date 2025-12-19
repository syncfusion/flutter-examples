/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Spline Chart sample with dynamically updated data points.
class AnimationSplineDefault extends SampleView {
  const AnimationSplineDefault(Key key) : super(key: key);

  @override
  _AnimationSplineDefaultState createState() => _AnimationSplineDefaultState();
}

class _AnimationSplineDefaultState extends SampleViewState {
  _AnimationSplineDefaultState();

  List<_ChartData>? _chartData;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    _buildChartData();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _buildChartData();
      });
    });
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
        majorTickLines: MajorTickLines(color: Colors.transparent),
        axisLine: AxisLine(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      series: _buildSplineSeries(),
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineSeries<_ChartData, num>> _buildSplineSeries() {
    return <SplineSeries<_ChartData, num>>[
      SplineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  /// Get the random value.
  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  /// Get the random data points.
  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i < 11; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(15, 85)));
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
