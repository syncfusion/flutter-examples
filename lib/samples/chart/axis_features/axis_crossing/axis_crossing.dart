
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Package import
import 'package:flutter/material.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';
import '../../../../widgets/customDropDown.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';


/// Renders the spline chart with axis crossing sample.
class AxisCrossing extends SampleView {
  const AxisCrossing(Key key) : super(key: key);

  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of the spline chart with axis crossing.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();
  final List<String> _axis = <String>['X', 'Y'].toList();
  String _selectedAxisType = 'X';
  String _selectedAxis;
  double crossAt = 0;
  bool isPlaceLabelsNearAxisLine = true;

  @override
  void initState() {
    _selectedAxisType = 'X';
    _selectedAxis = 'X';
    crossAt = 0;
    isPlaceLabelsNearAxisLine = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getAxisCrossingSample();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Axis  ',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
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
                        value: _selectedAxis,
                        item: _axis.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'X',
                              child: Text('$value',
                                  style: TextStyle(color: model.textColor)));
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
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  iconUpRightColor: model.textColor,
                  iconDownLeftColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
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
            const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
            HandCursor(
              child: BottomSheetCheckbox(
                activeColor: model.backgroundColor,
                switchValue: isPlaceLabelsNearAxisLine,
                valueChanged: (dynamic value) {
                  setState(() {
                    isPlaceLabelsNearAxisLine = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns the spline chart with axis crossing at provided axis value.
  SfCartesianChart getAxisCrossingSample() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Spline Interpolation'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
          minimum: -8,
          maximum: 8,
          interval: 2,
          placeLabelsNearAxisLine: isCardView
              ? true
              : _selectedAxisType == 'X'
                  ? isPlaceLabelsNearAxisLine ?? true
                  : true,
          crossesAt: _selectedAxisType == 'X' ? crossAt ?? 0 : 0,
          minorTicksPerInterval: 3),
      primaryYAxis: NumericAxis(
          minimum: -8,
          maximum: 8,
          interval: 2,
          placeLabelsNearAxisLine: isCardView
              ? true
              : _selectedAxisType == 'Y'
                  ? isPlaceLabelsNearAxisLine ?? true
                  : true,
          crossesAt: _selectedAxisType == 'Y' ? crossAt ?? 0 : 0,
          minorTicksPerInterval: 3),
      series: getSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the spline chart with axis crossing.
  List<ChartSeries<ChartSampleData, dynamic>> getSeries() {
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

  /// Method for updating the axis type on change.
  void onAxisTypeChange(String item) {
    _selectedAxis = item;
    if (_selectedAxis == 'X') {
      _selectedAxisType = 'X';
    } else if (_selectedAxis == 'Y') {
      _selectedAxisType = 'Y';
    }
    setState(() {});
  }
}