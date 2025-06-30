/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default Step Line Chart sample.
class StepLineDefault extends SampleView {
  const StepLineDefault(Key key) : super(key: key);

  @override
  _StepLineDefaultState createState() => _StepLineDefaultState();
}

/// State class of the default Step Line Chart.
class _StepLineDefaultState extends SampleViewState {
  _StepLineDefaultState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
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
      ChartSampleData(x: 2011, y: 509, secondSeriesYValue: 309),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Step Line series..
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Electricity-Production'),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        title: AxisTitle(text: isCardView ? '' : 'Production (kWh)'),
        labelFormat: '{value}B',
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
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'Renewable',
      ),
      StepLineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Non-Renewable',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
