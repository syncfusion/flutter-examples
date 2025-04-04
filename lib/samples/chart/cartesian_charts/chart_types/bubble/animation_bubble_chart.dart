/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Bubble Chart sample with dynamically updated data points.
class AnimationBubbleDefault extends SampleView {
  const AnimationBubbleDefault(Key key) : super(key: key);

  @override
  _AnimationBubbleDefaultState createState() => _AnimationBubbleDefaultState();
}

class _AnimationBubbleDefaultState extends SampleViewState {
  _AnimationBubbleDefaultState();

  Timer? _timer;
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _chartData = <_ChartData>[
      _ChartData(1, 11, 2.5),
      _ChartData(2, 24, 2.2),
      _ChartData(3, 36, 1.5),
      _ChartData(4, 54, 1.2),
      _ChartData(5, 57, 3),
      _ChartData(6, 70, 3.8),
      _ChartData(7, 78, 1),
    ];
    super.initState();
  }

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

  /// Return the Cartesian Chart with Bubble series.
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
      series: _buildBubbleSeries(),
    );
  }

  /// Returns the list of Cartesian Bubble series.
  List<BubbleSeries<_ChartData, num>> _buildBubbleSeries() {
    return <BubbleSeries<_ChartData, num>>[
      BubbleSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        sizeValueMapper: (_ChartData sales, int index) => sales.size,
      ),
    ];
  }

  /// To get the random data and return to the chart data source.
  int _buildRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    final Random randomValue = Random();
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(
        _ChartData(i, _buildRandomInt(15, 90), randomValue.nextDouble() * 0.9),
      );
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer!.cancel();
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.size);
  final int x;
  final int y;
  final double size;
}
