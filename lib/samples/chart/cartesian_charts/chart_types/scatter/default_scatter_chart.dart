/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default Scatter Chart sample.
class ScatterDefault extends SampleView {
  const ScatterDefault(Key key) : super(key: key);

  @override
  _ScatterDefaultState createState() => _ScatterDefaultState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultState extends SampleViewState {
  _ScatterDefaultState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;
  late MarkerSettings _markerSettings;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2006),
        y: 0.01,
        yValue: -0.03,
        secondSeriesYValue: 0.10,
      ),
      ChartSampleData(
        x: DateTime(2007),
        y: 0.03,
        yValue: -0.02,
        secondSeriesYValue: 0.08,
      ),
      ChartSampleData(
        x: DateTime(2008),
        y: -0.06,
        yValue: -0.13,
        secondSeriesYValue: -0.03,
      ),
      ChartSampleData(
        x: DateTime(2009),
        y: -0.03,
        yValue: -0.04,
        secondSeriesYValue: 0.04,
      ),
      ChartSampleData(
        x: DateTime(2010),
        y: 0.09,
        yValue: 0.07,
        secondSeriesYValue: 0.19,
      ),
      ChartSampleData(
        x: DateTime(2011),
        y: 0,
        yValue: 0.04,
        secondSeriesYValue: 0,
      ),
      ChartSampleData(
        x: DateTime(2012),
        y: 0.01,
        yValue: -0.01,
        secondSeriesYValue: -0.09,
      ),
      ChartSampleData(
        x: DateTime(2013),
        y: 0.05,
        yValue: 0.05,
        secondSeriesYValue: 0.10,
      ),
      ChartSampleData(
        x: DateTime(2014),
        y: 0,
        yValue: 0.08,
        secondSeriesYValue: 0.05,
      ),
      ChartSampleData(
        x: DateTime(2015),
        y: 0.1,
        yValue: 0.01,
        secondSeriesYValue: -0.04,
      ),
      ChartSampleData(
        x: DateTime(2016),
        y: 0.08,
        yValue: 0,
        secondSeriesYValue: 0.02,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _markerSettings = const MarkerSettings(height: 15, width: 15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Scatter series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Export growth rate'),
      primaryXAxis: const DateTimeAxis(
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        minorTickLines: MinorTickLines(size: 0),
      ),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
      series: _buildScatterSeries(),
    );
  }

  /// Returns the list of Cartesian Scatter series.
  List<ScatterSeries<ChartSampleData, DateTime>> _buildScatterSeries() {
    return <ScatterSeries<ChartSampleData, DateTime>>[
      ScatterSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        opacity: 0.7,
        name: 'Brazil',
        markerSettings: _markerSettings,
      ),
      ScatterSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        opacity: 0.7,
        name: 'Canada',
        markerSettings: _markerSettings,
      ),
      ScatterSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        color: const Color.fromRGBO(0, 168, 181, 1),
        name: 'India',
        markerSettings: _markerSettings,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
