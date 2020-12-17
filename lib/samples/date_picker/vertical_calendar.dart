///Package import
import 'package:flutter/material.dart';

///Date picker imports
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

///Local import
import '../../model/sample_view.dart';

/// Renders datepicker for blackout
class VerticalCalendar extends SampleView {
  /// Creates datepicker for blackout
  const VerticalCalendar(Key key) : super(key: key);

  @override
  _VerticalCalendarPickerState createState() => _VerticalCalendarPickerState();
}

class _VerticalCalendarPickerState extends SampleViewState {
  _VerticalCalendarPickerState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build([BuildContext context]) {
    final Widget calendar = Container(
      height: 550,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: model.cardThemeColor,
      child: Theme(
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getVerticalCalendar(),
      ),
    );
    final Widget _cardView = Card(
        elevation: 10,
        margin: model.isWeb
            ? const EdgeInsets.fromLTRB(30, 20, 30, 10)
            : const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: model.isWeb ? ListView(children: [calendar]) : calendar);
    return Scaffold(
        backgroundColor: model.themeData == null ||
                model.themeData.brightness == Brightness.light
            ? null
            : const Color(0x171A21),
        body: Column(children: <Widget>[
          Expanded(
              flex: 9,
              child: model.isWeb
                  ? Center(
                      child:

                          /// 580 defines 550 height and 30 margin
                          Container(width: 400, height: 580, child: _cardView))

                  /// 590 defines 550 height and 40 margin
                  : ListView(children: <Widget>[
                      Container(
                        height: 590,
                        child: _cardView,
                      )
                    ]))
        ]));
  }

  /// Returns the date range picker widget based on the properties passed.
  SfDateRangePicker _getVerticalCalendar() {
    return SfDateRangePicker(
      enableMultiView: true,
      navigationDirection: DateRangePickerNavigationDirection.vertical,
      selectionMode: DateRangePickerSelectionMode.multiRange,
      showNavigationArrow: model.isWeb,
    );
  }
}
