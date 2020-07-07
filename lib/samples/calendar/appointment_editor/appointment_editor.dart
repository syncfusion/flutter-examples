import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../widgets/customDropDown.dart';

class CalendarAppointmentEditor extends SampleView {
  const CalendarAppointmentEditor(Key key) : super(key: key);

  @override
  CalendarAppointmentEditorState createState() =>
      CalendarAppointmentEditorState();
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
bool _isTimeZoneEnabled = false;
String _subject = '';
String _notes = '';
String _location = '';

class CalendarAppointmentEditorState extends SampleViewState {
  CalendarAppointmentEditorState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<String> subjectCollection;
  List<Appointment> appointments;
  bool _isMobile;

  String _view;

  final List<String> _viewList = <String>[
    'Day',
    'Week',
    'Work week',
    'Month',
    'Timeline day',
    'Timeline week',
    'Timeline work week',
    'Schedule'
  ].toList();

  ScrollController controller;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  GlobalKey _globalKey;

  @override
  void initState() {
    initProperties();
    _globalKey = GlobalKey();
    _isMobile = false;
    controller = ScrollController();
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
    _isMobile = MediaQuery.of(context).size.width < 767;
    super.didChangeDependencies();
  }

  @override
  Widget build([BuildContext context]) {
    final Widget _calendar = Theme(
      /// The key set here to maintain the state, when we change the parent of the
      /// widget
      key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: getAppointmentEditorCalendar(
            _calendarView, _events, onCalendarTapped, model));
    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: _view == 'Month' && model.isWeb && _screenHeight < 800
            ? Scrollbar(
                isAlwaysShown: true,
                controller: controller,
                child: ListView(
                  controller: controller,
                  children: <Widget>[
                    Container(
                      color: model.isWeb
                          ? model.webSampleBackgroundColor
                          : model.cardThemeColor,
                      height: 600,
                      child: _calendar,
                    )
                  ],
                ))
            : Container(
                color: model.isWeb
                    ? model.webSampleBackgroundColor
                    : model.cardThemeColor,
                child: _calendar),
        );
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
    } else if (value == 'Schedule') {
      _calendarView = CalendarView.schedule;
    }

