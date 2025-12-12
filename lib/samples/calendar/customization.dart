/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' show DateFormat;

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local import.
import '../../model/sample_view.dart';
import '../../samples/calendar/getting_started.dart';

/// Widget of customization Calendar.
class CustomizationCalendar extends SampleView {
  /// Creates default customization Calendar.
  const CustomizationCalendar(Key key) : super(key: key);

  @override
  _CustomizationCalendarState createState() => _CustomizationCalendarState();
}

class _CustomizationCalendarState extends SampleViewState {
  _CustomizationCalendarState();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final List<IconData> _iconCollection = <IconData>[];
  final List<String> _locationCollection = <String>[];
  final _MeetingDataSource _events = _MeetingDataSource(<_Meeting>[]);
  final CalendarController _calendarController = CalendarController();
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];
  final ScrollController _controller = ScrollController();
  CalendarView _currentView = CalendarView.week;

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _calendarController.view = _currentView;
    addAppointmentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
      /// The key set here to maintain the state,
      /// when we change the parent of the widget.
      key: _globalKey,
      data: model.themeData.copyWith(
        colorScheme: model.themeData.colorScheme.copyWith(
          secondary: model.primaryColor,
        ),
      ),
      child: _getCustomizationCalendar(
        _calendarController,
        _events,
        _onViewChanged,
        _getAppointmentUI,
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

  /// The method called whenever the Calendar view navigated to previous/next
  /// view or switched to different Calendar view, based on the view changed
  /// details new appointment collection added to the Calendar.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    final Random random = Random.secure();

    /// Remove the scroll bar on sample while change the view from
    /// month view or change the view to month view.
    if (_currentView != _calendarController.view &&
        model.isWebFullView &&
        (_currentView == CalendarView.month ||
            _calendarController.view == CalendarView.month)) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        setState(() {});
      });
    }
    _currentView = _calendarController.view!;
    if (_currentView == CalendarView.day ||
        _currentView == CalendarView.week ||
        _currentView == CalendarView.workWeek) {
      final Map<String, String> events = <String, String>{};
      events['Environmental Discussion'] =
          'The day that encourages awareness to promote the healthy planet and reduce air pollution crisis on nature earth';
      events['Health Checkup'] =
          'The day that raises awareness on different health issues. It marks the anniversary of the foundation of WHO';
      events['Cancer awareness'] =
          'The day that promotes awareness on cancer and its preventive measures. Early detection saves life';
      events['Happiness'] =
          'The general idea is to promote happiness and smile around the world';
      events['Tourism'] =
          'The day that raises awareness to the role of tourism and its effect on social and economic values';
      final List<Color> colors = <Color>[
        const Color(0xFF56AB56),
        const Color(0xFF357CD2),
        const Color(0xFF7FA90E),
        Colors.deepOrangeAccent,
        const Color(0xFF5BBEAF),
      ];
      final List<String> images = <String>[
        'environment_day',
        'health_day',
        'cancer_day',
        'happiness_day',
        'tourism_day',
      ];
      final List<String> keys = events.keys.toList();
      DateTime date = DateTime.now();
      date = DateTime(
        date.year,
        date.month,
        date.day,
        9,
      ).subtract(Duration(days: date.weekday - 1));
      for (int i = 0; i < 5; i++) {
        final String key = keys[i];
        appointment.add(
          _Meeting(
            key,
            date,
            date.add(const Duration(hours: 6)),
            colors[i],
            false,
            events[key]!,
            images[i],
            null,
            '',
          ),
        );
        date = date.add(const Duration(days: 1));
      }
    }
    /// Creates new appointment collection based on
    /// the visible dates in Calendar.
    else if (_currentView != CalendarView.schedule) {
      for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
        final DateTime date = visibleDatesChangedDetails.visibleDates[i];
        final int count = _currentView != CalendarView.month
            ? 1
            : 1 + random.nextInt(model.isWebFullView ? 2 : 3);
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
              startDate,
              startDate.add(Duration(hours: random.nextInt(3))),
              _colorCollection[random.nextInt(9)],
              false,
              '',
              '',
              null,
              '',
            ),
          );
        }
      }
    } else {
      final DateTime rangeStartDate = DateTime.now().add(
        const Duration(days: -(365 ~/ 2)),
      );
      final DateTime rangeEndDate = DateTime.now().add(
        const Duration(days: 365),
      );
      for (
        DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))
      ) {
        final DateTime date = i;
        final int count = 1 + random.nextInt(6);
        for (int j = 0; j < count; j++) {
          final DateTime startDate = DateTime(
            date.year,
            date.month,
            date.day,
            8 + random.nextInt(8),
          );
          final int index = random.nextInt(7);
          appointment.add(
            _Meeting(
              _subjectCollection[index],
              startDate,
              startDate.add(
                Duration(hours: random.nextInt(j % 4 == 0 ? 36 : 3)),
              ),
              _colorCollection[random.nextInt(9)],
              false,
              '',
              '',
              _iconCollection[index],
              _locationCollection[random.nextInt(4)],
            ),
          );
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

    _iconCollection.add(Icons.people_outlined);
    _iconCollection.add(Icons.supervisor_account_outlined);
    _iconCollection.add(Icons.sticky_note_2_outlined);
    _iconCollection.add(Icons.headset_mic_outlined);
    _iconCollection.add(Icons.perm_phone_msg_outlined);
    _iconCollection.add(Icons.file_copy_outlined);
    _iconCollection.add(Icons.personal_video_outlined);
    _iconCollection.add(Icons.fact_check_outlined);
    _iconCollection.add(Icons.new_releases_outlined);
    _iconCollection.add(Icons.speed_outlined);

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

    _locationCollection.add('Paris');
    _locationCollection.add('New York');
    _locationCollection.add('London');
    _locationCollection.add('Chicago');
    _locationCollection.add('Singapore');
  }

  Widget _getAppointmentUI(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final dynamic meetingData = details.appointments.first;
    late final _Meeting meeting;
    if (meetingData is _Meeting) {
      meeting = meetingData;
    }
    final Color textColor =
        model.themeData == null ||
            model.themeData.colorScheme.brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    if (_calendarController.view == CalendarView.timelineDay ||
        _calendarController.view == CalendarView.timelineWeek ||
        _calendarController.view == CalendarView.timelineWorkWeek ||
        _calendarController.view == CalendarView.timelineMonth) {
      final double horizontalHighlight =
          _calendarController.view == CalendarView.timelineMonth ? 10 : 20;
      final double cornerRadius = horizontalHighlight / 4;
      return Row(
        children: <Widget>[
          Container(
            width: horizontalHighlight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cornerRadius),
                bottomLeft: Radius.circular(cornerRadius),
              ),
              color: meeting.background,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: meeting.background.withValues(alpha: 0.8),
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                meeting.eventName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            width: horizontalHighlight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(cornerRadius),
                bottomRight: Radius.circular(cornerRadius),
              ),
              color: meeting.background,
            ),
          ),
        ],
      );
    } else if (_calendarController.view != CalendarView.month &&
        _calendarController.view != CalendarView.schedule) {
      return Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(3),
            height: 50,
            alignment: model.isMobileResolution
                ? Alignment.topLeft
                : Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: meeting.background,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    meeting.eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: model.isMobileResolution ? 3 : 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (model.isMobileResolution)
                    Container()
                  else
                    Text(
                      'Time: ${DateFormat('hh:mm a').format(meeting.from)} - '
                      '${DateFormat('hh:mm a').format(meeting.to)}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: details.bounds.height - 70,
            padding: const EdgeInsets.fromLTRB(3, 5, 3, 2),
            color: meeting.background.withValues(alpha: 0.8),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Image(
                      image: ExactAssetImage(
                        'images/' + meeting.image + '.png',
                      ),
                      fit: BoxFit.contain,
                      width: details.bounds.width,
                      height: 60,
                    ),
                  ),
                  Text(
                    meeting.notes,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              color: meeting.background,
            ),
          ),
        ],
      );
    } else if (_calendarController.view == CalendarView.month) {
      final double fontSize = details.bounds.height > 11
          ? 10
          : details.bounds.height - 1;
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: details.isMoreAppointmentRegion
            ? Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  '+ More',
                  style: TextStyle(color: textColor, fontSize: fontSize),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : model.isMobileResolution
            ? Row(
                children: <Widget>[
                  Icon(Icons.circle, color: meeting.background, size: fontSize),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        meeting.eventName,
                        style: TextStyle(color: textColor, fontSize: fontSize),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Icon(Icons.circle, color: meeting.background, size: fontSize),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      meeting.isAllDay
                          ? 'All'
                          : DateFormat('h a').format(meeting.from),
                      style: TextStyle(color: textColor, fontSize: fontSize),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      meeting.eventName,
                      style: TextStyle(color: textColor, fontSize: fontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      );
    }
    final String format = (meeting.to.difference(meeting.from).inHours < 24)
        ? 'HH:mm'
        : 'dd MMM';
    final Color iconColor =
        model.themeData == null ||
            model.themeData.colorScheme.brightness == Brightness.light
        ? Colors.black87
        : Colors.white;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      color:
          model.themeData == null ||
              model.themeData.colorScheme.brightness == Brightness.light
          ? model.backgroundColor
          : model.homeCardColor,
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
              color: meeting.background,
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                ),
              ),
              padding: const EdgeInsets.only(left: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        meeting.eventName + (model.isWebFullView ? ', ' : ''),
                        style: TextStyle(
                          color: textColor,
                          fontSize: model.isWebFullView ? 15 : 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (model.isWebFullView)
                        Text(
                          meeting.location,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.6),
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        const Text(''),
                    ],
                  ),
                  Text(
                    DateFormat(format).format(meeting.from) +
                        ' - ' +
                        DateFormat(format).format(meeting.to),
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.6),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          _getScheduleAppointmentIcon(meeting),
          Container(
            margin: EdgeInsets.zero,
            width: 30,
            alignment: Alignment.center,
            child: Icon(meeting.icon, size: 20, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _getScheduleAppointmentIcon(_Meeting meeting) {
    if (meeting.eventName == 'General Meeting') {
      return Container(
        margin: EdgeInsets.zero,
        width: 30,
        alignment: Alignment.center,
        child: const Icon(
          Icons.priority_high_outlined,
          size: 20,
          color: Colors.red,
        ),
      );
    }

    return Container(width: 30);
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getCustomizationCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
    CalendarAppointmentBuilder? appointmentBuilder,
  ]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      appointmentBuilder: appointmentBuilder,
      showNavigationArrow: model.isWebFullView,
      showDatePickerButton: true,
      cellEndPadding: 3,
      onViewChanged: viewChangedCallback,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      scheduleViewSettings: ScheduleViewSettings(
        appointmentItemHeight: model.isWebFullView ? 60 : 50,
      ),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timelineAppointmentHeight: 50,
        timeIntervalWidth: 100,
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
  String? getLocation(int index) {
    return source[index].location;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in Calendar.
class _Meeting {
  _Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.notes,
    this.image,
    this.icon,
    this.location,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String notes;
  String image;
  IconData? icon;
  String location;
}
