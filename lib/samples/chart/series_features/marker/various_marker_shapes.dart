import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkerDefault extends StatefulWidget {
  const MarkerDefault(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _MarkerDefaultState createState() => _MarkerDefaultState(sample);
}

class _MarkerDefaultState extends State<MarkerDefault> {
  _MarkerDefaultState(this.sample);
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
  void didUpdateWidget(MarkerDefault oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/series_features/marker/various_marker_shapes.dart');
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
            child: Container(child: getMarkerDefaultChart(false)),
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

SfCartesianChart getMarkerDefaultChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Vehicles crossed tollgate'),
    legend: Legend(isVisible: isTileView ? false : true),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
      majorGridLines: MajorGridLines(width: 0),
      dateFormat: DateFormat.Hm(),
      title: AxisTitle(text: isTileView ? '' : 'Time'),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Count'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<_ChartNumeric, DateTime>> getLineSeries(bool isTileView) {
  final List<_ChartNumeric> chartData = <_ChartNumeric>[
    _ChartNumeric(DateTime(2018, 3, 1, 8, 0), 60, 28, 15),
    _ChartNumeric(DateTime(2018, 3, 1, 8, 30), 49, 40, 28),
    _ChartNumeric(DateTime(2018, 3, 1, 9, 0), 70, 32, 16),
    _ChartNumeric(DateTime(2018, 3, 1, 9, 30), 56, 36, 66),
    _ChartNumeric(DateTime(2018, 3, 1, 10, 0), 66, 50, 26),
    _ChartNumeric(DateTime(2018, 3, 1, 10, 30), 50, 35, 14),
    _ChartNumeric(DateTime(2018, 3, 1, 11, 0), 55, 32, 20),
  ];
  return <LineSeries<_ChartNumeric, DateTime>>[
    LineSeries<_ChartNumeric, DateTime>(
      dataSource: chartData,
      xValueMapper: (_ChartNumeric sales, _) => sales.x,
      yValueMapper: (_ChartNumeric sales, _) => sales.y1,
      width: 2,
      name: 'Truck',
      markerSettings: MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.pentagon,
          image: const AssetImage('images/truck.png')),
    ),
    LineSeries<_ChartNumeric, DateTime>(
      dataSource: chartData,
      width: 2,
      xValueMapper: (_ChartNumeric sales, _) => sales.x,
      yValueMapper: (_ChartNumeric sales, _) => sales.y2,
      name: 'Bike',
      markerSettings:
          MarkerSettings(isVisible: true, shape: DataMarkerType.triangle),
    ),
    LineSeries<_ChartNumeric, DateTime>(
      dataSource: chartData,
      width: 2,
      xValueMapper: (_ChartNumeric sales, _) => sales.x,
      yValueMapper: (_ChartNumeric sales, _) => sales.y3,
      name: 'Car',
      markerSettings:
          MarkerSettings(isVisible: true, shape: DataMarkerType.rectangle),
    )
  ];
}

class _ChartNumeric {
  _ChartNumeric(this.x, this.y1, this.y2, this.y3);
  final DateTime x;
  final double y1;
  final double y2;
  final double y3;
}
