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
class CartesianLegendOptions extends StatefulWidget {
  CartesianLegendOptions({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _CartesianLegendOptionsState createState() =>
      _CartesianLegendOptionsState(sample);
}

class _CartesianLegendOptionsState extends State<CartesianLegendOptions> {
  _CartesianLegendOptionsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, CartesianLegendWithOptionsFrontPanel(sample));
  }
}

SfCartesianChart getCartesianLegendOptionsChart(bool isTileView,
    [LegendPosition _position,
    LegendItemOverflowMode _overflowMode,
    dynamic toggleVisibility,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Monthly expense of a family'),
    legend: Legend(
        isVisible: !isTileView,
        position: isExistModel ? model.properties['Position'] : _position,
        overflowMode:
            isExistModel ? model.properties['OverflowMode'] : _overflowMode,
        toggleSeriesVisibility: isExistModel
            ? model.properties['ToggleVisibility']
            : toggleVisibility),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
      labelRotation: isTileView ? 0 : -45,
    ),
    primaryYAxis: NumericAxis(
        // maximum: 200,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
        majorTickLines: MajorTickLines(size: 0)),
    series: _getStackedLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<StackedLineSeries<ChartSampleData, String>> _getStackedLineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'Food', y: 55, yValue: 40, yValue2: 45, yValue3: 48, size: 28),
    ChartSampleData(
        x: 'Transport', y: 33, yValue: 45, yValue2: 54, yValue3: 28, size: 35),
    ChartSampleData(
        x: 'Medical', y: 43, yValue: 23, yValue2: 20, yValue3: 34, size: 48),
    ChartSampleData(
        x: 'Clothes', y: 32, yValue: 54, yValue2: 23, yValue3: 54, size: 27),
    ChartSampleData(
        x: 'Books', y: 56, yValue: 18, yValue2: 43, yValue3: 55, size: 31),
    ChartSampleData(
        x: 'Others', y: 23, yValue: 54, yValue2: 33, yValue3: 56, size: 35),
  ];
  return <StackedLineSeries<ChartSampleData, String>>[
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Person 1',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Person 2',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Person 3',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Person 4',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.size,
        name: 'Person 5',
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

//ignore: must_be_immutable
class CartesianLegendWithOptionsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  CartesianLegendWithOptionsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _CartesianLegendWithOptionsFrontPanelState createState() =>
      _CartesianLegendWithOptionsFrontPanelState(sample);
}

class _CartesianLegendWithOptionsFrontPanelState
    extends State<CartesianLegendWithOptionsFrontPanel> {
  _CartesianLegendWithOptionsFrontPanelState(this.sample);
  final SubItem sample;
  bool toggleVisibility;
  final List<String> _positionList =
      <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
  String _selectedPosition;
  LegendPosition _position;

  final List<String> _modeList = <String>['wrap', 'scroll', 'none'].toList();
  String _selectedMode;

  LegendItemOverflowMode _overflowMode;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) =>
      getCartesianLegendOptionsChart(false, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedPosition = 'auto';
    _position = LegendPosition.auto;
    _selectedMode = 'wrap';
    _overflowMode = LegendItemOverflowMode.wrap;
    toggleVisibility = true;

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
                          child: getCartesianLegendOptionsChart(
                              false,
                              _position,
                              _overflowMode,
                              toggleVisibility,
                              null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getCartesianLegendOptionsChart(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                        style:
                                            TextStyle(color: model.textColor)));
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
                                        style:
                                            TextStyle(color: model.textColor)));
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
                      activeColor: model.backgroundColor,
                      switchValue: model.properties['ToggleVisibility'],
                      valueChanged: (dynamic value) {
                        toggleVisibility = value;
                        model.properties['ToggleVisibility'] =
                            toggleVisibility = value;
                        model.sampleOutputContainer.outputKey.currentState
                            .refresh();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
                                            Text('Position ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      65, 0, 0, 0),
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
                                            Text('Toggle visibility ',
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
