import 'dart:async';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VerticalLineLiveUpdate extends StatefulWidget {
  const VerticalLineLiveUpdate(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _LiveUpdateState createState() => _LiveUpdateState(sample);
}

int count;

List<_ChartData> chartData = <_ChartData>[
  _ChartData(10, 0),
  _ChartData(9, 0),
  _ChartData(8, 0),
  _ChartData(7, 4),
  _ChartData(6, -3),
  _ChartData(5, 0),
  _ChartData(4, -2),
  _ChartData(3, 2),
  _ChartData(2, -3),
  _ChartData(1, 3),
  _ChartData(0, -4),
];
Timer timer;

class _LiveUpdateState extends State<VerticalLineLiveUpdate> {
  _LiveUpdateState(this.sample);
  final SubItemList sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    chartData = <_ChartData>[
      _ChartData(0, 0),
    ];
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
  void didUpdateWidget(VerticalLineLiveUpdate oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/live_update/vertical_live_chart.dart');
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
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItemList subItemList;

  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample) {
    count = 0;
  }
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), setTime);
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

  final SubItemList sample;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: getVerticalLineUpdateChart(false)),
            ),
          );
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItemList sample;
  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItemList sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final Size size = renderBoxRed.size;
    final Offset position = renderBoxRed.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleListModel model) {
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
    series: getLineSeries(),
  );
}

List<LineSeries<_ChartData, num>> getLineSeries() {
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
      dataSource: chartData,
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y,
      width: 2,
    ),
  ];
}

num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

List<_ChartData> getChartData() {
  count = count + 1;
  if (count > 350) {
    timer.cancel();
  } else if (count > 300) {
    chartData.add(_ChartData(chartData.length, getRandomInt(0, 1)));
  } else if (count > 250) {
    chartData.add(_ChartData(chartData.length, getRandomInt(-2, 1)));
  } else if (count > 180) {
    chartData.add(_ChartData(chartData.length, getRandomInt(-3, 2)));
  } else if (count > 100) {
    chartData.add(_ChartData(chartData.length, getRandomInt(-7, 6)));
  } else if (count < 50) {
    chartData.add(_ChartData(chartData.length, getRandomInt(-3, 3)));
  } else {
    chartData.add(_ChartData(chartData.length, getRandomInt(-9, 9)));
  }

  return chartData;
}

class _ChartData {
  _ChartData(this.x, this.y);
  final num x;
  final int y;
}
