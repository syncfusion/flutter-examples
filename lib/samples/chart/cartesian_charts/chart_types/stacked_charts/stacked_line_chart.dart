/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked line series chart sample.
class StackedLineChart extends SampleView {
  /// Creates the stacked line series chart sample.
  const StackedLineChart(Key key) : super(key: key);

  @override
  _StackedLineChartState createState() => _StackedLineChartState();
}

/// State class for the stacked line series chart.
class _StackedLineChartState extends SampleViewState {
  _StackedLineChartState();

  List<ChartSampleData>? chartData;
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Food',
        y: 55,
        yValue: 40,
        secondSeriesYValue: 45,
        thirdSeriesYValue: 48,
      ),
      ChartSampleData(
        x: 'Transport',
        y: 33,
        yValue: 45,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 28,
      ),
      ChartSampleData(
        x: 'Medical',
        y: 43,
        yValue: 23,
        secondSeriesYValue: 20,
        thirdSeriesYValue: 34,
      ),
      ChartSampleData(
        x: 'Clothes',
        y: 32,
        yValue: 54,
        secondSeriesYValue: 23,
        thirdSeriesYValue: 54,
      ),
      ChartSampleData(
        x: 'Books',
        y: 56,
        yValue: 18,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 55,
      ),
      ChartSampleData(
        x: 'Others',
        y: 23,
        yValue: 54,
        secondSeriesYValue: 33,
        thirdSeriesYValue: 56,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedLineChart();
  }

  /// Returns the cartesian stacked line chart.
  SfCartesianChart _buildStackedLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Monthly expense of a family'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelRotation: isCardView ? 0 : -45,
      ),
      primaryYAxis: const NumericAxis(
        maximum: 200,
        axisLine: AxisLine(width: 0),
        labelFormat: r'${value}',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// Returns the list of cartesian stacked line series.
  List<StackedLineSeries<ChartSampleData, String>> _buildStackedLineSeries() {
    return <StackedLineSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: 'Father',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: 'Mother',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: 'Son',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        name: 'Daughter',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}
