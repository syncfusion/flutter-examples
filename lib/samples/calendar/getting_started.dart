///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of getting started calendar
class GettingStartedCalendar extends SampleView {
  /// Creates default getting started calendar
  const GettingStartedCalendar(Key key) : super(key: key);

  @override
  _GettingStartedCalendarState createState() => _GettingStartedCalendarState();
}

class _GettingStartedCalendarState extends SampleViewState {
  _GettingStartedCalendarState();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final _MeetingDataSource _events = _MeetingDataSource(<_Meeting>[]);
  final DateTime _minDate =
          DateTime.now().subtract(const Duration(days: 365 ~/ 2)),
      _maxDate = DateTime.now().add(const Duration(days: 365 ~/ 2));

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  final List<String> _viewNavigationModeList =
      <String>['Snap', 'None'].toList();

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();

  List<DateTime> _blackoutDates = <DateTime>[];
  bool _showLeadingAndTrailingDates = true;
  bool _showDatePickerButton = true;
  bool _allowViewNavigation = true;
  bool _showCurrentTimeIndicator = true;

  ViewNavigationMode _viewNavigationMode = ViewNavigationMode.snap;
  String _viewNavigationModeString = 'Snap';

  @override
  void initState() {
    _calendarController.view = CalendarView.month;
    addAppointmentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getGettingStartedCalendar(_calendarController, _events,
            _onViewChanged, _minDate, _maxDate, scheduleViewBuilder));

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: _calendarController.view == CalendarView.month &&
                  model.isWebFullView &&
                  screenHeight < 800
              ? Scrollbar(
                  isAlwaysShown: true,
                  controller: _controller,
                  child: ListView(
                    controller: _controller,
                    children: <Widget>[
                      Container(
                        color: model.cardThemeColor,
                        height: 600,
                        child: calendar,
                      )
                    ],
                  ))
              : Container(color: model.cardThemeColor, child: calendar),
        )
      ]),
    );
  }

  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view, based on the view changed
  /// details new appointment collection added to the calendar
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    final Random random = Random();
    final List<DateTime> blockedDates = <DateTime>[];
    if (_calendarController.view == CalendarView.month ||
        _calendarController.view == CalendarView.timelineMonth) {
      for (int i = 0; i < 5; i++) {
        blockedDates.add(visibleDatesChangedDetails.visibleDates[
            random.nextInt(visibleDatesChangedDetails.visibleDates.length)]);
      }
    }

    SchedulerBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        if (_calendarController.view == CalendarView.month ||
            _calendarController.view == CalendarView.timelineMonth) {
          _blackoutDates = blockedDates;
        } else {
          _blackoutDates.clear();
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
        final int count = 1 + random.nextInt(model.isWebFullView ? 2 : 3);
        for (int j = 0; j < count; j++) {
          final DateTime startDate = DateTime(
              date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
          appointment.add(_Meeting(
            _subjectCollection[random.nextInt(7)],
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
          ));
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
            _subjectCollection[random.nextInt(7)],
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
          ));
        }
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

  /// Allows/Restrict switching to previous/next views through swipe interaction
  void onViewNavigationModeChange(String value) {
    _viewNavigationModeString = value;
    if (value == 'Snap') {
      _viewNavigationMode = ViewNavigationMode.snap;
    } else if (value == 'None') {
      _viewNavigationMode = ViewNavigationMode.none;
    }
    setState(() {
      /// update the view navigation mode changes
    });
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
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
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: model.backgroundColor,
                            value: _allowViewNavigation,
                            onChanged: (bool value) {
                              setState(() {
                                _allowViewNavigation = value;
                                stateSetter(() {});
                              });
                            },
                          )),
                    ),
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
                  padding: const EdgeInsets.all(0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: model.backgroundColor,
                            value: _showDatePickerButton,
                            onChanged: (bool value) {
                              setState(() {
                                _showDatePickerButton = value;
                                stateSetter(() {});
                              });
                            },
                          )),
                    ),
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
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: model.backgroundColor,
                            value: _showLeadingAndTrailingDates,
                            onChanged: (bool value) {
                              setState(() {
                                _showLeadingAndTrailingDates = value;
                                stateSetter(() {});
                              });
                            },
                          )),
                    )),
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
                    child: Text('Show current time indicator',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: Container(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: model.backgroundColor,
                            value: _showCurrentTimeIndicator,
                            onChanged: (bool value) {
                              setState(() {
                                _showCurrentTimeIndicator = value;
                                stateSetter(() {});
                              });
                            },
                          )),
                    )),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Text('View navigation mode',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor))),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(left: 60),
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _viewNavigationModeString,
                        items: _viewNavigationModeList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'Snap',
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        onChanged: (dynamic value) {
                          onViewNavigationModeChange(value);
                          stateSetter(() {});
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getGettingStartedCalendar(
      [CalendarController? _calendarController,
      CalendarDataSource? _calendarDataSource,
      ViewChangedCallback? viewChangedCallback,
      DateTime? _minDate,
      DateTime? _maxDate,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      controller: _calendarController,
      dataSource: _calendarDataSource,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showNavigationArrow: model.isWebFullView,
      showDatePickerButton: _showDatePickerButton,
      allowViewNavigation: _allowViewNavigation,
      showCurrentTimeIndicator: _showCurrentTimeIndicator,
      onViewChanged: viewChangedCallback,
      blackoutDates: _blackoutDates,
      blackoutDatesTextStyle: TextStyle(
          decoration: model.isWebFullView ? null : TextDecoration.lineThrough,
          color: Colors.red),
      minDate: _minDate,
      maxDate: _maxDate,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showTrailingAndLeadingDates: _showLeadingAndTrailingDates,
          appointmentDisplayCount: 4),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 60)),
      viewNavigationMode: _viewNavigationMode,
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
Widget scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: <Widget>[
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
          style: const TextStyle(fontSize: 18),
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
  Color getColor(int index) {
    return source[index].background;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
