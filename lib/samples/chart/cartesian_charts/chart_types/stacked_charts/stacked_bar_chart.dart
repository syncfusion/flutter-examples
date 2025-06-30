/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked bar chart series sample.
class StackedBarChart extends SampleView {
  /// Creates the stacked bar chart series sample.
  const StackedBarChart(Key key) : super(key: key);

  @override
  _StackedBarChartState createState() => _StackedBarChartState();
}

/// State class for the stacked bar series chart.
class _StackedBarChartState extends SampleViewState {
  _StackedBarChartState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 6, yValue: 6, secondSeriesYValue: -1),
      ChartSampleData(x: 'Feb', y: 8, yValue: 8, secondSeriesYValue: -1.5),
      ChartSampleData(x: 'Mar', y: 12, yValue: 11, secondSeriesYValue: -2),
      ChartSampleData(x: 'Apr', y: 15.5, yValue: 16, secondSeriesYValue: -2.5),
      ChartSampleData(x: 'May', y: 20, yValue: 21, secondSeriesYValue: -3),
      ChartSampleData(x: 'June', y: 24, yValue: 25, secondSeriesYValue: -3.5),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedBarChart();
  }

  /// Returns the cartesian stacked bar chart.
  SfCartesianChart _buildStackedBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison of fruits'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked bar series.
  List<StackedBarSeries<ChartSampleData, String>> _buildStackedBarSeries() {
    return <StackedBarSeries<ChartSampleData, String>>[
      StackedBarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: 'Apple',
      ),
      StackedBarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: 'Orange',
      ),
      StackedBarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: 'Wastage',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
