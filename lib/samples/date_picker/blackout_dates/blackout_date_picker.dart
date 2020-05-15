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

  Widget sampleWidget(SampleModel model) => BlackoutDatePicker();

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
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          final Widget _cardView = Card(
            elevation: 10,
            margin: model.isWeb
                ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
                : const EdgeInsets.all(30),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              color: model.cardThemeColor,
              child: getBlackoutDatePicker(_blackoutDates),
            ),
          );
          return Scaffold(
              backgroundColor: model.themeData == null ||
                      model.themeData.brightness == Brightness.light
                  ? null
                  : Colors.black,
              body: Column(children: <Widget>[
                Expanded(
                    flex: model.isWeb ? 9 : 8,
                    child: kIsWeb
                        ? Center(
                            child: Container(
                                width: 400, height: 600, child: _cardView))
                        : _cardView),
                Expanded(flex: model.isWeb ? 1 : 2, child: Container())
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
