import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/bottom_sheet.dart';
import '../../../../widgets/customDropDown.dart';

class PlotBandDefault extends StatefulWidget {
  const PlotBandDefault(this.sample, {Key key}) : super(key: key);

  final SubItemList sample;

  @override
  _PlotBandDefaultState createState() => _PlotBandDefaultState(sample);
}

class _PlotBandDefaultState extends State<PlotBandDefault> {
  _PlotBandDefaultState(this.sample);

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
  void didUpdateWidget(PlotBandDefault oldWidget) {
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
                toggleFrontLayer: false,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/plot_band/plot_band.dart');
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
  final List<String> _plotBandType =
      <String>['vertical', 'horizontal', 'segment'].toList();
  bool isHorizontal = true;
  bool isVertical = false;
  bool isSegment = false;

  String _selectedType;
  @override
  void initState() {
    super.initState();
    _selectedType = _plotBandType.first;
    isHorizontal = true;
    isVertical = false;
    isSegment = false;
  }

  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _,SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                child: Container(
                    child: getPlotBandChart(
                        false, isHorizontal, isVertical, isSegment)),
              ),
              floatingActionButton: Stack(
                children: <Widget>[
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

  void onEmptyPointModeChange(String item) {
    setState(() {
      _selectedType = item;
      if (_selectedType == 'horizontal') {
        isVertical = true;
        isHorizontal = false;
        isSegment = false;
      }
      if (_selectedType == 'vertical') {
        isHorizontal = true;
        isVertical = false;
        isSegment = false;
      }
      if (_selectedType == 'segment') {
        isHorizontal = false;
        isVertical = false;
        isSegment = true;
      }
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                    height: 120,
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
                                    child: ListView(children: <Widget>[
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Plot band type',
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
                                                        value: _selectedType,
                                                        item: _plotBandType.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'gap',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onEmptyPointModeChange(
                                                              value.toString());
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                ]))))))));
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

SfCartesianChart getPlotBandChart(bool isTileView,
    [bool isHorizontal, bool isVertical, bool isSegment]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Weather report'),
    legend: Legend(isVisible: false),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
        interval: 1,
        plotBands: <PlotBand>[
          PlotBand(
              isVisible: isTileView ? true : isHorizontal,
              start: -0.5,
              end: 1.5,
              text: 'Winter',
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.black, fontSize: 13),
              color: const Color.fromRGBO(101, 199, 209, 1)),
          PlotBand(
              isVisible: isTileView ? true : isHorizontal,
              start: 4.5,
              end: 7.5,
              text: 'Summer',
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.black, fontSize: 13),
              color: const Color.fromRGBO(254, 213, 2, 1)),
          PlotBand(
              isVisible: isTileView ? true : isHorizontal,
              start: 1.5,
              end: 4.5,
              text: 'Spring',
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.black, fontSize: 13),
              color: const Color.fromRGBO(140, 198, 62, 1)),
          PlotBand(
              isVisible: isTileView ? true : isHorizontal,
              start: 7.5,
              end: 9.5,
              text: 'Autumn',
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.black, fontSize: 13),
              color: const Color.fromRGBO(217, 112, 1, 1)),
          PlotBand(
              isVisible: isTileView ? true : isHorizontal,
              start: 9.5,
              end: 10.5,
              text: 'Winter',
              textStyle: ChartTextStyle(color: Colors.black, fontSize: 13),
              shouldRenderAboveSeries: false,
              color: const Color.fromRGBO(101, 199, 209, 1)),
          PlotBand(
              size: 2,
              start: -0.5,
              end: 4.5,
              textAngle: 0,
              associatedAxisStart: 20.5,
              text: 'Average',
              associatedAxisEnd: 27.5,
              isVisible: isTileView ? false : isSegment,
              color: const Color.fromRGBO(224, 155, 0, 1),
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.white, fontSize: 17)),
          PlotBand(
              start: 7.5,
              end: 10.5,
              size: 3,
              associatedAxisStart: 20.5,
              text: 'Average',
              associatedAxisEnd: 27.5,
              textAngle: 0,
              isVisible: isTileView ? false : isSegment,
              color: const Color.fromRGBO(224, 155, 0, 1),
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.white, fontSize: 17)),
          PlotBand(
              start: 4.5,
              end: 7.5,
              size: 2,
              associatedAxisStart: 32.5,
              text: 'High',
              associatedAxisEnd: 37.5,
              textAngle: 0,
              isVisible: isTileView ? false : isSegment,
              color: const Color.fromRGBO(207, 85, 7, 1),
              shouldRenderAboveSeries: false,
              textStyle: ChartTextStyle(color: Colors.white, fontSize: 17)),
        ], majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
      minimum: 10,
      maximum: 40,
      interval: 5,
      labelFormat: '{value} °C',
      rangePadding: ChartRangePadding.none,
      plotBands: <PlotBand>[
        PlotBand(
            isVisible: isTileView ? false : isVertical,
            start: 30,
            end: 40,
            text: 'High Temperature',
            shouldRenderAboveSeries: false,
            color: const Color.fromRGBO(207, 85, 7, 1),
            textStyle: ChartTextStyle(color:const Color.fromRGBO(255, 255, 255, 1))),
        PlotBand(
            isVisible: isTileView ? false : isVertical,
            start: 20,
            end: 30,
            text: 'Average Temperature',
            shouldRenderAboveSeries: false,
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle: ChartTextStyle(color:const Color.fromRGBO(255, 255, 255, 1))),
        PlotBand(
            isVisible: isTileView ? false : isVertical,
            start: 10,
            end: 20,
            text: 'Low Temperature',
            shouldRenderAboveSeries: false,
            color: const Color.fromRGBO(237, 195, 12, 1))
      ],
    ),
    series: _getColumnSeries(isTileView, isSegment),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<XyDataSeries<_ColumnData, dynamic>> _getColumnSeries(bool isTileView,
    [bool isSegment]) {
  final dynamic lineData = <_ColumnData>[
    _ColumnData(xValue: 'Jan', yValue: 23),
    _ColumnData(xValue: 'Feb', yValue: 24),
    _ColumnData(xValue: 'Mar', yValue: 23),
    _ColumnData(xValue: 'Apr', yValue: 22),
    _ColumnData(xValue: 'May', yValue: 21),
    _ColumnData(xValue: 'Jun', yValue: 27),
    _ColumnData(xValue: 'Jul', yValue: 33),
    _ColumnData(xValue: 'Aug', yValue: 36),
    _ColumnData(xValue: 'Sep', yValue: 23),
    _ColumnData(xValue: 'Oct', yValue: 25),
    _ColumnData(xValue: 'Nov', yValue: 22),
    // _ColumnData(xValue: 'Dec', yValue: 23),
  ];
  return <XyDataSeries<_ColumnData, dynamic>>[
    LineSeries<_ColumnData, dynamic>(
        dataSource: lineData,
        xValueMapper: (_ColumnData sales, _) => sales.xValue,
        yValueMapper: (_ColumnData sales, _) => sales.yValue,
        color:
            isTileView ? Colors.white : isSegment ? Colors.black : Colors.white,
        name: 'Weather',
        markerSettings: MarkerSettings(
            isVisible: true,
            borderColor: Colors.white,
            borderWidth: 2,
            color: const Color.fromRGBO(102, 102, 102, 1)))
  ];
}

class _ColumnData {
  _ColumnData({this.xValue, this.yValue});
  final String xValue;
  final num yValue;
}
