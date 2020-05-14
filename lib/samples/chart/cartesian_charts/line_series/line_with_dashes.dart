import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';

//ignore: must_be_immutable
class LineDashed extends StatefulWidget {
  LineDashed({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LineDashedState createState() => _LineDashedState(sample);
}

class _LineDashedState extends State<LineDashed> {
  _LineDashedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDashedLineChart(false), sample);
  }
}

SfCartesianChart getDashedLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Capital investment as a share of exports'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0),
        interval: 2),
    primaryYAxis: NumericAxis(
        minimum: 3,
        maximum: 21,
        interval: isTileView ? 6 : 3,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent)),
    series: getDashedLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<_ChartData, num>> getDashedLineSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(2010, 6.6, 9.0, 15.1, 18.8),
    _ChartData(2011, 6.3, 9.3, 15.5, 18.5),
    _ChartData(2012, 6.7, 10.2, 14.5, 17.6),
    _ChartData(2013, 6.7, 10.2, 13.9, 16.1),
    _ChartData(2014, 6.4, 10.9, 13, 17.2),
    _ChartData(2015, 6.8, 9.3, 13.4, 18.9),
    _ChartData(2016, 7.7, 10.1, 14.2, 19.4),
  ];
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'Singapore',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
        width: 2,
        name: 'Saudi Arabia',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
        name: 'Spain',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y3,
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
        name: 'Portugal',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y4,
        markerSettings: MarkerSettings(isVisible: true)),
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2, this.y3, this.y4);
  final double x;
  final double y;
  final double y2;
  final double y3;
  final double y4;
}
