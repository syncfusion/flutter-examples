import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PieRadius extends StatefulWidget {
  PieRadius({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PieRadiusState createState() => _PieRadiusState(sample);
}

class _PieRadiusState extends State<PieRadius> {
  _PieRadiusState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadiusPieChart(false), sample);
  }
}

SfCircularChart getRadiusPieChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(
        text:
            isTileView ? '' : 'Various countries population density and area'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: _getRadiusPieSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<PieSeries<ChartSampleData, String>> _getRadiusPieSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
    ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
    ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
    ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
    ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
    ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
    ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%')
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}
