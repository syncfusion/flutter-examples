import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class StepLineDashed extends StatefulWidget {
  const StepLineDashed(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _StepLineDashedState createState() => _StepLineDashedState(sample);
}

class _StepLineDashedState extends State<StepLineDashed> {
  _StepLineDashedState(this.sample);
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
  void didUpdateWidget(StepLineDashed oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/stepLine_series/stepline_with_dashes.dart');
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
            child: Container(child: getDashedStepLineChart(false)),
          ));
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
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

SfCartesianChart getDashedStepLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'CO2 - Intensity analysis'),
    primaryXAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
      title: AxisTitle(text: isTileView ? '' : 'Year'),
    ),
    primaryYAxis: NumericAxis(
      axisLine: AxisLine(width: 0),
      minimum: 360,
      maximum: 600,
      interval: 30,
      majorTickLines: MajorTickLines(size: 0),
      title: AxisTitle(text: isTileView ? '' : 'Intensity (g/kWh)'),
    ),
    legend: Legend(isVisible: isTileView ? false : true),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: getStepLineSeries(isTileView),
  );
}

List<StepLineSeries<_StepLineData, num>> getStepLineSeries(bool isTileView) {
  final List<_StepLineData> chartData = <_StepLineData>[
    _StepLineData(2006, 378, 463, 519, 570),
    _StepLineData(2007, 416, 449, 508, 579),
    _StepLineData(2008, 404, 458, 502, 563),
    _StepLineData(2009, 390, 450, 495, 550),
    _StepLineData(2010, 376, 425, 485, 545),
    _StepLineData(2011, 365, 430, 470, 525)
  ];
  return <StepLineSeries<_StepLineData, num>>[
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData data, _) => data.x,
        yValueMapper: (_StepLineData data, _) => data.y1,
        name: 'USA',
        width: 2,
        dashArray:<double>[10, 5]),
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData data, _) => data.x,
        yValueMapper: (_StepLineData data, _) => data.y2,
        name: 'UK',
        width: 2,
        dashArray: <double>[10, 5]),
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData data, _) => data.x,
        yValueMapper: (_StepLineData data, _) => data.y3,
        name: 'Korea',
        width: 2,
        dashArray: <double>[10, 5]),
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData data, _) => data.x,
        yValueMapper: (_StepLineData data, _) => data.y4,
        name: 'Japan',
        width: 2,
        dashArray: <double>[10, 5])
  ];
}

class _StepLineData {
  _StepLineData(this.x, this.y1, this.y2, this.y3, this.y4);
  final double x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
}
