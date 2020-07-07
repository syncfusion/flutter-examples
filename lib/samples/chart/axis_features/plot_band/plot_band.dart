import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class PlotBandDefault extends StatefulWidget {
  PlotBandDefault({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _PlotBandDefaultState createState() => _PlotBandDefaultState(sample);
}

class _PlotBandDefaultState extends State<PlotBandDefault> {
  _PlotBandDefaultState(this.sample);

  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, PlotBandFrontPanel(sample));
  }
}

SfCartesianChart getPlotBandChart(bool isTileView,
    [bool isHorizontal,
    bool isVertical,
    bool isSegment,
    SampleModel sampleModel]) {
  final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  if (isExistModel) {
    final String type = sampleModel.properties['PlotBandType'];
    isHorizontal = type == 'horizontal';
    isVertical = type == 'vertical';
    isSegment = type == 'segment';
  }
  if(isExistModel && !isHorizontal && !isSegment && !isVertical){
    isVertical = true;
  }
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
        ],
        majorGridLines: MajorGridLines(width: 0)),
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
            textStyle:
                ChartTextStyle(color: const Color.fromRGBO(255, 255, 255, 1))),
        PlotBand(
            isVisible: isTileView ? false : isVertical,
            start: 20,
            end: 30,
            text: 'Average Temperature',
            shouldRenderAboveSeries: false,
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle:
                ChartTextStyle(color: const Color.fromRGBO(255, 255, 255, 1))),
        PlotBand(
            isVisible: isTileView ? false : isVertical,
            start: 10,
            end: 20,
            text: 'Low Temperature',
            shouldRenderAboveSeries: false,
            color: const Color.fromRGBO(237, 195, 12, 1))
      ],
    ),
    series: _getPlotBandSeries(isTileView, isSegment),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<XyDataSeries<ChartSampleData, dynamic>> _getPlotBandSeries(bool isTileView,
    [bool isSegment]) {
  isSegment ??= false;
  final dynamic lineData = <ChartSampleData>[
    ChartSampleData(xValue: 'Jan', yValue: 23),
    ChartSampleData(xValue: 'Feb', yValue: 24),
    ChartSampleData(xValue: 'Mar', yValue: 23),
    ChartSampleData(xValue: 'Apr', yValue: 22),
    ChartSampleData(xValue: 'May', yValue: 21),
    ChartSampleData(xValue: 'Jun', yValue: 27),
    ChartSampleData(xValue: 'Jul', yValue: 33),
    ChartSampleData(xValue: 'Aug', yValue: 36),
    ChartSampleData(xValue: 'Sep', yValue: 23),
    ChartSampleData(xValue: 'Oct', yValue: 25),
    ChartSampleData(xValue: 'Nov', yValue: 22),
    // ChartSampleData(xValue: 'Dec', yValue: 23),
  ];
  return <XyDataSeries<ChartSampleData, dynamic>>[
    LineSeries<ChartSampleData, dynamic>(
        dataSource: lineData,
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
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

//ignore: must_be_immutable
class PlotBandFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  PlotBandFrontPanel([this.sample]);

  SubItem sample;

  @override
  _PlotBandFrontPanelState createState() => _PlotBandFrontPanelState(sample);
}

class _PlotBandFrontPanelState extends State<PlotBandFrontPanel> {
  _PlotBandFrontPanelState(this.sample);

  final SubItem sample;

  final List<String> _plotBandType =
      <String>['horizontal', 'vertical',  'segment'].toList();
  bool isHorizontal = true;
  bool isVertical = false;
  bool isSegment = false;

  String _selectedType;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getPlotBandChart(false, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedType = _plotBandType.first;
    isHorizontal = true;
    isVertical = false;
    isSegment = false;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedPlotBandType': _selectedType,
        'PlotBandType': 'horizontal'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                      child: Container(
                          child: getPlotBandChart(
                              false, isHorizontal, isVertical, isSegment)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child:
                              getPlotBandChart(false, null, null, null, model)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              _showSettingsPanel(model, false, context);
                            },
                            child: Icon(Icons.graphic_eq, color: Colors.white),
                            backgroundColor: model.backgroundColor,
                          ),
                        ),
                      ],
                    ));
        });
  }

  void onPlotBandModeChange(String item, SampleModel model) {
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
    model.properties['SelectedPlotBandType'] = _selectedType;
    model.properties['PlotBandType'] =
        isHorizontal ? 'horizontal' : isVertical ? 'vertical' : 'segment';
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Properties',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    HandCursor(
                        child: IconButton(
                      icon: Icon(Icons.close, color: model.textColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Plot band type',
                        style: TextStyle(
                            color: model.textColor,
                            fontSize: 14,
                            letterSpacing: 0.34,
                            fontWeight: FontWeight.normal)),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        height: 50,
                        width: 120,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: model.properties['SelectedPlotBandType'],
                                item: _plotBandType.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value:
                                          (value != null) ? value : 'horizontal',
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onPlotBandModeChange(value.toString(), model);
                                }),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ));
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 12.0,
          color: model.bottomSheetBackgroundColor,
          builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
              rebuildOnChange: false,
              builder: (BuildContext context, _, SampleModel model) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                      height: 120,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * height,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 5),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 50, 0, 0),
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
                                                          item: _plotBandType
                                                              .map((String
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: (value !=
                                                                        null)
                                                                    ? value
                                                                    : 'horizontal',
                                                                child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        color: model
                                                                            .textColor)));
                                                          }).toList(),
                                                          valueChanged:
                                                              (dynamic value) {
                                                            onPlotBandModeChange(
                                                                value
                                                                    .toString(),
                                                                model);
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
    return widget ?? Container();
  }
}
