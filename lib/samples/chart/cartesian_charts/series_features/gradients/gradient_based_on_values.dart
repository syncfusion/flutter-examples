/// Package import.
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default column series chart
/// filled with a gradient.
class GradientComparison extends SampleView {
  /// Creates the default column series chart
  /// filled with a gradient.
  const GradientComparison(Key key) : super(key: key);

  @override
  _GradientComparisonState createState() => _GradientComparisonState();
}

/// State class for the default column series chart
/// filled with a gradient.
class _GradientComparisonState extends SampleViewState {
  _GradientComparisonState();

  List<_ChartSampleData>? _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _chartData = <_ChartSampleData>[
      _ChartSampleData('Jan', 4.3),
      _ChartSampleData('Feb', 5.2),
      _ChartSampleData('Mar', 6.7),
      _ChartSampleData('Apr', 9.4),
      _ChartSampleData('May', 12.7),
      _ChartSampleData('Jun', 15.7),
      _ChartSampleData('Jul', 17.8),
      _ChartSampleData('Aug', 17),
      _ChartSampleData('Sep', 15),
      _ChartSampleData('Oct', 11.8),
      _ChartSampleData('Nov', 7.8),
      _ChartSampleData('Dec', 5.3),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradientChart();
  }

  /// Returns a cartesian column chart filled with a gradient.
  SfCartesianChart _buildGradientChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Average monthly temperature of London',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}°C',
        minimum: 0,
        maximum: 25,
        interval: 5,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildColumnSeries(),
    );
  }

  /// Returns the cartesian column series.
  List<CartesianSeries<_ChartSampleData, String>> _buildColumnSeries() {
    return <CartesianSeries<_ChartSampleData, String>>[
      ColumnSeries<_ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        name: 'London',
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
            details.rect.topCenter,
            details.rect.bottomCenter,
            const <Color>[Colors.red, Colors.orange, Colors.yellow],
            <double>[0.3, 0.6, 0.9],
          );
        },
        dataLabelSettings: DataLabelSettings(
          isVisible: !isCardView,
          offset: const Offset(0, -5),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartSampleData {
  _ChartSampleData(this.x, this.y);
  final String x;
  final double y;
}
