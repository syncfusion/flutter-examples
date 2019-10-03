import 'dart:async';
import 'dart:math' as Math;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveUpdate extends StatefulWidget {
  final SubItemList sample;
  const LiveUpdate(this.sample, {Key key}) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState(sample);
}

Timer timer;

List<_ChartData> chartData1 = <_ChartData>[
  _ChartData(0, 0),
  _ChartData(1, -2),
  _ChartData(2, 2),
  _ChartData(3, 0)
];
List<_ChartData> chartData2 = <_ChartData>[
  _ChartData(0, 0),
  _ChartData(1, 2),
  _ChartData(2, -2),
  _ChartData(3, 0)
];
bool canStopTimer = false;
int wave1;
int wave2, count = 1;

class _LiveUpdateState extends State<LiveUpdate> {
  Timer timer;
  final SubItemList sample;
  _LiveUpdateState(this.sample);

  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    chartData1 = <_ChartData>[
      _ChartData(0, 0),
    ];
    chartData2 = <_ChartData>[
      _ChartData(0, 0),
    ];
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LiveUpdate oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
              child: Backdrop(
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                frontPanelOpenPercentage: 0.28,
                toggleFrontLayer: false,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/live_update/live_update.dart');
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
  Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  final SubItemList sample;
  _FrontPanelState(this.sample) {
    wave1 = 0;
    wave2 = 180;
    if (chartData1.isNotEmpty && chartData2.isNotEmpty) {
      chartData1.clear();
      chartData2.clear();
    }
    updateLiveData();
    this.timer = Timer.periodic(Duration(milliseconds: 2), updateData);
  }

  void updateData(Timer timer) {
    setState(() {
      chartData1.removeAt(0);
      chartData1.add(new _ChartData(
        wave1,
        Math.sin(wave1 * (Math.pi / 180.0)),
      ));
      chartData2.removeAt(0);
      chartData2.add(new _ChartData(
        wave1,
        Math.sin(wave2 * (Math.pi / 180.0)),
      ));
      wave1++;
      wave2++;
    });
  }

  void updateLiveData() {
    for (var i = 0; i < 180; i++) {
      chartData1.add(new _ChartData(i, Math.sin(wave1 * (Math.pi / 180.0))));
      wave1++;
    }

    for (var i = 0; i < 180; i++) {
      chartData2.add(new _ChartData(i, Math.sin(wave2 * (Math.pi / 180.0))));
      wave2++;
    }

    wave1 = chartData1.length;
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
            child: Container(child: getLiveUpdateChart(false)),
          ));
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

void updateLiveData() {
  for (var i = 0; i < 180; i++) {
    chartData1.add(new _ChartData(i, Math.sin(wave1 * (Math.pi / 180.0))));
    wave1++;
  }

  for (var i = 0; i < 180; i++) {
    chartData2.add(new _ChartData(i, Math.sin(wave2 * (Math.pi / 180.0))));
    wave2++;
  }

  wave1 = chartData1.length;
}

SfCartesianChart getLiveUpdateChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getSplineSeries(false),
  );
}

List<SplineSeries<_ChartData, num>> getSplineSeries(bool isTileView) {
  return <SplineSeries<_ChartData, num>>[
    SplineSeries<_ChartData, num>(
        dataSource: chartData1,
        xValueMapper: (_ChartData sales, _) => sales.country,
        yValueMapper: (_ChartData sales, _) => sales.sales,
        width: 2),
    SplineSeries<_ChartData, num>(
      dataSource: chartData2,
      width: 2,
      xValueMapper: (_ChartData sales, _) => sales.country,
      yValueMapper: (_ChartData sales, _) => sales.sales,
    )
  ];
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final num country;
  final double sales;
}
