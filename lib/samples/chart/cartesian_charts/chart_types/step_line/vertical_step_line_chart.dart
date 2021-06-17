/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the vertical stepline chart sample.
class StepLineVertical extends SampleView {
  /// Creates the vertical stepline chart sample.
  const StepLineVertical(Key key) : super(key: key);

  @override
  _StepLineVerticalState createState() => _StepLineVerticalState();
}

/// State class of the vertical stepline chart.
class _StepLineVerticalState extends SampleViewState {
  _StepLineVerticalState();

  @override
  Widget build(BuildContext context) {
    return _buildVerticalStepLineChart();
  }

  /// Returns the vertical stepline chart.
  SfCartesianChart _buildVerticalStepLineChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: !isCardView),
      title:
          ChartTitle(text: isCardView ? '' : 'Unemployment rates 1975 - 2010'),
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          interval: 5),
      primaryYAxis: NumericAxis(labelFormat: '{value}%', interval: 5),
      isTransposed: true,
      series: _getVerticalStepLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the vertical stepline chart.
  List<StepLineSeries<ChartSampleData, DateTime>> _getVerticalStepLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1975), y: 16, secondSeriesYValue: 10),
      ChartSampleData(x: DateTime(1980), y: 12.5, secondSeriesYValue: 7.5),
      ChartSampleData(x: DateTime(1985), y: 19, secondSeriesYValue: 11),
      ChartSampleData(x: DateTime(1990), y: 14.4, secondSeriesYValue: 7),
      ChartSampleData(x: DateTime(1995), y: 11.5, secondSeriesYValue: 8),
      ChartSampleData(x: DateTime(2000), y: 14, secondSeriesYValue: 6),
      ChartSampleData(x: DateTime(2005), y: 10, secondSeriesYValue: 3.5),
      ChartSampleData(x: DateTime(2010), y: 16, secondSeriesYValue: 7),
    ];
    return <StepLineSeries<ChartSampleData, DateTime>>[
      StepLineSeries<ChartSampleData, DateTime>(
          markerSettings: const MarkerSettings(isVisible: true),
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'China'),
      StepLineSeries<ChartSampleData, DateTime>(
        markerSettings: const MarkerSettings(isVisible: true),
        dataSource: chartData,
        name: 'Australia',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }
}
