/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the stacked bar chart sample.
class StackedBarChart extends SampleView {
  const StackedBarChart(Key key) : super(key: key);

  @override
  _StackedBarChartState createState() => _StackedBarChartState();
}

/// State class of the stacked bar chart.
class _StackedBarChartState extends SampleViewState {
  _StackedBarChartState();

  @override
  Widget build(BuildContext context) {
    return getStackedBarChart();
  }

  /// Reutrns the cartesian stacked bar chart.
  SfCartesianChart getStackedBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison of fruits'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: MajorTickLines(size: 0)),
      series: getStackedBarSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the stacked bar chart.
  List<StackedBarSeries<ChartSampleData, String>> getStackedBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 6, yValue: 6, yValue2: -1),
      ChartSampleData(x: 'Feb', y: 8, yValue: 8, yValue2: -1.5),
      ChartSampleData(x: 'Mar', y: 12, yValue: 11, yValue2: -2),
      ChartSampleData(x: 'Apr', y: 15.5, yValue: 16, yValue2: -2.5),
      ChartSampleData(x: 'May', y: 20, yValue: 21, yValue2: -3),
      ChartSampleData(x: 'June', y: 24, yValue: 25, yValue2: -3.5),
    ];
    return <StackedBarSeries<ChartSampleData, String>>[
      StackedBarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Apple'),
      StackedBarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Orange'),
      StackedBarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Wastage')
    ];
  }
}