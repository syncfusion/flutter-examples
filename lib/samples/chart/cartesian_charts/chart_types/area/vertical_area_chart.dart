/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the vertical area chart sample.
class AreaVertical extends SampleView {
  /// Creates the transposed area chart sample.
  const AreaVertical(Key key) : super(key: key);

  @override
  _AreaVerticalState createState() => _AreaVerticalState();
}

/// State class of vertical area chart.
class _AreaVerticalState extends SampleViewState {
  _AreaVerticalState();

  @override
  Widget build(BuildContext context) {
    return _buildVerticalAreaChart();
  }

  /// Returns the cartesian area chart in transposed form.
  SfCartesianChart _buildVerticalAreaChart() {
    return SfCartesianChart(
      legend: Legend(
          isVisible: isCardView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap,
          opacity: 0.7),

      /// If we enable transposed mode as true
      /// then the series turned as vertical.
      isTransposed: true,
      title: ChartTitle(
          text: isCardView ? '' : 'Trend in sales of ethical produce'),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Spends'),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getVerticalAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series
  /// which need to render the vertical area chart.
  List<AreaSeries<ChartSampleData, DateTime>> _getVerticalAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2000, 0, 1),
          y: 0.61,
          yValue: 0.03,
          secondSeriesYValue: 0.48,
          thirdSeriesYValue: 0.23),
      ChartSampleData(
          x: DateTime(2001, 0, 1),
          y: 0.81,
          yValue: 0.05,
          secondSeriesYValue: 0.53,
          thirdSeriesYValue: 0.17),
      ChartSampleData(
          x: DateTime(2002, 0, 1),
          y: 0.91,
          yValue: 0.06,
          secondSeriesYValue: 0.57,
          thirdSeriesYValue: 0.17),
      ChartSampleData(
          x: DateTime(2003, 0, 1),
          y: 1,
          yValue: 0.09,
          secondSeriesYValue: 0.61,
          thirdSeriesYValue: 0.20),
      ChartSampleData(
          x: DateTime(2004, 0, 1),
          y: 1.19,
          yValue: 0.14,
          secondSeriesYValue: 0.63,
          thirdSeriesYValue: 0.23),
      ChartSampleData(
          x: DateTime(2005, 0, 1),
          y: 1.47,
          yValue: 0.20,
          secondSeriesYValue: 0.64,
          thirdSeriesYValue: 0.36),
      ChartSampleData(
          x: DateTime(2006, 0, 1),
          y: 1.74,
          yValue: 0.29,
          secondSeriesYValue: 0.66,
          thirdSeriesYValue: 0.43),
      ChartSampleData(
          x: DateTime(2007, 0, 1),
          y: 1.98,
          yValue: 0.46,
          secondSeriesYValue: 0.76,
          thirdSeriesYValue: 0.52),
      ChartSampleData(
          x: DateTime(2008, 0, 1),
          y: 1.99,
          yValue: 0.64,
          secondSeriesYValue: 0.77,
          thirdSeriesYValue: 0.72),
      ChartSampleData(
          x: DateTime(2009, 0, 1),
          y: 1.70,
          yValue: 0.75,
          secondSeriesYValue: 0.55,
          thirdSeriesYValue: 1.29),
      ChartSampleData(
          x: DateTime(2010, 0, 1),
          y: 1.48,
          yValue: 1.06,
          secondSeriesYValue: 0.54,
          thirdSeriesYValue: 1.38),
      ChartSampleData(
          x: DateTime(2011, 0, 1),
          y: 1.38,
          yValue: 1.25,
          secondSeriesYValue: 0.57,
          thirdSeriesYValue: 1.82),
      ChartSampleData(
          x: DateTime(2012, 0, 1),
          y: 1.66,
          yValue: 1.55,
          secondSeriesYValue: 0.61,
          thirdSeriesYValue: 2.16),
      ChartSampleData(
          x: DateTime(2013, 0, 1),
          y: 1.66,
          yValue: 1.55,
          secondSeriesYValue: 0.67,
          thirdSeriesYValue: 2.51),
      ChartSampleData(
          x: DateTime(2014, 0, 1),
          y: 1.67,
          yValue: 1.65,
          secondSeriesYValue: 0.67,
          thirdSeriesYValue: 2.61),
    ];
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          opacity: 0.7,
          name: 'Organic'),
      AreaSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          opacity: 0.7,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Others'),
    ];
  }
}
