import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DoughnutElevation extends StatefulWidget {
  DoughnutElevation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState(sample);
}

class _DoughnutDefaultState extends State<DoughnutElevation> {
  _DoughnutDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getElevationDoughnutChart(false), sample);
  }
}

SfCircularChart getElevationDoughnutChart(bool isTileView) {
  return SfCircularChart(
    annotations: <CircularChartAnnotation>[
      CircularChartAnnotation(
          height: '100%',
          width: '100%',
          widget: Container(
              child: PhysicalModel(
                  child: Container(),
                  shape: BoxShape.circle,
                  elevation: 10,
                  shadowColor: Colors.black,
                  color: const Color.fromRGBO(230, 230, 230, 1)))),
      CircularChartAnnotation(
          widget: Container(
              child: const Text('62%',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25))))
    ],
    title: ChartTitle(
        text: isTileView ? '' : 'Progress of a task',
        textStyle: ChartTextStyle(fontSize: 20)),
    series: getElevationDoughnutSeries(isTileView),
  );
}

List<DoughnutSeries<ChartSampleData, String>> getElevationDoughnutSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'A', y: 62, pointColor: const Color.fromRGBO(0, 220, 252, 1)),
    ChartSampleData(
        x: 'B', y: 38, pointColor: const Color.fromRGBO(230, 230, 230, 1))
  ];

  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        dataSource: chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor)
  ];
}
