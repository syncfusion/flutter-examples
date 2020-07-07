import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/switch.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../widgets/customDropDown.dart';
import '../popup_picker/popup_picker.dart';

class GettingStartedDatePicker extends SampleView {
  const GettingStartedDatePicker(Key key) : super(key: key);

  @override
  _GettingStartedDatePickerState createState() =>
      _GettingStartedDatePickerState();
}

class _GettingStartedDatePickerState extends SampleViewState {
  _GettingStartedDatePickerState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  DateRangePickerController _controller;
  DateRangePickerSelectionMode _selectionMode;
  DateRangePickerView _view;
  bool _showTrailingAndLeadingDates;
  bool _enablePastDates;
  bool _enableSwipingSelection;
  bool _enableViewNavigation;
  bool _isWeb;

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
    initProperties();
    _isWeb = false;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _controller = DateRangePickerController();
    _selectionMode = DateRangePickerSelectionMode.range;
    _view = DateRangePickerView.month;
    _showTrailingAndLeadingDates = true;
    _enablePastDates = true;
    _enableSwipingSelection = true;
    _enableViewNavigation = true;
    _selectionModeString = 'Range';
    _viewModeString = 'Month';
    _controller.view = _view;
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
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'PickerView': _view,
        'View': _viewModeString,
        'SelectionMode': _selectionMode,
        'Selection': _selectionModeString,
        'ShowLeadingTrailingDates': _showTrailingAndLeadingDates,
        'EnablePastDates': _enablePastDates,
        'EnableSwipingSelection': _enableSwipingSelection,
        'EnableViewNavigation': _enableViewNavigation,
        'Controller': _controller
      });
    }
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(GettingStartedDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
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
    super.didChangeDependencies();
  }

  @override
  Widget build([BuildContext context]) {
    if (model != null && model.isWeb && model.properties.isEmpty) {
      initProperties(model, true);
    }

    final bool _enableMultiView = _isWeb &&
        (_selectionMode == DateRangePickerSelectionMode.range ||
            _selectionMode == DateRangePickerSelectionMode.multiRange);
    final Widget _cardView = Card(
        elevation: 10,
        margin: model.isWeb
            ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
            : const EdgeInsets.all(30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          color: model.isWeb
              ? model.webSampleBackgroundColor
              : model.cardThemeColor,
          child: Theme(
              data:
                  model.themeData.copyWith(accentColor: model.backgroundColor),
              child: getGettingStartedDatePicker(
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
                          child: _cardView))
                  : _cardView),
          Expanded(flex: model.isWeb ? 1 : 2, child: Container())
        ]),
        );
  }

  void onPickerViewChange(String value, SampleModel model) {
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

    model.properties['PickerView'] = _view;
    model.properties['View'] = _viewModeString;
    model.properties['Controller'] = _controller;
  }

  void onSelectionModeChange(String value, SampleModel model) {
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

    model.properties['SelectionMode'] = _selectionMode;
    model.properties['Selection'] = _selectionModeString;
    setState(() {});
  }

  void onBoolValueChange(String property, bool value, SampleModel model) {
    if (property == 'ShowLeadingTrailingDates') {
      _showTrailingAndLeadingDates = value;
      model.properties['ShowLeadingTrailingDates'] =
          _showTrailingAndLeadingDates;
    } else if (property == 'EnablePastDates') {
      _enablePastDates = value;
      model.properties['EnablePastDates'] = _enablePastDates;
    } else if (property == 'EnableSwipingSelection') {
      _enableSwipingSelection = value;
      model.properties['EnableSwipingSelection'] = _enableSwipingSelection;
    } else if (property == 'EnableViewNavigation') {
      _enableViewNavigation = value;
      model.properties['EnableViewNavigation'] = _enableViewNavigation;
    }

    setState(() {});
  }

  Widget buildSettings([BuildContext context]) {
    final ThemeData _theme = model.themeData;
    return ListView(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Picker view',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: _viewModeString,
                                item: _viewModeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'Month',
                                      child: Text('$value',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onPickerViewChange(value, model);
                                }),
                          ),
                        )))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Selection mode',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: model.bottomSheetBackgroundColor),
                            child: DropDown(
                                value: _selectionModeString,
                                item: _selectionModeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'Range',
                                      child: Text('$value',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  onSelectionModeChange(value, model);
                                }),
                          ),
                        )))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Display date',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Theme(
                          data: _theme.copyWith(
                              canvasColor: model.bottomSheetBackgroundColor),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: DateRangePickerOption(
                                  _onDisplayDateChanged,
                                  _controller.displayDate,
                                  model,
                                  displayDate: _controller.displayDate)),
                        )))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Enable view navigation',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: BottomSheetSwitch(
                                  switchValue: _enableViewNavigation,
                                  valueChanged: (dynamic value) {
                                    setState(() {
                                      onBoolValueChange(
                                          'EnableViewNavigation', value, model);
                                    });
                                  },
                                  activeColor: model.backgroundColor,
                                ))),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Show trailing/leading dates',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: BottomSheetSwitch(
                                  switchValue: _showTrailingAndLeadingDates,
                                  valueChanged: (dynamic value) {
                                    onBoolValueChange(
                                        'ShowLeadingTrailingDates',
                                        value,
                                        model);
                                  },
                                  activeColor: model.backgroundColor,
                                ))),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Enable past dates',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: BottomSheetSwitch(
                                  switchValue: _enablePastDates,
                                  valueChanged: (dynamic value) {
                                    onBoolValueChange(
                                        'EnablePastDates', value, model);
                                  },
                                  activeColor: model.backgroundColor,
                                ))),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('Enable swipe selection',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: BottomSheetSwitch(
                                  switchValue: _enableSwipingSelection,
                                  valueChanged: (dynamic value) {
                                    setState(() {
                                      onBoolValueChange(
                                          'EnableSwipingSelection',
                                          value,
                                          model);
                                    });
                                  },
                                  activeColor: model.backgroundColor,
                                ))),
                      ),
                    ))
              ],
            ),
          ),
        ]);
  }

  void _onDisplayDateChanged(DateRangePickerSelectionChangedArgs details) {
    setState(() {
      _controller.displayDate = details.value;
    });
  }
}

