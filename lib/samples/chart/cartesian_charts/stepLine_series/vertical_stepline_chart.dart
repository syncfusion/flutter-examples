import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StepLineVertical extends StatefulWidget {
  StepLineVertical({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StepLineVerticalState createState() => _StepLineVerticalState(sample);
}

class _StepLineVerticalState extends State<StepLineVertical> {
  _StepLineVerticalState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getVerticalStepLineChart(false), sample);
  }
}

SfCartesianChart getVerticalStepLineChart(bool isTileView) {
  return SfCartesianChart(
    legend: Legend(isVisible: isTileView ? false : true),
    title: ChartTitle(text: isTileView ? '' : 'Unemployment rates 1975 - 2010'),
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        interval: 5),
    primaryYAxis: NumericAxis(labelFormat: '{value}%', interval: 5),
    isTransposed: true,
    series: getVerticalStepLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<StepLineSeries<ChartSampleData, DateTime>> getVerticalStepLineSeries(
    bool isTileView) {
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
