/// Dart imports
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the line chart with default data time axis sample.
class IntervalType extends SampleView {
  ///  Creates the line chart with default data time axis sample.
  const IntervalType(Key key) : super(key: key);

  @override
  _IntervalTypeState createState() => _IntervalTypeState();
}

/// State class of the line chart with default data time axis.
class _IntervalTypeState extends SampleViewState {
  _IntervalTypeState();

  List<String>? _intervalType;
  DateTimeIntervalType? _chartIntervalType;
  List<ChartSampleData>? chartData;
  List<ChartSampleData>? year;
  List<ChartSampleData>? month;
  List<ChartSampleData>? day;
  List<ChartSampleData>? hour;
  List<ChartSampleData>? minute;
  List<ChartSampleData>? second;
  List<ChartSampleData>? millisecond;
  late String _selectedIntervalType;

  @override
  void initState() {
    _chartIntervalType = DateTimeIntervalType.years;
    _intervalType = <String>[
      'years',
      'months',
      'days',
      'hours',
      'minutes',
      'seconds',
      'milliseconds'
    ].toList();
    year = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015), yValue: _getRandomInt(15, 95)),
      ChartSampleData(x: DateTime(2016), yValue: _getRandomInt(5, 75)),
      ChartSampleData(x: DateTime(2017), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2018), yValue: _getRandomInt(5, 85)),
      ChartSampleData(x: DateTime(2019), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2020), yValue: _getRandomInt(5, 95)),
    ];
    month = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 5), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 9), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2016), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2016, 5), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2016, 9), yValue: _getRandomInt(5, 95)),
    ];
    day = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015, 1, 30), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 1, 31), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 2), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 2, 2), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 2, 3), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 2, 4), yValue: _getRandomInt(5, 95)),
    ];
    hour = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2015, 1, 1, 23), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 24, 59), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 1, 2, 1), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 1, 2, 2), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 1, 2, 3), yValue: _getRandomInt(5, 95)),
      ChartSampleData(x: DateTime(2015, 1, 2, 4), yValue: _getRandomInt(5, 95)),
    ];
    minute = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2015, 1, 1, 10, 58), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 10, 59), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 11), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 11, 01), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 11, 02), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 11, 03), yValue: _getRandomInt(5, 95)),
    ];
    second = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 58, 58), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 58, 59), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 59), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 59, 01), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 59, 02), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 14, 59, 03), yValue: _getRandomInt(5, 95)),
    ];
    millisecond = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 58, 998),
          yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 58, 999),
          yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 59), yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 59, 001),
          yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 59, 002),
          yValue: _getRandomInt(5, 95)),
      ChartSampleData(
          x: DateTime(2015, 1, 1, 01, 01, 59, 003),
          yValue: _getRandomInt(5, 95)),
    ];
    _selectedIntervalType = 'years';
    chartData = year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultDateTimeAxisChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Interval type',
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                color: model.textColor,
              )),
          Container(
            height: 50.0,
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: DropdownButton<String>(
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedIntervalType,
                items: _intervalType!.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'left',
                      child: Text(value,
                          softWrap: false,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  onIntervalTypeChanged(value);
                  stateSetter(() {});
                }),
          ),
        ],
      );
    });
  }

  /// Returns the line chart with default datetime axis.
  SfCartesianChart _buildDefaultDateTimeAxisChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          title: AxisTitle(
              text: isCardView
                  ? ''
                  : '${_selectedIntervalType[0].toUpperCase()}${_selectedIntervalType.substring(1).toLowerCase()}'),
          labelIntersectAction: _selectedIntervalType == 'hours'
              ? AxisLabelIntersectAction.rotate45
              : AxisLabelIntersectAction.multipleRows,
          labelAlignment: _selectedIntervalType == 'hours'
              ? LabelAlignment.start
              : LabelAlignment.center,
          intervalType: _chartIntervalType!,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          interval: _selectedIntervalType == 'months' ? 4 : 1),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _getDefaultDateTimeSeries(),
    );
  }

  /// Returns the line chart with default data time axis.
  List<LineSeries<ChartSampleData, DateTime>> _getDefaultDateTimeSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData data, _) => data.x as DateTime,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
      )
    ];
  }

  void onIntervalTypeChanged(String intervalType) {
    if (intervalType == 'years') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.years;
      chartData = year;
    }
    if (intervalType == 'months') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.months;
      chartData = month;
    }
    if (intervalType == 'days') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.days;
      chartData = day;
    }
    if (intervalType == 'hours') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.hours;
      chartData = hour;
    }
    if (intervalType == 'minutes') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.minutes;
      chartData = minute;
    }
    if (intervalType == 'seconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.seconds;
      chartData = second;
    }
    if (intervalType == 'milliseconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.milliseconds;
      chartData = millisecond;
    }
    setState(() {});
  }

  @override
  void dispose() {
    year!.clear();
    month!.clear();
    day!.clear();
    hour!.clear();
    minute!.clear();
    second!.clear();
    millisecond!.clear();
    super.dispose();
  }
}

num _getRandomInt(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}