    model.properties['View'] = _view;
    model.properties['CalendarView'] = _calendarView;
    setState(() {});
  }

  void onCalendarTapped(
      CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header) {
      return;
    }

    _selectedAppointment = null;
    _isAllDay = calendarTapDetails.targetElement == CalendarElement.allDayPanel;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    _location = '';
    _isTimeZoneEnabled = false;

    /// Navigates the calendar to day view, when we tap on month cells in mobile.
    if (!model.isWeb && _calendarView == CalendarView.month) {
      _calendarView = CalendarView.day;
      _view = 'Day';
      model.properties['View'] = _view;
      model.properties['CalendarView'] = _calendarView;
      setState(() {});
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
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
        _location = appointment.location;
        _isTimeZoneEnabled = appointment.startTimeZone != null &&
            appointment.startTimeZone.isNotEmpty;
        _selectedAppointment = appointment;
      } else {
        final DateTime date = calendarTapDetails.date;
        _startDate = date;
        _endDate = date.add(const Duration(hours: 1));
      }

      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

      /// To open the appointment editor for web, when the screen width is greater
      /// than 767.
      if (model.isWeb && !_isMobile) {
        final bool _isAppointmentTapped =
            calendarTapDetails.targetElement == CalendarElement.appointment;
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              final List<Appointment> appointment = <Appointment>[];
              Appointment newAppointment;
              /// Creates a new appointment, which is displayed on the tapped
              /// calendar element, when the editor is opened.
              if (_selectedAppointment == null) {
                newAppointment = Appointment(
                  startTime: _startDate,
                  endTime: _endDate,
                  color: _colorCollection[_selectedColorIndex],
                  isAllDay: _isAllDay,
                  subject: _subject == '' ? '(No title)' : _subject,
                );
                appointment.add(newAppointment);

                _events.appointments.add(appointment[0]);

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _events.notifyListeners(
                      CalendarDataSourceAction.add, appointment);
                });

                _selectedAppointment = newAppointment;
              }

              return WillPopScope(
                onWillPop: () async {
                  if (newAppointment != null) {
                    /// To remove the created appointment when the pop-up closed
                    /// without saving the appointment.
                    _events.appointments
                        .removeAt(_events.appointments.indexOf(newAppointment));
                    _events.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[]..add(newAppointment));
                  }
                  return true;
                },
                child: Center(
                    child: Container(
                        width: _isAppointmentTapped ? 400 : 500,
                        height: _isAppointmentTapped ? 200 : 400,
                        child: Card(
                          margin: const EdgeInsets.all(0.0),
                          color: model.cardThemeColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: _isAppointmentTapped
                              ? _displayAppointmentDetails(context)
                              : PopUpAppointmentEditor(
                                  model, newAppointment, appointment),
                        ))),
              );
            });
      } else {
        Navigator.push<Widget>(
          context,
          // ignore: always_specify_types
          MaterialPageRoute(
              builder: (BuildContext context) => AppointmentEditor(model)),
        );
      }
    }
  }

  /// Displays the tapped appointment details in a pop-up view.
  Widget _displayAppointmentDetails(BuildContext context) {
    final Color defaultColor =
        model.themeData != null && model.themeData.brightness == Brightness.dark
            ? Colors.white
            : Colors.black87;
    return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
      ListTile(
          trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: defaultColor),
            onPressed: () {
              Navigator.pop(context);
              showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        return true;
                      },
                      // ignore: prefer_const_literals_to_create_immutables
                      child: AppointmentEditorWeb(model, <Appointment>[]),
                    );
                  });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: defaultColor),
            onPressed: () {
              _events.appointments
                  .removeAt(_events.appointments.indexOf(_selectedAppointment));
              _events.notifyListeners(CalendarDataSourceAction.remove,
                  <Appointment>[]..add(_selectedAppointment));
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: defaultColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
      ListTile(
          leading: Icon(
            Icons.lens,
            color: _selectedAppointment.color,
            size: 20,
          ),
          title: Text(_selectedAppointment.subject ?? '(No Text)',
              style: TextStyle(
                  fontSize: 20,
                  color: defaultColor,
                  fontWeight: FontWeight.w400)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _getAppointmentTimeText(),
              style: TextStyle(
                  fontSize: 15,
                  color: defaultColor,
                  fontWeight: FontWeight.w400),
            ),
          )),
      ListTile(
        leading: _selectedAppointment.location == null ||
                _selectedAppointment.location.isEmpty
            ? const Text('')
            : Icon(
                Icons.location_on,
                size: 20,
                color: defaultColor,
              ),
        title: Text(_selectedAppointment.location ?? '',
            style: TextStyle(
                fontSize: 15,
                color: defaultColor,
                fontWeight: FontWeight.w400)),
      )
    ]);
  }

  /// Formats the tapped appointment time text, to display on the pop-up view.
  String _getAppointmentTimeText() {
    if (_selectedAppointment.isAllDay) {
      return DateFormat('EEEE, MMM dd')
          .format(_selectedAppointment.startTime)
          .toString();
    } else if (_selectedAppointment.startTime.day !=
            _selectedAppointment.endTime.day ||
        _selectedAppointment.startTime.month !=
            _selectedAppointment.endTime.month ||
        _selectedAppointment.startTime.year !=
            _selectedAppointment.endTime.year) {
      String endFormat = 'EEEE, ';
      if (_selectedAppointment.startTime.month !=
          _selectedAppointment.endTime.month) {
        endFormat += 'MMM';
      }

      endFormat += ' dd hh:mm a';
      return DateFormat('EEEE, MMM dd hh:mm a')
              .format(_selectedAppointment.startTime) +
          ' - ' +
          DateFormat(endFormat).format(_selectedAppointment.endTime);
    } else {
      return DateFormat('EEEE, MMM dd hh:mm a')
              .format(_selectedAppointment.startTime) +
          ' - ' +
          DateFormat('hh:mm a').format(_selectedAppointment.endTime);
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
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
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

  Widget buildSettings(BuildContext context) {
    return ListView(children: <Widget>[
      Row(
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
              // width: 150,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: model.bottomSheetBackgroundColor),
                  child: DropDown(
                      value: _view,
                      item: _viewList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'Month',
                            child: Text('$value',
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      valueChanged: (dynamic value) {
                        setState(() {
                          onCalendarViewChange(value, model);
                        });
                      }),
                ),
              )),
        ],
      )
    ]);
  }
}

