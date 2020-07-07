import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class MarkerDefault extends StatefulWidget {
  MarkerDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _MarkerDefaultState createState() => _MarkerDefaultState(sample);
}

class _MarkerDefaultState extends State<MarkerDefault> {
  _MarkerDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getMarkerDefaultChart(false), sample);
  }
}

SfCartesianChart getMarkerDefaultChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Vehicles crossed tollgate'),
    legend: Legend(isVisible: isTileView ? false : true),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
      minimum: DateTime(2018, 3, 1, 8, 0),
      maximum: DateTime(2018, 3, 1, 11, 0),
      majorGridLines: MajorGridLines(width: 0),
      dateFormat: DateFormat.Hm(),
      title: AxisTitle(text: isTileView ? '' : 'Time'),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Count'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getMarkeSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<ChartSampleData, DateTime>> getMarkeSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2018, 3, 1, 8, 0), y: 60, yValue2: 28, yValue3: 15),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 8, 30), y: 49, yValue2: 40, yValue3: 28),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 9, 0), y: 70, yValue2: 32, yValue3: 16),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 9, 30), y: 56, yValue2: 36, yValue3: 66),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 10, 0), y: 66, yValue2: 50, yValue3: 26),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 10, 30), y: 50, yValue2: 35, yValue3: 14),
    ChartSampleData(
        x: DateTime(2018, 3, 1, 11, 0), y: 55, yValue2: 32, yValue3: 20),
  ];
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      width: 2,
      name: 'Truck',
      markerSettings: MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.pentagon,
          image: const AssetImage('images/truck.png')),
    ),
    LineSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      width: 2,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      name: 'Bike',
      markerSettings:
          MarkerSettings(isVisible: true, shape: DataMarkerType.triangle),
    ),
    LineSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      width: 2,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
      name: 'Car',
      markerSettings:
          MarkerSettings(isVisible: true, shape: DataMarkerType.rectangle),
    )
  ];
}
