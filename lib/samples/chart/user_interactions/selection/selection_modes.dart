import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore:must_be_immutable
class DefaultSelection extends StatefulWidget {
  DefaultSelection({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState(sample);
}

class _DefaultSelectionState extends State<DefaultSelection> {
  _DefaultSelectionState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, CartesianSelectionFrontPanel(sample));
  }
}

SfCartesianChart getDefaultSelectionChart(bool isTileView,
    [SelectionType _mode, bool enableMultiSelect,
    SampleModel model]) {
      final bool isExistModel = model != null && model.isWeb;
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Age distribution by country'),
    selectionType: isExistModel
                    ? model.properties['SelectionType']
                    : _mode,
    selectionGesture: ActivationMode.singleTap,
    enableMultiSelection: isExistModel
                    ? model.properties['EnableMultiSelection']
                    : enableMultiSelect,
    primaryXAxis: CategoryAxis(
        title: AxisTitle(text: isTileView ? '' : 'Countries'),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultSelectionSeries(isTileView),
  );
}

List<ColumnSeries<ChartSampleData, String>> getDefaultSelectionSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'CHN', y: 17, yValue2: 54, yValue3: 9),
    ChartSampleData(x: 'USA', y: 19, yValue2: 67, yValue3: 14),
    ChartSampleData(x: 'IDN', y: 29, yValue2: 65, yValue3: 6),
    ChartSampleData(x: 'JAP', y: 13, yValue2: 61, yValue3: 26),
    ChartSampleData(x: 'BRZ', y: 24, yValue2: 68, yValue3: 8)
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 0-14'),
    ColumnSeries<ChartSampleData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 15-64'),
    ColumnSeries<ChartSampleData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 65 & Above')
  ];
}

//ignore: must_be_immutable
class CartesianSelectionFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  CartesianSelectionFrontPanel([this.sample]);

  SubItem sample;

  @override
  _SelectionFrontPanelState createState() => _SelectionFrontPanelState(sample);
}

class _SelectionFrontPanelState extends State<CartesianSelectionFrontPanel> {
  _SelectionFrontPanelState(this.sample);
  final SubItem sample;
  bool enableMultiSelect = false;

  final List<String> _modeList =
      <String>['point', 'series', 'cluster'].toList();
  String _selectedMode = 'point';

  SelectionType _mode = SelectionType.point;
  
  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getDefaultSelectionChart(false, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedMode = 'point';
 _mode = SelectionType.point;
    enableMultiSelect = false;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedSelectionType': _selectedMode,
        'SelectionType': _mode,
        'EnableMultiSelection': enableMultiSelect
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
              body:!model.isWeb ?Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getDefaultSelectionChart(
                        false, _mode, enableMultiSelect)),
              ):Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Container(
                    child: getDefaultSelectionChart(
                        false, null, null, model)),
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
                      Text('Mode        ',
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
                                      .properties['SelectedSelectionType'],
                                  item: _modeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null) ? value : 'point',
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
                  Row(
                    children: <Widget>[
                      Text('Enable multi-selection',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['EnableMultiSelection'],
                          valueChanged: (dynamic value) {
                            model.properties['EnableMultiSelection'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
                       
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
                                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                                                150, 0, 0, 0),
                                            height: 50,
                                            width: 250,
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
                                          Text('Enable multi-selection ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          BottomSheetCheckbox(
                                            activeColor: model.backgroundColor,
                                            switchValue: enableMultiSelect,
                                            valueChanged: (dynamic value) {
                                              setState(() {
                                                enableMultiSelect = value;
                                              });
                                            },
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
      if (_selectedMode == 'point') {
        _mode = SelectionType.point;
      }
      if (_selectedMode == 'series') {
        _mode = SelectionType.series;
      }
      if (_selectedMode == 'cluster') {
        _mode = SelectionType.cluster;
      }
     model.properties['SelectedSelectionType'] = _selectedMode;
    model.properties['SelectionType'] = _mode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }
}
