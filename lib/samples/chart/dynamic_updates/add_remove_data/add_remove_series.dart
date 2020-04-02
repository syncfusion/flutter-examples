import 'dart:math';

import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class AddSeries extends StatefulWidget {
  AddSeries({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LiveVerticalState createState() => _LiveVerticalState(sample);
}

List<ChartSampleData> chartData = <ChartSampleData>[
  ChartSampleData(x:0, y:10),
  ChartSampleData(x:1, y:13),
  ChartSampleData(x:2, y:20),
  ChartSampleData(x:3, y:10),
  ChartSampleData(x:4, y:32),
  ChartSampleData(x:5, y:19)
];
List<LineSeries<ChartSampleData, int>> series =
    <LineSeries<ChartSampleData, int>>[
  LineSeries<ChartSampleData, int>(
    dataSource: chartData,
    width: 2,
    enableTooltip: true,
    xValueMapper: (ChartSampleData sales, _) => sales.x,
    yValueMapper: (ChartSampleData sales, _) => sales.y,
  ),
  LineSeries<ChartSampleData, int>(
    dataSource: <ChartSampleData>[
      ChartSampleData(x:0,y: 22),
      ChartSampleData(x:1, y:22),
      ChartSampleData(x:2, y:53),
      ChartSampleData(x:3, y:28),
      ChartSampleData(x:4, y:39),
      ChartSampleData(x:5, y:48)
    ],
    width: 2,
    enableTooltip: true,
    xValueMapper: (ChartSampleData sales, _) => sales.x,
    yValueMapper: (ChartSampleData sales, _) => sales.y,
  ),
];
int count = 0;

class _LiveVerticalState extends State<AddSeries> {
  _LiveVerticalState(this.sample);
  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
     return getScopedModel(null, sample, DynamicSeriesFrontPanel(sample));
  }
}

SfCartesianChart getAddRemoveSeriesChart(bool isTileView) {
  final List<LineSeries<ChartSampleData, int>> defaultSeries =
      <LineSeries<ChartSampleData, int>>[
    LineSeries<ChartSampleData, int>(
      dataSource: <ChartSampleData>[
        ChartSampleData(x:0,y: 10),
        ChartSampleData(x:1, y:13),
        ChartSampleData(x:2, y:20),
        ChartSampleData(x:3, y:10),
        ChartSampleData(x:4, y:32),
        ChartSampleData(x:5, y:19)
      ],
      width: 2,
      enableTooltip: true,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
    LineSeries<ChartSampleData, int>(
      dataSource: <ChartSampleData>[
        ChartSampleData(x:0, y:22),
        ChartSampleData(x:1,y: 22),
        ChartSampleData(x:2, y:53),
        ChartSampleData(x:3, y:28),
        ChartSampleData(x:4, y:39),
        ChartSampleData(x:5, y:48)
      ],
      width: 2,
      enableTooltip: true,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    )
  ];
  return SfCartesianChart(
    
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: isTileView ? defaultSeries : series,
  );
}

//ignore: must_be_immutable
class DynamicSeriesFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DynamicSeriesFrontPanel([this.sample]);
   SubItem sample;
  
  @override
  _DynamicSeriesFrontPanelState createState() => _DynamicSeriesFrontPanelState(sample);
}

class _DynamicSeriesFrontPanelState extends State<DynamicSeriesFrontPanel> {
  _DynamicSeriesFrontPanelState(this.sample);
  final SubItem sample;
  
  Widget sampleWidget(SampleModel model) => getAddRemoveSeriesChart(false);
  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void getSeries1(SampleModel model) {
    //ignore: invalid_use_of_protected_member
    model.notifyListeners();
    if (series != null && series.isNotEmpty){
      series.removeLast();
    }      
  }

  void getSeries(SampleModel model) {
    final List<ChartSampleData> chartData1 = <ChartSampleData>[];
    for (int i = 0; i <= 6; i++) {
      chartData1.add(ChartSampleData(x:i, y:getRandomInt(10, 50)));
    }
    series.add(LineSeries<ChartSampleData, int>(
      dataSource: chartData1,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ));
    count++;
    if (count == 8) {
      count = 0;
    }
    //ignore: invalid_use_of_protected_member
    model.notifyListeners();
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
                child: Container(child: getAddRemoveSeriesChart(false)),
              ),
              floatingActionButton: Stack(children: <Widget>[
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
                            child:IconButton(
                                icon: Icon(Icons.add_circle,
                                    size: 50, color: model.backgroundColor),
                                onPressed: () {
                                  setState(() {
                                    getSeries(model);
                                  });
                                })),
                                
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:  SizedBox(
                              width: 65,
                              height: 50,
                              child:IconButton(
                                icon: Icon(Icons.remove_circle,
                                    size: 50, color: model.backgroundColor),
                                onPressed: () => setState(() {
                                      getSeries1(model);
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
}