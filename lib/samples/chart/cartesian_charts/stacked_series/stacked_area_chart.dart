import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StackedAreaChart extends StatefulWidget {
  StackedAreaChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedAreaChartState createState() => _StackedAreaChartState(sample);
}

class _StackedAreaChartState extends State<StackedAreaChart> {
  _StackedAreaChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedAreaChart(false), sample);
  }
}

SfCartesianChart getStackedAreaChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Sales comparision of fruits in a shop'),
    legend: Legend(
        isVisible: !isTileView, overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y()),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}B',
        majorTickLines: MajorTickLines(size: 0)),
    series: getStackedAreaSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<StackedAreaSeries<ChartSampleData, DateTime>> getStackedAreaSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2000, 1, 1),
        y: 0.61,
        yValue: 0.03,
        yValue2: 0.48,
        yValue3: 0.23),
    ChartSampleData(
        x: DateTime(2001, 1, 1),
        y: 0.81,
        yValue: 0.05,
        yValue2: 0.53,
        yValue3: 0.17),
    ChartSampleData(
        x: DateTime(2002, 1, 1),
        y: 0.91,
        yValue: 0.06,
        yValue2: 0.57,
        yValue3: 0.17),
    ChartSampleData(
        x: DateTime(2003, 1, 1),
        y: 1.00,
        yValue: 0.09,
        yValue2: 0.61,
        yValue3: 0.20),
    ChartSampleData(
        x: DateTime(2004, 1, 1),
        y: 1.19,
        yValue: 0.14,
        yValue2: 0.63,
        yValue3: 0.23),
    ChartSampleData(
        x: DateTime(2005, 1, 1),
        y: 1.47,
        yValue: 0.20,
        yValue2: 0.64,
        yValue3: 0.36),
    ChartSampleData(
        x: DateTime(2006, 1, 1),
        y: 1.74,
        yValue: 0.29,
        yValue2: 0.66,
        yValue3: 0.43),
    ChartSampleData(
        x: DateTime(2007, 1, 1),
        y: 1.98,
        yValue: 0.46,
        yValue2: 0.76,
        yValue3: 0.52),
    ChartSampleData(
        x: DateTime(2008, 1, 1),
        y: 1.99,
        yValue: 0.64,
        yValue2: 0.77,
        yValue3: 0.72),
    ChartSampleData(
        x: DateTime(2009, 1, 1),
        y: 1.70,
        yValue: 0.75,
        yValue2: 0.55,
        yValue3: 1.29),
    ChartSampleData(
        x: DateTime(2010, 1, 1),
        y: 1.48,
        yValue: 1.06,
        yValue2: 0.54,
        yValue3: 1.38),
    ChartSampleData(
        x: DateTime(2011, 1, 1),
        y: 1.38,
        yValue: 1.25,
        yValue2: 0.57,
        yValue3: 1.82),
    ChartSampleData(
        x: DateTime(2012, 1, 1),
        y: 1.66,
        yValue: 1.55,
        yValue2: 0.61,
        yValue3: 2.16),
    ChartSampleData(
        x: DateTime(2013, 1, 1),
        y: 1.66,
        yValue: 1.55,
        yValue2: 0.67,
        yValue3: 2.51),
    ChartSampleData(
        x: DateTime(2014, 1, 1),
        y: 1.67,
        yValue: 1.65,
        yValue2: 0.67,
        yValue3: 2.61),
  ];
  return <StackedAreaSeries<ChartSampleData, DateTime>>[
    StackedAreaSeries<ChartSampleData, DateTime>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Apple'),
    StackedAreaSeries<ChartSampleData, DateTime>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Orange'),
    StackedAreaSeries<ChartSampleData, DateTime>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Pears'),
    StackedAreaSeries<ChartSampleData, DateTime>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Others')
  ];
}
