import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

//ignore: must_be_immutable
class CustomizedDatePicker extends StatefulWidget {
  CustomizedDatePicker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _CustomizedDatePickerState createState() =>
      _CustomizedDatePickerState(sample);
}

class _CustomizedDatePickerState extends State<CustomizedDatePicker> {
  _CustomizedDatePickerState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<DateTime> _blackoutDates;
  List<DateTime> _specialDates;

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    _blackoutDates = _getBlackoutDates();
    _specialDates = _getSpecialDates();
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  List<DateTime> _getBlackoutDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 1000));
    final DateTime endDate = DateTime.now().add(const Duration(days: 1000));
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 30))) {
      dates.add(date);
    }

    return dates;
  }

  List<DateTime> _getSpecialDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 990));
    final DateTime endDate = DateTime.now().add(const Duration(days: 990));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 25))) {
      for (int i = 0; i < 3; i++) {
        dates.add(date.add(Duration(days: random.nextInt(i + 4))));
      }
    }

    return dates;
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(CustomizedDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          final Widget _datePicker = Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(30),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Container(
                        child: getCustomizedDatePicker(
                            _blackoutDates, _specialDates, model.themeData)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  color: Colors.green,
                                  size: 10,
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text('Special dates'))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  color: Colors.red,
                                  size: 10,
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text('Blackout dates'))
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.brightness_1,
                                      color: const Color(0xFFDFDFDF),
                                      size: 10,
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Text('Weekend dates'))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          );
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: kIsWeb
                ? Center(
                    child:
                        Container(width: 500, height: 500, child: _datePicker))
                : _datePicker,
          );
        });
  }
}

SfDateRangePicker getCustomizedDatePicker(
    [List<DateTime> blackoutDates,
    List<DateTime> specialDates,
    ThemeData theme]) {
  return SfDateRangePicker(
    headerStyle: DateRangePickerHeaderStyle(textAlign: TextAlign.center),
    monthCellStyle: DateRangePickerMonthCellStyle(
      weekendDatesDecoration: BoxDecoration(
          color: theme == null || theme.brightness == Brightness.light
              ? const Color(0xFFDFDFDF)
              : const Color(0xFF6F6F6F),
          border: Border.all(
              color: theme == null || theme.brightness == Brightness.light
                  ? const Color(0xFFB6B6B6)
                  : const Color(0xFF6F6F6F),
              width: 1),
          shape: BoxShape.circle),
      specialDatesDecoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: const Color(0xFF2B732F), width: 1),
          shape: BoxShape.circle),
      blackoutDatesDecoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: const Color(0xFFF44436), width: 1),
          shape: BoxShape.circle),
      blackoutDateTextStyle: TextStyle(
          color: Colors.white, decoration: TextDecoration.lineThrough),
      specialDatesTextStyle: const TextStyle(color: Colors.white),
    ),
    showNavigationArrow: true,
    monthViewSettings: DateRangePickerMonthViewSettings(
      showTrailingAndLeadingDates: false,
      blackoutDates: blackoutDates,
      specialDates: specialDates,
    ),
  );
}
