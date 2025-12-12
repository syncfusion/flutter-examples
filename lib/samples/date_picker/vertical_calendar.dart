/// Package import.
import 'package:flutter/material.dart';

/// Date picker import.
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Renders date picker using a vertical calender.
class VerticalCalendar extends SampleView {
  /// Creates date picker using a vertical calender.
  const VerticalCalendar(Key key) : super(key: key);

  @override
  _VerticalCalendarPickerState createState() => _VerticalCalendarPickerState();
}

class _VerticalCalendarPickerState extends SampleViewState {
  _VerticalCalendarPickerState();

  DateRangePickerNavigationMode _navigationMode =
      DateRangePickerNavigationMode.scroll;
  String _navigationModeString = 'scroll';
  final List<String> _navigationModeList = <String>[
    'none',
    'snap',
    'scroll',
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
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Navigation mode',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _navigationModeString,
                    items: _navigationModeList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'scroll',
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onNavigationModeChange(value);
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: propertyOptions,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Container(
      height: 550,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: model.sampleOutputCardColor,
      child: Theme(
        data: model.themeData.copyWith(
          colorScheme: model.themeData.colorScheme.copyWith(
            secondary: model.primaryColor,
          ),
        ),
        child: _buildVerticalCalendar(),
      ),
    );
    final Widget cardView = Card(
      elevation: 10,
      margin: model.isWebFullView
          ? const EdgeInsets.fromLTRB(30, 20, 30, 10)
          : const EdgeInsets.fromLTRB(30, 30, 30, 10),
      child: model.isWebFullView
          ? ListView(children: <Widget>[calendar])
          : calendar,
    );
    return Scaffold(
      backgroundColor:
          model.themeData == null ||
              model.themeData.colorScheme.brightness == Brightness.light
          ? null
          : const Color(0x00171a21),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: model.isWebFullView
                ? Center(
                    child: SizedBox(
                      width: 400,
                      height: 580, // 580 defines 550 height and 30 margin.
                      child: cardView,
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 590, // 590 defines 550 height and 40 margin.
                        child: cardView,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _onNavigationModeChange(String value) {
    _navigationModeString = value;
    if (value == 'none') {
      _navigationMode = DateRangePickerNavigationMode.none;
    } else if (value == 'snap') {
      _navigationMode = DateRangePickerNavigationMode.snap;
    } else if (value == 'scroll') {
      _navigationMode = DateRangePickerNavigationMode.scroll;
    }

    setState(() {
      /// Update the date range picker navigation mode changes.
    });
  }

  /// Returns the date range picker widget based on the properties passed.
  SfDateRangePicker _buildVerticalCalendar() {
    return SfDateRangePicker(
      enableMultiView: true,
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: model.sampleOutputCardColor,
      ),
      navigationDirection: DateRangePickerNavigationDirection.vertical,
      selectionMode: DateRangePickerSelectionMode.multiRange,
      monthViewSettings: const DateRangePickerMonthViewSettings(
        enableSwipeSelection: false,
      ),
      showNavigationArrow: model.isWebFullView,
      navigationMode: _navigationMode,
    );
  }
}
