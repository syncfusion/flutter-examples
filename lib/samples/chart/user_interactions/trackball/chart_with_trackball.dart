import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore:must_be_immutable
class DefaultTrackball extends StatefulWidget {
  DefaultTrackball({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DefaultTrackballState createState() => _DefaultTrackballState(sample);
}

class _DefaultTrackballState extends State<DefaultTrackball> {
  _DefaultTrackballState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, TrackballFrontPanel(sample));
  }
}

SfCartesianChart getDefaultTrackballChart(bool isTileView,
    [TrackballDisplayMode _mode,
    ChartAlignment _alignment,
    bool showAlways,
    double duration,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Average sales per person'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        minimum: DateTime(2000, 2, 11),
        maximum: DateTime(2006, 2, 11),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Revenue'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0)),
    series: getDefaultTrackballSeries(isTileView),
    trackballBehavior: TrackballBehavior(
      enable: true,
      hideDelay:
          ((isExistModel ? model.properties['TrackballDuration'] : duration) ??
                  2.0) *
              1000,
      lineType: TrackballLineType.vertical,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: _alignment,
      tooltipDisplayMode:
          isExistModel ? model.properties['TrackballDisplayMode'] : _mode,
      tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
      shouldAlwaysShow: isTileView
          ? true
          : ((isExistModel
                  ? model.properties['TrackballAlwaysShow']
                  : showAlways) ??
              true),
    ),
  );
}

List<LineSeries<ChartSampleData, DateTime>> getDefaultTrackballSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2000, 2, 11), y: 15, yValue2: 39, yValue3: 60),
    ChartSampleData(x: DateTime(2000, 9, 14), y: 20, yValue2: 30, yValue3: 55),
    ChartSampleData(x: DateTime(2001, 2, 11), y: 25, yValue2: 28, yValue3: 48),
    ChartSampleData(x: DateTime(2001, 9, 16), y: 21, yValue2: 35, yValue3: 57),
    ChartSampleData(x: DateTime(2002, 2, 7), y: 13, yValue2: 39, yValue3: 62),
    ChartSampleData(x: DateTime(2002, 9, 7), y: 18, yValue2: 41, yValue3: 64),
    ChartSampleData(x: DateTime(2003, 2, 11), y: 24, yValue2: 45, yValue3: 57),
    ChartSampleData(x: DateTime(2003, 9, 14), y: 23, yValue2: 48, yValue3: 53),
    ChartSampleData(x: DateTime(2004, 2, 6), y: 19, yValue2: 54, yValue3: 63),
    ChartSampleData(x: DateTime(2004, 9, 6), y: 31, yValue2: 55, yValue3: 50),
    ChartSampleData(x: DateTime(2005, 2, 11), y: 39, yValue2: 57, yValue3: 66),
    ChartSampleData(x: DateTime(2005, 9, 11), y: 50, yValue2: 60, yValue3: 65),
    ChartSampleData(x: DateTime(2006, 2, 11), y: 24, yValue2: 60, yValue3: 79),
  ];
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        name: 'John',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        name: 'Andrew',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Thomas',
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

//ignore: must_be_immutable
class TrackballFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TrackballFrontPanel([this.sample]);
  SubItem sample;

  @override
  _TrackballFrontPanelState createState() => _TrackballFrontPanelState(sample);
}

class _TrackballFrontPanelState extends State<TrackballFrontPanel> {
  _TrackballFrontPanelState(this.sample);
  final SubItem sample;
  double duration = 2;
  bool showAlways = false;
  final List<String> _modeList =
      <String>['floatAllPoints', 'groupAllPoints', 'nearestPoint'].toList();
  String _selectedMode = 'floatAllPoints';

  TrackballDisplayMode _mode = TrackballDisplayMode.floatAllPoints;

  final List<String> _alignmentList =
      <String>['center', 'far', 'near'].toList();
  String _tooltipAlignment = 'center';

