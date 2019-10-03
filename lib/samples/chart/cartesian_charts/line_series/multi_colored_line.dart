import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LineMultiColor extends StatefulWidget {
  final SubItemList sample;
  const LineMultiColor(this.sample, {Key key}) : super(key: key);

  @override
  _LineMultiColorState createState() => _LineMultiColorState(sample);
}

class _LineMultiColorState extends State<LineMultiColor> {
  final SubItemList sample;
  _LineMultiColorState(this.sample);
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
  void didUpdateWidget(LineMultiColor oldWidget) {
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
                frontPanelOpenPercentage: 0.35,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/line_series/multi_colored_line.dart');
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
                        icon: Image.asset(model.informationIcon,
                            color: Colors.white),
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
                //frontHeader: model.panelTitle(context),
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
  bool enableTooltip = false;
  bool enableMarker = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(child: getMultiColorLineChart(false)),
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

SfCartesianChart getMultiColorLineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Annual rainfall of Paris'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        title: AxisTitle(text: 'Year')),
    primaryYAxis: NumericAxis(
        minimum: 200,
        maximum: 600,
        interval: 100,
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}mm',
        majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
    trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        tooltipSettings: InteractiveTooltip(format: '{point.x} : {point.y}')),
  );
}

List<LineSeries<_ChartData, DateTime>> getLineSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(DateTime(1925), 415, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1926), 408, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1927), 415, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1928), 350, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1929), 375, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1930), 500, Color.fromRGBO(248, 184, 131, 1)),
    _ChartData(DateTime(1931), 390, Color.fromRGBO(229, 101, 144, 1)),
    _ChartData(DateTime(1932), 450, Color.fromRGBO(229, 101, 144, 1)),
    _ChartData(DateTime(1933), 440, Color.fromRGBO(229, 101, 144, 1)),
    _ChartData(DateTime(1934), 350, Color.fromRGBO(229, 101, 144, 1)),
    _ChartData(DateTime(1935), 400, Color.fromRGBO(229, 101, 144, 1)),
    _ChartData(DateTime(1936), 365, Color.fromRGBO(53, 124, 210, 1)),
    _ChartData(DateTime(1937), 490, Color.fromRGBO(53, 124, 210, 1)),
    _ChartData(DateTime(1938), 400, Color.fromRGBO(53, 124, 210, 1)),
    _ChartData(DateTime(1939), 520, Color.fromRGBO(53, 124, 210, 1)),
    _ChartData(DateTime(1940), 510, Color.fromRGBO(53, 124, 210, 1)),
    _ChartData(DateTime(1941), 395, Color.fromRGBO(0, 189, 174, 1)),
    _ChartData(DateTime(1942), 380, Color.fromRGBO(0, 189, 174, 1)),
    _ChartData(DateTime(1943), 404, Color.fromRGBO(0, 189, 174, 1)),
    _ChartData(DateTime(1944), 400, Color.fromRGBO(0, 189, 174, 1)),
    _ChartData(DateTime(1945), 500, Color.fromRGBO(0, 189, 174, 1))
  ];
  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
        enableTooltip: true,
        animationDuration: 2500,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        pointColorMapper: (_ChartData sales, _) => sales.lineColor,
        width: 2)
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, [this.lineColor]);
  final DateTime x;
  final double y;
  final Color lineColor;
}
