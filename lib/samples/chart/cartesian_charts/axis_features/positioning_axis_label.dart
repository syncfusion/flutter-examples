/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Render the positioning axis label.
class LabelCustomization extends SampleView {
  /// Creates the positioning axis label.
  const LabelCustomization(Key key) : super(key: key);
  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of positioning axis label.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();
  String _ySelectedPositionType = 'inside';
  String _xSelectedPositionType = 'outside';
  String _ySelectedAlignmentType = 'end';
  String _xSelectedAlignmentType = 'center';
  late ChartDataLabelPosition _labelPositionX, _labelPositionY;
  late TickPosition _tickPositionX, _tickPositionY;
  late LabelAlignment _labelAlignmentX, _labelAlignmentY;

  /// List the axis position types.
  final List<String> _yPositionType = <String>['outside', 'inside'].toList();

  /// List the alignment type.
  final List<String> _yAlignmentType =
      <String>['start', 'end', 'center'].toList();
  final List<String> _xPositionType = <String>['outside', 'inside'].toList();
  final List<String> _xAlignmentType =
      <String>['start', 'end', 'center'].toList();
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Y Axis',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: model.textColor)),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Label position  ',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _ySelectedPositionType,
                      items: _yPositionType.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'outside',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onPositionChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Label alignment',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _ySelectedAlignmentType,
                      items: _yAlignmentType.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'start',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onAlignmentChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('X Axis',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: model.textColor)),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Label position  ',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _xSelectedPositionType,
                      items: _xPositionType.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'outside',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onXPositionChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Label alignment',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _xSelectedAlignmentType,
                      items: _xAlignmentType.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'center',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onXAlignmentChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLabelCustomizationSample();
  }

  /// Returen the Spline series with axis label position changing.
  SfCartesianChart _buildLabelCustomizationSample() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'New York temperature details'),
      primaryXAxis: CategoryAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1,
          labelPosition:
              isCardView ? ChartDataLabelPosition.outside : _labelPositionX,
          labelAlignment: isCardView ? LabelAlignment.center : _labelAlignmentX,
          tickPosition: isCardView ? TickPosition.outside : _tickPositionX,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement:
            isCardView ? EdgeLabelPlacement.none : EdgeLabelPlacement.shift,
        labelPosition:
            isCardView ? ChartDataLabelPosition.outside : _labelPositionY,
        labelAlignment: isCardView ? LabelAlignment.center : _labelAlignmentY,
        tickPosition: isCardView ? TickPosition.outside : _tickPositionY,
        opposedPosition: false,
        minimum: 0,
        maximum: 35,
        interval: 5,
        labelFormat: '{value}°C',
      ),
      series: _getSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Return the spline series.
  List<ChartSeries<ChartSampleData, String>> _getSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'May 1', y: 13, secondSeriesYValue: 69.8),
      ChartSampleData(x: 'May 2', y: 26, secondSeriesYValue: 87.8),
      ChartSampleData(x: 'May 3', y: 13, secondSeriesYValue: 78.8),
      ChartSampleData(x: 'May 4', y: 22, secondSeriesYValue: 75.2),
      ChartSampleData(x: 'May 5', y: 14, secondSeriesYValue: 68),
      ChartSampleData(x: 'May 6', y: 23, secondSeriesYValue: 78.8),
      ChartSampleData(x: 'May 7', y: 21, secondSeriesYValue: 80.6),
      ChartSampleData(x: 'May 8', y: 22, secondSeriesYValue: 73.4)
    ];
    return <ChartSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'New York')
    ];
  }

  @override
  void initState() {
    _labelPositionX = ChartDataLabelPosition.outside;
    _labelPositionY = ChartDataLabelPosition.inside;
    _tickPositionX = TickPosition.outside;
    _tickPositionY = TickPosition.inside;
    _labelAlignmentX = LabelAlignment.center;
    _labelAlignmentY = LabelAlignment.end;
    super.initState();
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
}
