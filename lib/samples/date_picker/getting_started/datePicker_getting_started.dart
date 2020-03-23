import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/switch.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/customDropDown.dart';
import '../popup_picker/popup_picker.dart';

//ignore: must_be_immutable
class GettingStartedDatePicker extends StatefulWidget {
  GettingStartedDatePicker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _GettingStartedDatePickerState createState() =>
      _GettingStartedDatePickerState(sample);
}

class _GettingStartedDatePickerState extends State<GettingStartedDatePicker> {
  _GettingStartedDatePickerState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  DateRangePickerController _controller;
  DateRangePickerSelectionMode _selectionMode;
  DateRangePickerView _view;
  bool _showTrailingAndLeadingDates;
  bool _enablePastDates;
  bool _enableSwipingSelection;

  String _selectionModeString = 'Range';
  final List<String> _selectionModeList = <String>[
    'Single',
    'Multiple',
    'Range',
    'Multi Range',
  ].toList();

  String _viewModeString = 'Month';
  final List<String> _viewModeList = <String>[
    'Month',
    'Year',
    'Decade',
    'Century',
  ].toList();

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _view = DateRangePickerView.month;
    _selectionMode = DateRangePickerSelectionMode.range;
    _showTrailingAndLeadingDates = true;
    _enablePastDates = true;
    _enableSwipingSelection = true;
    _controller = DateRangePickerController();
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
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(GettingStartedDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
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
                child: Container(
                    child: getGettingStartedDatePicker(
                  _controller,
                  _selectionMode,
                  _showTrailingAndLeadingDates,
                  _enablePastDates,
                  _enableSwipingSelection,
                  DateTime.now().subtract(const Duration(days: 200)),
                  DateTime.now().add(const Duration(days: 200)),
                )),
              ));
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
              ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }

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
  }

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

    setState(() {});
  }

  void _showSettingsPanel(SampleModel model) {
    final double height = 0.5 * MediaQuery.of(context).size.height;
    final ThemeData _theme = model.themeData;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
            rebuildOnChange: true,
            builder: (BuildContext context, _, SampleModel model) => Container(
                  height: height,
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                      children: <Widget>[
                        Container(
                          height: 40,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Settings',
                                  style: TextStyle(
                                      color: model.textColor,
                                      fontSize: 18,
                                      letterSpacing: 0.34,
                                      fontWeight: FontWeight.w500)),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: model.textColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
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
                                  child: Text('Picker view',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              canvasColor: model
                                                  .bottomSheetBackgroundColor),
                                          child: DropDown(
                                              value: _viewModeString,
                                              item: _viewModeList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                    value: (value != null)
                                                        ? value
                                                        : 'Month',
                                                    child: Text('$value',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: model
                                                                .textColor)));
                                              }).toList(),
                                              valueChanged: (dynamic value) {
                                                onPickerViewChange(value);
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
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              canvasColor: model
                                                  .bottomSheetBackgroundColor),
                                          child: DropDown(
                                              value: _selectionModeString,
                                              item: _selectionModeList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                    value: (value != null)
                                                        ? value
                                                        : 'Range',
                                                    child: Text('$value',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: model
                                                                .textColor)));
                                              }).toList(),
                                              valueChanged: (dynamic value) {
                                                onSelectionModeChange(value);
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
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Theme(
                                        data: _theme.copyWith(
                                            canvasColor: model
                                                .bottomSheetBackgroundColor),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: DateRangePickerOption(
                                                _onDisplayDateChanged,
                                                _controller.displayDate,
                                                displayDate:
                                                    _controller.displayDate)),
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
                                  child: Text('Show trailing/leading dates',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor:
                                              model.bottomSheetBackgroundColor),
                                      child: Container(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: BottomSheetSwitch(
                                                switchValue:
                                                    _showTrailingAndLeadingDates,
                                                valueChanged: (dynamic value) {
                                                  setState(() {
                                                    _showTrailingAndLeadingDates =
                                                        value;
                                                  });
                                                },
                                                activeColor:
                                                    model.backgroundColor,
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
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor:
                                              model.bottomSheetBackgroundColor),
                                      child: Container(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: BottomSheetSwitch(
                                                switchValue: _enablePastDates,
                                                valueChanged: (dynamic value) {
                                                  setState(() {
                                                    _enablePastDates = value;
                                                  });
                                                },
                                                activeColor:
                                                    model.backgroundColor,
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
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: model.textColor))),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor:
                                              model.bottomSheetBackgroundColor),
                                      child: Container(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: BottomSheetSwitch(
                                                switchValue:
                                                    _enableSwipingSelection,
                                                valueChanged: (dynamic value) {
                                                  setState(() {
                                                    _enableSwipingSelection =
                                                        value;
                                                  });
                                                },
                                                activeColor:
                                                    model.backgroundColor,
                                              ))),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ]),
                )));
  }

  void _onDisplayDateChanged(DateRangePickerSelectionChangedArgs details) {
    setState(() {
      _controller.displayDate = details.value;
    });
  }
}

class DateRangePickerOption extends StatefulWidget {
  const DateRangePickerOption(this.selectionChanged, this.date,
      {this.displayDate});

  final DateRangePickerSelectionChangedCallback selectionChanged;
  final DateTime date;
  final DateTime displayDate;

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
                    color: _theme.textTheme.subtitle.color,
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
    DateTime minDate,
    DateTime maxDate]) {
  return SfDateRangePicker(
    enablePastDates: enablePastDates,
    minDate: minDate,
    maxDate: maxDate,
    selectionMode: mode,
    controller: controller,
    monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: _enableSwipingSelection,
        showTrailingAndLeadingDates: showLeading ?? false),
  );
}
