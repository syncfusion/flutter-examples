/// Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the customized axis labels sample
class CustomLabelsEvent extends SampleView {
  /// creates the customized axis labels sample
  const CustomLabelsEvent(Key key) : super(key: key);
  @override
  _CustomLabelsEventState createState() => _CustomLabelsEventState();
}

class _CustomLabelsEventState extends SampleViewState<CustomLabelsEvent> {
  _CustomLabelsEventState();

  late int _segmentedControlValue;

  /// Here we define the chart data source.
  late List<_LabelData> _chartData;
  late List<_LabelData> _tileViewData;
  late int _count = 5;
  static DateTime _current = DateTime.now();
  late int _currentyear;
  late int _currentmonth;
  late int _currentdate;
  late int _currenthour;
  late int _currentmin;
  late DateFormat _formatter;
  late DateFormat _formatter1;
  late DateFormat _formatter2;
  late DateFormat _formatter3;
  late DateFormat _formatter4;
  late DateTimeIntervalType _timeinterval;
  late DateFormat _format;
  late bool _isYear;
  late bool _isMonth;
  late bool _isDay;
  late bool _isHours;
  late bool _isMin;
  late double bottomPadding;

  @override
  void initState() {
    _segmentedControlValue = 0;
    _chartData = <_LabelData>[
      _LabelData(DateTime(2016), 57),
      _LabelData(DateTime(2017), 70),
      _LabelData(DateTime(2018), 58),
      _LabelData(DateTime(2019), 65),
      _LabelData(DateTime(2020), 38),
    ];
    _tileViewData = <_LabelData>[
      _LabelData(DateTime(2016), 57),
      _LabelData(DateTime(2017), 70),
      _LabelData(DateTime(2018), 58),
      _LabelData(DateTime(2019), 65),
      _LabelData(DateTime(2020), 38),
    ];
    _count = 5;
    _currentyear = _current.year;
    _currentmonth = _current.month;
    _currentdate = _current.day;
    _currenthour = _current.hour;
    _currentmin = _current.minute;
    _formatter = DateFormat().add_d();
    _formatter1 = DateFormat().add_j();
    _formatter2 = DateFormat().add_m();
    _formatter3 = DateFormat().add_MMM();
    _formatter4 = DateFormat().add_y();
    _timeinterval = DateTimeIntervalType.years;
    _format = DateFormat.y();
    _isYear = true;
    _isMonth = false;
    _isDay = false;
    _isHours = false;
    _isMin = false;
    random = Random();
    super.initState();
  }

