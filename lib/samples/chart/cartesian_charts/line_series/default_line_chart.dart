import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class LineDefault extends StatefulWidget {
  LineDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LineDefaultState createState() => _LineDefaultState(sample);
}

class _LineDefaultState extends State<LineDefault> {
  _LineDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultLineChart(false), sample);
  }
}

SfCartesianChart getDefaultLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Inflation - Consumer price'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 2,
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent)),
    series: getDefaultLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<_ChartData, num>> getDefaultLineSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(2005, 21, 28),
    _ChartData(2006, 24, 44),
    _ChartData(2007, 36, 48),
    _ChartData(2008, 38, 50),
    _ChartData(2009, 54, 66),
    _ChartData(2010, 57, 78),
    _ChartData(2011, 70, 84)
  ];
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'Germany',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        name: 'England',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
