import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BlackoutDatePicker extends SampleView {
  const BlackoutDatePicker(Key key) : super(key: key);

  @override
  _BlackoutDatePickerState createState() => _BlackoutDatePickerState();
}

class _BlackoutDatePickerState extends SampleViewState {
  _BlackoutDatePickerState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<DateTime> _blackoutDates;

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _blackoutDates = _getBlackoutDates();
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(BlackoutDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

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
  Widget build([BuildContext context]) {
    final Widget _cardView = Card(
      elevation: 10,
      margin: model.isWeb
          ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
          : const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        color:
            model.isWeb ? model.webSampleBackgroundColor : model.cardThemeColor,
        child: Theme(
            data: model.themeData.copyWith(accentColor: model.backgroundColor),
            child: getBlackoutDatePicker(_blackoutDates)),
      ),
    );
    return Scaffold(
        backgroundColor: model.themeData == null ||
                model.themeData.brightness == Brightness.light
            ? null
            : const Color(0x171A21),
        body: Column(children: <Widget>[
          Expanded(
              flex: model.isWeb ? 9 : 8,
              child: kIsWeb
                  ? Center(
                      child:
                          Container(width: 400, height: 600, child: _cardView))
                  : _cardView),
          Expanded(flex: model.isWeb ? 1 : 2, child: Container())
        ]));
  }
}

SfDateRangePicker getBlackoutDatePicker([List<DateTime> dates]) {
  return SfDateRangePicker(
    monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: const TextStyle(
            color: Colors.red, decoration: TextDecoration.lineThrough)),
    monthViewSettings: DateRangePickerMonthViewSettings(
        showTrailingAndLeadingDates: true, blackoutDates: dates),
  );
}
