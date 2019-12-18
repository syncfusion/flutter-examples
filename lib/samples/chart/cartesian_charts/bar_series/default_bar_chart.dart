import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarDefault extends StatefulWidget {
  BarDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarDefaultState createState() => _BarDefaultState(sample);
}

class _BarDefaultState extends State<BarDefault> {
  _BarDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultBarChart(false), sample);
  }
}

SfCartesianChart getDefaultBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Tourism - Number of arrivals'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact()),
    series: getDefaultBarSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<BarSeries<ChartSampleData, String>> getDefaultBarSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'France', y: 84452000, yValue2: 82682000, yValue3: 86861000),
    ChartSampleData(
        x: 'Spain', y: 68175000, yValue2: 75315000, yValue3: 81786000),
    ChartSampleData(x: 'US', y: 77774000, yValue2: 76407000, yValue3: 76941000),
    ChartSampleData(
        x: 'Italy', y: 50732000, yValue2: 52372000, yValue3: 58253000),
    ChartSampleData(
        x: 'Mexico', y: 32093000, yValue2: 35079000, yValue3: 39291000),
    ChartSampleData(x: 'UK', y: 34436000, yValue2: 35814000, yValue3: 37651000),
  ];
  return <BarSeries<ChartSampleData, String>>[
    BarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: '2015'),
    BarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: '2016'),
    BarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: '2017')
  ];
}
