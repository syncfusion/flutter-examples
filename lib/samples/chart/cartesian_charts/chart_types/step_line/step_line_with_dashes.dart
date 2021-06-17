/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the dashed stepline chart sample.
class StepLineDashed extends SampleView {
  /// Creates the dashed stepline chart sample.
  const StepLineDashed(Key key) : super(key: key);

  @override
  _StepLineDashedState createState() => _StepLineDashedState();
}

/// State class of the dashed stepline chart.
class _StepLineDashedState extends SampleViewState {
  _StepLineDashedState();

  @override
  Widget build(BuildContext context) {
    return _buildDashedStepLineChart();
  }

  /// Returns the dashed cartesian stepline chart.
  SfCartesianChart _buildDashedStepLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'CO2 - Intensity analysis'),
      primaryXAxis: NumericAxis(
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'Year'),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        minimum: 360,
        maximum: 600,
        interval: 30,
        majorTickLines: const MajorTickLines(size: 0),
        title: AxisTitle(text: isCardView ? '' : 'Intensity (g/kWh)'),
      ),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getDashedStepLineSeries(),
    );
  }

  /// Returns the list of chart series which
  /// need to render on the stepline chart.
  List<StepLineSeries<ChartSampleData, num>> _getDashedStepLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 2006,
          y: 378,
          yValue: 463,
          secondSeriesYValue: 519,
          thirdSeriesYValue: 570),
      ChartSampleData(
          x: 2007,
          y: 416,
          yValue: 449,
          secondSeriesYValue: 508,
          thirdSeriesYValue: 579),
      ChartSampleData(
          x: 2008,
          y: 404,
          yValue: 458,
          secondSeriesYValue: 502,
          thirdSeriesYValue: 563),
      ChartSampleData(
          x: 2009,
          y: 390,
          yValue: 450,
          secondSeriesYValue: 495,
          thirdSeriesYValue: 550),
      ChartSampleData(
          x: 2010,
          y: 376,
          yValue: 425,
          secondSeriesYValue: 485,
          thirdSeriesYValue: 545),
      ChartSampleData(
          x: 2011,
          y: 365,
          yValue: 430,
          secondSeriesYValue: 470,
          thirdSeriesYValue: 525)
    ];
    return <StepLineSeries<ChartSampleData, num>>[
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as num,
          yValueMapper: (ChartSampleData data, _) => data.y,
          name: 'USA',
          width: 2,
          dashArray: const <double>[10, 5]),
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as num,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: 'UK',
          width: 2,
          dashArray: const <double>[10, 5]),
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as num,
          yValueMapper: (ChartSampleData data, _) => data.secondSeriesYValue,
          name: 'Korea',
          width: 2,
          dashArray: const <double>[10, 5]),
      StepLineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as num,
          yValueMapper: (ChartSampleData data, _) => data.thirdSeriesYValue,
          name: 'Japan',
          width: 2,
          dashArray: const <double>[10, 5])
    ];
  }
}
