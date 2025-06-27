/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the dashed Step Line Chart sample.
class StepLineDashed extends SampleView {
  const StepLineDashed(Key key) : super(key: key);

  @override
  _StepLineDashedState createState() => _StepLineDashedState();
}

/// State class of the dashed Step Line Chart.
class _StepLineDashedState extends SampleViewState {
  _StepLineDashedState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 2006,
        y: 378,
        yValue: 463,
        secondSeriesYValue: 519,
        thirdSeriesYValue: 570,
      ),
      ChartSampleData(
        x: 2007,
        y: 416,
        yValue: 449,
        secondSeriesYValue: 508,
        thirdSeriesYValue: 579,
      ),
      ChartSampleData(
        x: 2008,
        y: 404,
        yValue: 458,
        secondSeriesYValue: 502,
        thirdSeriesYValue: 563,
      ),
      ChartSampleData(
        x: 2009,
        y: 390,
        yValue: 450,
        secondSeriesYValue: 495,
        thirdSeriesYValue: 550,
      ),
      ChartSampleData(
        x: 2010,
        y: 376,
        yValue: 425,
        secondSeriesYValue: 485,
        thirdSeriesYValue: 545,
      ),
      ChartSampleData(
        x: 2011,
        y: 365,
        yValue: 430,
        secondSeriesYValue: 470,
        thirdSeriesYValue: 525,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Step Line series.
  SfCartesianChart _buildCartesianChart() {
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
      series: _buildStepLineSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Step Line series.
  List<StepLineSeries<ChartSampleData, num>> _buildStepLineSeries() {
    return <StepLineSeries<ChartSampleData, num>>[
      StepLineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: 'USA',
        dashArray: const <double>[10, 5],
      ),
      StepLineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: 'UK',
        dashArray: const <double>[10, 5],
      ),
      StepLineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: 'Korea',
        dashArray: const <double>[10, 5],
      ),
      StepLineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        name: 'Japan',
        dashArray: const <double>[10, 5],
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
