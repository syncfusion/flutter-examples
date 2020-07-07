import 'package:flutter_examples/model/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class RadialBarDefault extends StatefulWidget {
  RadialBarDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialBarDefaultState createState() => _RadialBarDefaultState(sample);
}

class _RadialBarDefaultState extends State<RadialBarDefault> {
  _RadialBarDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultRadialBarChart(false), sample);
  }
}

SfCircularChart getDefaultRadialBarChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Short put distance'),
    series: getRadialBarDefaultSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, format: 'point.x : point.ym'),
  );
}

List<RadialBarSeries<ChartSampleData, String>> getRadialBarDefaultSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'John',
        y: 10,
        text: '100%',
        pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
    ChartSampleData(
        x: 'Almaida',
        y: 11,
        text: '100%',
        pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
    ChartSampleData(
        x: 'Doe',
        y: 12,
        text: '100%',
        pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
    ChartSampleData(
        x: 'Tom',
        y: 13,
        text: '100%',
        pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
  ];
  return <RadialBarSeries<ChartSampleData, String>>[
    RadialBarSeries<ChartSampleData, String>(
        maximumValue: 15,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: ChartTextStyle(fontSize: 10.0)),
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        gap: '10%',
        radius: '90%',
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x)
  ];
}
