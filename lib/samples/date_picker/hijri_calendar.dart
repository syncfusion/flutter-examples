/// Package import.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// core import.
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

/// Date picker import.
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// Local imports.
import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'popup_picker.dart';

/// Renders a date picker widget using the Hijri calendar.
class HijriDatePicker extends SampleView {
  /// Creates a date picker widget with customized options for the Hijri calendar.
  const HijriDatePicker(Key key) : super(key: key);

  @override
  _HijriDatePickerState createState() => _HijriDatePickerState();
}

class _HijriDatePickerState extends SampleViewState {
  _HijriDatePickerState();

  late Orientation _deviceOrientation;

  final HijriDatePickerController _controller = HijriDatePickerController();
  DateRangePickerSelectionMode _selectionMode =
      DateRangePickerSelectionMode.extendableRange;
  ExtendableRangeSelectionDirection _selectionDirection =
      ExtendableRangeSelectionDirection.both;
  bool _enablePastDates = true;
  bool _enableSwipingSelection = true;
  bool _enableViewNavigation = true;
  bool _showActionButtons = true;
  bool _isWeb = false;
  bool _showWeekNumber = false;
  bool _showTodayButton = true;

  String _selectionModeString = 'extendableRange';
  final List<String> _selectionModeList = <String>[
    'single',
    'multiple',
    'range',
    'multiRange',
    'extendableRange',
  ].toList();

  String _viewModeString = 'month';
  final List<String> _viewModeList = <String>[
    'month',
    'year',
    'decade',
  ].toList();

  String _selectionDirectionString = 'both';
  final List<String> _selectionDirectionList = <String>[
    'forward',
    'backward',
    'both',
    'none',
  ].toList();

