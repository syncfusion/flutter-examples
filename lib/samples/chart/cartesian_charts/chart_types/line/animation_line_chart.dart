/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart sample with dynamically updated data points.
class AnimationLineDefault extends SampleView {
  const AnimationLineDefault(Key key) : super(key: key);
  @override
  _AnimationLineDefaultState createState() => _AnimationLineDefaultState();
}

class _AnimationLineDefaultState extends SampleViewState {
  _AnimationLineDefaultState();

  Timer? _timer;
  List<_ChartData>? _chartData;

  @override
  Widget build(BuildContext context) {
    _createChartData();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _createChartData();
      });
    });
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
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
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, num>> _buildLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  int _createRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _createChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i < 11; i++) {
      _chartData!.add(_ChartData(i, _createRandomInt(5, 95)));
    }
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
