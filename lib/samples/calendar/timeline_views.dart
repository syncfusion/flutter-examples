/// Dart import.
import 'dart:math';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Widget of getting started Calendar.
class TimelineViewsCalendar extends SampleView {
  /// Creates default getting started Calendar.
  const TimelineViewsCalendar(Key key) : super(key: key);

  @override
  _TimelineViewsCalendarState createState() => _TimelineViewsCalendarState();
}

class _TimelineViewsCalendarState extends SampleViewState {
  _TimelineViewsCalendarState();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final CalendarController _calendarController = CalendarController();
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];
  List<DateTime> _blackoutDates = <DateTime>[];
  late _MeetingDataSource _events;

  @override
  void initState() {
    addAppointmentDetails();
    _calendarController.view = CalendarView.timelineMonth;
    _events = _MeetingDataSource(<_Meeting>[]);
    super.initState();
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
                child: _getTimelineViewsCalendar(
                  _calendarController,
                  _events,
                  _onViewChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The method called whenever the Calendar view navigated to previous/next
  /// view or switched to different Calendar view, based on the view changed
  /// details new appointment collection added to the Calendar.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    final Random random = Random.secure();
    final List<DateTime> blockedDates = <DateTime>[];
    if (_calendarController.view == CalendarView.timelineMonth) {
      for (int i = 0; i < 5; i++) {
        blockedDates.add(
          visibleDatesChangedDetails.visibleDates[random.nextInt(
            visibleDatesChangedDetails.visibleDates.length,
          )],
        );
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        if (_calendarController.view == CalendarView.timelineMonth) {
          _blackoutDates = blockedDates;
        } else {
          _blackoutDates.clear();
        }
      });
    });

    /// Creates new appointment collection based on visible dates in Calendar.
    for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
      final DateTime date = visibleDatesChangedDetails.visibleDates[i];
      if (blockedDates != null &&
          blockedDates.isNotEmpty &&
          blockedDates.contains(date)) {
        continue;
      }
      final int count = model.isWebFullView
          ? 1 + random.nextInt(2)
          : 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
          date.year,
          date.month,
          date.day,
          8 + random.nextInt(8),
        );
        appointment.add(
          _Meeting(
            _subjectCollection[random.nextInt(7)],
            '',
            '',
            null,
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
            '',
            '',
            i == 0 ? 'FREQ=DAILY;INTERVAL=1' : '',
          ),
        );
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      _events.appointments.add(appointment[i]);
    }

    /// Resets the newly created appointment collection to render
    /// the appointments on the visible dates.
    _events.notifyListeners(CalendarDataSourceAction.reset, appointment);
  }

  /// Creates the required appointment details as a list.
  void addAppointmentDetails() {
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('Plan Execution');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getTimelineViewsCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
  ]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      showNavigationArrow: model.isWebFullView,
      showDatePickerButton: true,
      onViewChanged: viewChangedCallback,
      blackoutDates: _blackoutDates,
      blackoutDatesTextStyle: TextStyle(
        decoration: model.isWebFullView ? null : TextDecoration.lineThrough,
        color: Colors.red,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
    );
  }
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the Calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<_Meeting> get appointments => source;

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
  String? getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String? getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  String? getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in Calendar.
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
    this.recurrenceRule,
  );

  String eventName;
  String? organizer;
  String? contactID;
  int? capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;
}
