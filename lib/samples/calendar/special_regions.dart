/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Widget of special region schedule.
class SpecialRegionsCalendar extends SampleView {
  /// Creates Calendar for special regions.
  const SpecialRegionsCalendar(Key key) : super(key: key);

  @override
  _SpecialRegionsCalendarState createState() => _SpecialRegionsCalendarState();
}

class _SpecialRegionsCalendarState extends SampleViewState {
  _SpecialRegionsCalendarState();

  final CalendarController calendarController = CalendarController();
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
  ];
  List<TimeRegion> regions = <TimeRegion>[];
  late _DataSource events;

  @override
  void initState() {
    calendarController.view = CalendarView.week;
    events = _DataSource(_getAppointments());
    _updateRegions();
    super.initState();
  }

  /// Adds the special time region for the Calendar.
  void _updateRegions() {
    final DateTime date = DateTime.now().add(
      Duration(days: -DateTime.now().weekday),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day),
        endTime: DateTime(date.year, date.month, date.day, 9),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
      ),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day, 18),
        endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
      ),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day, 10),
        endTime: DateTime(date.year, date.month, date.day, 11),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        text: 'Not Available',
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=TU',
      ),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day, 15),
        endTime: DateTime(date.year, date.month, date.day, 16),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        text: 'Not Available',
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=WE',
      ),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day, 13),
        endTime: DateTime(date.year, date.month, date.day, 14),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        text: 'Lunch',
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
      ),
    );
    regions.add(
      TimeRegion(
        startTime: DateTime(date.year, date.month, date.day),
        endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withValues(alpha: 0.2),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SA,SU',
      ),
    );
  }

  /// Method that creates the collection the data source for Calendar.
  List<Appointment> _getAppointments() {
    final List<String> subjectCollection = <String>[];
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

    final Random random = Random.secure();
    final DateTime rangeStartDate = DateTime.now().add(
      const Duration(days: -(365 ~/ 2)),
    );
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 365));
    final List<Appointment> appointments = <Appointment>[];
    for (
      DateTime i = rangeStartDate;
      i.isBefore(rangeEndDate);
      i = i.add(const Duration(days: 1))
    ) {
      final DateTime date = i;
      if (date.weekday == 6 || date.weekday == 7) {
        continue;
      }
      final DateTime startDate = DateTime(
        date.year,
        date.month,
        date.day,
        (date.weekday.isEven ? 14 : 9) + random.nextInt(3),
      );
      appointments.add(
        Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(const Duration(hours: 1)),
          color: colorCollection[random.nextInt(9)],
        ),
      );
    }
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: model.sampleOutputCardColor,
              child: Theme(
                data: model.themeData.copyWith(
                  colorScheme: model.themeData.colorScheme.copyWith(
                    secondary: model.primaryColor,
                  ),
                ),
                child: _getSpecialRegionCalendar(
                  regions: regions,
                  dataSource: events,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSpecialRegionWidget(
    BuildContext context,
    TimeRegionDetails details,
  ) {
    if (details.region.text == 'Lunch') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant,
          color: Colors.grey.withValues(alpha: 0.5),
        ),
      );
    } else if (details.region.text == 'Not Available') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(Icons.block, color: Colors.grey.withValues(alpha: 0.5)),
      );
    }
    return Container(color: details.region.color);
  }

  /// Return the Calendar widget based on the properties passed.
  SfCalendar _getSpecialRegionCalendar({
    List<TimeRegion>? regions,
    _DataSource? dataSource,
  }) {
    return SfCalendar(
      showNavigationArrow: model.isWebFullView,
      controller: calendarController,
      showDatePickerButton: true,
      allowedViews: _allowedViews,
      specialRegions: regions,
      timeRegionBuilder: _getSpecialRegionWidget,
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 30),
      ),
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
