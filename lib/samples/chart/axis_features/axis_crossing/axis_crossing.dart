import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

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
    [String _selectedAxis, double _crossAt, bool isPlaceLabelsNearAxisLine]) {
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
            : _selectedAxis == 'X' ? isPlaceLabelsNearAxisLine : true,
        crossesAt: _selectedAxis == 'X' ? _crossAt : 0,
        minorTicksPerInterval: 3),
    primaryYAxis: NumericAxis(
        minimum: -8,
        maximum: 8,
        interval: 2,
        placeLabelsNearAxisLine: isTileView
            ? true
            : _selectedAxis == 'Y' ? isPlaceLabelsNearAxisLine : true,
        crossesAt: _selectedAxis == 'Y' ? _crossAt : 0,
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

  
  Widget sampleWidget(SampleModel model) => getAxisCrossingSample(false);

  @override
  void initState() {
    super.initState();
    crossAt = 0;
    _selectedAxis = 'X';
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
                    child: getAxisCrossingSample(false, _selectedAxisType,
                        crossAt, isPlaceLabelsNearAxisLine)),
              ),
              floatingActionButton: model.isWeb ?
              null :
              Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      _showSettingsPanel(model);
                    },
                    child: Icon(Icons.graphic_eq, color: Colors.white),
                    backgroundColor: model.backgroundColor,
                  ),
                ),
              ]));
        });
  }

  void onAxisTypeChange(String item) {
    setState(() {
      _selectedAxis = item;
      if (_selectedAxis == 'X') {
        _selectedAxisType = 'X';
      } else if (_selectedAxis == 'Y') {
        _selectedAxisType = 'Y';
      }
    });
  }

  void _showSettingsPanel(SampleModel model) {
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleModel model) => Container(
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
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Axis  ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: model.textColor)),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  height: 50,
                                  width: 150,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor:
                                              model.bottomSheetBackgroundColor),
                                      child: DropDown(
                                          value: _selectedAxis,
                                          item: _axis.map((String value) {
                                            return DropdownMenuItem<String>(
                                                value: (value != null)
                                                    ? value
                                                    : 'X',
                                                child: Text('$value',
                                                    style: TextStyle(
                                                        color:
                                                            model.textColor)));
                                          }).toList(),
                                          valueChanged: (dynamic value) {
                                            onAxisTypeChange(value.toString());
                                          }),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('Cross At  ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: model.textColor)),
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
                                        fontSize: 20.0, color: model.textColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // ),
                          // Container(
                          //   child:
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
                          // ),
                        ],
                      ),
                    ),
                  ]),
                  // ))))
                )));
  }
}
