import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class FunnelSmartLabels extends StatefulWidget {
  FunnelSmartLabels({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _FunnelSmartLabelState createState() => _FunnelSmartLabelState(sample);
}

class _FunnelSmartLabelState extends State<FunnelSmartLabels> {
  _FunnelSmartLabelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, FunnelSmartLabelFrontPanel(sample));
  }
}

SfFunnelChart getFunnelSmartLabelChart(bool isTileView,
    [ChartDataLabelPosition _labelPosition, SmartLabelMode _mode, SampleModel sampleModel]) {
  final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  return SfFunnelChart(
    smartLabelMode: ( isExistModel
          ? sampleModel.properties['FunnelSmartLabelMode']
          : _mode) ?? SmartLabelMode.shift,
    title: ChartTitle(text: isTileView ? '' : 'Tournament details'),
    tooltipBehavior: TooltipBehavior(
      enable: true,
    ),
    series: _getFunnelSeries(
      isTileView,
      (isExistModel
          ? sampleModel.properties['FunnelLabelPosition']
          : _labelPosition)??ChartDataLabelPosition.outside,
    ),
  );
}

FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isTileView,
    [ChartDataLabelPosition _labelPosition]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Finals', y: 2),
    ChartSampleData(x: 'Semifinals', y: 4),
    ChartSampleData(x: 'Quarter finals', y: 8),
    ChartSampleData(x: 'League matches', y: 16),
    ChartSampleData(x: 'Participated', y: 32),
    ChartSampleData(x: 'Eligible', y: 36),
    ChartSampleData(x: 'Applicants', y: 40),
  ];
  return FunnelSeries<ChartSampleData, String>(
      width: '60%',
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: isTileView ? ChartDataLabelPosition.outside : _labelPosition,
          useSeriesColor: true));
}

//ignore: must_be_immutable
class FunnelSmartLabelFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FunnelSmartLabelFrontPanel([this.sample]);
  SubItem sample;

  @override
  _FunnelSmartLabelFrontPanelState createState() =>
      _FunnelSmartLabelFrontPanelState(sample);
}

class _FunnelSmartLabelFrontPanelState
    extends State<FunnelSmartLabelFrontPanel> {
  _FunnelSmartLabelFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _labelPositon = <String>['outside', 'inside'].toList();
  ChartDataLabelPosition _selectedLabelPosition =
      ChartDataLabelPosition.outside;
  String _selectedPosition = 'outside';

  final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
  String _smartLabelMode = 'shift';
  SmartLabelMode _mode = SmartLabelMode.shift;

 
  // Widget sampleWidget(SampleModel model) => getLabelIntersectActionChart(false);
  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getFunnelSmartLabelChart(false,null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
      _selectedPosition = 'outside';
    _selectedLabelPosition = ChartDataLabelPosition.outside;
    _smartLabelMode = 'shift';
   _mode = SmartLabelMode.shift;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedFunnelSmartLabelMode': _smartLabelMode,
        'FunnelSmartLabelMode': _mode,
        'SelectedFunnelLabelPosition': _selectedPosition,
        'FunnelLabelPosition': _selectedLabelPosition,
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
              body: !model.isWeb ? Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getFunnelSmartLabelChart(
                        false, _selectedLabelPosition, _mode)),
              ) : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child:
                              getFunnelSmartLabelChart(false, null, null,model)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(children: <Widget>[
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
                    ]));
        });
  }

  void onLabelPositionChange(String item, SampleModel model) {
    _selectedPosition = item;
      if (_selectedPosition == 'inside') {
        _selectedLabelPosition = ChartDataLabelPosition.inside;
      } else if (_selectedPosition == 'outside') {
        _selectedLabelPosition = ChartDataLabelPosition.outside;
      }
    model.properties['SelectedFunnelLabelPosition'] = _selectedPosition;
    model.properties['FunnelLabelPosition'] = _selectedLabelPosition;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  void onSmartLabelModeChange(String item, SampleModel model) {
   _smartLabelMode = item;
      if (_smartLabelMode == 'shift') {
        _mode = SmartLabelMode.shift;
      }
      if (_smartLabelMode == 'hide') {
        _mode = SmartLabelMode.hide;
      }
      if (_smartLabelMode == 'none') {
        _mode = SmartLabelMode.none;
      }
    model.properties['SelectedFunnelSmartLabelMode'] = _smartLabelMode;
    model.properties['FunnelSmartLabelMode'] = _mode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  
  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    Widget widget;
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
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
                   Row(
                  children: <Widget>[
                    Text('Label Position  ',
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
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: model.properties[
                                    'SelectedFunnelLabelPosition'],
                                item: _labelPositon.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'outside',
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onLabelPositionChange(value.toString(), model);
                                }),
                          ),
                        )),
                  ],
               
              ),  Row(
                  children: <Widget>[
                    Text('Smart Label mode',
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
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: model.properties[
                                    'SelectedFunnelSmartLabelMode'],
                                item: _modeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'shift',
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onSmartLabelModeChange(value.toString(), model);
                                }),
                          ),
                        )),
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
                                            Text('Label Position          ',
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
                                                        value:
                                                            _selectedPosition,
                                                        item: _labelPositon.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'outside',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onLabelPositionChange(
                                                              value.toString(), model);
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Smart label mode',
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
                                                        value: _smartLabelMode,
                                                        item: _modeList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'shift',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onSmartLabelModeChange(
                                                              value.toString(),
                                                              model);
                                                        }),
                                                  ),
                                                )),
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