  @override
  void dispose() {
    _chartData.clear();
    _tileViewData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _isYear = true;
      _isMonth = false;
      _isDay = false;
      _isHours = false;
      _isMin = false;
    });
    bottomPadding = isCardView ? 0 : 50;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: _buildEventLineChart(false, _chartData)),
        ),
        floatingActionButton: isCardView ? null : _segmentedControl());
  }

  /// Get the format picker
  Widget _segmentedControl() => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
            foregroundDecoration: const BoxDecoration(shape: BoxShape.circle),
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: CupertinoSegmentedControl<int>(
              selectedColor: model.backgroundColor,
              borderColor: Colors.white,
              children: const <int, Widget>{
                0: Text('Y'),
                1: Text('M'),
                2: Text('D'),
                3: Text('H'),
                4: Text('Min'),
              },
              onValueChanged: (int val) {
                setState(() {
                  _segmentedControlValue = val;
                  _changeAxisLabel(val);
                });
              },
              groupValue: _segmentedControlValue,
            )),
      );

  /// Change the label format
  void _changeAxisLabel(int index) {
    switch (index) {
      case 0:
        _chartData = <_LabelData>[];
        _chartData = _getYearData();
        break;
      case 1:
        _chartData = <_LabelData>[];
        _chartData = _getMonthData();
        break;
      case 2:
        _chartData = <_LabelData>[];
        _chartData = _getDaysData();
        break;
      case 3:
        _chartData = <_LabelData>[];
        _chartData = _getHourData();
        break;
      case 4:
        _chartData = <_LabelData>[];
        _chartData = _getMinData();
        break;
      default:
        _chartData = <_LabelData>[];
        _chartData = _getYearData();
    }
  }

  /// Get the cartesian chart widget
  SfCartesianChart _buildEventLineChart(bool isTileView,
      [List<_LabelData>? data]) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        interval: 1,
        intervalType: _timeinterval,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: _format,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          if (details.axis is DateTimeAxis &&
              _isYear &&
              _formatter4.format(_current) == details.text) {
            return ChartAxisLabel(
                'Current\nYear',
                const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.red));
          } else if (details.axis is DateTimeAxis &&
              _isMonth &&
              _formatter3.format(_current) == details.text) {
            return ChartAxisLabel(
                'Current\nMonth',
                const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.red));
          } else if (details.axis is DateTimeAxis &&
              _isDay &&
              _formatter.format(_current) == details.text) {
            return ChartAxisLabel(
                'Today',
                const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.red));
          } else if (details.axis is DateTimeAxis &&
              _isHours &&
              _formatter1.format(_current) == details.text) {
            return ChartAxisLabel(
                'Current\nHour',
                const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.red));
          } else if (details.axis is DateTimeAxis &&
              _isMin &&
              _formatter2.format(_current) == details.text) {
            return ChartAxisLabel(
                'Now',
                const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.red));
          } else {
            return ChartAxisLabel(details.text, null);
          }
        },
      ),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  ///Get the line series
  List<LineSeries<_LabelData, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<_LabelData, DateTime>>[
      LineSeries<_LabelData, DateTime>(
          dataSource: isCardView ? _tileViewData : _chartData,
          xValueMapper: (_LabelData sales, _) => sales.x,
          yValueMapper: (_LabelData sales, _) => sales.y,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  late Random random;
  int _getRandomInt(int min, int max) {
    return min + random.nextInt(max - min);
  }

  /// Get the current date time
  void _getCurrentTime() {
    _current = DateTime.now();
    _currentyear = _current.year;
    _currentmonth = _current.month;
    _currentdate = _current.day;
    _currenthour = _current.hour;
    _currentmin = _current.minute;
  }

  ///Set the date time bool values
  void _setTimeVisibility(String time) {
    switch (time) {
      case 'year':
        _isYear = true;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMin = false;
        break;
      case 'month':
        _isYear = false;
        _isMonth = true;
        _isDay = false;
        _isHours = false;
        _isMin = false;
        break;
      case 'day':
        _isYear = false;
        _isMonth = false;
        _isDay = true;
        _isHours = false;
        _isMin = false;
        break;
      case 'hours':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = true;
        _isMin = false;
        break;
      case 'min':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMin = true;
        break;
    }
  }

  /// It returns the data for year to the chart data source.
  List<_LabelData> _getYearData() {
    _setTimeVisibility('year');
    _getCurrentTime();
    _timeinterval = DateTimeIntervalType.years;
    _format = DateFormat.y();
    int temp = _currentyear;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(_LabelData(DateTime(temp), _getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for month to the chart data source.
  List<_LabelData> _getMonthData() {
    _setTimeVisibility('month');
    _getCurrentTime();
    _timeinterval = DateTimeIntervalType.months;
    _format = DateFormat.MMM();
    int temp = _currentmonth;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(
          _LabelData(DateTime(_currentyear, temp), _getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for days to the chart data source.
  List<_LabelData> _getDaysData() {
    _setTimeVisibility('day');
    _getCurrentTime();
    _timeinterval = DateTimeIntervalType.days;
    _format = DateFormat.d();
    int temp = _currentdate;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(_LabelData(
          DateTime(_currentyear, _currentmonth, temp), _getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for hour to the chart data source.
  List<_LabelData> _getHourData() {
    _setTimeVisibility('hours');
    _getCurrentTime();
    _timeinterval = DateTimeIntervalType.hours;
    _format = DateFormat.j();
    int temp = _currenthour;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(_LabelData(
          DateTime(_currentyear, _currentmonth, _currentdate, temp),
          _getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for minutes to the chart data source.
  List<_LabelData> _getMinData() {
    _setTimeVisibility('min');
    _getCurrentTime();
    _timeinterval = DateTimeIntervalType.minutes;
    _format = DateFormat.m();
    int temp = _currentmin;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(_LabelData(
          DateTime(
              _currentyear, _currentmonth, _currentdate, _currenthour, temp),
          _getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }
}

class _LabelData {
  _LabelData(this.x, this.y);
  final DateTime x;
  final num y;
}
