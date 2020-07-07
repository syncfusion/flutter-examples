import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class LegendOptions extends StatefulWidget {
  LegendOptions({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LegendOptionsState createState() => _LegendOptionsState(sample);
}

class _LegendOptionsState extends State<LegendOptions> {
  _LegendOptionsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, LegendWithOptionsFrontPanel(sample));
  }
}

SfCircularChart getLegendOptionsChart(bool isTileView,
    [LegendPosition _position,
    LegendItemOverflowMode _overflowMode,
    dynamic toggleVisibility,
    SampleModel sampleModel]) {
  final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Expenses by category'),
    legend: Legend(
        isVisible: true,
        position: isExistModel ? sampleModel.properties['Position'] : _position,
        overflowMode: isExistModel
            ? sampleModel.properties['OverflowMode']
            : _overflowMode,
        toggleSeriesVisibility: isExistModel
            ? sampleModel.properties['ToggleVisibility']
            : toggleVisibility),
    series: getLegendOptionsSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<PieSeries<ChartSampleData, String>> getLegendOptionsSeries(
    bool isTileView) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Tution Fees', y: 21),
    ChartSampleData(x: 'Entertainment', y: 21),
    ChartSampleData(x: 'Private Gifts', y: 8),
    ChartSampleData(x: 'Local Revenue', y: 21),
    ChartSampleData(x: 'Federal Revenue', y: 16),
    ChartSampleData(x: 'Others', y: 8)
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: DataLabelSettings(isVisible: true)),
  ];
}

//ignore: must_be_immutable
class LegendWithOptionsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  LegendWithOptionsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _LegendWithOptionsFrontPanelState createState() =>
      _LegendWithOptionsFrontPanelState(sample);
}

class _LegendWithOptionsFrontPanelState
    extends State<LegendWithOptionsFrontPanel> {
  _LegendWithOptionsFrontPanelState(this.sample);
  final SubItem sample;
  bool toggleVisibility = true;
  final List<String> _positionList =
      <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
  String _selectedPosition = 'auto';
  LegendPosition _position = LegendPosition.auto;

  final List<String> _modeList = <String>['wrap', 'scroll', 'none'].toList();
  String _selectedMode = 'wrap';

  LegendItemOverflowMode _overflowMode = LegendItemOverflowMode.wrap;
  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getLegendOptionsChart(false, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    toggleVisibility = true;
    _selectedPosition = 'auto';
    _position = LegendPosition.auto;
    _selectedMode = 'wrap';
    _overflowMode = LegendItemOverflowMode.wrap;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedPosition': _selectedPosition,
        'Position': _position,
        'SelectedMode': _selectedMode,
        'OverflowMode': _overflowMode,
        'ToggleVisibility': toggleVisibility
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                          child: getLegendOptionsChart(false, _position,
                              _overflowMode, toggleVisibility, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getLegendOptionsChart(
                              false, null, null, null, null)),
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
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
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
                      style: TextStyle(
                          fontFamily: 'Roboto-Medium',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    HandCursor(
                        child: IconButton(
                      icon: Icon(Icons.close, color: model.webIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Position ',
                        style: TextStyle(
                            color: model.textColor,
                            fontSize: 14,
                            letterSpacing: 0.34,
                            fontWeight: FontWeight.normal)),
                    Container(
                      padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
                      height: 50,
                      width: 200,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: model.properties['SelectedPosition'],
                                item: _positionList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'auto',
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onPositionTypeChange(value.toString(), model);
                                })),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Overflow mode',
                        style: TextStyle(
                            color: model.textColor,
                            fontSize: 14,
                            letterSpacing: 0.34,
                            fontWeight: FontWeight.normal)),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      height: 50,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: model.properties['SelectedMode'],
                                item: _modeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'wrap',
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onModeTypeChange(value, model);
                                })),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Toggle visibility ',
                        style: TextStyle(
                            color: model.textColor,
                            fontSize: 14,
                            letterSpacing: 0.34,
                            fontWeight: FontWeight.normal)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BottomSheetCheckbox(
                        activeColor: model.properties['ToggleVisibility'],
                        switchValue: toggleVisibility,
                        valueChanged: (dynamic value) {
                          model.properties['ToggleVisibility'] = value;
                          model.sampleOutputContainer.outputKey.currentState
                              .refresh();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 20.0,
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
                                            Text('Position    ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      75, 0, 0, 0),
                                              height: 50,
                                              width: 200,
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
                                                            _selectedPosition,
                                                        item: _positionList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
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
                                                              value.toString(),
                                                              model);
                                                        })),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Overflow mode',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Container(
                                              height: 50,
                                              width: 200,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
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
                                                                  : 'wrap',
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
                                            Text('Toggle visibility   ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: BottomSheetCheckbox(
                                                activeColor:
                                                    model.backgroundColor,
                                                switchValue: toggleVisibility,
                                                valueChanged: (dynamic value) {
                                                  setState(() {
                                                    toggleVisibility = value;
                                                  });
                                                },
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

  void onPositionTypeChange(String item, SampleModel model) {
    // setState(() {
    _selectedPosition = item;
    if (_selectedPosition == 'auto') {
      _position = LegendPosition.auto;
    }
    if (_selectedPosition == 'bottom') {
      _position = LegendPosition.bottom;
    }
    if (_selectedPosition == 'right') {
      _position = LegendPosition.right;
    }
    if (_selectedPosition == 'left') {
      _position = LegendPosition.left;
    }
    if (_selectedPosition == 'top') {
      _position = LegendPosition.top;
    }
    model.properties['SelectedPosition'] = _selectedPosition;
    model.properties['Position'] = _position;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {
        // ignore: invalid_use_of_protected_member
        model.notifyListeners();
      });
    // });
  }

  void onModeTypeChange(String item, SampleModel model) {
    // setState(() {
    _selectedMode = item;
    if (_selectedMode == 'wrap') {
      _overflowMode = LegendItemOverflowMode.wrap;
    }
    if (_selectedMode == 'scroll') {
      _overflowMode = LegendItemOverflowMode.scroll;
    }
    if (_selectedMode == 'none') {
      _overflowMode = LegendItemOverflowMode.none;
    }
    model.properties['SelectedMode'] = _selectedMode;
    model.properties['OverflowMode'] = _overflowMode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {
        // ignore: invalid_use_of_protected_member
        model.notifyListeners();
      });
    // });
  }
}
