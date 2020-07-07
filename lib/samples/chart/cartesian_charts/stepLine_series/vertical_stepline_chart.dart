/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the vertical stepline chart sample.
class StepLineVertical extends SampleView {
  const StepLineVertical(Key key) : super(key: key);

  @override
  _StepLineVerticalState createState() => _StepLineVerticalState();
}

/// State class of the vertical stepline chart.
class _StepLineVerticalState extends SampleViewState {
  _StepLineVerticalState();

  @override
  Widget build(BuildContext context) {
    return getVerticalStepLineChart();
  }

  /// Returns the vertical stepline chart.
  SfCartesianChart getVerticalStepLineChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: isCardView ? false : true),
      title:
          ChartTitle(text: isCardView ? '' : 'Unemployment rates 1975 - 2010'),
      primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          interval: 5),
      primaryYAxis: NumericAxis(labelFormat: '{value}%', interval: 5),
      isTransposed: true,
      series: getVerticalStepLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the vertical stepline chart.
  List<StepLineSeries<ChartSampleData, DateTime>> getVerticalStepLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1975), y: 16, yValue2: 10),
      ChartSampleData(x: DateTime(1980), y: 12.5, yValue2: 7.5),
      ChartSampleData(x: DateTime(1985), y: 19, yValue2: 11),
      ChartSampleData(x: DateTime(1990), y: 14.4, yValue2: 7),
      ChartSampleData(x: DateTime(1995), y: 11.5, yValue2: 8),
      ChartSampleData(x: DateTime(2000), y: 14, yValue2: 6),
      ChartSampleData(x: DateTime(2005), y: 10, yValue2: 3.5),
      ChartSampleData(x: DateTime(2010), y: 16, yValue2: 7),
    ];
    return <StepLineSeries<ChartSampleData, DateTime>>[
      StepLineSeries<ChartSampleData, DateTime>(
          markerSettings: MarkerSettings(isVisible: true),
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'China'),
      StepLineSeries<ChartSampleData, DateTime>(
        markerSettings: MarkerSettings(isVisible: true),
        dataSource: chartData,
        name: 'Australia',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      )
    ];
  }
}