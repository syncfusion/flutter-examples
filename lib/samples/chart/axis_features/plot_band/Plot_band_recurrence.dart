import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../widgets/bottom_sheet.dart';

class PlotBandRecurrence extends StatefulWidget {
  const PlotBandRecurrence(this.sample, {Key key}) : super(key: key);

  final SubItemList sample;

  @override
  _PlotBandRecurrenceState createState() => _PlotBandRecurrenceState(sample);
}

class _PlotBandRecurrenceState extends State<PlotBandRecurrence> {
  _PlotBandRecurrenceState(this.sample);

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
  void didUpdateWidget(PlotBandRecurrence oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _,SampleListModel model) => SafeArea(
              child: Backdrop(
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                toggleFrontLayer: false,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/plot_band/Plot_band_recurrence.dart');
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
                color: model.cardThemeColor,
                titleVisibleOnPanelClosed: true,
                borderRadius:const BorderRadius.vertical(
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
  bool xAxis = false, yAxis = true;

  @override
  void initState() {
    xAxis = false;
    yAxis = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _,SampleListModel model) {
          return Scaffold(
             backgroundColor:model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                child: Container(
                    child: getPlotBandRecurrenceChart(false, xAxis, yAxis)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }

  void _showSettingsPanel(SampleListModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleListModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _,SampleListModel model) => Padding(
                padding:const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                    height: 180,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * height,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                              child: Stack(children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Settings',
                                          style: TextStyle(
                                              color: model.textColor,
                                              fontSize: 18,
                                              letterSpacing: 0.34,
                                              fontWeight: FontWeight.w500)),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: model.textColor,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 50, 0, 0),
                                  child: ListView(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('X Axis',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
                                              switchValue: xAxis,
                                              valueChanged: (dynamic value) {
                                                setState(() {
                                                  xAxis = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Y Axis',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
                                              switchValue: yAxis,
                                              valueChanged: (dynamic value) {
                                                setState(() {
                                                  yAxis = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            )))))));
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
 final  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  dynamic _afterLayout(dynamic _) {
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
      builder: (BuildContext context, _,SampleListModel model) {
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

SfCartesianChart getPlotBandRecurrenceChart(bool isTileView,
    [bool xVisible, bool yVisible]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'World pollution report'),
    legend: Legend(isVisible: !isTileView),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        interval: 5,
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        minimum: DateTime(1975, 1, 1),
        maximum: DateTime(2010, 1, 1),
        plotBands: <PlotBand>[
          PlotBand(
              isRepeatable: true,
              isVisible: isTileView ? false : xVisible,
              repeatEvery: 10,
              sizeType: DateTimeIntervalType.years,
              size: 5,
              repeatUntil: DateTime(2010, 1, 1),
              start: DateTime(1965, 1, 1),
              end: DateTime(2010, 1, 1),
              shouldRenderAboveSeries:false,
              color: const Color.fromRGBO(227, 228, 230, 0.4))
        ]),
    primaryYAxis: NumericAxis(
        isVisible: true,
        minimum: 0,
        interval: 2000,
        maximum: 18000,
        plotBands: <PlotBand>[
          PlotBand(
              isRepeatable: true,
              isVisible: isTileView ? true : yVisible,
              repeatEvery: 4000,
              size: 2000,
              start: 0,
              end: 18000,
              repeatUntil: 18000,
              shouldRenderAboveSeries:false,
              color: const Color.fromRGBO(227, 228, 230, 0.1))
        ],
        majorGridLines: MajorGridLines(color: Colors.grey),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
        labelStyle: ChartTextStyle(fontSize: 0)),
    series: _getColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<ColumnSeries<_ColumnData, DateTime>> _getColumnSeries(bool isTileView) {
  final List<_ColumnData> chartData = <_ColumnData>[
    _ColumnData(DateTime(1980, 1, 1), 15400, 6400),
    _ColumnData(DateTime(1985, 1, 1), 15800, 3700),
    _ColumnData(DateTime(1990, 1, 1), 14000, 7200),
    _ColumnData(DateTime(1995, 1, 1), 10500, 2300),
    _ColumnData(DateTime(2000, 1, 1), 13300, 4000),
    _ColumnData(DateTime(2005, 1, 1), 12800, 4800)
  ];
  return <ColumnSeries<_ColumnData, DateTime>>[
    ColumnSeries<_ColumnData, DateTime>(
      dataSource: chartData,
      name: 'All sources',
      xValueMapper: (_ColumnData sales, _) => sales.x,
      yValueMapper: (_ColumnData sales, _) => sales.y,
    ),
    ColumnSeries<_ColumnData, DateTime>(
      dataSource: chartData,
      name: 'Autos & Light Trucks',
      xValueMapper: (_ColumnData sales, _) => sales.x,
      yValueMapper: (_ColumnData sales, _) => sales.yVal,
    )
  ];
}

class _ColumnData {
  _ColumnData(this.x, this.y, this.yVal);
  final DateTime x;
  final double y;
  final double yVal;
}
