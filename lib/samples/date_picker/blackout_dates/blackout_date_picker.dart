import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

//ignore: must_be_immutable
class BlackoutDatePicker extends StatefulWidget {
  BlackoutDatePicker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BlackoutDatePickerState createState() => _BlackoutDatePickerState(sample);
}

class _BlackoutDatePickerState extends State<BlackoutDatePicker> {
  _BlackoutDatePickerState(this.sample);

  final SubItem sample;
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
        DateTime.now().subtract(const Duration(days: 200));
    final DateTime endDate = DateTime.now().add(const Duration(days: 200));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(Duration(days: random.nextInt(3)))) {
      dates.add(date);
    }

    return dates;
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          final Widget _cardView = Card(
            elevation: 10,
            margin: const EdgeInsets.all(30),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Container(child: getBlackoutDatePicker(_blackoutDates)),
            ),
          );
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Column(children: <Widget>[
                Expanded(
                    flex: 8,
                    child: kIsWeb
                        ? Center(
                            child: Container(
                                width: 500, height: 500, child: _cardView))
                        : _cardView),
                Expanded(flex: 2, child: Container())
              ]));
        });
  }
}

SfDateRangePicker getBlackoutDatePicker([List<DateTime> dates]) {
  return SfDateRangePicker(
    monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(
            color: Colors.red, decoration: TextDecoration.lineThrough)),
    monthViewSettings: DateRangePickerMonthViewSettings(
        showTrailingAndLeadingDates: true, blackoutDates: dates),
  );
}