  @override
  void initState() {
    _controller.view = HijriDatePickerView.month;
    _controller.displayDate = HijriDateTime.now();
    _controller.selectedDate = HijriDateTime.now();
    _controller.selectedDates = <HijriDateTime>[
      HijriDateTime.now(),
      HijriDateTime.now().add(const Duration(days: 2)),
      HijriDateTime.now().subtract(const Duration(days: 2)),
    ];
    _controller.selectedRange = HijriDateRange(
      HijriDateTime.now().subtract(const Duration(days: 2)),
      HijriDateTime.now().add(const Duration(days: 2)),
    );
    _controller.selectedRanges = <HijriDateRange>[
      HijriDateRange(
        HijriDateTime.now().subtract(const Duration(days: 2)),
        HijriDateTime.now().add(const Duration(days: 2)),
      ),
      HijriDateRange(
        HijriDateTime.now().add(const Duration(days: 8)),
        HijriDateTime.now().add(const Duration(days: 12)),
      ),
      HijriDateRange(
        HijriDateTime.now().add(const Duration(days: 15)),
        HijriDateTime.now().add(const Duration(days: 20)),
      ),
      HijriDateRange(
        HijriDateTime.now().add(const Duration(days: 22)),
        HijriDateTime.now().add(const Duration(days: 27)),
      ),
    ];
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
  Widget build(BuildContext context) {
    final bool enableMultiView =
        _isWeb &&
        (_selectionMode == DateRangePickerSelectionMode.range ||
            _selectionMode == DateRangePickerSelectionMode.multiRange ||
            _selectionMode == DateRangePickerSelectionMode.extendableRange);
    final Widget cardView = Card(
      elevation: 10,
      margin: model.isWebFullView
          ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
          : const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        color: model.sampleOutputCardColor,
        child: Theme(
          data: model.themeData.copyWith(
            colorScheme: model.themeData.colorScheme.copyWith(
              secondary: model.primaryColor,
            ),
          ),
          child: _buildGettingStartedDatePicker(
            _controller,
            _selectionMode,
            _enablePastDates,
            _enableSwipingSelection,
            _enableViewNavigation,
            _showActionButtons,
            HijriDateTime.now().subtract(const Duration(days: 200)),
            HijriDateTime.now().add(const Duration(days: 200)),
            enableMultiView,
            _showWeekNumber,
            _showTodayButton,
            _selectionDirection,
            context,
          ),
        ),
      ),
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
            flex: model.isWebFullView ? 9 : 8,
            child: model.isWebFullView
                ? Center(
                    child: SizedBox(
                      width: !enableMultiView ? 550 : 700,
                      height: 600,
                      child: cardView,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[SizedBox(height: 450, child: cardView)],
                  ),
          ),
          Expanded(
            flex: model.isWebFullView
                ? 1
                : model.isMobileResolution &&
                      _deviceOrientation == Orientation.landscape
                ? 0
                : 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  /// To change the date range picker view to the selected view, the view which
  /// selected in the dropdown menu set to the view property of the controller.
  void _onPickerViewChange(String value) {
    _viewModeString = value;
    if (value == 'month') {
      _controller.view = HijriDatePickerView.month;
    } else if (value == 'year') {
      _controller.view = HijriDatePickerView.year;
    } else if (value == 'decade') {
      _controller.view = HijriDatePickerView.decade;
    }
    setState(() {
      /// update the date range picker view changes.
    });
  }

  void _onSelectionDirectionChanged(String value) {
    _selectionDirectionString = value;
    if (value == 'none') {
      _selectionDirection = ExtendableRangeSelectionDirection.none;
    } else if (value == 'forward') {
      _selectionDirection = ExtendableRangeSelectionDirection.forward;
    } else if (value == 'backward') {
      _selectionDirection = ExtendableRangeSelectionDirection.backward;
    } else if (value == 'both') {
      _selectionDirection = ExtendableRangeSelectionDirection.both;
    }
    setState(() {
      /// update the date range picker view changes.
    });
  }

  /// Updates the date range picker selection mode based on the selected value
  /// from the dropdown menu. The selected mode is applied to the
  /// selection mode property of the date range picker.
  void _onSelectionModeChange(String value) {
    _selectionModeString = value;
    if (value == 'single') {
      _selectionMode = DateRangePickerSelectionMode.single;
    } else if (value == 'multiple') {
      _selectionMode = DateRangePickerSelectionMode.multiple;
    } else if (value == 'range') {
      _selectionMode = DateRangePickerSelectionMode.range;
    } else if (value == 'multiRange') {
      _selectionMode = DateRangePickerSelectionMode.multiRange;
    } else if (value == 'extendableRange') {
      _selectionMode = DateRangePickerSelectionMode.extendableRange;
    }
    setState(() {
      /// update the date range picker selection mode changes.
    });
  }

  /// Updates the corresponding boolean properties of the date range picker
  /// whenever a value is changed in the property window.
  void _onBoolValueChange(String property, bool value) {
    if (property == 'EnablePastDates') {
      _enablePastDates = value;
    } else if (property == 'EnableSwipingSelection') {
      _enableSwipingSelection = value;
    } else if (property == 'EnableViewNavigation') {
      _enableViewNavigation = value;
    } else if (property == 'ShowActionButtons') {
      _showActionButtons = value;
    } else if (property == 'showWeekNumber') {
      _showWeekNumber = value;
    } else if (property == 'ShowTodayButton') {
      _showTodayButton = value;
    }
    setState(() {
      /// Apply the updated boolean property changes to the date range picker.
    });
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        final List<Widget> propertyOptions = <Widget>[];
        if (!model.isMobile) {
          _controller.addPropertyChangedListener((String value) {
            if (value == 'view') {
              if (_controller.view == HijriDatePickerView.month) {
                _viewModeString = 'month';
              } else if (_controller.view == HijriDatePickerView.year) {
                _viewModeString = 'year';
              } else if (_controller.view == HijriDatePickerView.decade) {
                _viewModeString = 'decade';
              }
              SchedulerBinding.instance.addPostFrameCallback((
                Duration timeStamp,
              ) {
                stateSetter(() {});
              });
            }
          });
        }

        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Picker view',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _viewModeString,
                  items: _viewModeList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'month',
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onPickerViewChange(value);
                    stateSetter(() {});
                  },
                ),
              ],
            ),
          ),
        );

        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Selection mode',
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectionModeString,
                  items: _selectionModeList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'extendableRange',
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onSelectionModeChange(value);
                    stateSetter(() {});
                  },
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          _selectionModeString == 'extendableRange'
              ? SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Selection Direction',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.textColor,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: model.drawerBackgroundColor,
                        focusColor: Colors.transparent,
                        underline: Container(
                          color: const Color(0xFFBDBDBD),
                          height: 1,
                        ),
                        value: _selectionDirectionString,
                        items: _selectionDirectionList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'both',
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: model.textColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onSelectionDirectionChanged(value);
                          stateSetter(() {});
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Display date',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: model.themeData.copyWith(
                    canvasColor: model.drawerBackgroundColor,
                  ),
                  child: _DateRangePickerOption(
                    _onDisplayDateChanged,
                    _controller.displayDate!,
                    model,
                    displayDate: _controller.displayDate!,
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Show action buttons',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _showActionButtons,
                      onChanged: (bool value) {
                        setState(() {
                          _onBoolValueChange('ShowActionButtons', value);
                          stateSetter(() {});
                        });
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Show today button',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _showTodayButton,
                      onChanged: (bool value) {
                        setState(() {
                          _onBoolValueChange('ShowTodayButton', value);
                          stateSetter(() {});
                        });
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Enable view navigation',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _enableViewNavigation,
                      onChanged: (bool value) {
                        setState(() {
                          _onBoolValueChange('EnableViewNavigation', value);
                          stateSetter(() {});
                        });
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Enable past dates',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _enablePastDates,
                      onChanged: (dynamic value) {
                        _onBoolValueChange('EnablePastDates', value);
                        stateSetter(() {});
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Enable swipe selection',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _enableSwipingSelection,
                      onChanged: (dynamic value) {
                        setState(() {
                          _onBoolValueChange('EnableSwipingSelection', value);
                          stateSetter(() {});
                        });
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        propertyOptions.add(
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Show week number',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: model.drawerBackgroundColor),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _showWeekNumber,
                      onChanged: (dynamic value) {
                        setState(() {
                          _onBoolValueChange('showWeekNumber', value);
                          stateSetter(() {});
                        });
                      },
                      activeTrackColor: model.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: model.isWebFullView
              ? Column(children: propertyOptions)
              : ListView(children: propertyOptions),
        );
      },
    );
  }

  /// Updates the display for date range picker by setting the selected date value
  /// to the display date property of controller.
  void _onDisplayDateChanged(DateRangePickerSelectionChangedArgs details) {
    setState(() {
      final dynamic date = details.value;
      if (date is HijriDateTime) {
        _controller.displayDate = date;
      }
    });
  }
}

/// Builds the date range picker in a pop-up window, to select the display date
/// property for the date range picker, in the property window.
class _DateRangePickerOption extends StatefulWidget {
  const _DateRangePickerOption(
    this.selectionChanged,
    this.date,
    this.model, {
    required this.displayDate,
  });

  final DateRangePickerSelectionChangedCallback selectionChanged;
  final HijriDateTime date;
  final HijriDateTime displayDate;
  final SampleModel model;

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerOptionState();
  }
}

class _DateRangePickerOptionState extends State<_DateRangePickerOption> {
  late HijriDateTime _date;

  @override
  void initState() {
    _date = widget.date;
    super.initState();
  }

  /// Updates the selected date value to the date range pickers selected
  /// property.
  void _onSelectionChanged(HijriDateTime value) {
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
        onTap: () async {
          final HijriDateTime? result = await showDialog<HijriDateTime>(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: theme,
                child: DateRangePicker(
                  _date,
                  null,
                  minDate: HijriDateTime.now().subtract(
                    const Duration(days: 200),
                  ),
                  maxDate: HijriDateTime.now().add(const Duration(days: 200)),
                  displayDate: _date,
                  model: widget.model,
                ),
              );
            },
          );

          if (result != null) {
            _onSelectionChanged(result);
          }
        },
        child: Text(
          _date.day.toString() +
              '-' +
              _date.month.toString() +
              '-' +
              _date.year.toString(),
          style: TextStyle(
            fontSize: 15,
            color: theme.textTheme.titleSmall?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Returns the date range picker based on the properties passed.
SfHijriDateRangePicker _buildGettingStartedDatePicker(
  HijriDatePickerController controller,
  DateRangePickerSelectionMode mode,
  bool enablePastDates,
  bool enableSwipingSelection,
  bool enableViewNavigation,
  bool showActionButtons,
  HijriDateTime minDate,
  HijriDateTime maxDate,
  bool enableMultiView,
  bool showWeekNumber,
  bool showTodayButton,
  ExtendableRangeSelectionDirection selectionDirection,
  BuildContext context,
) {
  return SfHijriDateRangePicker(
    enablePastDates: enablePastDates,
    minDate: minDate,
    maxDate: maxDate,
    enableMultiView: enableMultiView,
    allowViewNavigation: enableViewNavigation,
    showActionButtons: showActionButtons,
    selectionMode: mode,
    extendableRangeSelectionDirection: selectionDirection,
    controller: controller,
    showTodayButton: showTodayButton,
    headerStyle: DateRangePickerHeaderStyle(
      textAlign: enableMultiView ? TextAlign.center : TextAlign.left,
    ),
    onCancel: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selection Cancelled'),
          duration: Duration(milliseconds: 200),
        ),
      );
    },
    onSubmit: (Object? value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selection Confirmed'),
          duration: Duration(milliseconds: 200),
        ),
      );
    },
    monthViewSettings: HijriDatePickerMonthViewSettings(
      enableSwipeSelection: enableSwipingSelection,
      showWeekNumber: showWeekNumber,
    ),
  );
}
