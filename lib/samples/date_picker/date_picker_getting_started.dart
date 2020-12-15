///Package import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Date picker imports
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

///Local import
import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'popup_picker.dart';

/// Render getting started datepicker widget
class GettingStartedDatePicker extends SampleView {
  /// Creates datepicker widget with customized options
  const GettingStartedDatePicker(Key key) : super(key: key);

  @override
  _GettingStartedDatePickerState createState() =>
      _GettingStartedDatePickerState();
}

class _GettingStartedDatePickerState extends SampleViewState {
  _GettingStartedDatePickerState();

  DateRangePickerController _controller;
  DateRangePickerSelectionMode _selectionMode;
  bool _showTrailingAndLeadingDates;
  bool _enablePastDates;
  bool _enableSwipingSelection;
  bool _enableViewNavigation;
  bool _isWeb;
  Orientation _deviceOrientation;

  String _selectionModeString;
  final List<String> _selectionModeList = <String>[
    'Single',
    'Multiple',
    'Range',
    'Multi Range',
  ].toList();

  String _viewModeString;
  final List<String> _viewModeList = <String>[
    'Month',
    'Year',
    'Decade',
    'Century',
  ].toList();

  @override
  void initState() {
    _controller = DateRangePickerController();
    _selectionMode = DateRangePickerSelectionMode.range;
    _showTrailingAndLeadingDates = true;
    _enablePastDates = true;
    _enableSwipingSelection = true;
    _enableViewNavigation = true;
    _selectionModeString = 'Range';
    _viewModeString = 'Month';
    _controller.view = DateRangePickerView.month;
    _controller.displayDate = DateTime.now();
    _controller.selectedDate = DateTime.now();
    _controller.selectedDates = <DateTime>[
      DateTime.now(),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 2))
    ];
    _controller.selectedRange = PickerDateRange(
        DateTime.now().subtract(const Duration(days: 2)),
        DateTime.now().add(const Duration(days: 2)));
    _controller.selectedRanges = <PickerDateRange>[
      PickerDateRange(DateTime.now().subtract(const Duration(days: 2)),
          DateTime.now().add(const Duration(days: 2))),
      PickerDateRange(DateTime.now().add(const Duration(days: 8)),
          DateTime.now().add(const Duration(days: 12))),
      PickerDateRange(DateTime.now().add(const Duration(days: 15)),
          DateTime.now().add(const Duration(days: 20))),
      PickerDateRange(DateTime.now().add(const Duration(days: 22)),
          DateTime.now().add(const Duration(days: 27)))
    ];
    _isWeb = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //// Extra small devices (phones, 600px and down)
