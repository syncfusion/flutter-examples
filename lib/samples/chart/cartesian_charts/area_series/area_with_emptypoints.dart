import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class AreaEmpty extends StatefulWidget {
  AreaEmpty({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _AreaEmptyState createState() => _AreaEmptyState(sample);
}

class _AreaEmptyState extends State<AreaEmpty> {
  _AreaEmptyState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getEmptyPointAreaChart(false), sample);
  }
}

SfCartesianChart getEmptyPointAreaChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Inflation rate of US'),
    primaryXAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        minimum: 100000000,
        maximum: 500000000,
        title: AxisTitle(text: isTileView ? '' : 'Rates'),
        numberFormat: NumberFormat.compact(),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getEmptyPointAreaSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<AreaSeries<ChartSampleData, num>> getEmptyPointAreaSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2002, y: 220000000),
    ChartSampleData(x: 2003, y: 340000000),
    ChartSampleData(x: 2004, y: 280000000),
    ChartSampleData(x: 2005, y: null),
    ChartSampleData(x: 2006, y: null),
    ChartSampleData(x: 2007, y: 250000000),
    ChartSampleData(x: 2008, y: 290000000),
    ChartSampleData(x: 2009, y: 380000000),
    ChartSampleData(x: 2010, y: 140000000),
    ChartSampleData(x: 2011, y: 310000000),
  ];
  return <AreaSeries<ChartSampleData, num>>[
    AreaSeries<ChartSampleData, num>(
        // animationDuration: isTileView ? 0 : 1500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y),
  ];
}
