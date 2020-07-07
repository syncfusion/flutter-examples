import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DoughnutDefault extends StatefulWidget {
  DoughnutDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState(sample);
}

class _DoughnutDefaultState extends State<DoughnutDefault> {
  _DoughnutDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.pngkit.com/view/u2q8y3w7r5y3t4o0_composition-of-ocean-water-earths-oceans-elements-percentage/';
    const String source = 'www.pngkit.com';
    return getScopedModel(
        getDefaultDoughnutChart(false), sample, null, sourceLink, source);
  }
}

SfCircularChart getDefaultDoughnutChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Composition of ocean water'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: getDefaultDoughnutSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<DoughnutSeries<ChartSampleData, String>> getDefaultDoughnutSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Chlorine', y: 55, text: '55%'),
    ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
    ChartSampleData(x: 'Magnesium', y: 7.7, text: '7.7%'),
    ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%'),
    ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
    ChartSampleData(x: 'Others', y: 1.4, text: '1.4%'),
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        radius: '80%',
        explode: true,
        explodeOffset: '10%',
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(isVisible: true))
  ];
}
