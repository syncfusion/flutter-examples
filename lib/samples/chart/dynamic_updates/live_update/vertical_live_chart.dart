import 'dart:async';
import 'dart:math';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class VerticalLineLiveUpdate extends StatefulWidget {
  VerticalLineLiveUpdate({this.sample, Key key}) : super(key: key);
  SubItem sample;
  
  @override
  _LiveUpdateState createState() => _LiveUpdateState(sample);
}

int count;

List<ChartSampleData> chartData = <ChartSampleData>[
  ChartSampleData(x:10,y: 0),
  ChartSampleData(x:9, y:0),
  ChartSampleData(x:8, y:0),
  ChartSampleData(x:7, y:4),
  ChartSampleData(x:6, y:-3),
  ChartSampleData(x:5, y:0),
  ChartSampleData(x:4, y:-2),
  ChartSampleData(x:3, y:2),
  ChartSampleData(x:2, y:-3),
  ChartSampleData(x:1, y:3),
  ChartSampleData(x:0, y:-4),
];
Timer timer;

class _LiveUpdateState extends State<VerticalLineLiveUpdate> {
  _LiveUpdateState(this.sample);
  final SubItem sample;
 
  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x:0, y:0),
    ];
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, VerticalLiveDataFrontPanel(sample));
   }
}
 
SfCartesianChart getVerticalLineUpdateChart(bool isTileView) {
  return SfCartesianChart(
    isTransposed: true,
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
      isInversed: false,
      title: AxisTitle(text: isTileView ? '' : 'Time(s)'),
      majorGridLines: MajorGridLines(color: Colors.transparent),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Velocity(m/s)'),
        minimum: -15,
        maximum: 15,
        isInversed: false),
    series: getVerticalLineSeries(),
  );
}

List<LineSeries<ChartSampleData, num>> getVerticalLineSeries() {
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      width: 2,
    ),
  ];
}

class VerticalLiveDataFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  VerticalLiveDataFrontPanel(this.subItemList);
  final SubItem subItemList;

  @override
  _VerticalLiveDataFrontPanelState createState() => _VerticalLiveDataFrontPanelState(subItemList);
}

class _VerticalLiveDataFrontPanelState extends State<VerticalLiveDataFrontPanel> {
  _VerticalLiveDataFrontPanelState(this.sample) {
    count = 0;
  }
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 10), setTime);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void setTime(Timer timer) {
    setState(() {
      chartData = getChartData();
    });
  }

  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: getVerticalLineUpdateChart(false)),
            ),
          );
        });
  }
  
num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

List<ChartSampleData> getChartData() {
  count = count + 1;
  if (count > 350) {
    timer.cancel();
  } else if (count > 300) {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(0, 1)));
  } else if (count > 250) {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(-2, 1)));
  } else if (count > 180) {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(-3, 2)));
  } else if (count > 100) {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(-7, 6)));
  } else if (count < 50) {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(-3, 3)));
  } else {
    chartData.add(ChartSampleData(x:chartData.length, y:getRandomInt(-9, 9)));
  }

  return chartData;
}
}
 