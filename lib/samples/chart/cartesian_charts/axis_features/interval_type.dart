/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Line Chart with default data time axis sample.
class IntervalType extends SampleView {
  const IntervalType(Key key) : super(key: key);

  @override
  _IntervalTypeState createState() => _IntervalTypeState();
}

/// State class of the Line Chart with default data time axis.
class _IntervalTypeState extends SampleViewState {
  _IntervalTypeState();

  DateTimeIntervalType? _chartIntervalType;
  List<String>? _intervalType;
  List<ChartSampleData>? _dateTimeData;
  List<ChartSampleData>? _year;
  List<ChartSampleData>? _month;
  List<ChartSampleData>? _day;
  List<ChartSampleData>? _hour;
  List<ChartSampleData>? _minute;
  List<ChartSampleData>? _second;
  List<ChartSampleData>? _millisecond;
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
      'milliseconds',
    ].toList();
    _year = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015), yValue: _buildRandomIntData(15, 95)),
      ChartSampleData(x: DateTime(2016), yValue: _buildRandomIntData(5, 75)),
      ChartSampleData(x: DateTime(2017), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2018), yValue: _buildRandomIntData(5, 85)),
      ChartSampleData(x: DateTime(2019), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2020), yValue: _buildRandomIntData(5, 95)),
    ];
    _month = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2015, 5), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2015, 9), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2016), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2016, 5), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(x: DateTime(2016, 9), yValue: _buildRandomIntData(5, 95)),
    ];
    _day = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2015, 1, 30),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 31),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(x: DateTime(2015, 2), yValue: _buildRandomIntData(5, 95)),
      ChartSampleData(
        x: DateTime(2015, 2, 2),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 2, 3),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 2, 4),
        yValue: _buildRandomIntData(5, 95),
      ),
    ];
    _hour = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2015, 1, 1, 23),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 24, 59),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 2, 1),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 2, 2),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 2, 3),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 2, 4),
        yValue: _buildRandomIntData(5, 95),
      ),
    ];
    _minute = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2015, 1, 1, 10, 58),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 10, 59),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 11),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 11, 01),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 11, 02),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 11, 03),
        yValue: _buildRandomIntData(5, 95),
      ),
    ];
    _second = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 58, 58),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 58, 59),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 59),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 59, 01),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 59, 02),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 59, 03),
        yValue: _buildRandomIntData(5, 95),
      ),
    ];
    _millisecond = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 58, 998),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 58, 999),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 59),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 59, 001),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 59, 002),
        yValue: _buildRandomIntData(5, 95),
      ),
      ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 59, 003),
        yValue: _buildRandomIntData(5, 95),
      ),
    ];
    _selectedIntervalType = 'years';
    _dateTimeData = _year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Interval type',
              softWrap: false,
              style: TextStyle(fontSize: 16, color: model.textColor),
            ),
            Container(
              height: 50.0,
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedIntervalType,
                items: _intervalType!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'left',
                    child: Text(
                      value,
                      softWrap: false,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  onIntervalTypeChanged(value);
                  stateSetter(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(
          text: isCardView
              ? ''
              : '${_selectedIntervalType[0].toUpperCase()}${_selectedIntervalType.substring(1).toLowerCase()}',
        ),
        labelIntersectAction: _selectedIntervalType == 'hours'
            ? AxisLabelIntersectAction.rotate45
            : AxisLabelIntersectAction.multipleRows,
        labelAlignment: _selectedIntervalType == 'hours'
            ? LabelAlignment.start
            : LabelAlignment.center,
        intervalType: _chartIntervalType!,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
        interval: _selectedIntervalType == 'months' ? 4 : 1,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _dateTimeData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
      ),
    ];
  }

  void onIntervalTypeChanged(String intervalType) {
    if (intervalType == 'years') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.years;
      _dateTimeData = _year;
    }
    if (intervalType == 'months') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.months;
      _dateTimeData = _month;
    }
    if (intervalType == 'days') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.days;
      _dateTimeData = _day;
    }
    if (intervalType == 'hours') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.hours;
      _dateTimeData = _hour;
    }
    if (intervalType == 'minutes') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.minutes;
      _dateTimeData = _minute;
    }
    if (intervalType == 'seconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.seconds;
      _dateTimeData = _second;
    }
    if (intervalType == 'milliseconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.milliseconds;
      _dateTimeData = _millisecond;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _year!.clear();
    _month!.clear();
    _day!.clear();
    _hour!.clear();
    _minute!.clear();
    _second!.clear();
    _millisecond!.clear();
    _dateTimeData!.clear();
    super.dispose();
  }
}

num _buildRandomIntData(int min, int max) {
  final Random random = Random.secure();
  return min + random.nextInt(max - min);
}
