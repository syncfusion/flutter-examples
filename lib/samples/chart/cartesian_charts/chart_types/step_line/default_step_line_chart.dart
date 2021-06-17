/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the default stepline chart sample.
class StepLineDefault extends SampleView {
  /// Creates the default step line sample.
  const StepLineDefault(Key key) : super(key: key);

  @override
  _StepLineDefaultState createState() => _StepLineDefaultState();
}

/// State class of the default stepline chart.
class _StepLineDefaultState extends SampleViewState {
  _StepLineDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildDefaultStepLineChart();
  }

  /// Returns the default cartesian stepline chart.
  SfCartesianChart _buildDefaultStepLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Electricity-Production'),
      primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0), interval: 1),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          title: AxisTitle(text: isCardView ? '' : 'Production (kWh)'),
          labelFormat: '{value}B'),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getDefaultStepLineSeries(),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the stepline chart.
  List<StepLineSeries<ChartSampleData, num>> _getDefaultStepLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2000, y: 416, secondSeriesYValue: 180),
      ChartSampleData(x: 2001, y: 490, secondSeriesYValue: 240),
      ChartSampleData(x: 2002, y: 470, secondSeriesYValue: 370),
      ChartSampleData(x: 2003, y: 500, secondSeriesYValue: 200),
      ChartSampleData(x: 2004, y: 449, secondSeriesYValue: 229),
      ChartSampleData(x: 2005, y: 470, secondSeriesYValue: 210),
      ChartSampleData(x: 2006, y: 437, secondSeriesYValue: 337),
      ChartSampleData(x: 2007, y: 458, secondSeriesYValue: 258),
      ChartSampleData(x: 2008, y: 500, secondSeriesYValue: 300),
      ChartSampleData(x: 2009, y: 473, secondSeriesYValue: 173),
      ChartSampleData(x: 2010, y: 520, secondSeriesYValue: 220),
      ChartSampleData(x: 2011, y: 509, secondSeriesYValue: 309)
    ];
    return <StepLineSeries<ChartSampleData, num>>[
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Renewable'),
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Non-Renewable')
    ];
  }
}
