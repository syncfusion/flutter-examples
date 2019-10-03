import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkerDefault extends StatefulWidget {
  final SubItemList sample;
  const MarkerDefault(this.sample, {Key key}) : super(key: key);

  @override
  _MarkerDefaultState createState() => _MarkerDefaultState(sample);
}

class _MarkerDefaultState extends State<MarkerDefault> {
  final SubItemList sample;
  _MarkerDefaultState(this.sample);
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
  void didUpdateWidget(MarkerDefault oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
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
          image: AssetImage('images/truck.png')),
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
