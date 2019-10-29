import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AxisCrossing extends StatefulWidget {
  const AxisCrossing(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  @override
  _AxisCrossingState createState() => _AxisCrossingState(sample);
}

class _AxisCrossingState extends State<AxisCrossing> {
    _AxisCrossingState(this.sample);
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
  void didUpdateWidget(AxisCrossing oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
              child: Backdrop(
                frontHeaderHeight: 20,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/axis_crossing/axis_crossing.dart');
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
                color:model.cardThemeColor,
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
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();
   final List<String> _axis =
      <String>['X', 'Y'].toList();
  String _selectedAxisType = 'X';
  String _selectedAxis;
  double crossAt = 0;
  bool isPlaceLabelsNearAxisLine = true;
   @override
  void initState() {
    super.initState();
    crossAt = 0;
    _selectedAxis = 'X'; 
    // _selectedPyramidMode = PyramidMode.linear;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _,SampleListModel model) {
          return Scaffold(
             backgroundColor:model.cardThemeColor,
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(child: getAxisCrossingSample(false,_selectedAxisType, crossAt, isPlaceLabelsNearAxisLine)),
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
                        // child: InkWell(
                        //   onTap: () => launch(
                        //       'https://data.worldbank.org/indicator/sp.rur.totl.zs'),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text('Source: ',
                        //           style: TextStyle(
                        //               fontSize: 16, color: model.textColor)),
                        //       Text('data.worldbank.org',
                        //           style: TextStyle(
                        //               fontSize: 14, color: Colors.blue)),
                        //     ],
                        //   ),
                        // ),
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
                
                ]));
        });
  }
  void onPyramidModeChange(String item) {
    setState(() {
      _selectedAxis = item;
      if (_selectedAxis == 'X') {
        _selectedAxisType = 'X';
      }
      else if (_selectedAxis == 'Y') {
        _selectedAxisType = 'Y';
      }
    });
  }
    void _showSettingsPanel(SampleListModel model) {
   final  double height =
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
                    height: 170,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Axis  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
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
                                                        value: _selectedAxis,
                                                        item: _axis
                                                            .map(
                                                                (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'X',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onPyramidModeChange(
                                                              value.toString());
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Cross At  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: -8,
                                                  maxValue: 8,
                                                  initialValue:
                                                      crossAt,
                                                  onChanged: (double val) =>
                                                      setState(() {
                                                        crossAt = val;
                                                      }),
                                                  step: 2,
                                                  horizontal: true,
                                                  loop: false,
                                                  padding: 0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
                                                  iconUpRightColor:
                                                      model.textColor,
                                                  iconDownLeftColor:
                                                      model.textColor,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: model.textColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
   Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Labels Near Axisline',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                                       const Padding(
                                                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                                                        ),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
                                              switchValue: isPlaceLabelsNearAxisLine,
                                              valueChanged: (dynamic value) {
                                                setState(() {
                                                  isPlaceLabelsNearAxisLine = value;
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
  final GlobalKey _globalKey = GlobalKey();

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

SfCartesianChart getAxisCrossingSample(bool isTileView,[String _selectedAxis, double _crossAt, bool isPlaceLabelsNearAxisLine]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Spline Interpolation'),
    legend:Legend(isVisible: !isTileView),
     primaryXAxis: NumericAxis(
                        minimum: -8,
                        maximum: 8,
                        interval: 2,
                        placeLabelsNearAxisLine: isTileView ? true : _selectedAxis == 'X' ? isPlaceLabelsNearAxisLine : true,
                        crossesAt: _selectedAxis == 'X' ? _crossAt: 0,
                        minorTicksPerInterval: 3),
                    primaryYAxis: NumericAxis(
                        minimum: -8,
                        maximum: 8,
                        interval: 2,
                        placeLabelsNearAxisLine: isTileView ? true : _selectedAxis == 'Y' ? isPlaceLabelsNearAxisLine : true,
                        crossesAt: _selectedAxis == 'Y' ? _crossAt: 0,
                        minorTicksPerInterval: 3),
    series: getSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ChartSeries<_ChartData, dynamic>> getSeries(bool isTileView) {
  final dynamic splineData = <_ChartData>[
      _ChartData( -7, -3),
      _ChartData( -4.5, -2),
      _ChartData( -3.5, 0),
      _ChartData( -3, 2),
      _ChartData( 0, 7),
      _ChartData( 3, 2),
      _ChartData( 3.5, 0),
      _ChartData( 4.5, -2),
      _ChartData( 7, -3),
    ];

 return <ChartSeries<_ChartData, dynamic>>[
      SplineSeries<_ChartData, dynamic>(
          dataSource: splineData,
          xValueMapper: (_ChartData sales, _) => sales.value1,
          yValueMapper: (_ChartData sales, _) => sales.value2,
          color: const Color.fromRGBO(20, 122, 20, 1),
          name: 'Cubic Interpolation',
          width: 2),
    ];
}

class _ChartData {
  _ChartData(this.value1, this.value2);
  final num value1;
  final num value2;
}
