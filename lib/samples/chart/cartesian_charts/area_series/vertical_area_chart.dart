import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AreaVertical extends StatefulWidget {
  const AreaVertical(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _AreaVerticalState createState() => _AreaVerticalState(sample);
}

class _AreaVerticalState extends State<AreaVertical> {
_AreaVerticalState(this.sample);  
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
  void didUpdateWidget(AreaVertical oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/area_series/vertical_area_chart.dart');
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
  //ignore:prefer_const_constructors_in_immutables 
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
            child: Container(child: getVerticalAreaChart(false)),
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

SfCartesianChart getVerticalAreaChart(bool isTileView) {
  return SfCartesianChart(
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
        opacity: 0.7),
    isTransposed: true,
    title:
        ChartTitle(text: isTileView ? '' : 'Trend in sales of ethical produce'),
    primaryXAxis: DateTimeAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Spends'),
        majorTickLines: MajorTickLines(size: 0)),
    series: getAreaSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<AreaSeries<_AreaData, DateTime>> getAreaSeries(bool isTileView) {
  final List<_AreaData> chartData = <_AreaData>[
    _AreaData(DateTime(2000, 0, 1), 0.61, 0.03, 0.48, 0.23),
    _AreaData(DateTime(2001, 0, 1), 0.81, 0.05, 0.53, 0.17),
    _AreaData(DateTime(2002, 0, 1), 0.91, 0.06, 0.57, 0.17),
    _AreaData(DateTime(2003, 0, 1), 1, 0.09, 0.61, 0.20),
    _AreaData(DateTime(2004, 0, 1), 1.19, 0.14, 0.63, 0.23),
    _AreaData(DateTime(2005, 0, 1), 1.47, 0.20, 0.64, 0.36),
    _AreaData(DateTime(2006, 0, 1), 1.74, 0.29, 0.66, 0.43),
    _AreaData(DateTime(2007, 0, 1), 1.98, 0.46, 0.76, 0.52),
    _AreaData(DateTime(2008, 0, 1), 1.99, 0.64, 0.77, 0.72),
    _AreaData(DateTime(2009, 0, 1), 1.70, 0.75, 0.55, 1.29),
    _AreaData(DateTime(2010, 0, 1), 1.48, 1.06, 0.54, 1.38),
    _AreaData(DateTime(2011, 0, 1), 1.38, 1.25, 0.57, 1.82),
    _AreaData(DateTime(2012, 0, 1), 1.66, 1.55, 0.61, 2.16),
    _AreaData(DateTime(2013, 0, 1), 1.66, 1.55, 0.67, 2.51),
    _AreaData(DateTime(2014, 0, 1), 1.67, 1.65, 0.67, 2.61),
  ];
  return <AreaSeries<_AreaData, DateTime>>[
    AreaSeries<_AreaData, DateTime>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_AreaData sales, _) => sales.x,
        yValueMapper: (_AreaData sales, _) => sales.y1,
        opacity: 0.7,
        name: 'Organic'),
    AreaSeries<_AreaData, DateTime>(
        enableTooltip: true,
        dataSource: chartData,
        opacity: 0.7,
        xValueMapper: (_AreaData sales, _) => sales.x,
        yValueMapper: (_AreaData sales, _) => sales.y4,
        name: 'Others'),
  ];
}

class _AreaData {
  _AreaData(this.x, this.y1, this.y2, this.y3, this.y4);
  final DateTime x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
}
