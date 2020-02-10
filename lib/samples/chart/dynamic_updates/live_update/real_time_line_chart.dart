import 'dart:async';
import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

Timer timer;

//ignore: must_be_immutable
class LiveLineChart extends StatefulWidget {
   LiveLineChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LiveLineChartState createState() => _LiveLineChartState(sample);
}

class _LiveLineChartState extends State<LiveLineChart> {
  _LiveLineChartState(this.sample);
  final SubItem sample;


  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  } 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, FrontPanel(sample));
  }
}


SfCartesianChart getLiveLineChart(bool isTileView,
    [List<_ChartData> chartData]) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: <LineSeries<_ChartData, int>>[
        LineSeries<_ChartData, int>(
          dataSource: isTileView
              ? <_ChartData>[
                  _ChartData(0, 42),
                  _ChartData(1, 47),
                  _ChartData(2, 33),
                  _ChartData(3, 49),
                  _ChartData(4, 54),
                  _ChartData(5, 41),
                  _ChartData(6, 58),
                  _ChartData(7, 51),
                  _ChartData(8, 98),
                  _ChartData(9, 41),
                  _ChartData(10, 53),
                  _ChartData(11, 72),
                  _ChartData(12, 86),
                  _ChartData(13, 52),
                  _ChartData(14, 94),
                  _ChartData(15, 92),
                  _ChartData(16, 86),
                  _ChartData(17, 72),
                  _ChartData(18, 94),
                ]
              : chartData,
          color: const Color.fromRGBO(192, 108, 132, 1),
          xValueMapper: (_ChartData sales, _) => sales.country,
          yValueMapper: (_ChartData sales, _) => sales.sales,
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        )
      ]);
}


class FrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItem subItemList;

  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample) {
    timer = Timer.periodic(const Duration(milliseconds: 100), updateDataSource);
  }
  Timer timer;
  List<_ChartData> chartData = <_ChartData>[
    _ChartData(0, 42),
    _ChartData(1, 47),
    _ChartData(2, 33),
    _ChartData(3, 49),
    _ChartData(4, 54),
    _ChartData(5, 41),
    _ChartData(6, 58),
    _ChartData(7, 51),
    _ChartData(8, 98),
    _ChartData(9, 41),
    _ChartData(10, 53),
    _ChartData(11, 72),
    _ChartData(12, 86),
    _ChartData(13, 52),
    _ChartData(14, 94),
    _ChartData(15, 92),
    _ChartData(16, 86),
    _ChartData(17, 72),
    _ChartData(18, 94),
  ];
  final SubItem sample;

  int count = 19;
  void updateDataSource(Timer timer) {
    setState(() {
      chartData.add(_ChartData(count, getRandomInt(10, 100)));

      if (chartData.length == 20) {
        chartData.removeAt(0);
      }

      count = count + 1;
    });
  }

  num getRandomInt(num min, num max) {
    final math.Random random = math.Random();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getLiveLineChart(false, chartData)),
              ));
        });
  }
}


class _ChartData {
  _ChartData(this.country, this.sales);
  final num country;
  final num sales;
}
