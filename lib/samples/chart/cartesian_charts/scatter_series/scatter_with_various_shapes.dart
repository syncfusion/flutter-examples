import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ScatterShapes extends StatefulWidget {
  final SubItemList sample;
  const ScatterShapes(this.sample, {Key key}) : super(key: key);

  @override
  _ScatterShapesState createState() => _ScatterShapesState(sample);
}

class _ScatterShapesState extends State<ScatterShapes> {
  final SubItemList sample;

  _ScatterShapesState(this.sample);

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
  void didUpdateWidget(ScatterShapes oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart');
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
                headerClosingHeight: 350,
                color: model.cardThemeColor,
                titleVisibleOnPanelClosed: true,
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
            child: Container(child: getShapesScatterChart(false)),
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

SfCartesianChart getShapesScatterChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Inflation Analysis'),
    primaryXAxis: NumericAxis(
      minimum: 1945,
      maximum: 2005,
      // interval: 5,
      title: AxisTitle(text: isTileView ? '' : 'Year'),
      labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      majorGridLines: MajorGridLines(width: 0),
    ),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Inflation Rate(%)'),
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
    series: getScatterSeries(isTileView),
  );
}

List<ScatterSeries<_ScatterData, num>> getScatterSeries(bool isTileView) {
  final List<_ScatterData> chartData = <_ScatterData>[
    _ScatterData(1950, 0.8, 1.4, 2),
    _ScatterData(1955, 1.2, 1.7, 2.4),
    _ScatterData(1960, 0.9, 1.5, 2.2),
    _ScatterData(1965, 1, 1.6, 2.5),
    _ScatterData(1970, 0.8, 1.4, 2.2),
    _ScatterData(1975, 1, 1.8, 2.4),
    _ScatterData(1980, 1, 1.7, 2),
    _ScatterData(1985, 1.2, 1.9, 2.3),
    _ScatterData(1990, 1.1, 1.4, 2),
    _ScatterData(1995, 1.2, 1.8, 2.2),
    _ScatterData(2000, 1.4, 2, 2.4),
  ];
  return <ScatterSeries<_ScatterData, num>>[
    ScatterSeries<_ScatterData, num>(
        dataSource: chartData,
        xValueMapper: (_ScatterData sales, _) => sales.x,
        yValueMapper: (_ScatterData sales, _) => sales.y1,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.diamond),
        name: 'India'),
    ScatterSeries<_ScatterData, num>(
        dataSource: chartData,
        xValueMapper: (_ScatterData sales, _) => sales.x,
        yValueMapper: (_ScatterData sales, _) => sales.y2,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.triangle),
        name: 'China'),
    ScatterSeries<_ScatterData, num>(
        dataSource: chartData,
        xValueMapper: (_ScatterData sales, _) => sales.x,
        yValueMapper: (_ScatterData sales, _) => sales.y3,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.pentagon),
        name: 'Japan')
  ];
}

class _ScatterData {
  _ScatterData(this.x, this.y1, this.y2, this.y3);
  final double x;
  final double y1;
  final double y2;
  final double y3;
}
