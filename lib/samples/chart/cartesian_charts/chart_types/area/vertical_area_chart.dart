/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical Area Chart sample.
class AreaVertical extends SampleView {
  const AreaVertical(Key key) : super(key: key);

  @override
  _AreaVerticalState createState() => _AreaVerticalState();
}

/// State class of vertical Area Chart.
class _AreaVerticalState extends SampleViewState {
  _AreaVerticalState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2000, 0),
        y: 0.61,
        yValue: 0.03,
        secondSeriesYValue: 0.48,
        thirdSeriesYValue: 0.23,
      ),
      ChartSampleData(
        x: DateTime(2001, 0),
        y: 0.81,
        yValue: 0.05,
        secondSeriesYValue: 0.53,
        thirdSeriesYValue: 0.17,
      ),
      ChartSampleData(
        x: DateTime(2002, 0),
        y: 0.91,
        yValue: 0.06,
        secondSeriesYValue: 0.57,
        thirdSeriesYValue: 0.17,
      ),
      ChartSampleData(
        x: DateTime(2003, 0),
        y: 1,
        yValue: 0.09,
        secondSeriesYValue: 0.61,
        thirdSeriesYValue: 0.20,
      ),
      ChartSampleData(
        x: DateTime(2004, 0),
        y: 1.19,
        yValue: 0.14,
        secondSeriesYValue: 0.63,
        thirdSeriesYValue: 0.23,
      ),
      ChartSampleData(
        x: DateTime(2005, 0),
        y: 1.47,
        yValue: 0.20,
        secondSeriesYValue: 0.64,
        thirdSeriesYValue: 0.36,
      ),
      ChartSampleData(
        x: DateTime(2006, 0),
        y: 1.74,
        yValue: 0.29,
        secondSeriesYValue: 0.66,
        thirdSeriesYValue: 0.43,
      ),
      ChartSampleData(
        x: DateTime(2007, 0),
        y: 1.98,
        yValue: 0.46,
        secondSeriesYValue: 0.76,
        thirdSeriesYValue: 0.52,
      ),
      ChartSampleData(
        x: DateTime(2008, 0),
        y: 1.99,
        yValue: 0.64,
        secondSeriesYValue: 0.77,
        thirdSeriesYValue: 0.72,
      ),
      ChartSampleData(
        x: DateTime(2009, 0),
        y: 1.70,
        yValue: 0.75,
        secondSeriesYValue: 0.55,
        thirdSeriesYValue: 1.29,
      ),
      ChartSampleData(
        x: DateTime(2010, 0),
        y: 1.48,
        yValue: 1.06,
        secondSeriesYValue: 0.54,
        thirdSeriesYValue: 1.38,
      ),
      ChartSampleData(
        x: DateTime(2011, 0),
        y: 1.38,
        yValue: 1.25,
        secondSeriesYValue: 0.57,
        thirdSeriesYValue: 1.82,
      ),
      ChartSampleData(
        x: DateTime(2012, 0),
        y: 1.66,
        yValue: 1.55,
        secondSeriesYValue: 0.61,
        thirdSeriesYValue: 2.16,
      ),
      ChartSampleData(
        x: DateTime(2013, 0),
        y: 1.66,
        yValue: 1.55,
        secondSeriesYValue: 0.67,
        thirdSeriesYValue: 2.51,
      ),
      ChartSampleData(
        x: DateTime(2014, 0),
        y: 1.67,
        yValue: 1.65,
        secondSeriesYValue: 0.67,
        thirdSeriesYValue: 2.61,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Area series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      /// Enable transposed mode as true to turn series vertically.
      isTransposed: true,
      title: ChartTitle(
        text: isCardView ? '' : 'Trend in sales of ethical produce',
      ),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Spends'),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
        opacity: 0.7,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Area series.
  List<AreaSeries<ChartSampleData, DateTime>> _buildAreaSeries() {
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        opacity: 0.7,
        name: 'Organic',
      ),
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        opacity: 0.7,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: 'Others',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
