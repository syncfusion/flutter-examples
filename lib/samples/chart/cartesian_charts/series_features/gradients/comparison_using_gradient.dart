/// Package import
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Renders default line series chart
class GradientComparison extends SampleView {
  ///Creates default line series chart
  const GradientComparison(Key key) : super(key: key);

  @override
  _GradientComparisonState createState() => _GradientComparisonState();
}

class _GradientComparisonState extends SampleViewState {
  _GradientComparisonState();

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradientComparisonChart();
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildGradientComparisonChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Average monthly temperature of London'),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}°C',
          minimum: 0,
          maximum: 25,
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      tooltipBehavior: _tooltipBehavior,
      series: _getGradientComparisonSeries(),
    );
  }

  /// The method returns line series to chart.
  List<CartesianSeries<_ChartData, String>> _getGradientComparisonSeries() {
    return <CartesianSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
        dataSource: <_ChartData>[
          _ChartData('Jan', 4.3),
          _ChartData('Feb', 5.2),
          _ChartData('Mar', 6.7),
          _ChartData('Apr', 9.4),
          _ChartData('May', 12.7),
          _ChartData('Jun', 15.7),
          _ChartData('Jul', 17.8),
          _ChartData('Aug', 17),
          _ChartData('Sep', 15),
          _ChartData('Oct', 11.8),
          _ChartData('Nov', 7.8),
          _ChartData('Dec', 5.3),
        ],
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              const <Color>[Colors.red, Colors.orange, Colors.yellow],
              <double>[0.3, 0.6, 0.9]);
        },
        name: 'London',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: !isCardView, offset: const Offset(0, -5)),
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
