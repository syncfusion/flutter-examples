import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultPanning extends StatefulWidget {
  const DefaultPanning(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _DefaultPanningState createState() => _DefaultPanningState(sample);
}

ZoomPanBehavior zoomingBehavior;

class _DefaultPanningState extends State<DefaultPanning> {
  _DefaultPanningState(this.sample);
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
  void didUpdateWidget(DefaultPanning oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/user_interactions/zooming_panning/pinch_zooming.dart');
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
  
  final List<String> _zoomModeTypeList = <String>['x', 'y', 'xy'].toList();
  String _selectedModeType = 'x';
  ZoomMode _zoomModeType = ZoomMode.x;

  @override
  Widget build(BuildContext context) {
    zoomingBehavior = ZoomPanBehavior(
        enablePinching: true,
        zoomMode: _zoomModeType,
        enablePanning: true);
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getDefaultPanningChart(false, _zoomModeType)),
              ),
              floatingActionButton: Container(
                height:45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        _showSettingsPanel(model);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ),
                    const Padding(
                      padding:EdgeInsets.only(left:5) ,
                    ),

                    FloatingActionButton(
                      heroTag: false,
                      onPressed: () {
                        zoomingBehavior.reset();
                      },
                      child: Icon(Icons.refresh, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    )
                  ],
                ),
              ));
        });
  }

  void _showSettingsPanel(SampleListModel model) {
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
                  height: 120,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: 120,
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
                                    const EdgeInsets.fromLTRB(15, 50, 0, 0),
                                child: ListView(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text('Zoom mode ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 40, 0),
                                            height: 50,
                                            width: 150,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _selectedModeType,
                                                      item: _zoomModeTypeList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value:
                                                                (value != null)
                                                                    ? value
                                                                    : 'x',
                                                            child: Text(
                                                                '$value',
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onZoomTypeChange(
                                                            value, model);
                                                      })),
                                            ),
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

  void onZoomTypeChange(String item, SampleListModel model) {
    setState(() {
      _selectedModeType = item;
      if (_selectedModeType == 'x') {
        _zoomModeType = ZoomMode.x;
      }
      if (_selectedModeType == 'y') {
        _zoomModeType = ZoomMode.y;
      }
      if (_selectedModeType == 'xy') {
        _zoomModeType = ZoomMode.xy;
      }
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

SfCartesianChart getDefaultPanningChart(bool isTileView,
    [ZoomMode _zoomModeType]) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getLineSeries(isTileView),
      zoomPanBehavior: zoomingBehavior);
}

List<AreaSeries<_DateTimeData, DateTime>> getLineSeries(bool isTileView) {
  final List<Color> color = <Color>[];
  color.add(Colors.teal[50]);
  color.add(Colors.teal[200]);
  color.add(Colors.teal);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
      LinearGradient(colors: color, stops: stops);
  return <AreaSeries<_DateTimeData, DateTime>>[
    AreaSeries<_DateTimeData, DateTime>(
        dataSource: getDatatTimeData(),
        xValueMapper: (_DateTimeData sales, _) => sales.year,
        yValueMapper: (_DateTimeData sales, _) => sales.y,
        gradient: gradientColors
        // width: 2
        )
  ];
}

class _DateTimeData {
  _DateTimeData(this.year, this.y);
  final DateTime year;
  final num y;
}

dynamic getDatatTimeData() {
  final List<_DateTimeData> randomData = <_DateTimeData>[
    _DateTimeData(DateTime(1950, 3, 31), 80.7),
    _DateTimeData(DateTime(1950, 5, 1), 80.2),
    _DateTimeData(DateTime(1950, 6, 2), 79.3),
    _DateTimeData(DateTime(1950, 7, 3), 78.6),
    _DateTimeData(DateTime(1950, 8, 4), 79.5),
    _DateTimeData(DateTime(1950, 9, 5), 78.9),
    _DateTimeData(DateTime(1950, 10, 6), 78.2),
    _DateTimeData(DateTime(1950, 11, 07), 77.4),
    _DateTimeData(DateTime(1950, 12, 08), 77.6),
    _DateTimeData(DateTime(1951, 01, 09), 77.7),
    _DateTimeData(DateTime(1951, 02, 10), 78.4),
    _DateTimeData(DateTime(1951, 03, 11), 78.6),
    _DateTimeData(DateTime(1951, 04, 12), 78.8),
    _DateTimeData(DateTime(1951, 05, 13), 79.4),
    _DateTimeData(DateTime(1951, 06, 14), 79.0),
    _DateTimeData(DateTime(1951, 07, 15), 79.9),
    _DateTimeData(DateTime(1951, 08, 16), 79.8),
    _DateTimeData(DateTime(1951, 09, 17), 79.2),
    _DateTimeData(DateTime(1951, 10, 18), 78.5),
    _DateTimeData(DateTime(1951, 11, 19), 77.9),
    _DateTimeData(DateTime(1951, 12, 20), 78.2),
    _DateTimeData(DateTime(1952, 01, 21), 79.1),
    _DateTimeData(DateTime(1952, 02, 22), 79.5),
    _DateTimeData(DateTime(1952, 03, 23), 79.6),
    _DateTimeData(DateTime(1952, 04, 24), 78.8),
    _DateTimeData(DateTime(1952, 05, 25), 79.4),
    _DateTimeData(DateTime(1952, 06, 26), 78.7),
    _DateTimeData(DateTime(1952, 07, 27), 79.0),
    _DateTimeData(DateTime(1952, 08, 28), 79.6),
    _DateTimeData(DateTime(1952, 09, 29), 80.4),
    _DateTimeData(DateTime(1952, 10, 30), 80.9),
    _DateTimeData(DateTime(1952, 12, 01), 81.1),
    _DateTimeData(DateTime(1953, 01, 01), 80.3),
    _DateTimeData(DateTime(1953, 02, 02), 81.0),
    _DateTimeData(DateTime(1953, 03, 06), 81.1),
    _DateTimeData(DateTime(1953, 04, 04), 81.2),
    _DateTimeData(DateTime(1953, 05, 06), 81.9),
    _DateTimeData(DateTime(1953, 06, 06), 82.9),
    _DateTimeData(DateTime(1953, 07, 08), 82.9),
    _DateTimeData(DateTime(1953, 08, 08), 82.8),
    _DateTimeData(DateTime(1953, 09, 09), 82.1),
    _DateTimeData(DateTime(1953, 10, 11), 81.5),
    _DateTimeData(DateTime(1953, 11, 11), 82.0),
    _DateTimeData(DateTime(1953, 12, 13), 81.2),
    _DateTimeData(DateTime(1954, 01, 13), 80.6),
    _DateTimeData(DateTime(1954, 02, 14), 80.2),
    _DateTimeData(DateTime(1954, 03, 18), 79.4),
    _DateTimeData(DateTime(1954, 04, 16), 78.4),
    _DateTimeData(DateTime(1954, 05, 18), 78.8),
    _DateTimeData(DateTime(1954, 06, 18), 78.0),
    _DateTimeData(DateTime(1954, 07, 20), 78.5),
    _DateTimeData(DateTime(1954, 08, 20), 78.9),
    _DateTimeData(DateTime(1954, 09, 21), 79.1),
    _DateTimeData(DateTime(1954, 10, 23), 79.1),
    _DateTimeData(DateTime(1954, 11, 23), 79.3),
    _DateTimeData(DateTime(1954, 12, 25), 80.2),
    _DateTimeData(DateTime(1955, 01, 25), 79.7),
    _DateTimeData(DateTime(1955, 02, 26), 79.8),
    _DateTimeData(DateTime(1955, 03, 30), 79.3),
    _DateTimeData(DateTime(1955, 04, 28), 78.3),
    _DateTimeData(DateTime(1955, 05, 30), 77.4),
    _DateTimeData(DateTime(1955, 06, 30), 78.0),
    _DateTimeData(DateTime(1955, 08, 01), 77.0),
    _DateTimeData(DateTime(1955, 09, 01), 77.6),
    _DateTimeData(DateTime(1955, 10, 03), 76.7),
    _DateTimeData(DateTime(1955, 11, 04), 76.5),
    _DateTimeData(DateTime(1955, 12, 05), 75.8),
    _DateTimeData(DateTime(1956, 01, 06), 75.2),
    _DateTimeData(DateTime(1956, 02, 06), 75.8),
    _DateTimeData(DateTime(1956, 03, 09), 76.3),
    _DateTimeData(DateTime(1956, 04, 10), 76.9),
    _DateTimeData(DateTime(1956, 05, 10), 76.3),
    _DateTimeData(DateTime(1956, 06, 11), 76.3),
    _DateTimeData(DateTime(1956, 07, 12), 76.6),
    _DateTimeData(DateTime(1956, 08, 13), 76.1),
    _DateTimeData(DateTime(1956, 09, 13), 76.3),
    _DateTimeData(DateTime(1956, 10, 15), 76.6),
    _DateTimeData(DateTime(1956, 11, 16), 77.3),
    _DateTimeData(DateTime(1956, 12, 17), 76.6),
    _DateTimeData(DateTime(1957, 01, 18), 76.6),
    _DateTimeData(DateTime(1957, 02, 18), 76.6),
    _DateTimeData(DateTime(1957, 03, 22), 77.4),
    _DateTimeData(DateTime(1957, 04, 23), 78.2),
    _DateTimeData(DateTime(1957, 05, 22), 78.0),
    _DateTimeData(DateTime(1957, 06, 23), 77.1),
    _DateTimeData(DateTime(1957, 07, 24), 77.6),
    _DateTimeData(DateTime(1957, 08, 25), 77.1),
    _DateTimeData(DateTime(1957, 09, 25), 77.4),
    _DateTimeData(DateTime(1957, 10, 27), 76.4),
    _DateTimeData(DateTime(1957, 11, 28), 76.7),
    _DateTimeData(DateTime(1957, 12, 29), 76.6),
    _DateTimeData(DateTime(1958, 01, 30), 76.7),
    _DateTimeData(DateTime(1958, 03, 02), 76.1),
    _DateTimeData(DateTime(1958, 04, 03), 75.4),
    _DateTimeData(DateTime(1958, 05, 05), 76.1),
    _DateTimeData(DateTime(1958, 06, 03), 76.6),
    _DateTimeData(DateTime(1958, 07, 05), 76.9),
    _DateTimeData(DateTime(1958, 08, 05), 77.9),
    _DateTimeData(DateTime(1958, 09, 06), 77.5),
    _DateTimeData(DateTime(1958, 10, 07), 77.5),
    _DateTimeData(DateTime(1958, 11, 08), 77.5),
    _DateTimeData(DateTime(1958, 12, 10), 77.3),
    _DateTimeData(DateTime(1959, 01, 10), 76.6),
    _DateTimeData(DateTime(1959, 02, 11), 77.0),
    _DateTimeData(DateTime(1959, 03, 14), 76.5),
    _DateTimeData(DateTime(1959, 04, 15), 77.4),
    _DateTimeData(DateTime(1959, 05, 17), 77.8),
    _DateTimeData(DateTime(1959, 06, 15), 78.3),
    _DateTimeData(DateTime(1959, 07, 17), 78.3),
    _DateTimeData(DateTime(1959, 08, 17), 78.9),
    _DateTimeData(DateTime(1959, 09, 18), 78.9),
    _DateTimeData(DateTime(1959, 10, 19), 79.3),
    _DateTimeData(DateTime(1959, 11, 20), 78.9),
    _DateTimeData(DateTime(1959, 12, 22), 78.7),
    _DateTimeData(DateTime(1960, 01, 22), 79.0),
    _DateTimeData(DateTime(1960, 02, 23), 78.4),
    _DateTimeData(DateTime(1960, 03, 25), 77.8),
    _DateTimeData(DateTime(1960, 04, 26), 78.6),
    _DateTimeData(DateTime(1960, 05, 28), 79.5),
    _DateTimeData(DateTime(1960, 06, 27), 79.1),
    _DateTimeData(DateTime(1960, 07, 29), 79.6),
    _DateTimeData(DateTime(1960, 08, 29), 79.3),
    _DateTimeData(DateTime(1960, 09, 30), 79.2),
    _DateTimeData(DateTime(1960, 10, 31), 79.4),
    _DateTimeData(DateTime(1960, 12, 02), 79.7),
    _DateTimeData(DateTime(1961, 01, 03), 80.5),
    _DateTimeData(DateTime(1961, 02, 03), 79.5),
    _DateTimeData(DateTime(1961, 03, 07), 80.3),
    _DateTimeData(DateTime(1961, 04, 07), 80.1),
    _DateTimeData(DateTime(1961, 05, 09), 80.3),
    _DateTimeData(DateTime(1961, 06, 10), 79.5),
    _DateTimeData(DateTime(1961, 07, 09), 78.9),
    _DateTimeData(DateTime(1961, 08, 10), 79.2),
    _DateTimeData(DateTime(1961, 09, 10), 79.6),
    _DateTimeData(DateTime(1961, 10, 12), 78.6),
    _DateTimeData(DateTime(1961, 11, 12), 78.8),
    _DateTimeData(DateTime(1961, 12, 14), 79.8),
    _DateTimeData(DateTime(1962, 01, 15), 80.3),
    _DateTimeData(DateTime(1962, 02, 15), 79.5),
    _DateTimeData(DateTime(1962, 03, 19), 79.5),
    _DateTimeData(DateTime(1962, 04, 19), 80.2),
    _DateTimeData(DateTime(1962, 05, 21), 80.0),
    _DateTimeData(DateTime(1962, 06, 22), 79.1),
    _DateTimeData(DateTime(1962, 07, 21), 79.1),
    _DateTimeData(DateTime(1962, 08, 22), 79.3),
    _DateTimeData(DateTime(1962, 09, 22), 79.1),
    _DateTimeData(DateTime(1962, 10, 24), 79.6),
    _DateTimeData(DateTime(1962, 11, 24), 80.3),
    _DateTimeData(DateTime(1962, 12, 26), 79.9),
    _DateTimeData(DateTime(1963, 01, 27), 80.1),
    _DateTimeData(DateTime(1963, 02, 27), 80.4),
    _DateTimeData(DateTime(1963, 03, 31), 80.5),
    _DateTimeData(DateTime(1963, 05, 01), 80.0),
    _DateTimeData(DateTime(1963, 06, 02), 80.4),
    _DateTimeData(DateTime(1963, 07, 04), 80.3),
    _DateTimeData(DateTime(1963, 08, 02), 81.3),
    _DateTimeData(DateTime(1963, 09, 03), 82.0),
    _DateTimeData(DateTime(1963, 10, 04), 82.3),
    _DateTimeData(DateTime(1963, 11, 05), 82.6),
    _DateTimeData(DateTime(1963, 12, 06), 82.4),
    _DateTimeData(DateTime(1964, 01, 07), 82.1),
    _DateTimeData(DateTime(1964, 02, 08), 81.5),
    _DateTimeData(DateTime(1964, 03, 10), 81.1),
    _DateTimeData(DateTime(1964, 04, 11), 80.2),
    _DateTimeData(DateTime(1964, 05, 12), 80.0),
    _DateTimeData(DateTime(1964, 06, 13), 79.2),
    _DateTimeData(DateTime(1964, 07, 15), 78.7),
    _DateTimeData(DateTime(1964, 08, 14), 78.0),
    _DateTimeData(DateTime(1964, 09, 15), 77.3),
    _DateTimeData(DateTime(1964, 10, 16), 77.9),
    _DateTimeData(DateTime(1964, 11, 17), 77.8),
    _DateTimeData(DateTime(1964, 12, 18), 77.0),
    _DateTimeData(DateTime(1965, 01, 19), 77.1),
    _DateTimeData(DateTime(1965, 02, 20), 78.0),
    _DateTimeData(DateTime(1965, 03, 23), 78.5),
    _DateTimeData(DateTime(1965, 04, 24), 78.8),
    _DateTimeData(DateTime(1965, 05, 25), 79.5),
    _DateTimeData(DateTime(1965, 06, 26), 80.2),
    _DateTimeData(DateTime(1965, 07, 28), 81.0),
    _DateTimeData(DateTime(1965, 08, 26), 80.2),
    _DateTimeData(DateTime(1965, 09, 27), 79.3),
    _DateTimeData(DateTime(1965, 10, 28), 79.4),
    _DateTimeData(DateTime(1965, 11, 29), 79.5),
    _DateTimeData(DateTime(1965, 12, 30), 79.6),
    _DateTimeData(DateTime(1966, 01, 31), 79.1),
    _DateTimeData(DateTime(1966, 03, 04), 79.8),
    _DateTimeData(DateTime(1966, 04, 04), 78.8),
    _DateTimeData(DateTime(1966, 05, 06), 79.6),
    _DateTimeData(DateTime(1966, 06, 06), 80.2),
    _DateTimeData(DateTime(1966, 07, 08), 79.2),
    _DateTimeData(DateTime(1966, 08, 09), 78.5),
    _DateTimeData(DateTime(1966, 09, 07), 77.5),
    _DateTimeData(DateTime(1966, 10, 09), 78.0),
    _DateTimeData(DateTime(1966, 11, 09), 78.5),
    _DateTimeData(DateTime(1966, 12, 11), 78.1),
    _DateTimeData(DateTime(1967, 01, 11), 77.3),
    _DateTimeData(DateTime(1967, 02, 12), 76.7),
    _DateTimeData(DateTime(1967, 03, 16), 76.0),
    _DateTimeData(DateTime(1967, 04, 16), 76.6),
    _DateTimeData(DateTime(1967, 05, 18), 76.3),
    _DateTimeData(DateTime(1967, 06, 18), 76.0),
    _DateTimeData(DateTime(1967, 07, 20), 76.5),
    _DateTimeData(DateTime(1967, 08, 21), 76.6),
    _DateTimeData(DateTime(1967, 09, 19), 77.3),
    _DateTimeData(DateTime(1967, 10, 21), 76.8),
    _DateTimeData(DateTime(1967, 11, 21), 77.8),
    _DateTimeData(DateTime(1967, 12, 23), 77.6),
    _DateTimeData(DateTime(1968, 01, 23), 77.6),
    _DateTimeData(DateTime(1968, 02, 24), 76.9),
    _DateTimeData(DateTime(1968, 03, 27), 76.0),
    _DateTimeData(DateTime(1968, 04, 27), 76.8),
    _DateTimeData(DateTime(1968, 05, 29), 75.9),
    _DateTimeData(DateTime(1968, 06, 29), 76.3),
    _DateTimeData(DateTime(1968, 07, 31), 75.5),
    _DateTimeData(DateTime(1968, 09, 01), 75.3),
    _DateTimeData(DateTime(1968, 10, 01), 75.0),
    _DateTimeData(DateTime(1968, 11, 02), 75.3),
    _DateTimeData(DateTime(1968, 12, 03), 74.8),
    _DateTimeData(DateTime(1969, 01, 04), 74.4),
    _DateTimeData(DateTime(1969, 02, 04), 74.1),
    _DateTimeData(DateTime(1969, 03, 08), 74.4),
    _DateTimeData(DateTime(1969, 04, 09), 74.6),
    _DateTimeData(DateTime(1969, 05, 10), 75.1),
    _DateTimeData(DateTime(1969, 06, 11), 74.9),
    _DateTimeData(DateTime(1969, 07, 12), 75.4),
    _DateTimeData(DateTime(1969, 08, 13), 76.0),
    _DateTimeData(DateTime(1969, 09, 14), 76.4),
    _DateTimeData(DateTime(1969, 10, 13), 76.7),
    _DateTimeData(DateTime(1969, 11, 14), 76.7),
    _DateTimeData(DateTime(1969, 12, 15), 77.0),
    _DateTimeData(DateTime(1970, 01, 16), 77.9),
    _DateTimeData(DateTime(1970, 02, 16), 77.9),
    _DateTimeData(DateTime(1970, 03, 20), 78.8),
    _DateTimeData(DateTime(1970, 04, 21), 79.1),
    _DateTimeData(DateTime(1970, 05, 22), 79.0),
    _DateTimeData(DateTime(1970, 06, 23), 78.7),
    _DateTimeData(DateTime(1970, 07, 24), 78.3),
    _DateTimeData(DateTime(1970, 08, 25), 78.3),
    _DateTimeData(DateTime(1970, 09, 26), 79.1),
    _DateTimeData(DateTime(1970, 10, 25), 78.1),
    _DateTimeData(DateTime(1970, 11, 26), 77.9),
    _DateTimeData(DateTime(1970, 12, 27), 77.2),
    _DateTimeData(DateTime(1971, 01, 28), 77.2),
    _DateTimeData(DateTime(1971, 02, 28), 76.2),
    _DateTimeData(DateTime(1971, 04, 01), 76.3),
    _DateTimeData(DateTime(1971, 05, 03), 75.6),
    _DateTimeData(DateTime(1971, 06, 03), 75.1),
    _DateTimeData(DateTime(1971, 07, 05), 74.5),
    _DateTimeData(DateTime(1971, 08, 05), 74.6),
    _DateTimeData(DateTime(1971, 09, 06), 75.2),
    _DateTimeData(DateTime(1971, 10, 08), 74.5),
    _DateTimeData(DateTime(1971, 11, 06), 74.7),
    _DateTimeData(DateTime(1971, 12, 08), 74.7),
    _DateTimeData(DateTime(1972, 01, 08), 75.2),
    _DateTimeData(DateTime(1972, 02, 09), 75.5),
    _DateTimeData(DateTime(1972, 03, 11), 76.3),
    _DateTimeData(DateTime(1972, 04, 12), 75.7),
    _DateTimeData(DateTime(1972, 05, 14), 76.5),
    _DateTimeData(DateTime(1972, 06, 14), 77.5),
    _DateTimeData(DateTime(1972, 07, 16), 78.3),
    _DateTimeData(DateTime(1972, 08, 16), 79.0),
    _DateTimeData(DateTime(1972, 09, 17), 80.0),
    _DateTimeData(DateTime(1972, 10, 19), 80.4),
    _DateTimeData(DateTime(1972, 11, 18), 80.5),
    _DateTimeData(DateTime(1972, 12, 20), 79.5),
    _DateTimeData(DateTime(1973, 01, 20), 78.9),
    _DateTimeData(DateTime(1973, 02, 21), 79.5),
    _DateTimeData(DateTime(1973, 03, 24), 80.5),
    _DateTimeData(DateTime(1973, 04, 25), 79.6),
    _DateTimeData(DateTime(1973, 05, 27), 80.6),
    _DateTimeData(DateTime(1973, 06, 27), 81.4),
    _DateTimeData(DateTime(1973, 07, 29), 81.2),
    _DateTimeData(DateTime(1973, 08, 29), 81.1),
    _DateTimeData(DateTime(1973, 09, 30), 81.3),
    _DateTimeData(DateTime(1973, 11, 01), 81.3),
    _DateTimeData(DateTime(1973, 11, 30), 80.6),
    _DateTimeData(DateTime(1974, 01, 01), 81.0),
    _DateTimeData(DateTime(1974, 02, 01), 81.6),
    _DateTimeData(DateTime(1974, 03, 05), 80.9),
    _DateTimeData(DateTime(1974, 04, 05), 80.0),
    _DateTimeData(DateTime(1974, 05, 07), 80.8),
    _DateTimeData(DateTime(1974, 06, 08), 81.0),
    _DateTimeData(DateTime(1974, 07, 09), 80.7),
    _DateTimeData(DateTime(1974, 08, 10), 80.4),
    _DateTimeData(DateTime(1974, 09, 10), 79.9),
    _DateTimeData(DateTime(1974, 10, 12), 79.3),
    _DateTimeData(DateTime(1974, 11, 13), 78.7),
    _DateTimeData(DateTime(1974, 12, 12), 77.9),
    _DateTimeData(DateTime(1975, 01, 13), 78.4),
    _DateTimeData(DateTime(1975, 02, 13), 77.4),
    _DateTimeData(DateTime(1975, 03, 17), 78.0),
    _DateTimeData(DateTime(1975, 04, 17), 77.9),
    _DateTimeData(DateTime(1975, 05, 19), 77.8),
    _DateTimeData(DateTime(1975, 06, 20), 78.3),
    _DateTimeData(DateTime(1975, 07, 21), 79.2),
    _DateTimeData(DateTime(1975, 08, 22), 79.9),
    _DateTimeData(DateTime(1975, 09, 22), 79.1),
    _DateTimeData(DateTime(1975, 10, 24), 79.1),
    _DateTimeData(DateTime(1975, 11, 25), 79.2),
    _DateTimeData(DateTime(1975, 12, 24), 78.3),
    _DateTimeData(DateTime(1976, 01, 25), 77.6),
    _DateTimeData(DateTime(1976, 02, 25), 78.3),
    _DateTimeData(DateTime(1976, 03, 28), 78.0),
    _DateTimeData(DateTime(1976, 04, 28), 78.0),
    _DateTimeData(DateTime(1976, 05, 30), 78.6),
    _DateTimeData(DateTime(1976, 07, 01), 79.5),
    _DateTimeData(DateTime(1976, 08, 01), 79.1),
    _DateTimeData(DateTime(1976, 09, 02), 79.9),
    _DateTimeData(DateTime(1976, 10, 03), 79.9),
    _DateTimeData(DateTime(1976, 11, 04), 79.0),
    _DateTimeData(DateTime(1976, 12, 06), 79.3),
    _DateTimeData(DateTime(1977, 01, 05), 78.7),
    _DateTimeData(DateTime(1977, 02, 06), 78.9),
    _DateTimeData(DateTime(1977, 03, 09), 79.9),
    _DateTimeData(DateTime(1977, 04, 10), 80.5),
    _DateTimeData(DateTime(1977, 05, 11), 79.7),
    _DateTimeData(DateTime(1977, 06, 12), 80.7),
    _DateTimeData(DateTime(1977, 07, 14), 81.6),
    _DateTimeData(DateTime(1977, 08, 14), 82.6),
    _DateTimeData(DateTime(1977, 09, 15), 82.1),
    _DateTimeData(DateTime(1977, 10, 16), 83.1),
    _DateTimeData(DateTime(1977, 11, 17), 82.9),
    _DateTimeData(DateTime(1977, 12, 19), 83.0),
    _DateTimeData(DateTime(1978, 01, 17), 82.1),
    _DateTimeData(DateTime(1978, 02, 18), 82.0),
    _DateTimeData(DateTime(1978, 03, 21), 82.0),
  ];
  return randomData;
}
