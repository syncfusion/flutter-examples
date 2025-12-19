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
class LoadMoreCalendar extends SampleView {
  /// Creates default getting started Calendar.
  const LoadMoreCalendar(Key key) : super(key: key);

  @override
  _LoadMoreCalendarState createState() => _LoadMoreCalendarState();
}

Map<DateTime, List<_Meeting>> _dataCollection = <DateTime, List<_Meeting>>{};

class _LoadMoreCalendarState extends SampleViewState {
  _LoadMoreCalendarState();

  final _MeetingDataSource _events = _MeetingDataSource(<_Meeting>[]);
  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.month;
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];
  final ScrollController _controller = ScrollController();

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _calendarController.view = _view;
    _addAppointmentDetails();
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
      child: _getLoadMoreCalendar(
        _calendarController,
        _onViewChanged,
        _events,
        _scheduleViewBuilder,
      ),
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

  /// Handle the view changed and it used to update the UI on web platform
  /// whether the Calendar view changed from month view or to month view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == _calendarController.view) {
      return;
    }
    if ((_calendarController.view == CalendarView.month ||
            _view == CalendarView.month) &&
        model.isWebFullView) {
      _view = _calendarController.view!;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          /// Update the web UI when the Calendar view changed from month view
          /// or to month view.
        });
      });
    }
    _view = _calendarController.view!;
  }

  /// Creates the required appointment details as a list.
  void _addAppointmentDetails() {
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
    _dataCollection = <DateTime, List<_Meeting>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1000));
    for (
      DateTime i = rangeStartDate;
      i.isBefore(rangeEndDate);
      i = i.add(Duration(days: 1 + random.nextInt(2)))
    ) {
      final DateTime date = i;
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
          date.year,
          date.month,
          date.day,
          8 + random.nextInt(8),
        );
        final int duration = random.nextInt(3);
        final _Meeting meeting = _Meeting(
          subjectCollection[random.nextInt(7)],
          startDate,
          startDate.add(Duration(hours: duration == 0 ? 1 : duration)),
          colorCollection[random.nextInt(9)],
          false,
        );
        if (_dataCollection.containsKey(date)) {
          final List<_Meeting> meetings = _dataCollection[date]!;
          meetings.add(meeting);
          _dataCollection[date] = meetings;
        } else {
          _dataCollection[date] = <_Meeting>[meeting];
        }
      }
    }
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getLoadMoreCalendar([
    CalendarController? calendarController,
    ViewChangedCallback? viewChangedCallback,
    CalendarDataSource? calendarDataSource,
    dynamic scheduleViewBuilder,
  ]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      onViewChanged: viewChangedCallback,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showNavigationArrow: model.isWebFullView,
      blackoutDatesTextStyle: TextStyle(
        decoration: model.isWebFullView ? null : TextDecoration.lineThrough,
        color: Colors.red,
      ),
      loadMoreWidgetBuilder:
          (BuildContext context, LoadMoreCallback loadMoreAppointments) {
            return FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
                return Container(
                  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color?>(
                      model.primaryColor,
                    ),
                  ),
                );
              },
            );
          },
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
    );
  }
}

/// Returns the month name based on the month value passed from date.
String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}

/// Returns the builder for schedule view.
Widget _scheduleViewBuilder(
  BuildContext buildContext,
  ScheduleViewMonthHeaderDetails details,
) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: <Widget>[
      Image(
        image: ExactAssetImage('images/' + monthName + '.png'),
        fit: BoxFit.cover,
        width: details.bounds.width,
        height: details.bounds.height,
      ),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          monthName + ' ' + details.date.year.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ],
  );
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the Calendar appointment, and
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
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    final List<_Meeting> meetings = <_Meeting>[];
    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime appEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );
    while (date.isBefore(appEndDate)) {
      final List<_Meeting>? data = _dataCollection[date];
      if (data == null) {
        date = date.add(const Duration(days: 1));
        continue;
      }
      for (final _Meeting meeting in data) {
        if (appointments.contains(meeting)) {
          continue;
        }
        meetings.add(meeting);
      }
      date = date.add(const Duration(days: 1));
    }
    appointments.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in Calendar.
class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
