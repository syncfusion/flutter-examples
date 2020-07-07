import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaViewCalendar extends SampleView {
  const AgendaViewCalendar(Key key) : super(key: key);

  @override
  _AgendaViewCalendarState createState() => _AgendaViewCalendarState();
}

class _AgendaViewCalendarState extends SampleViewState {
  _AgendaViewCalendarState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Meeting> meetings;
  MeetingDataSource events;
  DateTime selectedDate;
  ScrollController controller;

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    meetings = <Meeting>[];
    controller = ScrollController();
    selectedDate = DateTime.now();
    addAppointmentDetails();
    addAppointments();
    events = MeetingDataSource(meetings);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(AgendaViewCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final Widget _calendar = Theme(
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: getAgendaViewCalendar(
            events,
            onViewChanged,
            model.isWeb
                ? (_screenHeight < 600 ? 250 : _screenHeight * 0.4)
                : null,
            selectedDate));
    return model.isWeb && _screenHeight < 600
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
                  height: 450,
                  child: _calendar,
                )
              ],
            ))
        : Container(
            color: model.isWeb
                ? model.webSampleBackgroundColor
                : model.cardThemeColor,
            child: _calendar,
          );
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
        meetings.add(Meeting(
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
            ''));
      }
    }

    // added recurrence appointment
    meetings.add(Meeting(
        'Development status',
        '',
        '',
        null,
        DateTime.now(),
        DateTime.now().add(const Duration(hours: 2)),
        colorCollection[random.nextInt(9)],
        false,
        '',
        '',
        'FREQ=WEEKLY;BYDAY=FR;INTERVAL=1'));
  }

  void onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final DateTime currentViewDate = visibleDatesChangedDetails
          .visibleDates[visibleDatesChangedDetails.visibleDates.length ~/ 2];
      if (currentViewDate.month == DateTime.now().month &&
          currentViewDate.year == DateTime.now().year) {
        selectedDate = DateTime.now();
      } else {
        selectedDate =
            DateTime(currentViewDate.year, currentViewDate.month, 01);
      }
      setState(() {});
    });
  }

  SfCalendar getAgendaViewCalendar(
      [CalendarDataSource _calendarDataSource,
      ViewChangedCallback onViewChanged,
      double _agendaViewHeight,
      DateTime selectedDate]) {
    return SfCalendar(
      view: CalendarView.month,
      initialSelectedDate: selectedDate,
      showNavigationArrow: kIsWeb,
      onViewChanged: onViewChanged,
      dataSource: _calendarDataSource,
      monthViewSettings: MonthViewSettings(
          showAgenda: true,
          numberOfWeeksInView: kIsWeb ? 2 : 6,
          agendaViewHeight: _agendaViewHeight ?? -1),
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 60)),
    );
  }
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

  @override
  String getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
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