  ChartAlignment _alignment = ChartAlignment.center;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getDefaultTrackballChart(false, null, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    duration = 2;
    showAlways = false;
    _selectedMode = 'floatAllPoints';
    _mode = TrackballDisplayMode.floatAllPoints;
    _tooltipAlignment = 'center';
    _alignment = ChartAlignment.center;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'TrackballDuration': duration,
        'SelectedTrackballDisplayMode': _selectedMode,
        'TrackballDisplayMode': _mode,
        'TrackballAlwaysShow': showAlways,
        'SelectedTrackballAlignmentType': _tooltipAlignment,
        'TrackballAlignmentType': _alignment,
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
                          child: getDefaultTrackballChart(
                              false, _mode, _alignment, showAlways, duration)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getDefaultTrackballChart(
                              false, null, null, null, null, model)),
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
                      Text('Mode     ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 50,
                          width: 145,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: DropDown(
                                  value: model.properties[
                                      'SelectedTrackballDisplayMode'],
                                  item: _modeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null)
                                            ? value
                                            : 'floatAllPoints',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    onModeTypeChange(value.toString(), model);
                                  }),
                            ),
                          )),
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Text('Alignment',
                  //         style: TextStyle(
                  //             color:  model.textColor,
                  //             fontSize: 14,
                  //             letterSpacing: 0.34,
                  //             fontWeight: FontWeight.normal)),
                  //     Container(
                  //         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  //         height: 50,
                  //         width: 135,
                  //         child: Align(
                  //           alignment: Alignment.bottomCenter,
                  //           child: Theme(
                  //             data: Theme.of(context).copyWith(
                  //                 canvasColor:
                  //                     model.bottomSheetBackgroundColor),
                  //             child: DropDown(
                  //                 value: model.properties[
                  //                     'SelectedTrackballAlignmentType'],
                  //                 item: _alignmentList.map((String value) {
                  //                         return DropdownMenuItem<String>(
                  //                             value: (value != null)
                  //                                 ? value
                  //                                 : 'center',
                  //                             child: Text('$value',
                  //                                 style: TextStyle(
                  //                                     color: model.textColor)));
                  //                       }).toList(),
                  //                 valueChanged: (dynamic value) {
                  //                   onModeTypeChange(value.toString(), model);
                  //                 }),
                  //           ),
                  //         )),
                  //   ],
                  // ),
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
                          switchValue: model.properties['TrackballAlwaysShow'],
                          valueChanged: (dynamic value) {
                            model.properties['TrackballAlwaysShow'] = value;
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
                          initialValue: model.properties['TrackballDuration'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['TrackballDuration'] = val;
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
                                            Text('Mode ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      100, 0, 0, 0),
                                              height: 50,
                                              width: 280,
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            canvasColor: model
                                                                .bottomSheetBackgroundColor),
                                                    child: DropDown(
                                                        value: _selectedMode,
                                                        item: _modeList.map(
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      70, 0, 0, 0),
                                              height: 50,
                                              width: 150,
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            canvasColor: model
                                                                .bottomSheetBackgroundColor),
                                                    child: DropDown(
                                                        value:
                                                            _tooltipAlignment,
                                                        item: _selectedMode !=
                                                                'groupAllPoints'
                                                            ? null
                                                            : _alignmentList
                                                                .map((String
                                                                    value) {
                                                                return DropdownMenuItem<
                                                                        String>(
                                                                    value: (value !=
                                                                            null)
                                                                        ? value
                                                                        : 'center',
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
                                              activeColor:
                                                  model.backgroundColor,
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

  void onModeTypeChange(String item, SampleModel model) {
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
    model.properties['SelectedTrackballDisplayMode'] = _selectedMode;
    model.properties['TrackballDisplayMode'] = _mode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  void onAlignmentChange(String item, SampleModel model) {
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
    model.properties['SelectedTrackballAlignmentType'] = _tooltipAlignment;
    model.properties['TrackballAlignmentType'] = _alignment;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }
}
