import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonZooming extends StatefulWidget {
  const ButtonZooming(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _ButtonZoomingState createState() => _ButtonZoomingState(sample);
}

ZoomPanBehavior zoomPan;
final List<_ChartData> chartData = <_ChartData>[
  _ChartData(1.5, 21),
  _ChartData(2.2, 24),
  _ChartData(3.32, 36),
  _ChartData(4.56, 38),
  _ChartData(5.87, 54),
  _ChartData(6.8, 57),
  _ChartData(8.5, 70),
  _ChartData(9.5, 21),
  _ChartData(10.2, 24),
  _ChartData(11.32, 36),
  _ChartData(14.56, 38),
  _ChartData(15.87, 54),
  _ChartData(16.8, 57),
  _ChartData(18.5, 23),
  _ChartData(21.5, 21),
  _ChartData(22.2, 24),
  _ChartData(23.32, 36),
  _ChartData(24.56, 32),
  _ChartData(25.87, 54),
  _ChartData(26.8, 12),
  _ChartData(28.5, 54),
  _ChartData(30.2, 24),
  _ChartData(31.32, 36),
  _ChartData(34.56, 38),
  _ChartData(35.87, 14),
  _ChartData(36.8, 57),
  _ChartData(38.5, 70),
  _ChartData(41.5, 21),
  _ChartData(41.2, 24),
  _ChartData(43.32, 36),
  _ChartData(44.56, 21),
  _ChartData(45.87, 54),
  _ChartData(46.8, 57),
  _ChartData(48.5, 54),
  _ChartData(49.56, 38),
  _ChartData(49.87, 14),
  _ChartData(51.8, 57),
  _ChartData(54.5, 32),
  _ChartData(55.5, 21),
  _ChartData(57.2, 24),
  _ChartData(59.32, 36),
  _ChartData(60.56, 21),
  _ChartData(62.87, 54),
  _ChartData(63.8, 23),
  _ChartData(65.5, 54)
];

class _ButtonZoomingState extends State<ButtonZooming> {
  _ButtonZoomingState(this.sample);
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
  void didUpdateWidget(ButtonZooming oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    zoomPan = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
              child: Backdrop(
                frontHeaderHeight: 50,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/user_interactions/zooming_panning/zooming_with_custom_buttons.dart');
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
                    duration: const Duration(milliseconds: 1000),
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
                child: Container(child: getButtonZoomingChart(false)),
              ),
              floatingActionButton: Container(
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_up,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_left,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_right,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
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

SfCartesianChart getButtonZoomingChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
    zoomPanBehavior: zoomPan,
  );
}

List<LineSeries<_ChartData, num>> getLineSeries(bool isTileView) {
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.numeric,
        yValueMapper: (_ChartData sales, _) => sales.sales1,
        width: 2)
  ];
}

class _ChartData {
  _ChartData(this.numeric, this.sales1);
  final double numeric;
  final int sales1;
}
