import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultTrackball extends StatefulWidget {
  const DefaultTrackball(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _DefaultTrackballState createState() => _DefaultTrackballState(sample);
}

class _DefaultTrackballState extends State<DefaultTrackball> {
  _DefaultTrackballState(this.sample);
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
  void didUpdateWidget(DefaultTrackball oldWidget) {
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
                        icon:
                            Image.asset('images/code.png', color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/user_interactions/trackball/chart_with_trackball.dart');
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
  bool showAlways = true;
  final List<String> _modeList =
      <String>['floatAllPoints', 'groupAllPoints', 'nearestPoint'].toList();
  String _selectedMode = 'floatAllPoints';

  TrackballDisplayMode _mode = TrackballDisplayMode.floatAllPoints;

  final List<String> _alignmentList =
      <String>['center', 'far', 'near'].toList();
  String _tooltipAlignment = 'center';

  ChartAlignment _alignment = ChartAlignment.center;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                child: Container(
                    child: getDefaultTrackballChart(
                        false, _mode, _alignment, showAlways)),
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
            ? 0.4
            : 0.5;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleListModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleListModel model) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 220,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * height,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          Text('Mode ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                100, 0, 0, 0),
                                            height: 50,
                                            width: 280,
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _selectedMode,
                                                      item: _modeList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value:
                                                                (value != null)
                                                                    ? value
                                                                    : 'point',
                                                            child: Text(
                                                                '$value',
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onModeTypeChange(
                                                            value, model);
                                                      })),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text('Alignment',
                                              style: TextStyle(
                                                  color: _selectedMode !=
                                                          'groupAllPoints'
                                                      ? const Color.fromRGBO(
                                                          0, 0, 0, 0.3)
                                                      : model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                70, 0, 0, 0),
                                            height: 50,
                                            width: 150,
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _tooltipAlignment,
                                                      item: _selectedMode !=
                                                              'groupAllPoints'
                                                          ? null
                                                          : _alignmentList.map(
                                                              (String value) {
                                                              return DropdownMenuItem<
                                                                      String>(
                                                                  value: (value !=
                                                                          null)
                                                                      ? value
                                                                      : 'point',
                                                                  child: Text(
                                                                      '$value',
                                                                      style: TextStyle(
                                                                          color:
                                                                              model.textColor)));
                                                            }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onAlignmentChange(
                                                            value, model);
                                                      })),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text('Show always ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          BottomSheetCheckbox(
                                            activeColor: model.backgroundColor,
                                            switchValue: showAlways,
                                            valueChanged: (dynamic value) {
                                              setState(() {
                                                showAlways = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ))));
  }

  void onModeTypeChange(String item, SampleListModel model) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'floatAllPoints') {
        _mode = TrackballDisplayMode.floatAllPoints;
      }
      if (_selectedMode == 'groupAllPoints') {
        _mode = TrackballDisplayMode.groupAllPoints;
      }
      if (_selectedMode == 'nearestPoint') {
        _mode = TrackballDisplayMode.nearestPoint;
      }
      if (_selectedMode == 'none') {
        _mode = TrackballDisplayMode.none;
      }
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
    });
  }

  void onAlignmentChange(String item, SampleListModel model) {
    setState(() {
      _tooltipAlignment = item;
      if (_tooltipAlignment == 'center') {
        _alignment = ChartAlignment.center;
      }
      if (_tooltipAlignment == 'far') {
        _alignment = ChartAlignment.far;
      }
      if (_tooltipAlignment == 'near') {
        _alignment = ChartAlignment.near;
      }
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
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

SfCartesianChart getDefaultTrackballChart(bool isTileView,
    [TrackballDisplayMode _mode, ChartAlignment _alignment, bool showAlways]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Average sales per person'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Revenue'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0)),
    series: getLineSeries(isTileView),
    trackballBehavior: TrackballBehavior(
        enable: true,
        lineType: TrackballLineType.vertical,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _alignment,
        tooltipDisplayMode: _mode,
        tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
        shouldAlwaysShow: showAlways),
  );
}

List<LineSeries<_TrackballData, DateTime>> getLineSeries(bool isTileView) {
  final List<_TrackballData> chartData = <_TrackballData>[
    _TrackballData(DateTime(2000, 2, 11), 15, 39, 60),
    _TrackballData(DateTime(2000, 9, 14), 20, 30, 55),
    _TrackballData(DateTime(2001, 2, 11), 25, 28, 48),
    _TrackballData(DateTime(2001, 9, 16), 21, 35, 57),
    _TrackballData(DateTime(2002, 2, 7), 13, 39, 62),
    _TrackballData(DateTime(2002, 9, 7), 18, 41, 64),
    _TrackballData(DateTime(2003, 2, 11), 24, 45, 57),
    _TrackballData(DateTime(2003, 9, 14), 23, 48, 53),
    _TrackballData(DateTime(2004, 2, 6), 19, 54, 63),
    _TrackballData(DateTime(2004, 9, 6), 31, 55, 50),
    _TrackballData(DateTime(2005, 2, 11), 39, 57, 66),
    _TrackballData(DateTime(2005, 9, 11), 50, 60, 65),
    _TrackballData(DateTime(2006, 2, 11), 24, 60, 79),
  ];
  return <LineSeries<_TrackballData, DateTime>>[
    LineSeries<_TrackballData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_TrackballData sales, _) => sales.year,
        yValueMapper: (_TrackballData sales, _) => sales.y1,
        width: 2,
        name: 'John',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_TrackballData, DateTime>(
        dataSource: chartData,
        width: 2,
        name: 'Andrew',
        xValueMapper: (_TrackballData sales, _) => sales.year,
        yValueMapper: (_TrackballData sales, _) => sales.y2,
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_TrackballData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (_TrackballData sales, _) => sales.year,
        yValueMapper: (_TrackballData sales, _) => sales.y3,
        name: 'Thomas',
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class _TrackballData {
  _TrackballData(this.year, this.y1, this.y2, this.y3);
  final DateTime year;
  final double y1;
  final double y2;
  final double y3;
}
