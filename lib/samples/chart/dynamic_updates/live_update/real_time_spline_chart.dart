import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class LiveUpdate extends StatefulWidget {
  LiveUpdate({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LiveUpdateState createState() => _LiveUpdateState(sample);
}

Timer timer;

List<ChartSampleData> chartData1 = <ChartSampleData>[
  ChartSampleData(x: 0, y: 0),
  ChartSampleData(x: 1, y: -2),
  ChartSampleData(x: 2, y: 2),
  ChartSampleData(x: 3, y: 0)
];
List<ChartSampleData> chartData2 = <ChartSampleData>[
  ChartSampleData(x: 0, y: 0),
  ChartSampleData(x: 1, y: 2),
  ChartSampleData(x: 2, y: -2),
  ChartSampleData(x: 3, y: 0)
];
bool canStopTimer = false;
int wave1;
int wave2, count = 1;

class _LiveUpdateState extends State<LiveUpdate> {
  _LiveUpdateState(this.sample);
  Timer timer;
  final SubItem sample;

  @override
  void initState() {
    chartData1 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    chartData2 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, LiveHorizontalFrontPanel(sample));
  }
}

SfCartesianChart getLiveUpdateChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getLiveUpdateSeries(false),
  );
}

List<SplineSeries<ChartSampleData, num>> getLiveUpdateSeries(bool isTileView) {
  return <SplineSeries<ChartSampleData, num>>[
    SplineSeries<ChartSampleData, num>(
        dataSource: chartData1,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2),
    SplineSeries<ChartSampleData, num>(
      dataSource: chartData2,
      width: 2,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    )
  ];
}

//ignore: must_be_immutable
class LiveHorizontalFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  LiveHorizontalFrontPanel([this.sample]);
  SubItem sample;

  @override
  _LiveHorizontalFrontPanelState createState() =>
      _LiveHorizontalFrontPanelState(sample);
}

class _LiveHorizontalFrontPanelState extends State<LiveHorizontalFrontPanel> {
  _LiveHorizontalFrontPanelState(this.sample) {
    wave1 = 0;
    wave2 = 180;
    if (chartData1.isNotEmpty && chartData2.isNotEmpty) {
      chartData1.clear();
      chartData2.clear();
    }
    updateLiveData();
    timer = Timer.periodic(const Duration(milliseconds: 5), updateData);
  }

  Timer timer;

  Widget sampleWidget(SampleModel model) =>
      !kIsWeb ? getLiveUpdateChart(false) : getLiveUpdateChart(true);
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final SubItem sample;

  void updateData(Timer timer) {
    setState(() {
      chartData1.removeAt(0);
      chartData1.add(ChartSampleData(
        x: wave1,
        y: math.sin(wave1 * (math.pi / 180.0)),
      ));
      chartData2.removeAt(0);
      chartData2.add(ChartSampleData(
        x: wave1,
        y: math.sin(wave2 * (math.pi / 180.0)),
      ));
      wave1++;
      wave2++;
    });
  }

  void updateLiveData() {
    for (int i = 0; i < 180; i++) {
      chartData1
          .add(ChartSampleData(x: i, y: math.sin(wave1 * (math.pi / 180.0))));
      wave1++;
    }

    for (int i = 0; i < 180; i++) {
      chartData2
          .add(ChartSampleData(x: i, y: math.sin(wave2 * (math.pi / 180.0))));
      wave2++;
    }

    wave1 = chartData1.length;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor:
                  model.isWeb ? Colors.transparent : model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getLiveUpdateChart(false)),
              ));
        });
  }
}

void updateLiveData() {
  for (int i = 0; i < 180; i++) {
    chartData1
        .add(ChartSampleData(x: i, y: math.sin(wave1 * (math.pi / 180.0))));
    wave1++;
  }

  for (int i = 0; i < 180; i++) {
    chartData2
        .add(ChartSampleData(x: i, y: math.sin(wave2 * (math.pi / 180.0))));
    wave2++;
  }

  wave1 = chartData1.length;
}
