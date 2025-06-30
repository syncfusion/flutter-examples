/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical Step Line Chart sample.
class StepLineVertical extends SampleView {
  const StepLineVertical(Key key) : super(key: key);

  @override
  _StepLineVerticalState createState() => _StepLineVerticalState();
}

/// State class of the vertical Step Line Chart.
class _StepLineVerticalState extends SampleViewState {
  _StepLineVerticalState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;
  late MarkerSettings _markerSettings;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1975), y: 16, secondSeriesYValue: 10),
      ChartSampleData(x: DateTime(1980), y: 12.5, secondSeriesYValue: 7.5),
      ChartSampleData(x: DateTime(1985), y: 19, secondSeriesYValue: 11),
      ChartSampleData(x: DateTime(1990), y: 14.4, secondSeriesYValue: 7),
      ChartSampleData(x: DateTime(1995), y: 11.5, secondSeriesYValue: 8),
      ChartSampleData(x: DateTime(2000), y: 14, secondSeriesYValue: 6),
      ChartSampleData(x: DateTime(2005), y: 10, secondSeriesYValue: 3.5),
      ChartSampleData(x: DateTime(2010), y: 16, secondSeriesYValue: 7),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _markerSettings = const MarkerSettings(isVisible: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Step Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      isTransposed: true,
      title: ChartTitle(
        text: isCardView ? '' : 'Unemployment rates 1975 - 2010',
      ),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        interval: 5,
      ),
      primaryYAxis: const NumericAxis(labelFormat: '{value}%', interval: 5),
      series: _buildStepLineSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Step Line series.
  List<StepLineSeries<ChartSampleData, DateTime>> _buildStepLineSeries() {
    return <StepLineSeries<ChartSampleData, DateTime>>[
      StepLineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'China',
        markerSettings: _markerSettings,
      ),
      StepLineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Australia',
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
