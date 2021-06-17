/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the stacked area chart sample.
class StackedAreaChart extends SampleView {
  /// Creates the stacked area chart sample.
  const StackedAreaChart(Key key) : super(key: key);

  @override
  _StackedAreaChartState createState() => _StackedAreaChartState();
}

/// State class of the stacked  area chart.
class _StackedAreaChartState extends SampleViewState {
  _StackedAreaChartState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedAreaChart();
  }

  /// Returns the cartesian stacked area chart.
  SfCartesianChart _buildStackedAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Sales comparision of fruits in a shop'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y()),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}B',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedAreaSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render
  /// on the stacked area chart.
  List<StackedAreaSeries<ChartSampleData, DateTime>> _getStackedAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2000, 1, 1),
          y: 0.61,
          yValue: 0.03,
          secondSeriesYValue: 0.48,
          thirdSeriesYValue: 0.23),
      ChartSampleData(
          x: DateTime(2001, 1, 1),
          y: 0.81,
          yValue: 0.05,
          secondSeriesYValue: 0.53,
          thirdSeriesYValue: 0.17),
      ChartSampleData(
          x: DateTime(2002, 1, 1),
          y: 0.91,
          yValue: 0.06,
          secondSeriesYValue: 0.57,
          thirdSeriesYValue: 0.17),
      ChartSampleData(
          x: DateTime(2003, 1, 1),
          y: 1.00,
          yValue: 0.09,
          secondSeriesYValue: 0.61,
          thirdSeriesYValue: 0.20),
      ChartSampleData(
          x: DateTime(2004, 1, 1),
          y: 1.19,
          yValue: 0.14,
          secondSeriesYValue: 0.63,
          thirdSeriesYValue: 0.23),
      ChartSampleData(
          x: DateTime(2005, 1, 1),
          y: 1.47,
          yValue: 0.20,
          secondSeriesYValue: 0.64,
          thirdSeriesYValue: 0.36),
      ChartSampleData(
          x: DateTime(2006, 1, 1),
          y: 1.74,
          yValue: 0.29,
          secondSeriesYValue: 0.66,
          thirdSeriesYValue: 0.43),
      ChartSampleData(
          x: DateTime(2007, 1, 1),
          y: 1.98,
          yValue: 0.46,
          secondSeriesYValue: 0.76,
          thirdSeriesYValue: 0.52),
      ChartSampleData(
          x: DateTime(2008, 1, 1),
          y: 1.99,
          yValue: 0.64,
          secondSeriesYValue: 0.77,
          thirdSeriesYValue: 0.72),
      ChartSampleData(
          x: DateTime(2009, 1, 1),
          y: 1.70,
          yValue: 0.75,
          secondSeriesYValue: 0.55,
          thirdSeriesYValue: 1.29),
      ChartSampleData(
          x: DateTime(2010, 1, 1),
          y: 1.48,
          yValue: 1.06,
          secondSeriesYValue: 0.54,
          thirdSeriesYValue: 1.38),
      ChartSampleData(
          x: DateTime(2011, 1, 1),
          y: 1.38,
          yValue: 1.25,
          secondSeriesYValue: 0.57,
          thirdSeriesYValue: 1.82),
      ChartSampleData(
          x: DateTime(2012, 1, 1),
          y: 1.66,
          yValue: 1.55,
          secondSeriesYValue: 0.61,
          thirdSeriesYValue: 2.16),
      ChartSampleData(
          x: DateTime(2013, 1, 1),
          y: 1.66,
          yValue: 1.55,
          secondSeriesYValue: 0.67,
          thirdSeriesYValue: 2.51),
      ChartSampleData(
          x: DateTime(2014, 1, 1),
          y: 1.67,
          yValue: 1.65,
          secondSeriesYValue: 0.67,
          thirdSeriesYValue: 2.61),
    ];
    return <StackedAreaSeries<ChartSampleData, DateTime>>[
      StackedAreaSeries<ChartSampleData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Apple'),
      StackedAreaSeries<ChartSampleData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Orange'),
      StackedAreaSeries<ChartSampleData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Pears'),
      StackedAreaSeries<ChartSampleData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Others')
    ];
  }
}
