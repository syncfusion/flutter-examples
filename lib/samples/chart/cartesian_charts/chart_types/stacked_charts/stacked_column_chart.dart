/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked column series chart sample.
class StackedColumnChart extends SampleView {
  /// Creates the stacked column series chart sample.
  const StackedColumnChart(Key key) : super(key: key);

  @override
  _StackedColumnChartState createState() => _StackedColumnChartState();
}

/// State class for the stacked column series chart.
class _StackedColumnChartState extends SampleViewState {
  _StackedColumnChartState();

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
      ChartSampleData(
        x: 'Q1',
        y: 50,
        yValue: 55,
        secondSeriesYValue: 72,
        thirdSeriesYValue: 65,
      ),
      ChartSampleData(
        x: 'Q2',
        y: 80,
        yValue: 75,
        secondSeriesYValue: 70,
        thirdSeriesYValue: 60,
      ),
      ChartSampleData(
        x: 'Q3',
        y: 35,
        yValue: 45,
        secondSeriesYValue: 55,
        thirdSeriesYValue: 52,
      ),
      ChartSampleData(
        x: 'Q4',
        y: 65,
        yValue: 50,
        secondSeriesYValue: 70,
        thirdSeriesYValue: 65,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedColumnChart();
  }

  /// Returns the cartesian Stacked column chart.
  SfCartesianChart _buildStackedColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Quarterly wise sales of products',
      ),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}K',
        maximum: 300,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked column series.
  List<StackedColumnSeries<ChartSampleData, String>>
  _buildStackedColumnSeries() {
    return <StackedColumnSeries<ChartSampleData, String>>[
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: 'Product A',
      ),
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: 'Product B',
      ),
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: 'Product C',
      ),
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        name: 'Product D',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
