/// Dart imports
import 'dart:math';
import 'package:intl/intl.dart';

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

  final List<String> _intervalType = <String>[
    'years',
    'months',
    'days',
    'hours',
    'minutes',
    'seconds',
    'milliseconds'
  ].toList();
  late String _selectedIntervalType;
  DateTimeIntervalType _chartIntervalType = DateTimeIntervalType.years;
  DateFormat _dateFormat = DateFormat.y();
  late List<ChartSampleData> chartData;

  final List<ChartSampleData> year = <ChartSampleData>[
    ChartSampleData(x: DateTime(2015, 1, 1), yValue: _getRandomInt(15, 95)),
    ChartSampleData(x: DateTime(2016, 1, 1), yValue: _getRandomInt(5, 75)),
    ChartSampleData(x: DateTime(2017, 1, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2018, 1, 1), yValue: _getRandomInt(5, 85)),
    ChartSampleData(x: DateTime(2019, 1, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2020, 1, 1), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> month = <ChartSampleData>[
    ChartSampleData(x: DateTime(2015, 1, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 2, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 3, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 4, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 5, 1), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 6, 1), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> day = <ChartSampleData>[
    ChartSampleData(x: DateTime(2015, 1, 5), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 1, 6), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 1, 7), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 1, 8), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 1, 9), yValue: _getRandomInt(5, 95)),
    ChartSampleData(x: DateTime(2015, 1, 10), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> hour = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2015, 1, 1, 11, 00), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 12, 00), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 13, 00), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 00), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 15, 00), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 16, 00), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> minute = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 01), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 02), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 03), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 04), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 05), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 22, 06), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> second = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 01), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 02), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 03), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 04), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 05), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 14, 52, 06), yValue: _getRandomInt(5, 95)),
  ];
  final List<ChartSampleData> millisecond = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 001), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 002), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 003), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 004), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 005), yValue: _getRandomInt(5, 95)),
    ChartSampleData(
        x: DateTime(2015, 1, 1, 01, 01, 55, 006), yValue: _getRandomInt(5, 95)),
  ];

  @override
  void initState() {
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
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
              title: Text('Interval type',
                  softWrap: false,
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.45 * screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                    isExpanded: true,
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _selectedIntervalType,
                    items: _intervalType.map((String value) {
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
              )),
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
          intervalType: _chartIntervalType,
          dateFormat: _selectedIntervalType == 'days'
              ? DateFormat('EEE')
              : _selectedIntervalType == 'milliseconds'
                  ? DateFormat('ss:SSS')
                  : _dateFormat,
          edgeLabelPlacement: _selectedIntervalType != 'months' &&
                  _selectedIntervalType != 'days' &&
                  !model.isWebFullView
              ? EdgeLabelPlacement.shift
              : EdgeLabelPlacement.none,
          majorGridLines: const MajorGridLines(width: 0),
          interval: 1),
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
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x as DateTime,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
      )
    ];
  }

  void onIntervalTypeChanged(String intervalType) {
    if (intervalType == 'years') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.years;
      _dateFormat = DateFormat.y();
      chartData = year;
    }
    if (intervalType == 'months') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.months;
      _dateFormat = DateFormat.MMM();
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
      _dateFormat = DateFormat.jm();
      chartData = hour;
    }
    if (intervalType == 'minutes') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.minutes;
      _dateFormat = DateFormat.Hm();
      chartData = minute;
    }
    if (intervalType == 'seconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.seconds;
      _dateFormat = DateFormat.ms();
      chartData = second;
    }
    if (intervalType == 'milliseconds') {
      _selectedIntervalType = intervalType;
      _chartIntervalType = DateTimeIntervalType.milliseconds;
      chartData = millisecond;
    }
    setState(() {});
  }
}

num _getRandomInt(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}