SfCalendar getAppointmentEditorCalendar(
    [CalendarView _calendarView,
    CalendarDataSource _calendarDataSource,
    dynamic calendarTapCallback,
    SampleModel model]) {
  return SfCalendar(
      view: _calendarView,
      showNavigationArrow: model.isWeb,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 4),
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
          width: kIsWeb ? 500 : double.maxFinite,
          height: (_colorCollection.length * 50).toDouble(),
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
  const _CalendarTimeZonePicker(this.backgroundColor);

  final Color backgroundColor;

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
          width: kIsWeb ? 500 : double.maxFinite,
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
                  color: widget.backgroundColor,
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

class PopUpAppointmentEditor extends StatefulWidget {
  const PopUpAppointmentEditor(
      this.model, this.newAppointment, this.appointment);

  final SampleModel model;

  final Appointment newAppointment;

  final List<Appointment> appointment;

  @override
  PopUpAppointmentEditorState createState() => PopUpAppointmentEditorState();
}

class PopUpAppointmentEditorState extends State<PopUpAppointmentEditor> {
  @override
  Widget build(BuildContext context) {
    final Color defaultColor = widget.model.themeData != null &&
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Widget _startDatePicker = FlatButton(
      padding: const EdgeInsets.only(left: 0),
      child: Text(DateFormat('MMM dd, yyyy').format(_startDate),
          textAlign: TextAlign.left),
      onPressed: () async {
        final DateTime date = await showDatePicker(
            context: context,
            initialDate: _startDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based on the selected theme and primary
                /// color.
                data: ThemeData(
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(date.year, date.month, date.day,
                _startTime.hour, _startTime.minute, 0);
            _endDate = _startDate.add(difference);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          });
        }
      },
    );

    final Widget _startTimePicker = FlatButton(
      child: Text(
        DateFormat('hh:mm a').format(_startDate),
        textAlign: TextAlign.left,
      ),
      onPressed: () async {
        final TimeOfDay time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
            builder: (BuildContext context, Widget child) {
              /// Theme widget used to apply the theme and primary color to the
              /// time picker.
              return Theme(
                /// The themedata created based on the selected theme and primary
                /// color.
                data: ThemeData(
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child,
              );
            });

        if (time != null && time != _startTime) {
          setState(() {
            _startTime = time;
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(_startDate.year, _startDate.month,
                _startDate.day, _startTime.hour, _startTime.minute, 0);
            _endDate = _startDate.add(difference);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          });
        }
      },
    );

    final Widget _endTimePicker = FlatButton(
      child: Text(
        DateFormat('hh:mm a').format(_endDate),
        textAlign: TextAlign.left,
      ),
      onPressed: () async {
        final TimeOfDay time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
            builder: (BuildContext context, Widget child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based on the selected theme and primary
                /// color.
                data: ThemeData(
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child,
              );
            });

        if (time != null && time != _endTime) {
          setState(() {
            _endTime = time;
            final Duration difference = _endDate.difference(_startDate);
            _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day,
                _endTime.hour, _endTime.minute, 0);
            if (_endDate.isBefore(_startDate)) {
              _startDate = _endDate.subtract(difference);
              _startTime =
                  TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            }
          });
        }
      },
    );

    final Widget _endDatePicker = FlatButton(
      child: Text(DateFormat('MMM dd, yyyy').format(_endDate),
          textAlign: TextAlign.left),
      onPressed: () async {
        final DateTime date = await showDatePicker(
            context: context,
            initialDate: _endDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based on the selected theme and primary
                /// color.
                data: ThemeData(
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _endDate = DateTime(date.year, date.month, date.day, _endTime.hour,
                _endTime.minute, 0);
            if (_endDate.isBefore(_startDate)) {
              _startDate = _endDate.subtract(difference);
              _startTime =
                  TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            }
          });
        }
      },
    );

    return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
      ListTile(
        trailing: IconButton(
          icon: Icon(Icons.close, color: defaultColor),
          onPressed: () {
            if (widget.newAppointment != null &&
                _events.appointments.contains(widget.newAppointment)) {
              /// To remove the created appointment, when the appointment editor
              /// closed without saving the appointment.
              _events.appointments.removeAt(
                  _events.appointments.indexOf(widget.newAppointment));
              _events.notifyListeners(CalendarDataSourceAction.remove,
                  <Appointment>[]..add(widget.newAppointment));
            }

            Navigator.pop(context);
          },
        ),
      ),
      ListTile(
        leading: const Text(''),
        title: TextField(
          autofocus: true,
          controller: TextEditingController(text: _subject),
          onChanged: (String value) {
            _subject = value;
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(
              fontSize: 20, color: defaultColor, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            focusColor: widget.model.backgroundColor,
            border: const UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.model.backgroundColor,
                    width: 2.0,
                    style: BorderStyle.solid)),
            hintText: 'Add title and time',
          ),
        ),
      ),
      ListTile(
        leading: Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.access_time,
              size: 20,
              color: defaultColor,
            )),
        title: _isAllDay
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    _startDatePicker,
                    const Text('-'),
                    _endDatePicker,
                    const Text(''),
                    const Text(''),
                  ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    _startDatePicker,
                    _startTimePicker,
                    const Text('-'),
                    _endTimePicker,
                    _endDatePicker,
                  ]),
      ),
      ListTile(
        leading: Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.location_on,
              color: defaultColor,
              size: 20,
            )),
        title: TextField(
          controller: TextEditingController(text: _location),
          onChanged: (String value) {
            _location = value;
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(
              fontSize: 15, color: defaultColor, fontWeight: FontWeight.w300),
          decoration: const InputDecoration(
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
            fillColor: Colors.transparent,
            border: InputBorder.none,
            hintText: 'Add location',
          ),
        ),
      ),
      ListTile(
        leading: Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.subject,
              size: 20,
              color: defaultColor,
            )),
        title: TextField(
          controller: TextEditingController(text: _notes),
          onChanged: (String value) {
            _notes = value;
          },
          keyboardType: TextInputType.multiline,
          maxLines: widget.model.isWeb ? 1 : null,
          style: TextStyle(
              fontSize: 15, color: defaultColor, fontWeight: FontWeight.w300),
          decoration: const InputDecoration(
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
            fillColor: Colors.transparent,
            border: InputBorder.none,
            hintText: 'Add description',
          ),
        ),
      ),
      ListTile(
        leading: Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Icon(Icons.lens,
                size: 20, color: _colorCollection[_selectedColorIndex])),
        title: FlatButton(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              _colorNames[_selectedColorIndex],
              textAlign: TextAlign.start,
            ),
          ),
          onPressed: () {
            showDialog<Widget>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return _CalendarColorPicker();
              },
            ).then((dynamic value) => setState(() {}));
          },
        ),
      ),
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: const Text('MORE OPTIONS'),
              onPressed: () {
                Navigator.pop(context);
                showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () async {
                          if (widget.newAppointment != null) {
                            _events.appointments.removeAt(_events.appointments
                                .indexOf(widget.newAppointment));
                            _events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[]..add(widget.newAppointment));
                          }
                          return true;
                        },
                        child: AppointmentEditorWeb(widget.model,
                            widget.appointment, widget.newAppointment),
                      );
                    });
              },
            ),
            FlatButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              color: widget.model.backgroundColor,
              textColor: Colors.white,
              child: const Text('SAVE'),
              onPressed: () {
                if (_selectedAppointment != null ||
                    widget.newAppointment != null) {
                  if (_events.appointments.isNotEmpty &&
                      _events.appointments.contains(_selectedAppointment)) {
                    _events.appointments.removeAt(
                        _events.appointments.indexOf(_selectedAppointment));
                    _events.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[]..add(_selectedAppointment));
                  }
                  if (widget.appointment.isNotEmpty &&
                      widget.appointment.contains(widget.newAppointment)) {
                    widget.appointment.removeAt(
                        widget.appointment.indexOf(widget.newAppointment));
                  }
                }

                widget.appointment.add(Appointment(
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
                  location: _location,
                  subject: _subject == '' ? '(No title)' : _subject,
                ));

                _events.appointments.add(widget.appointment[0]);

                _events.notifyListeners(
                    CalendarDataSourceAction.add, widget.appointment);
                _selectedAppointment = null;

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ]);
  }
}

