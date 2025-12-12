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
class ResizingCalendar extends SampleView {
  /// Creates default getting started Calendar.
  const ResizingCalendar(Key key) : super(key: key);

  @override
  _ResizingCalendarState createState() => _ResizingCalendarState();
}

class _ResizingCalendarState extends SampleViewState {
  _ResizingCalendarState();

  _DataSource _events = _DataSource(<Appointment>[]);
  late CalendarView _currentView;
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _currentView = CalendarView.month;
    _calendarController.view = _currentView;
    _events = _DataSource(getAppointmentDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
      /// The key set here to maintain the state,
      ///  when we change the parent of the widget.
      key: _globalKey,
      data: model.themeData.copyWith(
        colorScheme: model.themeData.colorScheme.copyWith(
          secondary: model.primaryColor,
        ),
      ),
      child: _getResizingCalendar(_calendarController, _events, _onViewChanged),
    );

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child:
                _calendarController.view == CalendarView.month &&
                    model.isWebFullView &&
                    screenHeight < 800
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: _controller,
                    child: ListView(
                      controller: _controller,
                      children: <Widget>[
                        Container(
                          color: model.sampleOutputCardColor,
                          height: 600,
                          child: calendar,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: model.sampleOutputCardColor,
                    child: calendar,
                  ),
          ),
        ],
      ),
    );
  }

  /// Update the current view when the view changed and update the scroll view
  /// when the view changes from or to month view because month view placed
  /// on scroll view.
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
    if (_currentView != CalendarView.month &&
        _calendarController.view != CalendarView.month) {
      _currentView = _calendarController.view!;
      return;
    }
    _currentView = _calendarController.view!;
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

  /// Creates the required appointment details as a list.
  List<Appointment> getAppointmentDetails() {
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

    final List<Appointment> appointments = <Appointment>[];
    final Random random = Random.secure();
    DateTime today = DateTime.now();
    final DateTime rangeStartDate = today.add(
      const Duration(days: -(365 ~/ 2)),
    );
    final DateTime rangeEndDate = today.add(const Duration(days: 365));
    for (
      DateTime i = rangeStartDate;
      i.isBefore(rangeEndDate);
      i = i.add(const Duration(days: 1))
    ) {
      final DateTime date = i;
      final int count = random.nextInt(2);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
          date.year,
          date.month,
          date.day,
          8 + random.nextInt(8),
        );
        appointments.add(
          Appointment(
            subject: subjectCollection[random.nextInt(7)],
            startTime: startDate,
            endTime: startDate.add(Duration(hours: 1 + random.nextInt(3))),
            color: colorCollection[random.nextInt(9)],
          ),
        );
      }
    }

    today = DateTime(today.year, today.month, today.day, 9);
    // Added recurrence appointment.
    appointments.add(
      Appointment(
        subject: 'Development status',
        startTime: today,
        endTime: today.add(const Duration(hours: 2)),
        color: colorCollection[random.nextInt(9)],
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR;INTERVAL=1',
      ),
    );
    return appointments;
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getResizingCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
  ]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      showNavigationArrow: model.isWebFullView,
      onViewChanged: viewChangedCallback,
      allowAppointmentResize: true,
      showDatePickerButton: true,
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
