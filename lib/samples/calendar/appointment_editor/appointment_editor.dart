import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/customDropDown.dart';

//ignore: must_be_immutable
class CalendarAppointmentEditor extends StatefulWidget {
  CalendarAppointmentEditor({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  CalendarAppointmentEditorState createState() =>
      CalendarAppointmentEditorState(sample);
}

List<Color> _colorCollection;
List<String> _colorNames;
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection;
DataSource _events;
Appointment _selectedAppointment;
DateTime _startDate;
TimeOfDay _startTime;
DateTime _endDate;
TimeOfDay _endTime;
bool _isAllDay;
String _subject = '';
String _notes = '';

class CalendarAppointmentEditorState extends State<CalendarAppointmentEditor> {
  CalendarAppointmentEditorState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<String> subjectCollection;
  List<Appointment> appointments;

  String _view;

  final List<String> _viewList = <String>[
    'Day',
    'Week',
    'Work week',
    'Month',
    'Timeline day',
    'Timeline week',
    'Timeline work week'
  ].toList();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) => CalendarAppointmentEditor();

  @override
  void initState() {
    initProperties();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    appointments = getAppointmentDetails();
    _events = DataSource(appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _view = 'Month';
    _calendarView = CalendarView.month;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(
          <dynamic, dynamic>{'CalendarView': _calendarView, 'View': _view});
    }
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(CalendarAppointmentEditor oldWidget) {
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
          return Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              backgroundColor: model.themeData == null ||
                      model.themeData.brightness == Brightness.light
                  ? null
                  : Colors.black,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Container(
                          color: model.cardThemeColor,
                          child: getAppointmentEditorCalendar(
                              _calendarView, _events, onCalendarTapped, model)),
                    )
                  : Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                            color: model.cardThemeColor,
                            child: getAppointmentEditorCalendar(_calendarView,
                                _events, onCalendarTapped, model)),
                      ))
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

  void onCalendarViewChange(String value, SampleModel model) {
    _view = value;
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    model.properties['View'] = _view;
    model.properties['CalendarView'] = _calendarView;
    if (model.isWeb) {
      model.sampleOutputContainer.outputKey.currentState.refresh();
    } else {
      setState(() {});
    }
  }

  void onCalendarTapped(
      CalendarTapDetails calendarTapDetails, SampleModel model) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    _selectedAppointment = null;
    _isAllDay = false;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';

    if ((model != null &&
            model.isWeb &&
            model.properties.isNotEmpty &&
            model.properties['CalendarView'] == CalendarView.month) ||
        !kIsWeb && _calendarView == CalendarView.month) {
      _calendarView = CalendarView.day;
      _view = 'Day';
      model.properties['View'] = _view;
      model.properties['CalendarView'] = _calendarView;
      setState(() {});
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.appointments.length == 1) {
        final Appointment appointment = calendarTapDetails.appointments[0];
        _startDate = appointment.startTime;
        _endDate = appointment.endTime;
        _isAllDay = appointment.isAllDay;
        _selectedColorIndex = _colorCollection.indexOf(appointment.color);
        _selectedTimeZoneIndex = appointment.startTimeZone == ''
            ? 0
            : _timeZoneCollection.indexOf(appointment.startTimeZone);
        _subject =
            appointment.subject == '(No title)' ? '' : appointment.subject;
        _notes = appointment.notes;
        _selectedAppointment = appointment;
      } else {
        final DateTime date = calendarTapDetails.date;
        _startDate = date;
        _endDate = date.add(const Duration(hours: 1));
      }

      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

      Navigator.push<Widget>(
        context,
        // ignore: always_specify_types
        MaterialPageRoute(
            builder: (BuildContext context) => AppointmentEditor()),
      );
    }
  }

  List<Appointment> getAppointmentDetails() {
    final List<Appointment> appointmentCollection = <Appointment>[];
    subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Scrum');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
    _timeZoneCollection.add('Central America Standard Time');
    _timeZoneCollection.add('Central Asia Standard Time');
    _timeZoneCollection.add('Central Brazilian Standard Time');
    _timeZoneCollection.add('Central Europe Standard Time');
    _timeZoneCollection.add('Central European Standard Time');
    _timeZoneCollection.add('Central Pacific Standard Time');
    _timeZoneCollection.add('Central Standard Time');
    _timeZoneCollection.add('China Standard Time');
    _timeZoneCollection.add('Dateline Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('E. Australia Standard Time');
    _timeZoneCollection.add('E. South America Standard Time');
    _timeZoneCollection.add('Eastern Standard Time');
    _timeZoneCollection.add('Egypt Standard Time');
    _timeZoneCollection.add('Ekaterinburg Standard Time');
    _timeZoneCollection.add('FLE Standard Time');
    _timeZoneCollection.add('Fiji Standard Time');
    _timeZoneCollection.add('GMT Standard Time');
    _timeZoneCollection.add('GTB Standard Time');
    _timeZoneCollection.add('Georgian Standard Time');
    _timeZoneCollection.add('Greenland Standard Time');
    _timeZoneCollection.add('Greenwich Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('India Standard Time');
    _timeZoneCollection.add('Iran Standard Time');
    _timeZoneCollection.add('Israel Standard Time');
    _timeZoneCollection.add('Jordan Standard Time');
    _timeZoneCollection.add('Kaliningrad Standard Time');
    _timeZoneCollection.add('Korea Standard Time');
    _timeZoneCollection.add('Libya Standard Time');
    _timeZoneCollection.add('Line Islands Standard Time');
    _timeZoneCollection.add('Magadan Standard Time');
    _timeZoneCollection.add('Mauritius Standard Time');
    _timeZoneCollection.add('Middle East Standard Time');
    _timeZoneCollection.add('Montevideo Standard Time');
    _timeZoneCollection.add('Morocco Standard Time');
    _timeZoneCollection.add('Mountain Standard Time');
    _timeZoneCollection.add('Mountain Standard Time (Mexico)');
    _timeZoneCollection.add('Myanmar Standard Time');
    _timeZoneCollection.add('N. Central Asia Standard Time');
    _timeZoneCollection.add('Namibia Standard Time');
    _timeZoneCollection.add('Nepal Standard Time');
    _timeZoneCollection.add('New Zealand Standard Time');
    _timeZoneCollection.add('Newfoundland Standard Time');
    _timeZoneCollection.add('North Asia East Standard Time');
    _timeZoneCollection.add('North Asia Standard Time');
    _timeZoneCollection.add('Pacific SA Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('Pakistan Standard Time');
    _timeZoneCollection.add('Paraguay Standard Time');
    _timeZoneCollection.add('Romance Standard Time');
    _timeZoneCollection.add('Russia Time Zone 10');
    _timeZoneCollection.add('Russia Time Zone 11');
    _timeZoneCollection.add('Russia Time Zone 3');
    _timeZoneCollection.add('Russian Standard Time');
    _timeZoneCollection.add('SA Eastern Standard Time');
    _timeZoneCollection.add('SA Pacific Standard Time');
    _timeZoneCollection.add('SA Western Standard Time');
    _timeZoneCollection.add('SE Asia Standard Time');
    _timeZoneCollection.add('Samoa Standard Time');
    _timeZoneCollection.add('Singapore Standard Time');
    _timeZoneCollection.add('South Africa Standard Time');
    _timeZoneCollection.add('Sri Lanka Standard Time');
    _timeZoneCollection.add('Syria Standard Time');
    _timeZoneCollection.add('Taipei Standard Time');
    _timeZoneCollection.add('Tasmania Standard Time');
    _timeZoneCollection.add('Tokyo Standard Time');
    _timeZoneCollection.add('Tonga Standard Time');
    _timeZoneCollection.add('Turkey Standard Time');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');
    _timeZoneCollection.add('UTC');
    _timeZoneCollection.add('UTC+12');
    _timeZoneCollection.add('UTC-02');
    _timeZoneCollection.add('UTC-11');
    _timeZoneCollection.add('Ulaanbaatar Standard Time');
    _timeZoneCollection.add('Venezuela Standard Time');
    _timeZoneCollection.add('Vladivostok Standard Time');
    _timeZoneCollection.add('W. Australia Standard Time');
    _timeZoneCollection.add('W. Central Africa Standard Time');
    _timeZoneCollection.add('W. Europe Standard Time');
    _timeZoneCollection.add('West Asia Standard Time');
    _timeZoneCollection.add('West Pacific Standard Time');
    _timeZoneCollection.add('Yakutsk Standard Time');

    final DateTime today = DateTime.now();
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          appointmentCollection.add(Appointment(
            startTime: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour)),
            endTime: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour + 2)),
            color: _colorCollection[random.nextInt(9)],
            startTimeZone: '',
            endTimeZone: '',
            notes: '',
            isAllDay: false,
            subject: subjectCollection[random.nextInt(7)],
          ));
        }
      }
    }

    return appointmentCollection;
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Properties',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  HandCursor(
                      child: IconButton(
                    icon: Icon(Icons.close, color: model.textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ]),
            const Divider(
              thickness: 1,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text('Calendar View',
                      style: TextStyle(
                          color: model.textColor,
                          fontSize: 16,
                          letterSpacing: 0.34,
                          fontWeight: FontWeight.normal)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      height: 50,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: model.bottomSheetBackgroundColor),
                          child: DropDown(
                              value: model.properties['View'],
                              item: _viewList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'Month',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onCalendarViewChange(value, model);
                              }),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 12.0,
          color: model.bottomSheetBackgroundColor,
          builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
              rebuildOnChange: false,
              builder: (BuildContext context, _, SampleModel model) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                      height: 170,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * height,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                                child: Stack(children: <Widget>[
                                  Container(
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 50, 0, 0),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Calendar View   ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: model.textColor)),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              height: 50,
                                              width: 200,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _view,
                                                      item: _viewList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value: (value !=
                                                                    null)
                                                                ? value
                                                                : 'Month',
                                                            child: Text(
                                                                '$value',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onCalendarViewChange(
                                                            value, model);
                                                      }),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              )))))));
    }
    return widget ?? Container();
  }
}