class DateRangePickerOption extends StatefulWidget {
  const DateRangePickerOption(this.selectionChanged, this.date, this.model,
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

class _DateRangePickerOptionState extends State<DateRangePickerOption> {
  DateTime date;

  @override
  void initState() {
    date = widget.date;
    super.initState();
  }

  void _onSelectionChanged(DateTime value) {
    setState(() {
      date = value;
    });

    if (widget.selectionChanged != null) {
      widget.selectionChanged(DateRangePickerSelectionChangedArgs(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
        color: Colors.transparent,
        child: GestureDetector(
            child: Text(DateFormat('dd-MM-yyyy').format(date),
                style: TextStyle(
                    fontSize: 15,
                    color: _theme.textTheme.subtitle2.color,
                    fontWeight: FontWeight.w600)),
            onTap: () async {
              final DateTime result = await showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                        data: _theme,
                        child: DateRangePicker(
                          date,
                          null,
                          minDate: DateTime.now()
                              .subtract(const Duration(days: 200)),
                          maxDate:
                              DateTime.now().add(const Duration(days: 200)),
                          displayDate: date,
                          model: widget.model,
                        ));
                  });

              if (result != null) {
                _onSelectionChanged(result);
              }
            }));
  }
}

SfDateRangePicker getGettingStartedDatePicker(
    [DateRangePickerController controller,
    DateRangePickerSelectionMode mode,
    bool showLeading,
    bool enablePastDates,
    bool _enableSwipingSelection,
    bool _enableViewNavigation,
    DateTime minDate,
    DateTime maxDate,
    bool enableMultiView]) {
  return SfDateRangePicker(
    enablePastDates: enablePastDates,
    minDate: minDate,
    maxDate: maxDate,
    enableMultiView: enableMultiView,
    allowViewNavigation: _enableViewNavigation,
    selectionMode: mode,
    controller: controller,
    monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: _enableSwipingSelection,
        showTrailingAndLeadingDates: showLeading ?? false),
  );
}
