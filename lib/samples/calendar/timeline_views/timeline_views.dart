///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of getting started calendar
class TimelineViewsCalendar extends SampleView {
  /// Creates default getting started calendar
  const TimelineViewsCalendar(Key key) : super(key: key);

  @override
  _TimelineViewsCalendarState createState() => _TimelineViewsCalendarState();
}

class _TimelineViewsCalendarState extends SampleViewState {
  _TimelineViewsCalendarState();

  List<String> subjectCollection;
  List<Color> colorCollection;
  List<_Meeting> meetings;
  List<DateTime> blackoutDates;
  _MeetingDataSource events;
  CalendarController _calendarController;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  @override
  void initState() {
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.timelineMonth;
    blackoutDates = <DateTime>[];
    meetings = <_Meeting>[];
    addAppointmentDetails();
    events = _MeetingDataSource(meetings);
    super.initState();
  }

  @override
  Widget build([BuildContext context]) {
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: Container(
              color: model.cardThemeColor,
              child: Theme(
                  data: model.themeData
                      .copyWith(accentColor: model.backgroundColor),
                  child: _getTimelineViewsCalendar(
                      _calendarController, events, _onViewChanged))),
        )
      ]),
    );
  }

  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view, based on the view changed
  /// details new appointment collection added to the calendar
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<_Meeting> appointment = <_Meeting>[];
    events.appointments.clear();
    final Random random = Random();
    final List<DateTime> blockedDates = <DateTime>[];
    if (_calendarController.view == CalendarView.timelineMonth) {
      for (int i = 0; i < 5; i++) {
        blockedDates.add(visibleDatesChangedDetails.visibleDates[
            random.nextInt(visibleDatesChangedDetails.visibleDates.length)]);
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (_calendarController.view == CalendarView.timelineMonth) {
          blackoutDates = blockedDates;
        } else {
          blackoutDates?.clear();
        }
      });
    });

    /// Creates new appointment collection based on
    /// the visible dates in calendar.
    for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
      final DateTime date = visibleDatesChangedDetails.visibleDates[i];
      if (blockedDates != null &&
          blockedDates.isNotEmpty &&
          blockedDates.contains(date)) {
        continue;
      }
      final int count =
          model.isWeb ? 1 + random.nextInt(2) : 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        appointment.add(_Meeting(
            subjectCollection[random.nextInt(7)],
            '',
            '',
            null,
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            colorCollection[random.nextInt(9)],
            false,
            '',
            '',
            i == 0 ? 'FREQ=DAILY;INTERVAL=1' : ''));
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      events.appointments.add(appointment[i]);
    }

    /// Resets the newly created appointment collection to render
    /// the appointments on the visible dates.
    events.notifyListeners(CalendarDataSourceAction.reset, appointment);
  }

  /// Creates the required appointment details as a list.
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

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getTimelineViewsCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      ViewChangedCallback viewChangedCallback]) {
    return SfCalendar(
        controller: _calendarController,
        dataSource: _calendarDataSource,
        allowedViews: _allowedViews,
        showNavigationArrow: model.isWeb,
        showDatePickerButton: true,
        onViewChanged: viewChangedCallback,
        blackoutDates: blackoutDates,
        blackoutDatesTextStyle: TextStyle(
            decoration: model.isWeb ? null : TextDecoration.lineThrough,
            color: Colors.red),
        timeSlotViewSettings: TimeSlotViewSettings(
            minimumAppointmentDuration: const Duration(minutes: 60)));
  }
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

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

  @override
  String getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class _Meeting {
  _Meeting(
      this.eventName,
      this.organizer,
      this.contactID,
      this.capacity,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.startTimeZone,
      this.endTimeZone,
      this.recurrenceRule);

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
  String recurrenceRule;
}
