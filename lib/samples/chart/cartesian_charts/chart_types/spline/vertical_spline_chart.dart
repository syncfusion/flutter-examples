/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical Spline Chart sample.
class SplineVertical extends SampleView {
  const SplineVertical(Key key) : super(key: key);

  @override
  _SplineVerticalState createState() => _SplineVerticalState();
}

/// State class of the vertical Spline Chart.
class _SplineVerticalState extends SampleViewState {
  _SplineVerticalState();

  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <_ChartData>[
      _ChartData('Jan', -1, 7),
      _ChartData('Mar', 12, 2),
      _ChartData('Apr', 25, 13),
      _ChartData('Jun', 31, 21),
      _ChartData('Aug', 26, 26),
      _ChartData('Oct', 14, 10),
      _ChartData('Dec', 8, 0),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Climate graph - 2012'),
      isTransposed: true,
      primaryXAxis: const CategoryAxis(
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: -10,
        maximum: 40,
        interval: 10,
        labelFormat: '{value}°C',
        majorGridLines: MajorGridLines(width: 0),
      ),
      series: _buildSplineSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineSeries<_ChartData, String>> _buildSplineSeries() {
    return <SplineSeries<_ChartData, String>>[
      SplineSeries<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        name: 'London',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      SplineSeries<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y2,
        name: 'France',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the Spline series data points.
class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final String x;
  final double y;
  final double y2;
}
