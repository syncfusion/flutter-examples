/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the vertical spline chart sample.
class SplineVertical extends SampleView {
  /// Creates the transposed spline chart sample.
  const SplineVertical(Key key) : super(key: key);

  @override
  _SplineVerticalState createState() => _SplineVerticalState();
}

/// State class of the vertical spline chart.
class _SplineVerticalState extends SampleViewState {
  _SplineVerticalState();

  @override
  Widget build(BuildContext context) {
    return _buildVerticalSplineChart();
  }

  /// Returns the vertical spline chart.
  SfCartesianChart _buildVerticalSplineChart() {
    return SfCartesianChart(
      isTransposed: true,
      title: ChartTitle(text: isCardView ? '' : 'Climate graph - 2012'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: -10,
          maximum: 40,
          interval: 10,
          labelFormat: '{value}°C',
          majorGridLines: const MajorGridLines(width: 0)),
      series: _getVerticalSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the vertical spline chart.
  List<SplineSeries<_ChartData, String>> _getVerticalSplineSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData('Jan', -1, 7),
      _ChartData('Mar', 12, 2),
      _ChartData('Apr', 25, 13),
      _ChartData('Jun', 31, 21),
      _ChartData('Aug', 26, 26),
      _ChartData('Oct', 14, 10),
      _ChartData('Dec', 8, 0),
    ];
    return <SplineSeries<_ChartData, String>>[
      SplineSeries<_ChartData, String>(
          markerSettings: const MarkerSettings(isVisible: true),
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
          name: 'London'),
      SplineSeries<_ChartData, String>(
        markerSettings: const MarkerSettings(isVisible: true),
        dataSource: chartData,
        width: 2,
        name: 'France',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
      )
    ];
  }
}

/// Private class for storing the spline series data points.
class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final String x;
  final double y;
  final double y2;
}
