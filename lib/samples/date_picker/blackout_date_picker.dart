/// Dart import
import 'dart:math';

///Package import
import 'package:flutter/material.dart';

///Date picker imports
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

///Local import
import '../../model/sample_view.dart';

/// Renders datepicker for blackout
class BlackoutDatePicker extends SampleView {
  /// Creates datepicker for blackout
  const BlackoutDatePicker(Key key) : super(key: key);

  @override
  _BlackoutDatePickerState createState() => _BlackoutDatePickerState();
}

class _BlackoutDatePickerState extends SampleViewState {
  _BlackoutDatePickerState();

  late List<DateTime> _blackoutDates;
  late Orientation _deviceOrientation;

  @override
  void initState() {
    _blackoutDates = _getBlackoutDates();
    super.initState();
  }

  /// Returns the list of dates that set to the blackout dates property of
  /// date range picker.
  List<DateTime> _getBlackoutDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 500));
    final DateTime endDate = DateTime.now().add(const Duration(days: 500));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(Duration(days: random.nextInt(25)))) {
      dates.add(date);
    }

    return dates;
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget cardView = Card(
      elevation: 10,
      margin: model.isWebFullView
          ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
          : const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        color: model.cardThemeColor,
        child: Theme(
            data: model.themeData.copyWith(accentColor: model.backgroundColor),
            child: _getBlackoutDatePicker()),
      ),
    );
    return Scaffold(
        backgroundColor: model.themeData == null ||
                model.themeData.brightness == Brightness.light
            ? null
            : const Color(0x00171a21),
        body: Column(children: <Widget>[
          Expanded(
              flex: model.isWebFullView ? 9 : 8,
              child: model.isWebFullView
                  ? Center(
                      child:
                          Container(width: 400, height: 600, child: cardView))
                  : ListView(children: <Widget>[
                      Container(
                        height: 450,
                        child: cardView,
                      )
                    ])),
          Expanded(
              flex: model.isWebFullView
                  ? 1
                  : model.isMobileResolution &&
                          _deviceOrientation == Orientation.landscape
                      ? 0
                      : 1,
              child: Container())
        ]));
  }

  /// Returns the date range picker widget based on the properties passed.
  SfDateRangePicker _getBlackoutDatePicker() {
    return SfDateRangePicker(
      monthCellStyle: const DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: TextStyle(
              color: Colors.red, decoration: TextDecoration.lineThrough)),
      monthViewSettings: DateRangePickerMonthViewSettings(
          showTrailingAndLeadingDates: true, blackoutDates: _blackoutDates),
      showNavigationArrow: model.isWebFullView,
    );
  }
}
