import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as _picker;

//ignore: must_be_immutable
class PopUpDatePicker extends StatefulWidget {
  PopUpDatePicker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PopUpDatePickerState createState() => _PopUpDatePickerState(sample);
}

class _PopUpDatePickerState extends State<PopUpDatePicker>
    with SingleTickerProviderStateMixin {
  _PopUpDatePickerState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  DateTime _startDate;
  DateTime _endDate;
  int _value;

  Widget sampleWidget(SampleModel model) => PopUpDatePicker();

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
    _value = 1;
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(PopUpDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  void _onSelectedDateChanged(DateTime date) {
    if (date != null && date != _startDate) {
      setState(() {
        final Duration difference = _endDate.difference(_startDate);
        _startDate = DateTime(date.year, date.month, date.day);
        _endDate = _startDate.add(difference);
      });
    }
  }

  void _onSelectedRangeChanged(_picker.PickerDateRange dateRange) {
    final DateTime startDateValue = dateRange.startDate;
    DateTime endDateValue = dateRange.endDate;
    endDateValue ??= startDateValue;
    setState(() {
      if (startDateValue.isAfter(endDateValue)) {
        _startDate = endDateValue;
        _endDate = startDateValue;
      } else {
        _startDate = startDateValue;
        _endDate = endDateValue;
      }
    });
  }

  Widget _getBooking(SampleModel model) {
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: Container(
            color: model.cardThemeColor,
            child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                      child: Center(
                          child: Wrap(
                        spacing: 5,
                        children: List<Widget>.generate(
                          2,
                          (int index) {
                            return ChoiceChip(
                              label: Text(
                                index == 0 ? 'One-way' : 'Round-Trip',
                                style: TextStyle(
                                    color: _value == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                              selected: _value == index,
                              selectedColor: model.backgroundColor,
                              backgroundColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  _value = index;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ))),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: const <Widget>[
                                Text(
                                  'From',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text('CLE',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            )),
                        const Expanded(
                          flex: 4,
                          child: Text(''),
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: const <Widget>[
                                Text(
                                  'Destination',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text('NYC',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ))
                      ])),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Divider(
                        color: Colors.black26,
                        height: 1.0,
                        thickness: 1,
                      )),
                  _value == 0
                      ? GestureDetector(
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text('Depart',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12)),
                                ),
                              ),
                              const Expanded(flex: 4, child: Text('')),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 0),
                                        child: Text(
                                            DateFormat('dd MMM yy')
                                                .format(_startDate),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600))),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 0),
                                        child: Text(
                                            DateFormat('EEEE')
                                                .format(_startDate),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12))),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            final DateTime date = await showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DateRangePicker(_startDate, null,
                                      displayDate: _startDate,
                                      minDate: DateTime.now(),
                                      model: model);
                                });
                            if (date != null) {
                              _onSelectedDateChanged(date);
                            }
                          })
                      : Container(
                          height: 60,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                      child: Column(
                                        children: <Widget>[
                                          const Text('Depart',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 5, 0),
                                              child: Text(
                                                  DateFormat('dd MMM yy')
                                                      .format(_startDate),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 5, 0),
                                              child: Text(
                                                  DateFormat('EEEE')
                                                      .format(_startDate),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12))),
                                        ],
                                      ),
                                      onTap: () async {
                                        final _picker.PickerDateRange range =
                                            await showDialog<dynamic>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DateRangePicker(
                                                    null,
                                                    _picker.PickerDateRange(
                                                      _startDate,
                                                      _endDate,
                                                    ),
                                                    displayDate: _startDate,
                                                    minDate: DateTime.now(),
                                                    model: model,
                                                  );
                                                });

                                        if (range != null) {
                                          _onSelectedRangeChanged(range);
                                        }
                                      })),
                              const Expanded(flex: 4, child: Text('')),
                              Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                      child: Column(
                                        children: <Widget>[
                                          const Text('Return',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 5, 0),
                                              child: Text(
                                                  DateFormat('dd MMM yy')
                                                      .format(_endDate),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 5, 0),
                                              child: Text(
                                                  DateFormat('EEEE')
                                                      .format(_endDate),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12))),
                                        ],
                                      ),
                                      onTap: () async {
                                        final _picker.PickerDateRange range =
                                            await showDialog<dynamic>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DateRangePicker(
                                                    null,
                                                    _picker.PickerDateRange(
                                                        _startDate, _endDate),
                                                    displayDate: _endDate,
                                                    minDate: DateTime.now(),
                                                    model: model,
                                                  );
                                                });

                                        if (range != null) {
                                          _onSelectedRangeChanged(range);
                                        }
                                      }))
                            ],
                          ),
                        ),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Divider(
                        color: Colors.black26,
                        height: 1.0,
                        thickness: 1,
                      )),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: const <Widget>[
                                Text(
                                  'Travellers',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text('1 Adult',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            )),
                        const Expanded(
                          flex: 4,
                          child: Text(''),
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: const <Widget>[
                                Text(
                                  'Class',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text('Economy',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ))
                      ])),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('')),
                  ListTile(
                    title: Center(
                        child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            shape: BoxShape.rectangle,
                            color: model.backgroundColor),
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(
                          'SEARCH',
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.transparent,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            'Searching...',
                          ),
                          duration: Duration(milliseconds: 200),
                        ));
                      },
                    )),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                  ),
                ])));
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Container(
              color: model.themeData == null ||
                      model.themeData.brightness == Brightness.light
                  ? null
                  : Colors.black,
              child: kIsWeb
                  ? Center(
                      child: Container(
                          width: 500, height: 500, child: _getBooking(model)))
                  : _getBooking(model));
        });
  }
}

