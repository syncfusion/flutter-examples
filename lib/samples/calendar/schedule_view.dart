///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../model/sample_view.dart';
import 'getting_started.dart';

/// Widget class of Schedule view calendar
class ScheduleViewCalendar extends SampleView {
  /// Creates Schedule view calendar
  const ScheduleViewCalendar(Key key) : super(key: key);

  @override
  _ScheduleViewCalendarState createState() => _ScheduleViewCalendarState();
}

class _ScheduleViewCalendarState extends SampleViewState {
  _ScheduleViewCalendarState();

  late _DataSource events;

  @override
  void initState() {
    events = _DataSource(_getAppointments());
    super.initState();
  }

  /// Method that creates the collection the data source for calendar, with
  /// required information.
  List<Appointment> _getAppointments() {
    final List<String> subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

    final List<Color> colorCollection = <Color>[];
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

    final Random random = Random();
    final DateTime rangeStartDate =
        DateTime.now().add(const Duration(days: -(365 ~/ 2)));
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 365));
    final List<Appointment> appointments = <Appointment>[];
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(Duration(days: random.nextInt(10)))) {
      final DateTime date = i;
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        appointments.add(Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(Duration(hours: random.nextInt(3))),
          color: colorCollection[random.nextInt(9)],
          isAllDay: false,
        ));
      }
    }

    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day, 11, 0, 0);
    // added recurrence appointment
    appointments.add(Appointment(
        subject: 'Scrum',
        startTime: date,
        endTime: date.add(const Duration(hours: 1)),
        color: colorCollection[random.nextInt(9)],
        isAllDay: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=10'));
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: Container(
            color: model.cardThemeColor,
            child: getScheduleViewCalendar(
                events: events, scheduleViewBuilder: scheduleViewBuilder)));
  }

  /// returns the calendar widget based on the properties passed
  SfCalendar getScheduleViewCalendar(
      {_DataSource? events, dynamic scheduleViewBuilder}) {
    return SfCalendar(
      showDatePickerButton: true,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      view: CalendarView.schedule,
      dataSource: events,
    );
  }
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
