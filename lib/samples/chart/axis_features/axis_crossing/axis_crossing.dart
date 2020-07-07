import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/helper.dart';

//ignore: must_be_immutable
class AxisCrossing extends StatefulWidget {
  AxisCrossing({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _AxisCrossingState createState() => _AxisCrossingState(sample);
}

class _AxisCrossingState extends State<AxisCrossing> {
  _AxisCrossingState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, AxisCrossingFrontPanel(sample));
  }
}

SfCartesianChart getAxisCrossingSample(bool isTileView,
    [String _selectedAxis,
    double _crossAt,
    bool isPlaceLabelsNearAxisLine,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Spline Interpolation'),
    legend: Legend(isVisible: !isTileView),
    primaryXAxis: NumericAxis(
        minimum: -8,
        maximum: 8,
        interval: 2,
        placeLabelsNearAxisLine: isTileView
            ? true
            : (isExistModel ? model.properties['CrossAxis'] : _selectedAxis) ==
                    'X'
                ? ((isExistModel
                        ? model.properties['LabelsNearAxisLine']
                        : isPlaceLabelsNearAxisLine) ??
                    true)
                : true,
        crossesAt: (isExistModel
                    ? model.properties['CrossAxis']
                    : _selectedAxis) ==
                'X'
            ? ((isExistModel ? model.properties['AxisCrossAt'] : _crossAt) ?? 0)
            : 0,
        minorTicksPerInterval: 3),
    primaryYAxis: NumericAxis(
        minimum: -8,
        maximum: 8,
        interval: 2,
        placeLabelsNearAxisLine: isTileView
            ? true
            : (isExistModel ? model.properties['CrossAxis'] : _selectedAxis) ==
                    'Y'
                ? ((isExistModel
                        ? model.properties['LabelsNearAxisLine']
                        : isPlaceLabelsNearAxisLine) ??
                    true)
                : true,
        crossesAt: (isExistModel
                    ? model.properties['CrossAxis']
                    : _selectedAxis) ==
                'Y'
            ? ((isExistModel ? model.properties['AxisCrossAt'] : _crossAt) ?? 0)
            : 0,
        minorTicksPerInterval: 3),
    series: getSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ChartSeries<ChartSampleData, dynamic>> getSeries(bool isTileView) {
  final dynamic splineData = <ChartSampleData>[
    ChartSampleData(x: -7, y: -3),
    ChartSampleData(x: -4.5, y: -2),
    ChartSampleData(x: -3.5, y: 0),
    ChartSampleData(x: -3, y: 2),
    ChartSampleData(x: 0, y: 7),
    ChartSampleData(x: 3, y: 2),
    ChartSampleData(x: 3.5, y: 0),
    ChartSampleData(x: 4.5, y: -2),
    ChartSampleData(x: 7, y: -3),
  ];

  return <ChartSeries<ChartSampleData, dynamic>>[
    SplineSeries<ChartSampleData, dynamic>(
        dataSource: splineData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        color: const Color.fromRGBO(20, 122, 20, 1),
        name: 'Cubic Interpolation',
        width: 2),
  ];
}

//ignore: must_be_immutable
class AxisCrossingFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  AxisCrossingFrontPanel([this.sample]);

  SubItem sample;

  @override
  _AxisCrossingFrontPanelState createState() =>
      _AxisCrossingFrontPanelState(sample);
}

class _AxisCrossingFrontPanelState extends State<AxisCrossingFrontPanel> {
  _AxisCrossingFrontPanelState(this.sample);
  final SubItem sample;
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();
  final List<String> _axis = <String>['X', 'Y'].toList();
  String _selectedAxisType = 'X';
  String _selectedAxis;
  double crossAt = 0;
  bool isPlaceLabelsNearAxisLine = true;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getAxisCrossingSample(false, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedAxisType = 'X';
    _selectedAxis = 'X';
    crossAt = 0;
    isPlaceLabelsNearAxisLine = true;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'AxisCrossAt': crossAt,
        'SelectedCrossAxis': _selectedAxis,
        'CrossAxis': _selectedAxisType,
        'LabelsNearAxisLine': isPlaceLabelsNearAxisLine
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
                          child: getAxisCrossingSample(false, _selectedAxisType,
                              crossAt, isPlaceLabelsNearAxisLine)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getAxisCrossingSample(
                              false, null, null, null, model)),
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

  void onAxisTypeChange(String item, SampleModel model) {
    _selectedAxis = item;
    if (_selectedAxis == 'X') {
      _selectedAxisType = 'X';
    } else if (_selectedAxis == 'Y') {
      _selectedAxisType = 'Y';
    }
    model.properties['SelectedCrossAxis'] = _selectedAxis;
    model.properties['CrossAxis'] = _selectedAxisType;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
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
                      Text('Axis     ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 16,
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
                                  value: model.properties['SelectedCrossAxis'],
                                  item: _axis.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null) ? value : 'X',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    onAxisTypeChange(value.toString(), model);
                                  }),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Cross At ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: -8,
                          maxValue: 8,
                          step: 2,
                          initialValue: model.properties['AxisCrossAt'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['AxisCrossAt'] = val;
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
                  Row(
                    children: <Widget>[
                      Text('Labels Near AxisLine',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      BottomSheetCheckbox(
                        activeColor: model.backgroundColor,
                        switchValue: model.properties['LabelsNearAxisLine'],
                        valueChanged: (dynamic value) {
                          model.properties['LabelsNearAxisLine'] = value;
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
              builder: (BuildContext context, _, SampleModel model) =>
                  Container(
                    height: 170,
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                    child: Stack(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                        child: ListView(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('Axis  ',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: model.textColor)),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    height: 50,
                                    width: 150,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: model
                                                .bottomSheetBackgroundColor),
                                        child: DropDown(
                                            value: _selectedAxis,
                                            item: _axis.map((String value) {
                                              return DropdownMenuItem<String>(
                                                  value: (value != null)
                                                      ? value
                                                      : 'X',
                                                  child: Text('$value',
                                                      style: TextStyle(
                                                          color: model
                                                              .textColor)));
                                            }).toList(),
                                            valueChanged: (dynamic value) {
                                              onAxisTypeChange(
                                                  value.toString(), model);
                                            }),
                                      ),
                                    ))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Cross At  ',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: model.textColor)),
                                Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: CustomButton(
                                      minValue: -8,
                                      maxValue: 8,
                                      initialValue: crossAt,
                                      onChanged: (double val) => setState(() {
                                        crossAt = val;
                                      }),
                                      step: 2,
                                      horizontal: true,
                                      loop: false,
                                      padding: 0,
                                      iconUp: Icons.keyboard_arrow_up,
                                      iconDown: Icons.keyboard_arrow_down,
                                      iconLeft: Icons.keyboard_arrow_left,
                                      iconRight: Icons.keyboard_arrow_right,
                                      iconUpRightColor: model.textColor,
                                      iconDownLeftColor: model.textColor,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: model.textColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Labels Near Axisline',
                                    style: TextStyle(
                                        color: model.textColor,
                                        fontSize: 16,
                                        letterSpacing: 0.34,
                                        fontWeight: FontWeight.normal)),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                BottomSheetCheckbox(
                                  activeColor: model.backgroundColor,
                                  switchValue: isPlaceLabelsNearAxisLine,
                                  valueChanged: (dynamic value) {
                                    setState(() {
                                      isPlaceLabelsNearAxisLine = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )));
    }
    return widget ?? Container();
  }
}
