/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Render the positioning axis label.
class LabelCustomization extends SampleView {
  const LabelCustomization(Key key) : super(key: key);
  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of positioning axis label.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();

  List<ChartSampleData>? _temperatureDataOfNewYork;
  late TooltipBehavior _tooltipBehavior;
  late String _xSelectedPositionType;
  late String _ySelectedPositionType;
  late String _xSelectedAlignmentType;
  late String _ySelectedAlignmentType;
  late ChartDataLabelPosition _labelPositionX;
  late ChartDataLabelPosition _labelPositionY;
  late TickPosition _tickPositionX;
  late TickPosition _tickPositionY;
  late LabelAlignment _labelAlignmentX;
  late LabelAlignment _labelAlignmentY;

  /// List the axis position types.
  List<String>? _xPositionType;
  List<String>? _yPositionType;

  /// List the alignment type.
  List<String>? _xAlignmentType;
  List<String>? _yAlignmentType;

  @override
  void initState() {
    _temperatureDataOfNewYork = <ChartSampleData>[
      ChartSampleData(x: 'May 1', y: 13, secondSeriesYValue: 69.8),
      ChartSampleData(x: 'May 2', y: 26, secondSeriesYValue: 87.8),
      ChartSampleData(x: 'May 3', y: 13, secondSeriesYValue: 78.8),
      ChartSampleData(x: 'May 4', y: 22, secondSeriesYValue: 75.2),
      ChartSampleData(x: 'May 5', y: 14, secondSeriesYValue: 68),
      ChartSampleData(x: 'May 6', y: 23, secondSeriesYValue: 78.8),
      ChartSampleData(x: 'May 7', y: 21, secondSeriesYValue: 80.6),
      ChartSampleData(x: 'May 8', y: 22, secondSeriesYValue: 73.4),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _xSelectedPositionType = 'outside';
    _ySelectedPositionType = 'inside';
    _xSelectedAlignmentType = 'center';
    _ySelectedAlignmentType = 'end';
    _labelPositionX = ChartDataLabelPosition.outside;
    _labelPositionY = ChartDataLabelPosition.inside;
    _tickPositionX = TickPosition.outside;
    _tickPositionY = TickPosition.inside;
    _labelAlignmentX = LabelAlignment.center;
    _labelAlignmentY = LabelAlignment.end;
    _xPositionType = <String>['outside', 'inside'].toList();
    _yPositionType = <String>['outside', 'inside'].toList();
    _xAlignmentType = <String>['start', 'end', 'center'].toList();
    _yAlignmentType = <String>['start', 'end', 'center'].toList();
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Y Axis',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: model.textColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Label position  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _ySelectedPositionType,
                    items: _yPositionType!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'outside',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onPositionChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Label alignment',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _ySelectedAlignmentType,
                    items: _yAlignmentType!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'start',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onAlignmentChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'X Axis',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: model.textColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Label position  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _xSelectedPositionType,
                    items: _xPositionType!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'outside',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onXPositionChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Label alignment',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _xSelectedAlignmentType,
                    items: _xAlignmentType!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'center',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onXAlignmentChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'New York temperature details'),
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1,
        labelPosition: isCardView
            ? ChartDataLabelPosition.outside
            : _labelPositionX,
        labelAlignment: isCardView ? LabelAlignment.center : _labelAlignmentX,
        tickPosition: isCardView ? TickPosition.outside : _tickPositionX,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: isCardView
            ? EdgeLabelPlacement.none
            : EdgeLabelPlacement.shift,
        labelPosition: isCardView
            ? ChartDataLabelPosition.outside
            : _labelPositionY,
        labelAlignment: isCardView ? LabelAlignment.center : _labelAlignmentY,
        tickPosition: isCardView ? TickPosition.outside : _tickPositionY,
        minimum: 0,
        maximum: 35,
        interval: 5,
        labelFormat: '{value}°C',
      ),
      series: _buildSplineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<CartesianSeries<ChartSampleData, String>> _buildSplineSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: _temperatureDataOfNewYork,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'New York',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  /// Method for Y axis label position change.
  void _onPositionChange(String item) {
    setState(() {
      _ySelectedPositionType = item;
      if (_ySelectedPositionType == 'outside') {
        _labelPositionY = ChartDataLabelPosition.outside;
        _tickPositionY = TickPosition.outside;
      }
      if (_ySelectedPositionType == 'inside') {
        _labelPositionY = ChartDataLabelPosition.inside;
        _tickPositionY = TickPosition.inside;
      }
    });
  }

  /// Method for X axis label position change.
  void _onXPositionChange(String item) {
    setState(() {
      _xSelectedPositionType = item;
      if (_xSelectedPositionType == 'outside') {
        _labelPositionX = ChartDataLabelPosition.outside;
        _tickPositionX = TickPosition.outside;
      } else {
        _labelPositionX = ChartDataLabelPosition.inside;
        _tickPositionX = TickPosition.inside;
      }
    });
  }

  /// Method for Y axis label alignment change.
  void _onAlignmentChange(String item) {
    setState(() {
      _ySelectedAlignmentType = item;
      if (_ySelectedAlignmentType == 'start') {
        _labelAlignmentY = LabelAlignment.start;
      } else if (_ySelectedAlignmentType == 'center') {
        _labelAlignmentY = LabelAlignment.center;
      } else if (_ySelectedAlignmentType == 'end') {
        _labelAlignmentY = LabelAlignment.end;
      }
    });
  }

  /// Method for X axis label alignment change.
  void _onXAlignmentChange(String item) {
    setState(() {
      _xSelectedAlignmentType = item;
      if (_xSelectedAlignmentType == 'start') {
        _labelAlignmentX = LabelAlignment.start;
      } else if (_xSelectedAlignmentType == 'center') {
        _labelAlignmentX = LabelAlignment.center;
      } else if (_xSelectedAlignmentType == 'end') {
        _labelAlignmentX = LabelAlignment.end;
      }
    });
  }

  @override
  void dispose() {
    _yPositionType!.clear();
    _xPositionType!.clear();
    _yAlignmentType!.clear();
    _xAlignmentType!.clear();
    _temperatureDataOfNewYork!.clear();
    super.dispose();
  }
}
