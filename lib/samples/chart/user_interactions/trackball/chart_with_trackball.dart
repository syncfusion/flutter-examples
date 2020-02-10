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

double duration = 2;

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
    [TrackballDisplayMode _mode, ChartAlignment _alignment, bool showAlways]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Average sales per person'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
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
        hideDelay: duration * 1000,
        lineType: TrackballLineType.vertical,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _alignment,
        tooltipDisplayMode: _mode,
        tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
        shouldAlwaysShow: isTileView ? true : showAlways),
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

class TrackballFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TrackballFrontPanel(this.subItemList);
  final SubItem subItemList;

  @override
  _TrackballFrontPanelState createState() =>
      _TrackballFrontPanelState(subItemList);
}

class _TrackballFrontPanelState extends State<TrackballFrontPanel> {
  _TrackballFrontPanelState(this.sample);
  final SubItem sample;
  bool showAlways = false;
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
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
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

  void onModeTypeChange(String item, SampleModel model) {
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

  void onAlignmentChange(String item, SampleModel model) {
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
