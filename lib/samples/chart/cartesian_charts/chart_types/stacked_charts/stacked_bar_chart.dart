/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the stacked bar chart sample.
class StackedBarChart extends SampleView {
  /// Creates the stacked bar chart sample.
  const StackedBarChart(Key key) : super(key: key);

  @override
  _StackedBarChartState createState() => _StackedBarChartState();
}

/// State class of the stacked bar chart.
class _StackedBarChartState extends SampleViewState {
  _StackedBarChartState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedBarChart();
  }

  /// Reutrns the cartesian stacked bar chart.
  SfCartesianChart _buildStackedBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison of fruits'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render
  /// on the stacked bar chart.
  List<StackedBarSeries<ChartSampleData, String>> _getStackedBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 6, yValue: 6, secondSeriesYValue: -1),
      ChartSampleData(x: 'Feb', y: 8, yValue: 8, secondSeriesYValue: -1.5),
      ChartSampleData(x: 'Mar', y: 12, yValue: 11, secondSeriesYValue: -2),
      ChartSampleData(x: 'Apr', y: 15.5, yValue: 16, secondSeriesYValue: -2.5),
      ChartSampleData(x: 'May', y: 20, yValue: 21, secondSeriesYValue: -3),
      ChartSampleData(x: 'June', y: 24, yValue: 25, secondSeriesYValue: -3.5),
    ];
    return <StackedBarSeries<ChartSampleData, String>>[
      StackedBarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Apple'),
      StackedBarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Orange'),
      StackedBarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Wastage')
    ];
  }
}
