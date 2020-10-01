///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../../model/sample_view.dart';
import '../../../widgets/switch.dart';

/// Widget of getting started calendar
class GettingStartedCalendar extends SampleView {
  /// Creates default getting started calendar
  const GettingStartedCalendar(Key key) : super(key: key);

  @override
  _GettingStartedCalendarState createState() => _GettingStartedCalendarState();
}

class _GettingStartedCalendarState extends SampleViewState {
  _GettingStartedCalendarState();

  List<String> subjectCollection;
  List<Color> colorCollection;
  List<_Meeting> meetings;
  List<DateTime> blackoutDates;
  _MeetingDataSource events;
  DateTime _minDate, _maxDate;
  CalendarController _calendarController;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  bool _showLeadingAndTrailingDates = true;
  bool _showDatePickerButton = true;
  bool _allowViewNavigation = true;

  ScrollController controller;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  GlobalKey _globalKey;

  @override
  void initState() {
    _showLeadingAndTrailingDates = true;
    _showDatePickerButton = true;
    _allowViewNavigation = true;
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.month;
    _globalKey = GlobalKey();
    controller = ScrollController();
    blackoutDates = <DateTime>[];
    meetings = <_Meeting>[];
    addAppointmentDetails();
    events = _MeetingDataSource(meetings);
    _minDate = DateTime.now().subtract(const Duration(days: 365 ~/ 2));
    _maxDate = DateTime.now().add(const Duration(days: 365 ~/ 2));
    super.initState();
  }

  @override
  Widget build([BuildContext context]) {
    final Widget _calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getGettingStartedCalendar(_calendarController, events,
            _onViewChanged, _minDate, _maxDate, scheduleViewBuilder));

    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: _calendarController.view == CalendarView.month &&
                  model.isWeb &&
                  _screenHeight < 800
              ? Scrollbar(
                  isAlwaysShown: true,
                  controller: controller,
                  child: ListView(
                    controller: controller,
                    children: <Widget>[
                      Container(
                        color: model.cardThemeColor,
                        height: 600,
                        child: _calendar,
                      )
                    ],
                  ))
              : Container(color: model.cardThemeColor, child: _calendar),
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
    if (_calendarController.view == CalendarView.month ||
        _calendarController.view == CalendarView.timelineMonth) {
      for (int i = 0; i < 5; i++) {
        blockedDates.add(visibleDatesChangedDetails.visibleDates[
            random.nextInt(visibleDatesChangedDetails.visibleDates.length)]);
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (_calendarController.view == CalendarView.month ||
            _calendarController.view == CalendarView.timelineMonth) {
          blackoutDates = blockedDates;
        } else {
          blackoutDates?.clear();
        }
      });
    });

    /// Creates new appointment collection based on
    /// the visible dates in calendar.
    if (_calendarController.view != CalendarView.schedule) {
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
              ''));
        }
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

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Allow view navigation',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: model.bottomSheetBackgroundColor),
                  child: Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomSwitch(
                            switchValue: _allowViewNavigation,
                            valueChanged: (dynamic value) {
                              setState(() {
                                _allowViewNavigation = value;
                              });
                            },
                            activeColor: model.backgroundColor,
                          ))),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Show date picker button',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: model.bottomSheetBackgroundColor),
                  child: Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomSwitch(
                            switchValue: _showDatePickerButton,
                            valueChanged: (dynamic value) {
                              setState(() {
                                _showDatePickerButton = value;
                              });
                            },
                            activeColor: model.backgroundColor,
                          ))),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text('Show trailing and leading dates',
                      style:
                          TextStyle(fontSize: 16.0, color: model.textColor))),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: model.bottomSheetBackgroundColor),
                  child: Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomSwitch(
                            switchValue: _showLeadingAndTrailingDates,
                            valueChanged: (dynamic value) {
                              setState(() {
                                _showLeadingAndTrailingDates = value;
                              });
                            },
                            activeColor: model.backgroundColor,
                          ))),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getGettingStartedCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      ViewChangedCallback viewChangedCallback,
      DateTime _minDate,
      DateTime _maxDate,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
        controller: _calendarController,
        dataSource: _calendarDataSource,
        allowedViews: _allowedViews,
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        showNavigationArrow: model.isWeb,
        showDatePickerButton: _showDatePickerButton,
        allowViewNavigation: _allowViewNavigation,
        onViewChanged: viewChangedCallback,
        blackoutDates: blackoutDates,
        blackoutDatesTextStyle: TextStyle(
            decoration: model.isWeb ? null : TextDecoration.lineThrough,
            color: Colors.red),
        minDate: _minDate,
        maxDate: _maxDate,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showTrailingAndLeadingDates: _showLeadingAndTrailingDates,
            appointmentDisplayCount: 4),
        timeSlotViewSettings: TimeSlotViewSettings(
            minimumAppointmentDuration: const Duration(minutes: 60)));
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
Widget scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: [
      Image(
          image: ExactAssetImage('images/' + monthName + '.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          monthName + ' ' + details.date.year.toString(),
          style: TextStyle(fontSize: 18),
        ),
      )
    ],
  );
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
