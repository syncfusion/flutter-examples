/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Step Line Chart sample with dynamically updated data points.
class AnimationStepLineDefault extends SampleView {
  const AnimationStepLineDefault(Key key) : super(key: key);

  @override
  _AnimationStepLineDefaultState createState() =>
      _AnimationStepLineDefaultState();
}

class _AnimationStepLineDefaultState extends SampleViewState {
  _AnimationStepLineDefaultState();

  Timer? _timer;
  List<_ChartData>? _chartData;

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

  /// Return the Cartesian Chart with Step Line series.
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
      series: _buildStepLineSeries(),
    );
  }

  /// Returns the list of Cartesian Step Line series.
  List<StepLineSeries<_ChartData, num>> _buildStepLineSeries() {
    return <StepLineSeries<_ChartData, num>>[
      StepLineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
      ),
    ];
  }

  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i <= 10; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(5, 95)));
    }
    _chartData![10] = _ChartData(10, _chartData![9].y);
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _chartData!.clear();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
