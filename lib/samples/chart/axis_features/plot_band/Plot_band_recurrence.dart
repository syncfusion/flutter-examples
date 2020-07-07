import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:intl/intl.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class PlotBandRecurrence extends StatefulWidget {
  PlotBandRecurrence({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _PlotBandRecurrenceState createState() => _PlotBandRecurrenceState(sample);
}

class _PlotBandRecurrenceState extends State<PlotBandRecurrence> {
  _PlotBandRecurrenceState(this.sample);

  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, PlotBandRecurrenceFrontPanel(sample));
  }
}

SfCartesianChart getPlotBandRecurrenceChart(bool isTileView,
    [bool xVisible, bool yVisible, SampleModel sampleModel]) {
  final bool isExistModel = sampleModel != null && sampleModel.isWeb;
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
              isVisible: (isExistModel
                      ? sampleModel.properties['XAxisRecurrence']
                      : xVisible) ??
                  false,
              repeatEvery: 10,
              sizeType: DateTimeIntervalType.years,
              size: (isExistModel && sampleModel.isWeb) ? 3: 5,
              repeatUntil: DateTime(2010, 1, 1),
              start: DateTime(1965, 1, 1),
              end: DateTime(2010, 1, 1),
              shouldRenderAboveSeries: false,
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
              isVisible: (isExistModel
                      ? sampleModel.properties['YAxisRecurrence']
                      : yVisible) ??
                  true,
              repeatEvery: 4000,
              size: 2000,
              start: 0,
              end: 18000,
              repeatUntil: 18000,
              shouldRenderAboveSeries: false,
              color: const Color.fromRGBO(227, 228, 230, 0.1))
        ],
        majorGridLines: MajorGridLines(color: Colors.grey),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
        labelStyle: ChartTextStyle(fontSize: 0)),
    series: _getPlotBandRecurrenceSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<ColumnSeries<ChartSampleData, DateTime>> _getPlotBandRecurrenceSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(1980, 1, 1), y: 15400, yValue: 6400),
    ChartSampleData(x: DateTime(1985, 1, 1), y: 15800, yValue: 3700),
    ChartSampleData(x: DateTime(1990, 1, 1), y: 14000, yValue: 7200),
    ChartSampleData(x: DateTime(1995, 1, 1), y: 10500, yValue: 2300),
    ChartSampleData(x: DateTime(2000, 1, 1), y: 13300, yValue: 4000),
    ChartSampleData(x: DateTime(2005, 1, 1), y: 12800, yValue: 4800)
  ];
  return <ColumnSeries<ChartSampleData, DateTime>>[
    ColumnSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      name: 'All sources',
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
    ColumnSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      name: 'Autos & Light Trucks',
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue,
    )
  ];
}

//ignore: must_be_immutable
class PlotBandRecurrenceFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  PlotBandRecurrenceFrontPanel([this.sample]);

  SubItem sample;

  @override
  _PlotBandRecurrenceFrontPanelState createState() =>
      _PlotBandRecurrenceFrontPanelState(sample);
}

class _PlotBandRecurrenceFrontPanelState
    extends State<PlotBandRecurrenceFrontPanel> {
  _PlotBandRecurrenceFrontPanelState(this.sample);
  final SubItem sample;
  bool xAxis = false, yAxis = true;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getPlotBandRecurrenceChart(false, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    xAxis = false;
    yAxis = true;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'XAxisRecurrence': xAxis,
        'YAxisRecurrence': yAxis
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
                          child:
                              getPlotBandRecurrenceChart(false, xAxis, yAxis)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getPlotBandRecurrenceChart(
                              false, null, null, model)),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model, false, context);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
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
                      icon: Icon(Icons.close, color: model.webIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('X Axis',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['XAxisRecurrence'],
                          valueChanged: (dynamic value) {
                            model.properties['XAxisRecurrence'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Y Axis',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['YAxisRecurrence'],
                          valueChanged: (dynamic value) {
                            model.properties['YAxisRecurrence'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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
                      height: 180,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * height,
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
    return widget ?? Container();
  }
}
