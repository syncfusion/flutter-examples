import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PieDefault extends StatefulWidget {
  PieDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PieDefaultState createState() => _PieDefaultState(sample);
}

class _PieDefaultState extends State<PieDefault> {
  _PieDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultPieChart(false), sample);
  }
}

SfCircularChart getDefaultPieChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Sales by sales person'),
    legend: Legend(isVisible: isTileView ? false : true),
    series: getDefaultPieSeries(isTileView),
  );
}

List<PieSeries<ChartSampleData, String>> getDefaultPieSeries(bool isTileView) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'David', y: 30, text: 'David \n 30%'),
    ChartSampleData(x: 'Steve', y: 35, text: 'Steve \n 35%'),
    ChartSampleData(x: 'Jack', y: 39, text: 'Jack \n 39%'),
    ChartSampleData(x: 'Others', y: 75, text: 'Others \n 75%'),
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        explode: true,
        explodeIndex: 0,
        explodeOffset: '10%',
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: DataLabelSettings(isVisible: true)),
  ];
}
