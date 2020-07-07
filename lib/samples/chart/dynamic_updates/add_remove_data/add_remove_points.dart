import 'dart:math';

import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class AddDataPoints extends StatefulWidget {
  AddDataPoints({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LiveVerticalState createState() => _LiveVerticalState(sample);
}

class _LiveVerticalState extends State<AddDataPoints> {
  _LiveVerticalState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, DynamicPointFrontPanel(sample));
  }
}

SfCartesianChart getAddRemovePointsChart(bool isTileView,
    [List<ChartSampleData> chartData]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getAddRemovePointSeries(chartData),
  );
}

List<ChartSampleData> chartData1 = <ChartSampleData>[
  ChartSampleData(x: 0, y: 10),
  ChartSampleData(x: 1, y: 13),
  ChartSampleData(x: 2, y: 80),
  ChartSampleData(x: 3, y: 30),
  ChartSampleData(x: 4, y: 72),
  ChartSampleData(x: 5, y: 19),
  ChartSampleData(x: 6, y: 30),
  ChartSampleData(x: 7, y: 92),
  ChartSampleData(x: 8, y: 48),
  ChartSampleData(x: 9, y: 20),
  ChartSampleData(x: 10, y: 51),
];
List<LineSeries<ChartSampleData, num>> getAddRemovePointSeries(
    List<ChartSampleData> chartData) {
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
        animationDuration: 0,
        dataSource: chartData ?? chartData1,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2),
  ];
}

//ignore: must_be_immutable
class DynamicPointFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DynamicPointFrontPanel([this.sample]);
  SubItem sample;

  @override
  _DynamicPointFrontPanelState createState() =>
      _DynamicPointFrontPanelState(sample);
}

class _DynamicPointFrontPanelState extends State<DynamicPointFrontPanel> {
  _DynamicPointFrontPanelState(this.sample) {
    if (chartData.length > 11){
       chartData.removeRange(10, chartData.length - 1);
    }
  }
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 0, y: 10),
    ChartSampleData(x: 1, y: 13),
    ChartSampleData(x: 2, y: 80),
    ChartSampleData(x: 3, y: 30),
    ChartSampleData(x: 4, y: 72),
    ChartSampleData(x: 5, y: 19),
    ChartSampleData(x: 6, y: 30),
    ChartSampleData(x: 7, y: 92),
    ChartSampleData(x: 8, y: 48),
    ChartSampleData(x: 9, y: 20),
    ChartSampleData(x: 10, y: 51),
  ];
  final SubItem sample;
  int count = 11;
  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getAddRemovePointsChart(false, chartData);

  @override
  void initState() {
    super.initState();
  }

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<ChartSampleData> getChartData(SampleModel model) {
    chartData.add(ChartSampleData(x: count, y: getRandomInt(10, 100)));
    count = count + 1;
    return chartData;
  }

  List<ChartSampleData> getChartData1(SampleModel model) {
    // ignore: invalid_use_of_protected_member
    if (chartData != null && chartData.isNotEmpty)
      chartData.removeAt(chartData.length - 1);
    count = count - 1;
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                      child: Container(
                          child: getAddRemovePointsChart(false, chartData)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getAddRemovePointsChart(false, null)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                          child: Container(
                            height: 50,
                            width: model.isWeb ? 180 : 120,
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                      width: 45,
                                      height: 50,
                                      child: IconButton(
                                        icon: Icon(Icons.add_circle,
                                            size: 50,
                                            color: model.backgroundColor),
                                        onPressed: () => setState(() {
                                          chartData = getChartData(model);
                                        }),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: SizedBox(
                                        width: 65,
                                        height: 50,
                                        child: IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              size: 50,
                                              color: model.backgroundColor),
                                          onPressed: () => setState(() {
                                            chartData = getChartData1(model);
                                          }),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]));
        });
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListView(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Properties',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                HandCursor(
                    child: IconButton(
                  icon: Icon(Icons.close, color: model.textColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))
              ]),
          Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: RaisedButton(
                color: model.backgroundColor.withOpacity(0.8),
                child: const Text('Add'),
                onPressed: () {
                  chartData = getChartData(model);
                  model.sampleOutputContainer.outputKey.currentState.refresh();
                },
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: RaisedButton(
                color: model.backgroundColor.withOpacity(0.8),
                child: const Text('Remove'),
                onPressed: () {
                  chartData = getChartData1(model);
                  model.sampleOutputContainer.outputKey.currentState.refresh();
                },
              ))
        ],
      ),
    );
  }
}