class AppointmentEditorWeb extends StatefulWidget {
  const AppointmentEditorWeb(this.model,
      [this.appointment, this.newAppointment]);

  final SampleModel model;

  final Appointment newAppointment;

  final List<Appointment> appointment;

  @override
  AppointmentEditorWebState createState() => AppointmentEditorWebState();
}

class AppointmentEditorWebState extends State<AppointmentEditorWeb> {
  @override
  Widget build(BuildContext context) {
    final Color defaultColor = widget.model.themeData != null &&
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Container(
        color: widget.model.cardThemeColor,
        width: 600,
        height: _isTimeZoneEnabled ? 490 : 430,
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            ListTile(
              title: Text(
                _selectedAppointment != null && widget.newAppointment == null
                    ? 'Edit appointment'
                    : 'New appointment',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: defaultColor),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, color: defaultColor),
                onPressed: () {
                  if (widget.newAppointment != null &&
                      _events.appointments.contains(widget.newAppointment)) {
                    /// To remove the created appointment when the pop-up closed
                    /// without saving the appointment.
                    _events.appointments.removeAt(
                        _events.appointments.indexOf(widget.newAppointment));
                    _events.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[]..add(widget.newAppointment));
                  }

                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
                title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 2, bottom: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 12,
                                color: defaultColor,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.start,
                          ),
                          TextField(
                            autofocus: true,
                            controller: TextEditingController(text: _subject),
                            onChanged: (String value) {
                              _subject = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 13,
                                color: defaultColor,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              isDense: true,
                              focusColor: widget.model.backgroundColor,
                              border: const UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.model.backgroundColor,
                                      width: 2.0,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 2, bottom: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Location',
                          style: TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: TextEditingController(text: _location),
                          onChanged: (String value) {
                            _location = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 13,
                              color: defaultColor,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            focusColor: widget.model.backgroundColor,
                            isDense: true,
                            border: const UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.model.backgroundColor,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start',
                          style: TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: DateFormat('dd/MM/yy h:mm a')
                                  .format(_startDate)),
                          onChanged: (String value) {
                            _startDate = DateTime.parse(value);
                            _startTime = TimeOfDay(
                                hour: _startDate.hour,
                                minute: _startDate.minute);
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 13,
                              color: defaultColor,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            isDense: true,
                            suffix: Container(
                              height: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  ButtonTheme(
                                      minWidth: 50.0,
                                      child: FlatButton(
                                        onPressed: () async {
                                          final DateTime date =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: _startDate,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                          brightness: widget
                                                              .model
                                                              .themeData
                                                              .brightness,
                                                          colorScheme:
                                                              _getColorScheme(
                                                                  widget.model),
                                                          accentColor: widget
                                                              .model
                                                              .backgroundColor,
                                                          primaryColor: widget
                                                              .model
                                                              .backgroundColor),
                                                      child: child,
                                                    );
                                                  });

                                          if (date != null &&
                                              date != _startDate) {
                                            setState(() {
                                              final Duration difference =
                                                  _endDate
                                                      .difference(_startDate);
                                              _startDate = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  _startTime.hour,
                                                  _startTime.minute,
                                                  0);
                                              _endDate =
                                                  _startDate.add(difference);
                                              _endTime = TimeOfDay(
                                                  hour: _endDate.hour,
                                                  minute: _endDate.minute);
                                            });
                                          }
                                        },
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.date_range,
                                          color: defaultColor,
                                          size: 20,
                                        ),
                                      )),
                                  ButtonTheme(
                                      minWidth: 50.0,
                                      child: FlatButton(
                                        child: Icon(
                                          Icons.access_time,
                                          color: defaultColor,
                                          size: 20,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          final TimeOfDay time =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: _startTime.hour,
                                                      minute:
                                                          _startTime.minute),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                        brightness: widget
                                                            .model
                                                            .themeData
                                                            .brightness,
                                                        colorScheme:
                                                            _getColorScheme(
                                                                widget.model),
                                                        accentColor: widget
                                                            .model
                                                            .backgroundColor,
                                                        primaryColor: widget
                                                            .model
                                                            .backgroundColor,
                                                      ),
                                                      child: child,
                                                    );
                                                  });

                                          if (time != null &&
                                              time != _startTime) {
                                            setState(() {
                                              _startTime = time;
                                              final Duration difference =
                                                  _endDate
                                                      .difference(_startDate);
                                              _startDate = DateTime(
                                                  _startDate.year,
                                                  _startDate.month,
                                                  _startDate.day,
                                                  _startTime.hour,
                                                  _startTime.minute,
                                                  0);
                                              _endDate =
                                                  _startDate.add(difference);
                                              _endTime = TimeOfDay(
                                                  hour: _endDate.hour,
                                                  minute: _endDate.minute);
                                            });
                                          }
                                        },
                                      ))
                                ],
                              ),
                            ),
                            focusColor: widget.model.backgroundColor,
                            border: const UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.model.backgroundColor,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('End',
                            style: TextStyle(
                                fontSize: 12,
                                color: defaultColor,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.start),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: DateFormat('dd/MM/yy h:mm a')
                                  .format(_endDate)),
                          onChanged: (String value) {
                            _endDate = DateTime.parse(value);
                            _endTime = TimeOfDay(
                                hour: _endDate.hour, minute: _endDate.minute);
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 13,
                              color: defaultColor,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            isDense: true,
                            suffix: Container(
                              height: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ButtonTheme(
                                      minWidth: 50.0,
                                      child: FlatButton(
                                        child: Icon(
                                          Icons.date_range,
                                          color: defaultColor,
                                          size: 20,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          final DateTime date =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: _endDate,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                        brightness: widget
                                                            .model
                                                            .themeData
                                                            .brightness,
                                                        colorScheme:
                                                            _getColorScheme(
                                                                widget.model),
                                                        accentColor: widget
                                                            .model
                                                            .backgroundColor,
                                                        primaryColor: widget
                                                            .model
                                                            .backgroundColor,
                                                      ),
                                                      child: child,
                                                    );
                                                  });

                                          if (date != null &&
                                              date != _startDate) {
                                            setState(() {
                                              final Duration difference =
                                                  _endDate
                                                      .difference(_startDate);
                                              _endDate = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  _endTime.hour,
                                                  _endTime.minute,
                                                  0);
                                              if (_endDate
                                                  .isBefore(_startDate)) {
                                                _startDate = _endDate
                                                    .subtract(difference);
                                                _startTime = TimeOfDay(
                                                    hour: _startDate.hour,
                                                    minute: _startDate.minute);
                                              }
                                            });
                                          }
                                        },
                                      )),
                                  ButtonTheme(
                                      minWidth: 50.0,
                                      child: FlatButton(
                                        child: Icon(
                                          Icons.access_time,
                                          color: defaultColor,
                                          size: 20,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          final TimeOfDay time =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: _endTime.hour,
                                                      minute: _endTime.minute),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                        brightness: widget
                                                            .model
                                                            .themeData
                                                            .brightness,
                                                        colorScheme:
                                                            _getColorScheme(
                                                                widget.model),
                                                        accentColor: widget
                                                            .model
                                                            .backgroundColor,
                                                        primaryColor: widget
                                                            .model
                                                            .backgroundColor,
                                                      ),
                                                      child: child,
                                                    );
                                                  });

                                          if (time != null &&
                                              time != _endTime) {
                                            setState(() {
                                              _endTime = time;
                                              final Duration difference =
                                                  _endDate
                                                      .difference(_startDate);
                                              _endDate = DateTime(
                                                  _endDate.year,
                                                  _endDate.month,
                                                  _endDate.day,
                                                  _endTime.hour,
                                                  _endTime.minute,
                                                  0);
                                              if (_endDate
                                                  .isBefore(_startDate)) {
                                                _startDate = _endDate
                                                    .subtract(difference);
                                                _startTime = TimeOfDay(
                                                    hour: _startDate.hour,
                                                    minute: _startDate.minute);
                                              }
                                            });
                                          }
                                        },
                                      ))
                                ],
                              ),
                            ),
                            focusColor: widget.model.backgroundColor,
                            border: const UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.model.backgroundColor,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    focusColor: widget.model.backgroundColor,
                    activeColor: widget.model.backgroundColor,
                    value: _isAllDay,
                    onChanged: (bool value) {
                      setState(() {
                        _isAllDay = value;
                        if (_isAllDay) {
                          _isTimeZoneEnabled = false;
                        }
                      });
                    },
                  ),
                  Text(
                    'All day',
                    style: TextStyle(
                        fontSize: 14,
                        color: defaultColor,
                        fontWeight: FontWeight.w300),
                  ),
                  _isAllDay
                      ? Container()
                      : Checkbox(
                          focusColor: widget.model.backgroundColor,
                          activeColor: widget.model.backgroundColor,
                          value: _isTimeZoneEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isTimeZoneEnabled = value;
                              if (!_isTimeZoneEnabled && _selectedTimeZoneIndex != 0) {
                                _selectedTimeZoneIndex = 0;
                              }
                            });
                          },
                        ),
                  _isAllDay
                      ? Container()
                      : Text(
                          'Time zone',
                          style: TextStyle(
                              fontSize: 14,
                              color: defaultColor,
                              fontWeight: FontWeight.w300),
                        ),
                ],
              ),
            ),
            _isTimeZoneEnabled
                ? ListTile(
                    contentPadding: const EdgeInsets.only(
                        left: 15, top: 2, bottom: 2, right: 305),
                    title: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: defaultColor.withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    _timeZoneCollection[_selectedTimeZoneIndex],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    size: 24,
                                  )
                                ],
                              ),
                              onPressed: () {
                                showDialog<Widget>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return _CalendarTimeZonePicker(
                                        widget.model.backgroundColor);
                                  },
                                ).then((dynamic value) => setState(() {}));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 17, right: 17, bottom: 2, top: 2),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: TextEditingController(text: _notes),
                    onChanged: (String value) {
                      _notes = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: widget.model.isWeb ? 1 : null,
                    style: TextStyle(
                        fontSize: 13,
                        color: defaultColor,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      isDense: true,
                      focusColor: widget.model.backgroundColor,
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.model.backgroundColor,
                              width: 2.0,
                              style: BorderStyle.solid)),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                contentPadding: const EdgeInsets.only(
                    left: 15, top: 2, bottom: 2, right: 15),
                title: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: defaultColor.withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.lens,
                        size: 20,
                        color: _colorCollection[_selectedColorIndex],
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: const EdgeInsets.only(
                            right: 0,
                            left: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _colorNames[_selectedColorIndex],
                                style: TextStyle(
                                    fontSize: 13,
                                    color: defaultColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                              )
                            ],
                          ),
                          onPressed: () {
                            showDialog<Widget>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return _CalendarColorPicker();
                              },
                            ).then((dynamic value) => setState(() {}));
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      if (widget.newAppointment != null) {
                        _events.appointments.removeAt(_events.appointments
                            .indexOf(widget.newAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Appointment>[]..add(widget.newAppointment));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: widget.model.backgroundColor,
                    textColor: Colors.white,
                    child: const Text('SAVE'),
                    onPressed: () {
                      if (_selectedAppointment != null ||
                          widget.newAppointment != null) {
                        if (_events.appointments.isNotEmpty &&
                            _events.appointments
                                .contains(_selectedAppointment)) {
                          _events.appointments.removeAt(_events.appointments
                              .indexOf(_selectedAppointment));
                          _events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[]..add(_selectedAppointment));
                        }
                        if (widget.appointment.isNotEmpty &&
                            widget.appointment
                                .contains(widget.newAppointment)) {
                          widget.appointment.removeAt(widget.appointment
                              .indexOf(widget.newAppointment));
                        }
                      }

                      widget.appointment.add(Appointment(
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
                        location: _location,
                        subject: _subject == '' ? '(No title)' : _subject,
                      ));

                      _events.appointments.add(widget.appointment[0]);

                      _events.notifyListeners(
                          CalendarDataSourceAction.add, widget.appointment);
                      _selectedAppointment = null;

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns color scheme based on dark and light theme.
ColorScheme _getColorScheme(SampleModel model) {
  if (model.themeData.brightness == Brightness.dark) {
    return ColorScheme.dark(
      surface: model.backgroundColor,
      primary: model.backgroundColor,
    );
  }

  return ColorScheme.light(
    primary: model.backgroundColor,
    surface: model.backgroundColor,
  );
}

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor(this.model);

  final SampleModel model;

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
                decoration: const InputDecoration(
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
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData(
                                        brightness:
                                            widget.model.themeData.brightness,
                                        colorScheme:
                                            _getColorScheme(widget.model),
                                        accentColor:
                                            widget.model.backgroundColor,
                                        primaryColor:
                                            widget.model.backgroundColor,
                                      ),
                                      child: child,
                                    );
                                  });

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
                                            minute: _startTime.minute),
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData(
                                              brightness: widget
                                                  .model.themeData.brightness,
                                              colorScheme:
                                                  _getColorScheme(widget.model),
                                              accentColor:
                                                  widget.model.backgroundColor,
                                              primaryColor:
                                                  widget.model.backgroundColor,
                                            ),
                                            child: child,
                                          );
                                        });

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
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData(
                                        brightness:
                                            widget.model.themeData.brightness,
                                        colorScheme:
                                            _getColorScheme(widget.model),
                                        accentColor:
                                            widget.model.backgroundColor,
                                        primaryColor:
                                            widget.model.backgroundColor,
                                      ),
                                      child: child,
                                    );
                                  });

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
                                            minute: _endTime.minute),
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData(
                                              brightness: widget
                                                  .model.themeData.brightness,
                                              colorScheme:
                                                  _getColorScheme(widget.model),
                                              accentColor:
                                                  widget.model.backgroundColor,
                                              primaryColor:
                                                  widget.model.backgroundColor,
                                            ),
                                            child: child,
                                          );
                                        });

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
                    return _CalendarTimeZonePicker(
                        widget.model.backgroundColor);
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
            widget.model.isWeb
                ? ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.location_on,
                      color: defaultColor,
                    ),
                    title: TextField(
                      controller: TextEditingController(text: _location),
                      onChanged: (String value) {
                        _location = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(
                          fontSize: 18,
                          color: defaultColor,
                          fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add location',
                      ),
                    ),
                  )
                : Container(),
            widget.model.isWeb
                ? const Divider(
                    height: 1.0,
                    thickness: 1,
                  )
                : Container(),
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
                maxLines: widget.model.isWeb ? 1 : null,
                style: TextStyle(
                    fontSize: 18,
                    color: defaultColor,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
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
    return Theme(
        data: widget.model.themeData,
        child: Scaffold(
            backgroundColor: widget.model.cardThemeColor,
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
                      final List<Appointment> appointment = <Appointment>[];
                      if (_selectedAppointment != null) {
                        _events.appointments.removeAt(
                            _events.appointments.indexOf(_selectedAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
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
                      widget.model.cardThemeColor,
                      widget.model.themeData.brightness != null &&
                              widget.model.themeData.brightness ==
                                  Brightness.dark
                          ? Colors.white
                          : Colors.black87)
                ],
              ),
            ),
            floatingActionButton: widget.model.isWeb
                ? null
                : _selectedAppointment == null
                    ? const Text('')
                    : FloatingActionButton(
                        onPressed: () {
                          if (_selectedAppointment != null) {
                            _events.appointments.removeAt(_events.appointments
                                .indexOf(_selectedAppointment));
                            _events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[]..add(_selectedAppointment));
                            _selectedAppointment = null;
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(Icons.delete_outline,
                            color: Colors.white),
                        backgroundColor: widget.model.backgroundColor,
                      )));
  }
}