//// @media only screen and (max-width: 600px) {...}
////
//// Small devices (portrait tablets and large phones, 600px and up)
//// @media only screen and (min-width: 600px) {...}
////
//// Medium devices (landscape tablets, 768px and up)
//// media only screen and (min-width: 768px) {...}
////
//// Large devices (laptops/desktops, 992px and up)
//// media only screen and (min-width: 992px) {...}
////
//// Extra large devices (large laptops and desktops, 1200px and up)
//// media only screen and (min-width: 1200px) {...}
//// Default width to render the mobile UI in web, if the device width exceeds
//// the given width agenda view will render the web UI.
    _isWeb = MediaQuery.of(context).size.width > 767;
    _deviceOrientation = MediaQuery.of(context).orientation;

    super.didChangeDependencies();
  }

  @override
  Widget build([BuildContext context]) {
    final bool _enableMultiView = _isWeb &&
        (_selectionMode == DateRangePickerSelectionMode.range ||
            _selectionMode == DateRangePickerSelectionMode.multiRange);
    final Widget cardView = Card(
        elevation: 10,
        margin: model.isWeb
            ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
            : const EdgeInsets.all(30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          color: model.cardThemeColor,
          child: Theme(
              data:
                  model.themeData.copyWith(accentColor: model.backgroundColor),
              child: _getGettingStartedDatePicker(
                  _controller,
                  _selectionMode,
                  _showTrailingAndLeadingDates,
                  _enablePastDates,
                  _enableSwipingSelection,
                  _enableViewNavigation,
                  DateTime.now().subtract(const Duration(days: 200)),
                  DateTime.now().add(const Duration(days: 200)),
                  _enableMultiView)),
        ));
    return Scaffold(
      backgroundColor: model.themeData == null ||
              model.themeData.brightness == Brightness.light
          ? null
          : const Color(0x171A21),
      body: Column(children: <Widget>[
        Expanded(
            flex: model.isWeb ? 9 : 8,
            child: model.isWeb
                ? Center(
                    child: Container(
                        width: !_enableMultiView ? 400 : 700,
                        height: 600,
                        child: cardView))
                : ListView(children: <Widget>[
                    Container(
                      height: 450,
                      child: cardView,
                    )
                  ])),
        Expanded(
            flex: model.isWeb
                ? 1
                : model.isMobileResolution &&
                        _deviceOrientation == Orientation.landscape
                    ? 0
                    : 1,
            child: Container())
      ]),
    );
  }

  /// To change the date range picker view to the selected view, the view which
  /// selected in the dropdown menu set to the view property of the controller.
  void onPickerViewChange(String value) {
    _viewModeString = value;
    if (value == 'Month') {
      _controller.view = DateRangePickerView.month;
    } else if (value == 'Year') {
      _controller.view = DateRangePickerView.year;
    } else if (value == 'Decade') {
      _controller.view = DateRangePickerView.decade;
    } else if (value == 'Century') {
      _controller.view = DateRangePickerView.century;
    }
    setState(() {
      /// update the date range picker view changes
    });
  }

  /// To change the date range picker selection mode to the selected mode, the
  /// mode which selected in the dropdown menu set to the selection mode property,
  /// which is set to the selection mode property of date range picker.
  void onSelectionModeChange(String value) {
    _selectionModeString = value;
    if (value == 'Single') {
      _selectionMode = DateRangePickerSelectionMode.single;
    } else if (value == 'Multiple') {
      _selectionMode = DateRangePickerSelectionMode.multiple;
    } else if (value == 'Range') {
      _selectionMode = DateRangePickerSelectionMode.range;
    } else if (value == 'Multi Range') {
      _selectionMode = DateRangePickerSelectionMode.multiRange;
    }
    setState(() {
      /// update the date range picker selection mode changes
    });
  }

  /// Handled to update the boolean values from the property window, whenever the
  /// boolean value changed it's value set the corresponding property of date range
  /// picker.
  void onBoolValueChange(String property, bool value) {
    if (property == 'ShowLeadingTrailingDates') {
      _showTrailingAndLeadingDates = value;
    } else if (property == 'EnablePastDates') {
      _enablePastDates = value;
    } else if (property == 'EnableSwipingSelection') {
      _enableSwipingSelection = value;
    } else if (property == 'EnableViewNavigation') {
      _enableViewNavigation = value;
    }
    setState(() {
      /// update the bool value changes
    });
  }

  @override
  Widget buildSettings([BuildContext context]) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      List<Widget> propertyOptions = <Widget>[];
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Picker view',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline: Container(color: Color(0xFFBDBDBD), height: 1),
                    value: _viewModeString,
                    items: _viewModeList.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'Month',
                          child: Text('$value',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      onPickerViewChange(value);
                      stateSetter(() {});
                    }),
              ),
            )
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Selection mode',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline: Container(color: Color(0xFFBDBDBD), height: 1),
                    value: _selectionModeString,
                    items: _selectionModeList.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'Range',
                          child: Text('$value',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      onSelectionModeChange(value);
                      stateSetter(() {});
                    }),
              ),
            )
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Display date',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.centerLeft,
                  child: Theme(
                      data: model.themeData.copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: _DateRangePickerOption(
                          _onDisplayDateChanged, _controller.displayDate, model,
                          displayDate: _controller.displayDate)),
                ))
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Enable view navigation',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _enableViewNavigation,
                              onChanged: (bool value) {
                                setState(() {
                                  onBoolValueChange(
                                      'EnableViewNavigation', value);
                                  stateSetter(() {});
                                });
                              },
                              activeColor: model.backgroundColor,
                            ))),
                  ),
                ))
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Show trailing/leading dates',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _showTrailingAndLeadingDates,
                              onChanged: (dynamic value) {
                                onBoolValueChange(
                                    'ShowLeadingTrailingDates', value);
                                stateSetter(() {});
                              },
                              activeColor: model.backgroundColor,
                            ))),
                  ),
                ))
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Enable past dates',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _enablePastDates,
                              onChanged: (dynamic value) {
                                onBoolValueChange('EnablePastDates', value);
                                stateSetter(() {});
                              },
                              activeColor: model.backgroundColor,
                            ))),
                  ),
                ))
          ],
        ),
      ));
      propertyOptions.add(Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text('Enable swipe selection',
                    style: TextStyle(fontSize: 16.0, color: model.textColor))),
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _enableSwipingSelection,
                              onChanged: (dynamic value) {
                                setState(() {
                                  onBoolValueChange(
                                      'EnableSwipingSelection', value);
                                  stateSetter(() {});
                                });
                              },
                              activeColor: model.backgroundColor,
                            ))),
                  ),
                ))
          ],
        ),
      ));
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
        child: model.isWeb
            ? Column(
                children: propertyOptions,
              )
            : ListView(
                children: propertyOptions,
              ),
      );
    });
  }

  /// Updates the display for date range picker by setting the selected date value
  /// to the display date property of controller.
  void _onDisplayDateChanged(DateRangePickerSelectionChangedArgs details) {
    setState(() {
      _controller.displayDate = details.value;
    });
  }
}

