import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AddSeries extends StatefulWidget {
  final SubItemList sample;
  const AddSeries(this.sample, {Key key}) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState(sample);
}

List<_ChartData> chartData = <_ChartData>[
  _ChartData(0, 10),
  _ChartData(1, 13),
  _ChartData(2, 20),
  _ChartData(3, 10),
  _ChartData(4, 32),
  _ChartData(5, 19)
];
List<LineSeries<_ChartData, int>> series = <LineSeries<_ChartData, int>>[
  LineSeries<_ChartData, int>(
    dataSource: chartData,
    width: 2,
    enableTooltip: true,
    xValueMapper: (_ChartData sales, _) => sales.country,
    yValueMapper: (_ChartData sales, _) => sales.sales,
  ),
  LineSeries<_ChartData, int>(
    dataSource: <_ChartData>[
      _ChartData(0, 22),
      _ChartData(1, 22),
      _ChartData(2, 53),
      _ChartData(3, 28),
      _ChartData(4, 39),
      _ChartData(5, 48)
    ],
    width: 2,
    enableTooltip: true,
    xValueMapper: (_ChartData sales, _) => sales.country,
    yValueMapper: (_ChartData sales, _) => sales.sales,
  ),
];
int count = 0;

class _LiveVerticalState extends State<AddSeries> {
  final SubItemList sample;
  _LiveVerticalState(this.sample);
  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(AddSeries oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
              child: Backdrop(
                frontHeaderHeight: 50,
                frontHeader: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[],
                        ),
                      ],
                    )),
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                frontPanelOpenPercentage: 0.28,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon:
                            Image.asset('images/code.png', color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/add_remove_data/add_remove_series.dart');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (frontPanelVisible.value)
                            frontPanelVisible.value = false;
                          else
                            frontPanelVisible.value = true;
                        },
                      ),
                    ),
                  ),
                ],
                appBarTitle: AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: Text(sample.title.toString())),
                backLayer: BackPanel(sample),
                frontLayer: FrontPanel(sample),
                sideDrawer: null,
                headerClosingHeight: 350,
                titleVisibleOnPanelClosed: true,
                color: model.cardThemeColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  final SubItemList sample;
  _FrontPanelState(this.sample);

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void getSeries1(SampleListModel model) {
    //ignore: invalid_use_of_protected_member
    model.notifyListeners();
    if (series != null && series.isNotEmpty) series.removeLast();
  }

  void getSeries(SampleListModel model) {
    final List<_ChartData> chartData1 = <_ChartData>[];
    for (int i = 0; i <= 6; i++) {
      chartData1.add(_ChartData(i, getRandomInt(10, 50)));
    }
    series.add(LineSeries<_ChartData, int>(
      dataSource: chartData1,
      xValueMapper: (_ChartData sales, _) => sales.country,
      yValueMapper: (_ChartData sales, _) => sales.sales,
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
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
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
                      width: 120,
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.add_circle,
                                    size: 50, color: model.backgroundColor),
                                onPressed: () {
                                  setState(() {
                                    getSeries(model);
                                  });
                                }),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(Icons.remove_circle,
                                    size: 50, color: model.backgroundColor),
                                onPressed: () => setState(() {
                                      getSeries1(model);
                                    }),
                              ),
                            )
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

class BackPanel extends StatefulWidget {
  final SubItemList sample;

  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfCartesianChart getAddRemoveSeriesChart(bool isTileView) {
  final List<LineSeries<_ChartData, int>> defaultSeries =
      <LineSeries<_ChartData, int>>[
    LineSeries<_ChartData, int>(
      dataSource: <_ChartData>[
        _ChartData(0, 10),
        _ChartData(1, 13),
        _ChartData(2, 20),
        _ChartData(3, 10),
        _ChartData(4, 32),
        _ChartData(5, 19)
      ],
      width: 2,
      enableTooltip: true,
      xValueMapper: (_ChartData sales, _) => sales.country,
      yValueMapper: (_ChartData sales, _) => sales.sales,
    ),
    LineSeries<_ChartData, int>(
      dataSource: <_ChartData>[
        _ChartData(0, 22),
        _ChartData(1, 22),
        _ChartData(2, 53),
        _ChartData(3, 28),
        _ChartData(4, 39),
        _ChartData(5, 48)
      ],
      width: 2,
      enableTooltip: true,
      xValueMapper: (_ChartData sales, _) => sales.country,
      yValueMapper: (_ChartData sales, _) => sales.sales,
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

class _ChartData {
  _ChartData(this.country, this.sales);
  final num country;
  final int sales;
}
