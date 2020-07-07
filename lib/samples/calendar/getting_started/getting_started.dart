import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../widgets/customDropDown.dart';

class GettingStartedCalendar extends SampleView {
  const GettingStartedCalendar(Key key) : super(key: key);

  @override
  _GettingStartedCalendarState createState() => _GettingStartedCalendarState();
}

class _GettingStartedCalendarState extends SampleViewState {
  _GettingStartedCalendarState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Meeting> meetings;
  MeetingDataSource events;
  DateTime _minDate, _maxDate;

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
    controller = ScrollController();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    meetings = <Meeting>[];
    addAppointmentDetails();
    events = MeetingDataSource(meetings);
    _minDate = DateTime.now().subtract(const Duration(days: 365 ~/ 2));
    _maxDate = DateTime.now().add(const Duration(days: 365 ~/ 2));
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
  void didUpdateWidget(GettingStartedCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    final Widget _calendar = Theme(
      /// The key set here to maintain the state, when we change the parent of the
      /// widget
      key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: getGettingStartedCalendar(
            _calendarView, events, onViewChanged, _minDate, _maxDate, model));

    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Row(children: <Widget>[
          Expanded(
            child: _view == 'Month' && model.isWeb && _screenHeight < 800
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
          )
        ]),
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

  void onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<Meeting> appointment = <Meeting>[];
    events.appointments.clear();
    final Random random = Random();
    /// Creates new appointment collection based on  the visible dates in calendar.
    if (_calendarView != CalendarView.schedule) {
      for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
        final DateTime date = visibleDatesChangedDetails.visibleDates[i];
        final int count =
            kIsWeb ? 1 + random.nextInt(2) : 1 + random.nextInt(3);
        for (int j = 0; j < count; j++) {
          final DateTime startDate = DateTime(
              date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
          appointment.add(Meeting(
              subjectCollection[random.nextInt(7)],
              '',
              '',
              null,
              startDate,
              startDate.add(Duration(hours: random.nextInt(3))),
              colorCollection[random.nextInt(9)],
              false,
              '',
              ''));
        }
      }
    } else {
      final DateTime rangeStartDate =
          DateTime.now().add(const Duration(days: -(365 ~/ 2)));
      final DateTime rangeEndDate =
          DateTime.now().add(const Duration(days: 365));
      for (DateTime i = rangeStartDate;
          i.isBefore(rangeEndDate);
          i = i.add(const Duration(days: 1))) {
        final DateTime date = i;
        final int count = 1 + random.nextInt(3);
        for (int j = 0; j < count; j++) {
          final DateTime startDate = DateTime(
              date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
          appointment.add(Meeting(
              subjectCollection[random.nextInt(7)],
              '',
              '',
              null,
              startDate,
              startDate.add(Duration(hours: random.nextInt(3))),
              colorCollection[random.nextInt(9)],
              false,
              '',
              ''));
        }
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      events.appointments.add(appointment[i]);
    }

    /// Resets the newly created appointment collection to render the appointments
    /// on the visible dates.
    events.notifyListeners(CalendarDataSourceAction.reset, appointment);
  }

  void addAppointmentDetails() {
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

    colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));
  }

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
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
                  // width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _view,
                          item: _viewList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'Month',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
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
    );
  }
}

SfCalendar getGettingStartedCalendar(
    [CalendarView _calendarView,
    CalendarDataSource _calendarDataSource,
    ViewChangedCallback viewChangedCallback,
    DateTime _minDate,
    DateTime _maxDate,
    SampleModel model]) {
  return SfCalendar(
      view: _calendarView,
      dataSource: _calendarDataSource,
      showNavigationArrow: kIsWeb,
      onViewChanged: viewChangedCallback,
      minDate: _minDate,
      maxDate: _maxDate,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 4),
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 60)));
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

class Meeting {
  Meeting(
      this.eventName,
      this.organizer,
      this.contactID,
      this.capacity,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.startTimeZone,
      this.endTimeZone);

  String eventName;
  String organizer;
  String contactID;
  int capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
}
