import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
Timer timer;

class CartesianDynamicAnimation extends StatefulWidget {
  const CartesianDynamicAnimation(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _CartesianDynamicAnimationState createState() =>
      _CartesianDynamicAnimationState(sample);
}

class _CartesianDynamicAnimationState extends State<CartesianDynamicAnimation> {
  _CartesianDynamicAnimationState(this.sample);
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
    timer.cancel();
  }

  @override
  void didUpdateWidget(CartesianDynamicAnimation oldWidget) {
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
                toggleFrontLayer: false,
                frontPanelOpenPercentage: 0.28,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/series_features/animation/dynamic_animation.dart');
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

List<_DynamicData> chartData = <_DynamicData>[
  _DynamicData('1', 45, Colors.yellow),
  _DynamicData('2', 52, Colors.teal),
  _DynamicData('3', 41, Colors.blue),
  _DynamicData('4', 65, Colors.orange),
  _DynamicData('5', 36, Colors.pink),
  _DynamicData('6', 65, Colors.brown[300]),
];

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
  final SubItemList sample;
  bool enableTooltip = false;
  bool enableMarker = false;
  bool enableDatalabel = false;
  // List<_DynamicData> chartData;
  int count = 0;
  final List<String> _seriesType = <String>[
    'Column',
    'Line',
    'Spline',
    'StepLine',
    'Scatter',
    'Bubble',
    'Bar',
    'Area'
  ].toList();

  String _selectedType = 'Column';


  @override
  Widget build(BuildContext context) {
    chartData = getChartData();
    timer = Timer(Duration(seconds: 3), () {
      setState(() {
        chartData = getChartData();
      });
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getDynamicAnimationChart(false, _selectedType)),
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                      child: Container(
                        height: 50,
                        width: 250,
                        child: InkWell(
                          onTap: () => launch(
                              'https://en.wikipedia.org/wiki/List_of_men%27s_footballers_with_500_or_more_goals'),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        _showSettingsPanel(model);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ),
                  ),
                ],
              ));
        });
  }

  void onSeriesTypeChange(String item, SampleListModel model) {
    setState(() {
      _selectedType = item;
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
                            height: 150,
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
                                            Text('Chart type ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 0, 0),
                                                height: 50,
                                                width: 150,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            canvasColor: model
                                                                .bottomSheetBackgroundColor),
                                                    child: DropDown(
                                                        value: _selectedType,
                                                        item: _seriesType.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'column',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onSeriesTypeChange(
                                                              value.toString(),
                                                              model);
                                                        }),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            )))))));
  }

  List<_DynamicData> getChartData() {
    if (count == 0) {
      chartData = <_DynamicData>[
        _DynamicData('1', 76, Colors.yellow),
        _DynamicData('2', 50, Colors.teal),
        _DynamicData('3', 60, Colors.blue),
        _DynamicData('4', 32, Colors.orange),
        _DynamicData('5', 29, Colors.pink),
        _DynamicData('6', 20, Colors.brown[300]),
      ];
      count++;
    } else if (count == 1) {
      chartData = <_DynamicData>[
        _DynamicData('1', 36, Colors.yellow),
        _DynamicData('2', 10, Colors.teal),
        _DynamicData('3', 20, Colors.blue),
        _DynamicData('4', 50, Colors.orange),
        _DynamicData('5', 19, Colors.pink),
        _DynamicData('6', 67, Colors.brown[300]),
      ];
      count++;
    } else if (count == 2) {
      chartData = <_DynamicData>[
        _DynamicData('1', 40, Colors.yellow),
        _DynamicData('2', 60, Colors.teal),
        _DynamicData('3', 35, Colors.blue),
        _DynamicData('4', 12, Colors.orange),
        _DynamicData('5', 65, Colors.pink),
        _DynamicData('6', 40, Colors.brown[300]),
      ];
      count = 0;
    }
    if (timer != null) {
      timer.cancel();
    }
    return chartData;
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
    // _selectedseriesType = _seriesTypes.first;
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

SfCartesianChart getDynamicAnimationChart(bool isTileView,
    [String _selectedType]) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        interval: 20,
        maximum: 80,
        majorTickLines: MajorTickLines(size: 0)),
    series: getAnimationData(isTileView, isTileView ? 'Column' : _selectedType),
  );
}

List<ChartSeries<_DynamicData, String>> getAnimationData(
    bool isTileView, String _selectedseriesType) {
  if (_selectedseriesType == 'Line') {
    return <LineSeries<_DynamicData, String>>[
      LineSeries<_DynamicData, String>(
        dataSource: chartData,
         color: const Color.fromRGBO(0, 168, 181, 1),
        width: 2,
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
      )
    ];
  } else if (_selectedseriesType == 'Column') {
    return <ColumnSeries<_DynamicData, String>>[
      ColumnSeries<_DynamicData, String>(
        dataSource: chartData,
         color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      )
    ];
  } else if (_selectedseriesType == 'Spline') {
    return <SplineSeries<_DynamicData, String>>[
      SplineSeries<_DynamicData, String>(
        dataSource: chartData,
         color: const Color.fromRGBO(0, 168, 181, 1),
        width: 2,
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
      )
    ];
  } else if (_selectedseriesType == 'Area') {
    return <AreaSeries<_DynamicData, String>>[
      AreaSeries<_DynamicData, String>(
        dataSource: chartData,
         color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'StepLine') {
    return <StepLineSeries<_DynamicData, String>>[
      StepLineSeries<_DynamicData, String>(
        dataSource: chartData,
        width: 2,
         color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Bar') {
    return <BarSeries<_DynamicData, String>>[
      BarSeries<_DynamicData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Scatter') {
    return <ScatterSeries<_DynamicData, String>>[
      ScatterSeries<_DynamicData, String>(
        dataSource: chartData,
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        color: const Color.fromRGBO(0, 168, 181, 1),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 10,
            width: 10,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Bubble') {
    return <BubbleSeries<_DynamicData, String>>[
      BubbleSeries<_DynamicData, String>(
        dataSource: chartData,
         color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (_DynamicData sales, _) => sales.country,
        yValueMapper: (_DynamicData sales, _) => sales.sales,
        sizeValueMapper: (_DynamicData sales, _) => sales.sales,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  }

  return null;
}

class _DynamicData {
  _DynamicData(this.country, this.sales, this.pointColor);
  final String country;
  final double sales;
  final Color pointColor;
}