SfCalendar getAppointmentEditorCalendar(
    [CalendarView _calendarView,
    CalendarDataSource _calendarDataSource,
    dynamic calendarTapCallback,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCalendar(
      view: isExistModel ? model.properties['CalendarView'] : _calendarView,
      dataSource: _calendarDataSource,
      onTap: (CalendarTapDetails calendarTapDetails) {
        calendarTapCallback(calendarTapDetails, model);
      },
      initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: isExistModel ? 3 : 4),
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 60)));
}

class DataSource extends CalendarDataSource {
  DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

class _CalendarColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarColorPickerState();
  }
}

class _CalendarColorPickerState extends State<_CalendarColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _colorCollection.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Icon(
                    index == _selectedColorIndex
                        ? Icons.lens
                        : Icons.trip_origin,
                    color: _colorCollection[index]),
                title: Text(_colorNames[index]),
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}

class _CalendarTimeZonePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarTimeZonePickerState();
  }
}

class _CalendarTimeZonePickerState extends State<_CalendarTimeZonePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _timeZoneCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Icon(
                  index == _selectedTimeZoneIndex
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
                title: Text(_timeZoneCollection[index]),
                onTap: () {
                  setState(() {
                    _selectedTimeZoneIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}

class AppointmentEditor extends StatefulWidget {
  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
  Widget _getAppointmentEditor(
      BuildContext context, Color backgroundColor, Color defaultColor) {
    return Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: _subject),
                onChanged: (String value) {
                  _subject = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 25,
                    color: defaultColor,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.access_time,
                  color: defaultColor,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_startDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: _startTime.hour,
                                            minute: _startTime.minute));

                                    if (time != null && time != _startTime) {
                                      setState(() {
                                        _startTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _startDate = DateTime(
                                            _startDate.year,
                                            _startDate.month,
                                            _startDate.day,
                                            _startTime.hour,
                                            _startTime.minute,
                                            0);
                                        _endDate = _startDate.add(difference);
                                        _endTime = TimeOfDay(
                                            hour: _endDate.hour,
                                            minute: _endDate.minute);
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_endDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: _endTime.hour,
                                            minute: _endTime.minute));

                                    if (time != null && time != _endTime) {
                                      setState(() {
                                        _endTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _endDate = DateTime(
                                            _endDate.year,
                                            _endDate.month,
                                            _endDate.day,
                                            _endTime.hour,
                                            _endTime.minute,
                                            0);
                                        if (_endDate.isBefore(_startDate)) {
                                          _startDate =
                                              _endDate.subtract(difference);
                                          _startTime = TimeOfDay(
                                              hour: _startDate.hour,
                                              minute: _startDate.minute);
                                        }
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.public,
                color: defaultColor,
              ),
              title: Text(_timeZoneCollection[_selectedTimeZoneIndex]),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _CalendarTimeZonePicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: _colorCollection[_selectedColorIndex]),
              title: Text(
                _colorNames[_selectedColorIndex],
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _CalendarColorPicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: defaultColor,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 18,
                    color: defaultColor,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Theme(
              data: model.themeData,
              child: Scaffold(
                  backgroundColor: model.cardThemeColor,
                  appBar: AppBar(
                    backgroundColor: _colorCollection[_selectedColorIndex],
                    leading: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: <Widget>[
                      IconButton(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          icon: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            final List<Appointment> appointment =
                                <Appointment>[];
                            if (_selectedAppointment != null) {
                              _events.appointments.removeAt(_events.appointments
                                  .indexOf(_selectedAppointment));
                              _events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[]..add(_selectedAppointment));
                            }
                            appointment.add(Appointment(
                              startTime: _startDate,
                              endTime: _endDate,
                              color: _colorCollection[_selectedColorIndex],
                              startTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : _timeZoneCollection[_selectedTimeZoneIndex],
                              endTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : _timeZoneCollection[_selectedTimeZoneIndex],
                              notes: _notes,
                              isAllDay: _isAllDay,
                              subject: _subject == '' ? '(No title)' : _subject,
                            ));

                            _events.appointments.add(appointment[0]);

                            _events.notifyListeners(
                                CalendarDataSourceAction.add, appointment);
                            _selectedAppointment = null;

                            Navigator.pop(context);
                          })
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Stack(
                      children: <Widget>[
                        _getAppointmentEditor(
                            context,
                            model.cardThemeColor,
                            model.theme != null &&
                                    model.theme == Brightness.dark
                                ? Colors.white
                                : Colors.black87)
                      ],
                    ),
                  ),
                  floatingActionButton: model.isWeb
                      ? null
                      : _selectedAppointment == null
                          ? const Text('')
                          : FloatingActionButton(
                              onPressed: () {
                                if (_selectedAppointment != null) {
                                  _events.appointments.removeAt(_events
                                      .appointments
                                      .indexOf(_selectedAppointment));
                                  _events.notifyListeners(
                                      CalendarDataSourceAction.remove,
                                      <Appointment>[]
                                        ..add(_selectedAppointment));
                                  _selectedAppointment = null;
                                  Navigator.pop(context);
                                }
                              },
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                              backgroundColor: model.backgroundColor,
                            )));
        });
  }
}
