/// Dart import.
import 'dart:math';

/// Package imports.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the customized axis labels sample.
class CustomLabelsEvent extends SampleView {
  const CustomLabelsEvent(Key key) : super(key: key);

  @override
  _CustomLabelsEventState createState() => _CustomLabelsEventState();
}

class _CustomLabelsEventState extends SampleViewState<CustomLabelsEvent> {
  _CustomLabelsEventState();

  static DateTime _current = DateTime.now();
  late int _count;
  late int _segmentedControlValue;
  late int _currentYear;
  late int _currentMonth;
  late int _currentDate;
  late int _currentHours;
  late int _currentMinutes;
  late DateFormat _formatter;
  late DateFormat _formatter1;
  late DateFormat _formatter2;
  late DateFormat _formatter3;
  late DateFormat _formatter4;
  late DateTimeIntervalType _timeInterval;
  late DateFormat _format;
  late bool _isYear;
  late bool _isMonth;
  late bool _isDay;
  late bool _isHours;
  late bool _isMinutes;
  late double _bottomPadding;
  late TooltipBehavior _tooltipBehavior;
  late Random _random;
  late List<_LabelData> _chartData;
  late List<_LabelData> _tileViewData;

  @override
  void initState() {
    _segmentedControlValue = 0;
    _count = 5;
    _currentYear = _current.year;
    _currentMonth = _current.month;
    _currentDate = _current.day;
    _currentHours = _current.hour;
    _currentMinutes = _current.minute;
    _formatter = DateFormat().add_d();
    _formatter1 = DateFormat().add_j();
    _formatter2 = DateFormat().add_m();
    _formatter3 = DateFormat().add_MMM();
    _formatter4 = DateFormat().add_y();
    _timeInterval = DateTimeIntervalType.years;
    _format = DateFormat.y();
    _isYear = true;
    _isMonth = false;
    _isDay = false;
    _isHours = false;
    _isMinutes = false;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _random = Random.secure();
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _isYear = true;
      _isMonth = false;
      _isDay = false;
      _isHours = false;
      _isMinutes = false;
    });
    _bottomPadding = isCardView ? 0 : 50;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, _bottomPadding),
        child: Container(child: _buildCartesianChart(false, _chartData)),
      ),
      floatingActionButton: isCardView ? null : _segmentedControl(),
    );
  }

  /// Get the format picker.
  Widget _segmentedControl() => SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Container(
      foregroundDecoration: const BoxDecoration(shape: BoxShape.circle),
      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
      child: CupertinoSegmentedControl<int>(
        selectedColor: model.primaryColor,
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
      ),
    ),
  );

  /// Change the label format.
  void _changeAxisLabel(int index) {
    switch (index) {
      case 0:
        _chartData = <_LabelData>[];
        _chartData = _buildYearData();
        break;
      case 1:
        _chartData = <_LabelData>[];
        _chartData = _buildMonthData();
        break;
      case 2:
        _chartData = <_LabelData>[];
        _chartData = _buildDaysData();
        break;
      case 3:
        _chartData = <_LabelData>[];
        _chartData = _buildHourData();
        break;
      case 4:
        _chartData = <_LabelData>[];
        _chartData = _buildMinData();
        break;
      default:
        _chartData = <_LabelData>[];
        _chartData = _buildYearData();
    }
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart(
    bool isTileView, [
    List<_LabelData>? data,
  ]) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        interval: 1,
        intervalType: _timeInterval,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: _format,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          if (details.axis is DateTimeAxis &&
              _isYear &&
              _formatter4.format(_current) == details.text) {
            return ChartAxisLabel(
              'Current\nYear',
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            );
          } else if (details.axis is DateTimeAxis &&
              _isMonth &&
              _formatter3.format(_current) == details.text) {
            return ChartAxisLabel(
              'Current\nMonth',
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            );
          } else if (details.axis is DateTimeAxis &&
              _isDay &&
              _formatter.format(_current) == details.text) {
            return ChartAxisLabel(
              'Today',
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            );
          } else if (details.axis is DateTimeAxis &&
              _isHours &&
              _formatter1.format(_current) == details.text) {
            return ChartAxisLabel(
              'Current\nHour',
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            );
          } else if (details.axis is DateTimeAxis &&
              _isMinutes &&
              _formatter2.format(_current) == details.text) {
            return ChartAxisLabel(
              'Now',
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            );
          } else {
            return ChartAxisLabel(details.text, null);
          }
        },
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_LabelData, DateTime>> _buildLineSeries() {
    return <LineSeries<_LabelData, DateTime>>[
      LineSeries<_LabelData, DateTime>(
        dataSource: isCardView ? _tileViewData : _chartData,
        xValueMapper: (_LabelData sales, int index) => sales.x,
        yValueMapper: (_LabelData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  int _createRandomIntData(int min, int max) {
    return min + _random.nextInt(max - min);
  }

  /// Get the current date time.
  void _updateCurrentTime() {
    _current = DateTime.now();
    _currentYear = _current.year;
    _currentMonth = _current.month;
    _currentDate = _current.day;
    _currentHours = _current.hour;
    _currentMinutes = _current.minute;
  }

  /// Set the date time bool values.
  void _updateTimeVisibility(String time) {
    switch (time) {
      case 'year':
        _isYear = true;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMinutes = false;
        break;
      case 'month':
        _isYear = false;
        _isMonth = true;
        _isDay = false;
        _isHours = false;
        _isMinutes = false;
        break;
      case 'day':
        _isYear = false;
        _isMonth = false;
        _isDay = true;
        _isHours = false;
        _isMinutes = false;
        break;
      case 'hours':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = true;
        _isMinutes = false;
        break;
      case 'min':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMinutes = true;
        break;
    }
  }

  /// It returns the data for year to the Chart data source.
  List<_LabelData> _buildYearData() {
    _updateTimeVisibility('year');
    _updateCurrentTime();
    _timeInterval = DateTimeIntervalType.years;
    _format = DateFormat.y();
    int temp = _currentYear;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(_LabelData(DateTime(temp), _createRandomIntData(10, 100)));
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for month to the Chart data source.
  List<_LabelData> _buildMonthData() {
    _updateTimeVisibility('month');
    _updateCurrentTime();
    _timeInterval = DateTimeIntervalType.months;
    _format = DateFormat.MMM();
    int temp = _currentMonth;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(
        _LabelData(DateTime(_currentYear, temp), _createRandomIntData(10, 100)),
      );
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for days to the Chart data source.
  List<_LabelData> _buildDaysData() {
    _updateTimeVisibility('day');
    _updateCurrentTime();
    _timeInterval = DateTimeIntervalType.days;
    _format = DateFormat.d();
    int temp = _currentDate;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(
        _LabelData(
          DateTime(_currentYear, _currentMonth, temp),
          _createRandomIntData(10, 100),
        ),
      );
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for hour to the Chart data source.
  List<_LabelData> _buildHourData() {
    _updateTimeVisibility('hours');
    _updateCurrentTime();
    _timeInterval = DateTimeIntervalType.hours;
    _format = DateFormat.j();
    int temp = _currentHours;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(
        _LabelData(
          DateTime(_currentYear, _currentMonth, _currentDate, temp),
          _createRandomIntData(10, 100),
        ),
      );
      temp = temp - 1;
    }
    return _chartData;
  }

  /// It returns the data for minutes to the Chart data source.
  List<_LabelData> _buildMinData() {
    _updateTimeVisibility('min');
    _updateCurrentTime();
    _timeInterval = DateTimeIntervalType.minutes;
    _format = DateFormat.m();
    int temp = _currentMinutes;
    for (int itr = _count; itr > 0; itr--) {
      _chartData.add(
        _LabelData(
          DateTime(
            _currentYear,
            _currentMonth,
            _currentDate,
            _currentHours,
            temp,
          ),
          _createRandomIntData(10, 100),
        ),
      );
      temp = temp - 1;
    }
    return _chartData;
  }

  @override
  void dispose() {
    _chartData.clear();
    _tileViewData.clear();
    super.dispose();
  }
}

class _LabelData {
  _LabelData(this.x, this.y);
  final DateTime x;
  final num y;
}
