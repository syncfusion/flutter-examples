import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class SplineVertical extends StatefulWidget {
  SplineVertical({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SplineVerticalState createState() => _SplineVerticalState(sample);
}

class _SplineVerticalState extends State<SplineVertical> {
  _SplineVerticalState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getVerticalSplineChart(false), sample);
  }
}

SfCartesianChart getVerticalSplineChart(bool isTileView) {
  return SfCartesianChart(
    isTransposed: true,
    title: ChartTitle(text: isTileView ? '' : 'Climate graph - 2012'),
    plotAreaBorderWidth: 0,
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(
        majorTickLines: MajorTickLines(size: 0), axisLine: AxisLine(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: -10,
        maximum: 40,
        interval: 10,
        labelFormat: '{value}°C',
        majorGridLines: MajorGridLines(width: 0)),
    series: getVerticalSplineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<SplineSeries<_ChartData, String>> getVerticalSplineSeries(
    bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Jan', -1, 7),
    _ChartData('Mar', 12, 2),
    _ChartData('Apr', 25, 13),
    _ChartData('Jun', 31, 21),
    _ChartData('Aug', 26, 26),
    _ChartData('Oct', 14, 10),
    _ChartData('Dec', 8, 0),
  ];
  return <SplineSeries<_ChartData, String>>[
    SplineSeries<_ChartData, String>(
        markerSettings: MarkerSettings(isVisible: true),
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'London'),
    SplineSeries<_ChartData, String>(
      markerSettings: MarkerSettings(isVisible: true),
      dataSource: chartData,
      width: 2,
      name: 'France',
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y2,
    )
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final String x;
  final double y;
  final double y2;
}
