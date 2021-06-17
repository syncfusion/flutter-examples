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

  DateRangePickerNavigationMode _navigationMode =
      DateRangePickerNavigationMode.scroll;
  String _navigationModeString = 'Scroll';
  final List<String> _navigationModeList = <String>[
    'None',
    'Snap',
    'Scroll',
  ].toList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      final List<Widget> propertyOptions = <Widget>[];
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Navigation mode',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _navigationModeString,
                    items: _navigationModeList.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'Scroll',
                          child: Text(value,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      onNavigationModeChange(value);
                      stateSetter(() {});
                    }),
              ),
            )
          ],
        ),
      ));
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
        child: model.isWebFullView
            ? Column(
                children: propertyOptions,
              )
            : ListView(
                children: propertyOptions,
              ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
        margin: model.isWebFullView
            ? const EdgeInsets.fromLTRB(30, 20, 30, 10)
            : const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: model.isWebFullView
            ? ListView(children: <Widget>[calendar])
            : calendar);
    return Scaffold(
        backgroundColor: model.themeData == null ||
                model.themeData.brightness == Brightness.light
            ? null
            : const Color(0x00171a21),
        body: Column(children: <Widget>[
          Expanded(
              flex: 9,
              child: model.isWebFullView
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

  void onNavigationModeChange(String value) {
    _navigationModeString = value;
    if (value == 'None') {
      _navigationMode = DateRangePickerNavigationMode.none;
    } else if (value == 'Snap') {
      _navigationMode = DateRangePickerNavigationMode.snap;
    } else if (value == 'Scroll') {
      _navigationMode = DateRangePickerNavigationMode.scroll;
    }

    setState(() {
      /// Update the date range picker navigation mode changes.
    });
  }

  /// Returns the date range picker widget based on the properties passed.
  SfDateRangePicker _getVerticalCalendar() {
    return SfDateRangePicker(
      enableMultiView: true,
      headerStyle:
          DateRangePickerHeaderStyle(backgroundColor: model.cardThemeColor),
      navigationDirection: DateRangePickerNavigationDirection.vertical,
      selectionMode: DateRangePickerSelectionMode.multiRange,
      monthViewSettings:
          const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
      showNavigationArrow: model.isWebFullView,
      navigationMode: _navigationMode,
    );
  }
}
