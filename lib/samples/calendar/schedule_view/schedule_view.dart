import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleViewCalendar extends SampleView {
  const ScheduleViewCalendar(Key key) : super(key: key);

  @override
  _ScheduleViewCalendarState createState() => _ScheduleViewCalendarState();
}

class _ScheduleViewCalendarState extends SampleViewState {
  _ScheduleViewCalendarState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Appointment> appointments;
  _DataSource events;

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    appointments = <Appointment>[];
    addAppointmentDetails();
    addAppointments();
    events = _DataSource(appointments);
    super.initState();
  }

  void addAppointmentDetails() {
    subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
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

  void addAppointments() {
    final Random random = Random();
    final DateTime rangeStartDate =
        DateTime.now().add(const Duration(days: -(365 ~/ 2)));
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 365));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
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
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(ScheduleViewCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: Container(
            color: model.isWeb
                ? model.webSampleBackgroundColor
                : model.cardThemeColor,
            child: getScheduleViewCalendar(events: events)));
  }

  SfCalendar getScheduleViewCalendar({_DataSource events}) {
    return SfCalendar(
      view: CalendarView.schedule,
      dataSource: events,
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
