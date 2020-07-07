import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class RadialBarAngle extends StatefulWidget {
  RadialBarAngle({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialBarAngleState createState() => _RadialBarAngleState(sample);
}

class _RadialBarAngleState extends State<RadialBarAngle> {
  _RadialBarAngleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getAngleRadialBarChart(false), sample);
  }
}

SfCircularChart getAngleRadialBarChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Activity tracker'),
    legend: Legend(
        isVisible: true,
        iconHeight: 20,
        iconWidth: 20,
        overflowMode: LegendItemOverflowMode.wrap),
    tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x'),
    series: getRadialBarSeries(isTileView),
  );
}

List<RadialBarSeries<ChartSampleData, String>> getRadialBarSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'Move 65%\n338/520 CAL',
        y: 65,
        text: 'Move  ',
        xValue: null,
        pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
    ChartSampleData(
        x: 'Exercise 43%\n13/30 MIN',
        y: 43,
        text: 'Exercise  ',
        xValue: null,
        pointColor: const Color.fromRGBO(63, 224, 0, 1.0)),
    ChartSampleData(
        x: 'Stand 58%\n7/12 HR',
        y: 58,
        text: 'Stand  ',
        xValue: null,
        pointColor: const Color.fromRGBO(226, 1, 26, 1.0)),
  ];
  final List<RadialBarSeries<ChartSampleData, String>> list =
      <RadialBarSeries<ChartSampleData, String>>[
    RadialBarSeries<ChartSampleData, String>(
        animationDuration: 0,
        pointRadiusMapper: (ChartSampleData data, _) => data.xValue,
        maximumValue: 100,
        radius: '100%',
        gap: '2%',
        innerRadius: '30%',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(isVisible: true))
  ];
  return list;
}
