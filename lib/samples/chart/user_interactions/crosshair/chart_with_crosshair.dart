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

double duration = 2;

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
    [bool alwaysShow, CrosshairLineType lineType, dynamic randomData]) {
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
        hideDelay: duration * 1000,
        lineWidth: 1,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: isTileView ? true : alwaysShow,
        lineType: isTileView ? CrosshairLineType.both : lineType),
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

class CrosshairFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  CrosshairFrontPanel(this.subItemList);
  final SubItem subItemList;

  @override
  _CrosshairFrontPanelState createState() =>
      _CrosshairFrontPanelState(subItemList);
}

class _CrosshairFrontPanelState extends State<CrosshairFrontPanel> {
  _CrosshairFrontPanelState(this.sample);
  final SubItem sample;
  bool alwaysShow = false;
  final List<String> _lineTypeList =
      <String>['both', 'vertical', 'horizontal'].toList();
  String _selectedLineType = 'both';
  CrosshairLineType _lineType = CrosshairLineType.both;
  dynamic randomData;
  @override
  void initState() {
    super.initState();
    randomData = getDatatTimeData();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getDefaultCrossHairChart(
                        false, alwaysShow, _lineType, randomData)),
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

  void _showSettingsPanel(SampleModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
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
                                          Text('Line type        ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            height: 50,
                                            width: 150,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _selectedLineType,
                                                      item: _lineTypeList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value:
                                                                (value != null)
                                                                    ? value
                                                                    : 'auto',
                                                            child: Text(
                                                                '$value',
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onPositionTypeChange(
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
                                            activeColor: model.backgroundColor,
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
                                                iconUp: Icons.keyboard_arrow_up,
                                                iconDown:
                                                    Icons.keyboard_arrow_down,
                                                iconLeft:
                                                    Icons.keyboard_arrow_left,
                                                iconRight:
                                                    Icons.keyboard_arrow_right,
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

  void onPositionTypeChange(String item, SampleModel model) {
    setState(() {
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

      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
    });
  }
}
