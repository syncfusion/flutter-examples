/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the default stepline chart sample.
class StepLineDefault extends SampleView {
  const StepLineDefault(Key key) : super(key: key);

  @override
  _StepLineDefaultState createState() => _StepLineDefaultState();
}

/// State class of the default stepline chart.
class _StepLineDefaultState extends SampleViewState {
  _StepLineDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDefaultStepLineChart();
  }

  /// Returns the default cartesian stepline chart.
  SfCartesianChart getDefaultStepLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Electricity-Production'),
      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0),
      interval: 1),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          title: AxisTitle(text: isCardView ? '' : 'Production (kWh)'),
          labelFormat: '{value}B'),
      legend: Legend(isVisible: isCardView ? false : true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: getDefaultStepLineSeries(),
    );
  }

  /// Returns the list of chart series which need to render on the stepline chart.
  List<StepLineSeries<ChartSampleData, num>> getDefaultStepLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2000, y: 416, yValue2: 180),
      ChartSampleData(x: 2001, y: 490, yValue2: 240),
      ChartSampleData(x: 2002, y: 470, yValue2: 370),
      ChartSampleData(x: 2003, y: 500, yValue2: 200),
      ChartSampleData(x: 2004, y: 449, yValue2: 229),
      ChartSampleData(x: 2005, y: 470, yValue2: 210),
      ChartSampleData(x: 2006, y: 437, yValue2: 337),
      ChartSampleData(x: 2007, y: 458, yValue2: 258),
      ChartSampleData(x: 2008, y: 500, yValue2: 300),
      ChartSampleData(x: 2009, y: 473, yValue2: 173),
      ChartSampleData(x: 2010, y: 520, yValue2: 220),
      ChartSampleData(x: 2011, y: 509, yValue2: 309)
    ];
    return <StepLineSeries<ChartSampleData, num>>[
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Renewable'),
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Non-Renewable')
    ];
  }
}
