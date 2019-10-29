import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AreaGradient extends StatefulWidget {
  const AreaGradient(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _AreaGradientState createState() => _AreaGradientState(sample);
}

class _AreaGradientState extends State<AreaGradient> {
  _AreaGradientState(this.sample);
  final SubItemList sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

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
  void didUpdateWidget(AreaGradient oldWidget) {
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/area_series/area_with_gradient.dart');
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
  _FrontPanelState(this.sample); 
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
            child: Container(child: getGradientAreaChart(false)),
          ));
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

SfCartesianChart getGradientAreaChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Annual rainfall of Paris'),
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
    series: getAreaSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<AreaSeries<_ChartData, DateTime>> getAreaSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(DateTime(1924), 400),
    _ChartData(DateTime(1925), 415),
    _ChartData(DateTime(1926), 408),
    _ChartData(DateTime(1927), 415),
    _ChartData(DateTime(1928), 350),
    _ChartData(DateTime(1929), 375),
    _ChartData(DateTime(1930), 500),
    _ChartData(DateTime(1931), 390),
    _ChartData(DateTime(1932), 450),
    _ChartData(DateTime(1933), 440),
    _ChartData(DateTime(1934), 350),
    _ChartData(DateTime(1935), 400),
    _ChartData(DateTime(1936), 365),
    _ChartData(DateTime(1937), 490),
    _ChartData(DateTime(1938), 400),
    _ChartData(DateTime(1939), 520),
    _ChartData(DateTime(1940), 510),
    _ChartData(DateTime(1941), 395),
    _ChartData(DateTime(1942), 380),
    _ChartData(DateTime(1943), 404),
    _ChartData(DateTime(1944), 400),
    _ChartData(DateTime(1945), 500)
  ];
  final List<Color> color = <Color>[];
  color.add(Colors.blue[50]);
  color.add(Colors.blue[200]);
  color.add(Colors.blue);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
      LinearGradient(colors: color, stops: stops);
  return <AreaSeries<_ChartData, DateTime>>[
    AreaSeries<_ChartData, DateTime>(
      enableTooltip: true,
      gradient: gradientColors,
      dataSource: chartData,
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y,
      name: 'Annual Rainfall',
    )
  ];
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