_picker.SfDateRangePicker getPopUpDatePicker() {
  return _picker.SfDateRangePicker();
}

class DateRangePicker extends StatefulWidget {
  const DateRangePicker(this.date, this.range,
      {this.minDate, this.maxDate, this.displayDate, this.model});

  final DateTime date;
  final _picker.PickerDateRange range;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime displayDate;
  final SampleModel model;

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState();
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime date;
  _picker.DateRangePickerController _controller;
  _picker.PickerDateRange range;

  @override
  void initState() {
    date = widget.date;
    range = widget.range;
    _controller = _picker.DateRangePickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget footerWidget = ButtonBarTheme(
      data: ButtonBarTheme.of(context),
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, null),
          ),
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              if (range != null) {
                Navigator.pop(context, range);
              } else {
                Navigator.pop(context, date);
              }
            },
          ),
        ],
      ),
    );

    final Widget selectedDateWidget = Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: range == null ||
                    range.startDate == null ||
                    range.endDate == null ||
                    range.startDate == range.endDate
                ? Text(
                    DateFormat('dd MMM, yyyy').format(range == null
                        ? date
                        : (range.startDate != null
                            ? range.startDate
                            : range.endDate)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Text(
                          DateFormat('dd MMM, yyyy').format(
                              range.startDate.isAfter(range.endDate)
                                  ? range.endDate
                                  : range.startDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          child: const VerticalDivider(
                        thickness: 1,
                      )),
                      Expanded(
                        flex: 5,
                        child: Text(
                          DateFormat('dd MMM, yyyy').format(
                              range.startDate.isAfter(range.endDate)
                                  ? range.startDate
                                  : range.endDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )));

    _controller.selectedDate = date;
    _controller.selectedRange = range;
    final Widget pickerWidget = _picker.SfDateRangePicker(
      controller: _controller,
      initialDisplayDate: widget.displayDate,
      showNavigationArrow: true,
      selectionMode: range == null
          ? _picker.DateRangePickerSelectionMode.single
          : _picker.DateRangePickerSelectionMode.range,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      todayHighlightColor: Colors.transparent,
      monthCellStyle: _picker.DateRangePickerMonthCellStyle(
          todayTextStyle: const TextStyle(color: Colors.blue, fontSize: 13)),
      yearCellStyle: _picker.DateRangePickerYearCellStyle(
          todayTextStyle: const TextStyle(color: Colors.blue, fontSize: 13)),
      headerStyle: _picker.DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(color: Colors.blue[700], fontSize: 15)),
      onSelectionChanged:
          (_picker.DateRangePickerSelectionChangedArgs details) {
        setState(() {
          if (range == null) {
            date = details.value;
          } else {
            range = details.value;
          }
        });
      },
    );

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 400,
          width: 300,
          color: widget.model.cardThemeColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              selectedDateWidget,
              Flexible(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: pickerWidget)),
              footerWidget,
            ],
          ),
        ));
  }
}
