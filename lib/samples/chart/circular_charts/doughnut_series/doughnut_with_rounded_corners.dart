import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DoughnutRounded extends StatefulWidget {
  DoughnutRounded({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DoughnutRoundedState createState() => _DoughnutRoundedState(sample);
}

class _DoughnutRoundedState extends State<DoughnutRounded> {
  _DoughnutRoundedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRoundedDoughnutChart(false), sample);
  }
}

SfCircularChart getRoundedDoughnutChart(bool isTileView) {
  return SfCircularChart(
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    title: ChartTitle(text: isTileView ? '' : 'Software development cycle'),
    series: getRoundedDoughnutSeries(isTileView),
  );
}

List<DoughnutSeries<ChartSampleData, String>> getRoundedDoughnutSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Planning', y: 10),
    ChartSampleData(x: 'Analysis', y: 10),
    ChartSampleData(x: 'Design', y: 10),
    ChartSampleData(x: 'Development', y: 10),
    ChartSampleData(x: 'Testing & Integration', y: 10),
    ChartSampleData(x: 'Maintainance', y: 10)
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
      dataSource: chartData,
      animationDuration: 0,
      cornerStyle: CornerStyle.bothCurve,
      radius: '80%',
      innerRadius: '60%',
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
    ),
  ];
}
