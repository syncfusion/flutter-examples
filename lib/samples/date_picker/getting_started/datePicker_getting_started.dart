import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/switch.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

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

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) => GettingStartedDatePicker();

  @override
  void initState() {
    initProperties();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _controller = _controller == null
        ? sampleModel != null &&
        sampleModel.isWeb &&
        sampleModel.properties.isNotEmpty
        ? sampleModel.properties['Controller']
        : DateRangePickerController()
        : _controller;

    _selectionMode = DateRangePickerSelectionMode.range;
    _view = _controller.view ?? DateRangePickerView.month;
    _showTrailingAndLeadingDates = true;
    _enablePastDates = true;
    _enableSwipingSelection = true;
    _selectionModeString = 'Range';
    _viewModeString = 'Month';
    _controller.view ??= _view;
    _controller.displayDate??= DateTime.now();
    _controller.selectedDate??= DateTime.now();
    _controller.selectedDates??= <DateTime>[
      DateTime.now(),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 2))
    ];
    _controller.selectedRange ??= PickerDateRange(
        DateTime.now().subtract(const Duration(days: 2)),
        DateTime.now().add(const Duration(days: 2)));
    _controller.selectedRanges ??= <PickerDateRange>[
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
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          if (model != null && model.isWeb && model.properties.isEmpty) {
            initProperties(model, true);
          }
          final Widget _cardView = Card(
            elevation: 10,
            margin: model.isWeb
                ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
                : const EdgeInsets.all(30),
            child: Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                color: model.cardThemeColor,
                child: getGettingStartedDatePicker(
                    _controller,
                    _selectionMode,
                    _showTrailingAndLeadingDates,
                    _enablePastDates,
                    _enableSwipingSelection,
                    DateTime.now().subtract(const Duration(days: 200)),
                    DateTime.now().add(const Duration(days: 200)),
                    model)),
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
              ]),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model, false, context);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
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
    if (model.isWeb) {
      model.sampleOutputContainer.outputKey.currentState.refresh();
    } else {
      setState(() {});
    }
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height = 0.5 * MediaQuery
        .of(context)
        .size
        .height;
    final ThemeData _theme = model.themeData;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(children: <Widget>[
          Container(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Properties',
                    style: TextStyle(
                        color: model.textColor,
                        fontSize: 18,
                        letterSpacing: 0.34,
                        fontWeight: FontWeight.w500)),
                HandCursor(
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: model.textColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
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
                                value: model.properties['View'],
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
                                value: model.properties['Selection'],
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
                                  switchValue: model
                                      .properties['ShowLeadingTrailingDates'],
                                  valueChanged: (dynamic value) {
                                    _showTrailingAndLeadingDates = value;
                                    model.properties[
                                    'ShowLeadingTrailingDates'] =
                                        _showTrailingAndLeadingDates;
                                    if (model.isWeb) {
                                      model.sampleOutputContainer.outputKey
                                          .currentState
                                          .refresh();
                                    } else {
                                      setState(() {});
                                    }
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
                                  switchValue:
                                  model.properties['EnablePastDates'],
                                  valueChanged: (dynamic value) {
                                    _enablePastDates = value;
                                    model.properties['EnablePastDates'] =
                                        _enablePastDates;
                                    if (model.isWeb) {
                                      model.sampleOutputContainer.outputKey
                                          .currentState
                                          .refresh();
                                    } else {
                                      setState(() {});
                                    }
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
                                  switchValue: model
                                      .properties['EnableSwipingSelection'],
                                  valueChanged: (dynamic value) {
                                    _enableSwipingSelection = value;
                                    model.properties['EnableSwipingSelection'] =
                                        _enableSwipingSelection;
                                    if (model.isWeb) {
                                      model.sampleOutputContainer.outputKey
                                          .currentState
                                          .refresh();
                                    } else {
                                      setState(() {});
                                    }
                                  },
                                  activeColor: model.backgroundColor,
                                ))),
                      ),
                    ))
              ],
            ),
          )
        ]),
      );
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 12.0,
          color: model.bottomSheetBackgroundColor,
          builder: (BuildContext context) =>
              ScopedModelDescendant<SampleModel>(
                  rebuildOnChange: true,
                  builder: (BuildContext context, _, SampleModel model) =>
                      Container(
                        height: height,
                        child: ListView(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                            children: <Widget>[
                              Container(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                    canvasColor: model
                                                        .bottomSheetBackgroundColor),
                                                child: DropDown(
                                                    value: _viewModeString,
                                                    item: _viewModeList
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
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
                                                    valueChanged: (
                                                        dynamic value) {
                                                      onPickerViewChange(
                                                          value, model);
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                    canvasColor: model
                                                        .bottomSheetBackgroundColor),
                                                child: DropDown(
                                                    value: _selectionModeString,
                                                    item: _selectionModeList
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
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
                                                    valueChanged: (
                                                        dynamic value) {
                                                      onSelectionModeChange(
                                                          value, model);
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Theme(
                                              data: _theme.copyWith(
                                                  canvasColor: model
                                                      .bottomSheetBackgroundColor),
                                              child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: DateRangePickerOption(
                                                      _onDisplayDateChanged,
                                                      _controller.displayDate,
                                                      model,
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
                                        child: Text(
                                            'Show trailing/leading dates',
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
                                                canvasColor: model
                                                    .bottomSheetBackgroundColor),
                                            child: Container(
                                                child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: BottomSheetSwitch(
                                                      switchValue:
                                                      _showTrailingAndLeadingDates,
                                                      valueChanged:
                                                          (dynamic value) {
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
                                                canvasColor: model
                                                    .bottomSheetBackgroundColor),
                                            child: Container(
                                                child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: BottomSheetSwitch(
                                                      switchValue: _enablePastDates,
                                                      valueChanged:
                                                          (dynamic value) {
                                                        setState(() {
                                                          _enablePastDates =
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
                                                canvasColor: model
                                                    .bottomSheetBackgroundColor),
                                            child: Container(
                                                child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: BottomSheetSwitch(
                                                      switchValue:
                                                      _enableSwipingSelection,
                                                      valueChanged:
                                                          (dynamic value) {
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

    return widget ?? Container();
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
                    color: _theme.textTheme.subtitle1.color,
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
      DateTime minDate,
      DateTime maxDate,
      SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfDateRangePicker(
    enablePastDates:
    isExistModel ? model.properties['EnablePastDates'] : enablePastDates,
    minDate: minDate,
    maxDate: maxDate,
    selectionMode: isExistModel ? model.properties['SelectionMode'] : mode,
    controller: isExistModel ? model.properties['Controller'] : controller,
    monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: isExistModel
            ? model.properties['EnableSwipingSelection']
            : _enableSwipingSelection,
        showTrailingAndLeadingDates: isExistModel
            ? model.properties['ShowLeadingTrailingDates']
            : showLeading ?? false),
  );
}
