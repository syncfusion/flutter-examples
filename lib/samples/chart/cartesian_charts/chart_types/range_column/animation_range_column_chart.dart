/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Range Column Chart sample with dynamically updated data points.
class AnimationRangeColumnDefault extends SampleView {
  const AnimationRangeColumnDefault(Key key) : super(key: key);

  @override
  _AnimationRangeColumnDefaultState createState() =>
      _AnimationRangeColumnDefaultState();
}

class _AnimationRangeColumnDefaultState extends SampleViewState {
  _AnimationRangeColumnDefaultState();

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

  /// Return the Cartesian Chart with Range Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorTickLines: MajorTickLines(color: Colors.transparent),
        axisLine: AxisLine(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      series: _buildRangeColumnSeries(),
    );
  }

  /// Returns the list of Cartesian Range Column series.
  List<RangeColumnSeries<_ChartData, num>> _buildRangeColumnSeries() {
    return <RangeColumnSeries<_ChartData, num>>[
      RangeColumnSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        lowValueMapper: (_ChartData sales, int index) => sales.y,
        highValueMapper: (_ChartData sales, int index) => sales.z,
      ),
    ];
  }

  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(
        _ChartData(i, _buildRandomInt(5, 45), _buildRandomInt(46, 95)),
      );
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
  _ChartData(this.x, this.y, this.z);
  final int x;
  final int y;
  final int z;
}
