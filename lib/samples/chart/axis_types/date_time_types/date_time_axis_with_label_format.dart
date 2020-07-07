import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class DateTimeLabel extends StatefulWidget {
  DateTimeLabel({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DateTimeLabelState createState() => _DateTimeLabelState(sample);
}

class _DateTimeLabelState extends State<DateTimeLabel> {
  _DateTimeLabelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://en.wikipedia.org/wiki/List_of_earthquakes_in_Indonesia';
    const String source = 'en.wikipedia.org';
    return getScopedModel(
        getLabelDateTimeAxisChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getLabelDateTimeAxisChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Earthquakes in Indonesia'),
    primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        majorGridLines: MajorGridLines(width: 0),
        interval: 2,
        minimum: DateTime(2019, 4, 12),
        maximum: DateTime(2017, 10, 31),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        dateFormat: DateFormat.yMd()),
    primaryYAxis: NumericAxis(
      axisLine: AxisLine(width: 0),
      majorTickLines: MajorTickLines(size: 0),
      minimum: 4,
      maximum: 8,
      title: AxisTitle(text: isTileView ? '' : 'Magnitude (Mw)'),
    ),
    series: getLabelDateTimeAxisSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y Mw',
        header: '',
        canShowMarker: false),
  );
}

List<ScatterSeries<ChartSampleData, DateTime>> getLabelDateTimeAxisSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2019, 4, 12), yValue: 6.8),
    ChartSampleData(x: DateTime(2019, 03, 17), yValue: 5.5),
    ChartSampleData(x: DateTime(2018, 11, 14), yValue: 5.6),
    ChartSampleData(x: DateTime(2018, 10, 10), yValue: 6.0),
    ChartSampleData(x: DateTime(2018, 09, 28), yValue: 7.5),
    ChartSampleData(x: DateTime(2018, 08, 19), yValue: 6.9),
    ChartSampleData(x: DateTime(2018, 08, 19), yValue: 6.3),
    ChartSampleData(x: DateTime(2018, 08, 09), yValue: 5.9),
    ChartSampleData(x: DateTime(2018, 08, 05), yValue: 6.9),
    ChartSampleData(x: DateTime(2018, 07, 29), yValue: 6.4),
    ChartSampleData(x: DateTime(2018, 07, 21), yValue: 5.2),
    ChartSampleData(x: DateTime(2018, 04, 18), yValue: 4.5),
    ChartSampleData(x: DateTime(2018, 01, 23), yValue: 6.0),
    ChartSampleData(x: DateTime(2017, 12, 15), yValue: 6.5),
    ChartSampleData(x: DateTime(2017, 10, 31), yValue: 6.3)
  ];
  return <ScatterSeries<ChartSampleData, DateTime>>[
    ScatterSeries<ChartSampleData, DateTime>(
        enableTooltip: true,
        opacity: 0.8,
        markerSettings: MarkerSettings(height: 15, width: 15),
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        color: const Color.fromRGBO(232, 84, 84, 1))
  ];
}
