/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the numeric with axis label format.
class NumericLabel extends SampleView {
  /// Creates the numeric with axis label format.
  const NumericLabel(Key key) : super(key: key);

  @override
  _NumericLabelState createState() => _NumericLabelState();
}

/// State class of numeric axis label format.
class _NumericLabelState extends SampleViewState {
  _NumericLabelState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
        format: 'point.x / point.y');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  Widget _buildChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title:
          ChartTitle(text: isCardView ? '' : 'Farenheit - Celsius conversion'),
      primaryXAxis: NumericAxis(
          labelFormat: '{value}°C',
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}°F',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: getNumericLabelSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Return the line series with numeric axis label.
  List<LineSeries<ChartSampleData, num>> getNumericLabelSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(xValue: 0, yValue: 32),
      ChartSampleData(xValue: 5, yValue: 41),
      ChartSampleData(xValue: 10, yValue: 50),
      ChartSampleData(xValue: 15, yValue: 59),
      ChartSampleData(xValue: 20, yValue: 68),
      ChartSampleData(xValue: 25, yValue: 77),
      ChartSampleData(xValue: 30, yValue: 86),
      ChartSampleData(xValue: 35, yValue: 95),
      ChartSampleData(xValue: 40, yValue: 104),
      ChartSampleData(xValue: 45, yValue: 113),
      ChartSampleData(xValue: 50, yValue: 122)
    ];
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          width: 2,
          markerSettings:
              const MarkerSettings(height: 10, width: 10, isVisible: true)),
    ];
  }
}