/// Builds the date range picker in a pop-up window, to select the display date
/// property for the date range picker, in the property window.
class _DateRangePickerOption extends StatefulWidget {
  const _DateRangePickerOption(this.selectionChanged, this.date, this.model,
      {this.displayDate});

  final DateRangePickerSelectionChangedCallback selectionChanged;
  final DateTime date;
  final DateTime displayDate;
  final SampleModel model;

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerOptionState();
  }
}

class _DateRangePickerOptionState extends State<_DateRangePickerOption> {
  DateTime _date;

  @override
  void initState() {
    _date = widget.date;
    super.initState();
  }

  /// Updates the selected date value to the date range pickers selected
  /// property
  void _onSelectionChanged(DateTime value) {
    setState(() {
      _date = value;
    });

    if (widget.selectionChanged != null) {
      widget.selectionChanged(DateRangePickerSelectionChangedArgs(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
        color: Colors.transparent,
        child: GestureDetector(
            child: Text(DateFormat('dd-MM-yyyy').format(_date),
                style: TextStyle(
                    fontSize: 15,
                    color: theme.textTheme.subtitle2.color,
                    fontWeight: FontWeight.w600)),
            onTap: () async {
              final DateTime result = await showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                        data: theme,
                        child: DateRangePicker(
                          _date,
                          null,
                          minDate: DateTime.now()
                              .subtract(const Duration(days: 200)),
                          maxDate:
                              DateTime.now().add(const Duration(days: 200)),
                          displayDate: _date,
                          model: widget.model,
                        ));
                  });

              if (result != null) {
                _onSelectionChanged(result);
              }
            }));
  }
}

/// Returns the date range picker based on the properties passed
SfDateRangePicker _getGettingStartedDatePicker(
    [DateRangePickerController controller,
    DateRangePickerSelectionMode mode,
    bool showLeading,
    bool enablePastDates,
    bool enableSwipingSelection,
    bool enableViewNavigation,
    DateTime minDate,
    DateTime maxDate,
    bool enableMultiView]) {
  return SfDateRangePicker(
    enablePastDates: enablePastDates,
    minDate: minDate,
    maxDate: maxDate,
    enableMultiView: enableMultiView,
    allowViewNavigation: enableViewNavigation,
    selectionMode: mode,
    controller: controller,
    monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: enableSwipingSelection,
        showTrailingAndLeadingDates: showLeading ?? false),
  );
}
