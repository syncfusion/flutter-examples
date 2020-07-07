import 'dart:math';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore:must_be_immutable
class DefaultCrossHair extends StatefulWidget {
  DefaultCrossHair({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _DefaultCrossHairState createState() => _DefaultCrossHairState(sample);
}

class _DefaultCrossHairState extends State<DefaultCrossHair> {
  _DefaultCrossHairState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, CrosshairFrontPanel(sample));
  }
}

SfCartesianChart getDefaultCrossHairChart(bool isTileView,
    [bool alwaysShow,
    CrosshairLineType lineType,
    dynamic randomData,
    double duration,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  lineType = (isExistModel ? model.properties['CrosshairLineType'] : lineType) ?? CrosshairLineType.both;
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interactiveTooltip: InteractiveTooltip(
            enable: (isTileView ||
                    lineType == CrosshairLineType.both ||
                    lineType == CrosshairLineType.vertical)
                ? true
                : false)),
    crosshairBehavior: CrosshairBehavior(
        enable: true,
        hideDelay: ((isExistModel
                    ? model.properties['CrosshairDuration']
                    : duration) ??
                2.0) *
            1000,
        lineWidth: 1,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: isTileView
            ? true
            : ((isExistModel
                    ? model.properties['CrosshairAlwaysShow']
                    : alwaysShow) ??
                true),
        lineType: isTileView
            ? CrosshairLineType.both
            : lineType),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        interactiveTooltip: InteractiveTooltip(
            enable: (isTileView ||
                    lineType == CrosshairLineType.both ||
                    lineType == CrosshairLineType.horizontal)
                ? true
                : false),
        majorTickLines: MajorTickLines(width: 0)),
    series: getDefaultCrossHairSeries(isTileView, randomData),
  );
}

List<LineSeries<ChartSampleData, DateTime>> getDefaultCrossHairSeries(
    bool isTileView, dynamic randomData) {
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
        dataSource: isTileView ? getDatatTimeData() : randomData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2)
  ];
}

dynamic getDatatTimeData() {
  final List<ChartSampleData> randomData = <ChartSampleData>[];
  final Random rand = Random();
  double value = 100;
  for (int i = 1; i < 2000; i++) {
    if (rand.nextDouble() > 0.5)
      value += rand.nextDouble();
    else
      value -= rand.nextDouble();

    randomData.add(ChartSampleData(x: DateTime(1900, i, 1), y: value));
  }
  return randomData;
}

//ignore: must_be_immutable
class CrosshairFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  CrosshairFrontPanel([this.sample]);
  SubItem sample;

  @override
  _CrosshairFrontPanelState createState() => _CrosshairFrontPanelState(sample);
}

class _CrosshairFrontPanelState extends State<CrosshairFrontPanel> {
  _CrosshairFrontPanelState([this.sample]);
  final SubItem sample;
  bool alwaysShow = false;
  double duration = 2;
  final List<String> _lineTypeList =
      <String>['both', 'vertical', 'horizontal'].toList();
  String _selectedLineType = 'both';
  CrosshairLineType _lineType = CrosshairLineType.both;
  dynamic  randomData = getDatatTimeData();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getDefaultCrossHairChart(false, null, null, randomData,null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {   
    _selectedLineType = 'both';
    _lineType = CrosshairLineType.both;
    duration = 2;
    alwaysShow = true;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'CrosshairDuration': duration,
        'SelectedCrosshairLineType': _selectedLineType,
        'CrosshairLineType': _lineType,
        'CrosshairAlwaysShow': alwaysShow
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                      child: Container(
                          child: getDefaultCrossHairChart(false, alwaysShow,
                              _lineType, randomData, duration)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getDefaultCrossHairChart(
                              false, null, null, randomData, duration, model)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
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
    Widget widget;
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
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
                      Text('Line Type   ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 50,
                          width: 135,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: DropDown(
                                  value: model
                                      .properties['SelectedCrosshairLineType'],
                                  item: _lineTypeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null) ? value : 'both',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    onLineTypeChange(value.toString(), model);
                                  }),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Show Always',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['CrosshairAlwaysShow'],
                          valueChanged: (dynamic value) {
                            model.properties['CrosshairAlwaysShow'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Hide delay ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: 0,
                          maxValue: 10,
                          step: 2,
                          initialValue: model.properties['CrosshairDuration'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['CrosshairDuration'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          loop: false,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
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
                    height: 170,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height *
                              (model.isWeb ? 0.5 : height),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                            child: Stack(
                              children: <Widget>[
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
                                            Text('Line type        ',
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
                                                        value:
                                                            _selectedLineType,
                                                        item: _lineTypeList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'both',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onLineTypeChange(
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
                                            Text('Show always  ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
                                              switchValue: alwaysShow,
                                              valueChanged: (dynamic value) {
                                                setState(() {
                                                  alwaysShow = value;
                                                });
                                              },
                                            ),
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
                                            Text('Hide delay  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        40, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 0,
                                                  maxValue: 10,
                                                  initialValue: duration,
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    duration = val;
                                                  }),
                                                  step: 2,
                                                  horizontal: true,
                                                  loop: true,
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ))));
    }
    return widget ?? Container();
  }

  void onLineTypeChange(String item, SampleModel model) {
    _selectedLineType = item;
    if (_selectedLineType == 'both') {
      _lineType = CrosshairLineType.both;
    }
    if (_selectedLineType == 'horizontal') {
      _lineType = CrosshairLineType.horizontal;
    }
    if (_selectedLineType == 'vertical') {
      _lineType = CrosshairLineType.vertical;
    }
    model.properties['SelectedCrosshairLineType'] = _selectedLineType;
    model.properties['CrosshairLineType'] = _lineType;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }
}
