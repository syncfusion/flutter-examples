import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DoughnutCustomization extends StatefulWidget {
  DoughnutCustomization({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState(sample);
}

class _DoughnutDefaultState extends State<DoughnutCustomization> {
  _DoughnutDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDoughnutCustomizationChart(false), sample);
  }
}

SfCircularChart getDoughnutCustomizationChart(bool isTileView) {
  return SfCircularChart(
    annotations: <CircularChartAnnotation>[
      CircularChartAnnotation(
          widget: Container(
              child: Text('90%',
                  style: TextStyle(color: Colors.grey, fontSize: 25))))
    ],
    title: ChartTitle(
        text: isTileView ? '' : 'Work progress',
        textStyle: ChartTextStyle(fontSize: 20)),
    series: getDoughnutCustomizationSeries(isTileView),
  );
}

List<DoughnutSeries<ChartSampleData, String>> getDoughnutCustomizationSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'A', y: 10, pointColor: const Color.fromRGBO(255, 4, 0, 1)),
    ChartSampleData(
        x: 'B', y: 10, pointColor: const Color.fromRGBO(255, 15, 0, 1)),
    ChartSampleData(
        x: 'C', y: 10, pointColor: const Color.fromRGBO(255, 31, 0, 1)),
    ChartSampleData(
        x: 'D', y: 10, pointColor: const Color.fromRGBO(255, 60, 0, 1)),
    ChartSampleData(
        x: 'E', y: 10, pointColor: const Color.fromRGBO(255, 90, 0, 1)),
    ChartSampleData(
        x: 'F', y: 10, pointColor: const Color.fromRGBO(255, 115, 0, 1)),
    ChartSampleData(
        x: 'G', y: 10, pointColor: const Color.fromRGBO(255, 135, 0, 1)),
    ChartSampleData(
        x: 'H', y: 10, pointColor: const Color.fromRGBO(255, 155, 0, 1)),
    ChartSampleData(
        x: 'I', y: 10, pointColor: const Color.fromRGBO(255, 175, 0, 1)),
    ChartSampleData(
        x: 'J', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
    ChartSampleData(
        x: 'K', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
    ChartSampleData(
        x: 'L', y: 10, pointColor: const Color.fromRGBO(251, 188, 2, 1)),
    ChartSampleData(
        x: 'M', y: 10, pointColor: const Color.fromRGBO(245, 188, 6, 1)),
    ChartSampleData(
        x: 'N', y: 10, pointColor: const Color.fromRGBO(233, 188, 12, 1)),
    ChartSampleData(
        x: 'O', y: 10, pointColor: const Color.fromRGBO(220, 187, 19, 1)),
    ChartSampleData(
        x: 'P', y: 10, pointColor: const Color.fromRGBO(208, 187, 26, 1)),
    ChartSampleData(
        x: 'Q', y: 10, pointColor: const Color.fromRGBO(193, 187, 34, 1)),
    ChartSampleData(
        x: 'R', y: 10, pointColor: const Color.fromRGBO(177, 186, 43, 1)),
    ChartSampleData(
        x: 'S', y: 10, pointColor: const Color.fromRGBO(230, 230, 230, 1)),
    ChartSampleData(
        x: 'T', y: 10, pointColor: const Color.fromRGBO(230, 230, 230, 1))
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
      dataSource: chartData,
      radius: '100%',
      strokeColor: Colors.white,
      strokeWidth: 2,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      pointColorMapper: (ChartSampleData data, _) => data.pointColor,
      dataLabelMapper: (ChartSampleData data, _) => data.x,
    ),
  ];
}
