///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of special region schedule
class SpecialRegionsCalendar extends SampleView {
  /// Creates calendar for special regions
  const SpecialRegionsCalendar(Key key) : super(key: key);

  @override
  _SpecialRegionsCalendarState createState() => _SpecialRegionsCalendarState();
}

class _SpecialRegionsCalendarState extends SampleViewState {
  _SpecialRegionsCalendarState();

  List<TimeRegion> regions;
  CalendarController calendarController;
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek
  ];

  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Appointment> _appointments;
  _DataSource events;

  @override
  void initState() {
    _appointments = <Appointment>[];
    calendarController = CalendarController();
    calendarController.view = CalendarView.week;
    _addAppointmentDetails();
    _addAppointments();
    events = _DataSource(_appointments);
    _addRegions();
    super.initState();
  }

  /// Adds the special time region for the calendar with the required information
  void _addRegions() {
    regions = <TimeRegion>[];
    final DateTime date =
        DateTime.now().add(Duration(days: -DateTime.now().weekday));
    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day),
      endTime: DateTime(date.year, date.month, date.day, 9, 0, 0),
      enablePointerInteraction: false,
      textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 18, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
      enablePointerInteraction: false,
      textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 13, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 14, 0, 0),
      enablePointerInteraction: false,
      textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 0, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
      enablePointerInteraction: false,
      textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SA,SU',
    ));
  }

  /// Creates the required appointment details as a list.
  void _addAppointmentDetails() {
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

  /// Method that creates the collection the data source for calendar, with
  /// required information.
  void _addAppointments() {
    final Random random = Random();
    final DateTime rangeStartDate =
        DateTime.now().add(const Duration(days: -(365 ~/ 2)));
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 365));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      if (date.weekday == 6 || date.weekday == 7) {
        continue;
      }

      final DateTime startDate = DateTime(date.year, date.month, date.day,
          (date.weekday % 2 == 0 ? 14 : 9) + random.nextInt(3), 0, 0);
      _appointments.add(Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(const Duration(hours: 1)),
          color: colorCollection[random.nextInt(9)]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
      Expanded(
          child: Container(
        color: model.cardThemeColor,
        child: Theme(
            data: model.themeData.copyWith(accentColor: model.backgroundColor),
            child: _getSpecialRegionCalendar(
                regions: regions, dataSource: events)),
      ))
    ]));
  }

  /// Return the calendar widget based on the properties passed
  SfCalendar _getSpecialRegionCalendar(
      {List<TimeRegion> regions, _DataSource dataSource}) {
    return SfCalendar(
      showNavigationArrow: model.isWeb,
      controller: calendarController,
      showDatePickerButton: true,
      allowedViews: _allowedViews,
      specialRegions: regions,
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 30)),
      dataSource: dataSource,
    );
  }
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
