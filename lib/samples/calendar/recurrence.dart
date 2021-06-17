///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../model/sample_view.dart';
import 'getting_started.dart';

/// Widget class of recurrence calendar
class RecurrenceCalendar extends SampleView {
  /// Creates recurrence calendar
  const RecurrenceCalendar(Key key) : super(key: key);

  @override
  _RecurrenceCalendarState createState() => _RecurrenceCalendarState();
}

class _RecurrenceCalendarState extends SampleViewState {
  _RecurrenceCalendarState();

  final CalendarController calendarController = CalendarController();
  late _AppointmentDataSource _dataSource;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  final ScrollController controller = ScrollController();

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  CalendarView _view = CalendarView.week;

  @override
  void initState() {
    calendarController.view = _view;
    _dataSource = _AppointmentDataSource(_getRecursiveAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _calendar = Theme(

        /// The key set here to maintain the state, when we change
        /// the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getRecurrenceCalendar(calendarController, _dataSource,
            _onViewChanged, scheduleViewBuilder));

    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: calendarController.view == CalendarView.month &&
                  model.isWebFullView &&
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
  /// view or switched to different calendar view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == calendarController.view ||
        !model.isWebFullView ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view!;

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  /// Creates the data source with the recurrence appointments by adding required
  /// information on it.
  List<Appointment> _getRecursiveAppointments() {
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
    final Random random = Random();
    //Recurrence Appointment 1
    final DateTime currentDate = DateTime.now();
    final DateTime startTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 0, 0);
    final DateTime endTime = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 11, 0, 0);
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties(
            startDate: startTime,
            recurrenceType: RecurrenceType.daily,
            interval: 2,
            recurrenceRange: RecurrenceRange.count,
            recurrenceCount: 20);
    final Appointment alternativeDayAppointment = Appointment(
        startTime: startTime,
        endTime: endTime,
        color: colorCollection[random.nextInt(9)],
        subject: 'Scrum meeting',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForAlternativeDay, startTime, endTime));

    appointments.add(alternativeDayAppointment);

    //Recurrence Appointment 2
    final DateTime startTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    final DateTime endTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties(
      startDate: startTime1,
      recurrenceType: RecurrenceType.weekly,
      recurrenceRange: RecurrenceRange.count,
      interval: 1,
      weekDays: <WeekDays>[WeekDays.monday],
      recurrenceCount: 20,
    );

    final Appointment weeklyAppointment = Appointment(
        startTime: startTime1,
        endTime: endTime1,
        color: colorCollection[random.nextInt(9)],
        subject: 'product development status',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForWeeklyAppointment, startTime1, endTime1));

    appointments.add(weeklyAppointment);

    final DateTime startTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    final RecurrenceProperties recurrencePropertiesForMonthlyAppointment =
        RecurrenceProperties(
            startDate: startTime2,
            recurrenceType: RecurrenceType.monthly,
            recurrenceRange: RecurrenceRange.count,
            interval: 1,
            dayOfMonth: 1,
            recurrenceCount: 10);

    final Appointment monthlyAppointment = Appointment(
        startTime: startTime2,
        endTime: endTime2,
        color: colorCollection[random.nextInt(9)],
        subject: 'Sprint planning meeting',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForMonthlyAppointment, startTime2, endTime2));

    appointments.add(monthlyAppointment);

    final DateTime startTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final RecurrenceProperties recurrencePropertiesForYearlyAppointment =
        RecurrenceProperties(
            startDate: startTime3,
            recurrenceType: RecurrenceType.yearly,
            recurrenceRange: RecurrenceRange.noEndDate,
            interval: 1,
            dayOfMonth: 5);

    final Appointment yearlyAppointment = Appointment(
        startTime: startTime3,
        endTime: endTime3,
        color: colorCollection[random.nextInt(9)],
        isAllDay: true,
        subject: 'Stephen birthday',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForYearlyAppointment, startTime3, endTime3));

    appointments.add(yearlyAppointment);

    final DateTime startTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 17, 0, 0);
    final DateTime endTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);
    final RecurrenceProperties recurrencePropertiesForCustomDailyAppointment =
        RecurrenceProperties(
            startDate: startTime4,
            recurrenceType: RecurrenceType.daily,
            recurrenceRange: RecurrenceRange.noEndDate,
            interval: 1);

    final Appointment customDailyAppointment = Appointment(
      startTime: startTime4,
      endTime: endTime4,
      color: colorCollection[random.nextInt(9)],
      subject: 'General meeting',
      recurrenceRule: SfCalendar.generateRRule(
          recurrencePropertiesForCustomDailyAppointment, startTime4, endTime4),
    );

    appointments.add(customDailyAppointment);

    final DateTime startTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
        RecurrenceProperties(
            startDate: startTime5,
            recurrenceType: RecurrenceType.weekly,
            recurrenceRange: RecurrenceRange.endDate,
            interval: 1,
            weekDays: <WeekDays>[WeekDays.monday, WeekDays.friday],
            endDate: DateTime.now().add(const Duration(days: 14)));

    final Appointment customWeeklyAppointment = Appointment(
        startTime: startTime5,
        endTime: endTime5,
        color: colorCollection[random.nextInt(9)],
        subject: 'performance check',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomWeeklyAppointment,
            startTime5,
            endTime5));

    appointments.add(customWeeklyAppointment);

    final DateTime startTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 16, 0, 0);
    final DateTime endTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);

    final RecurrenceProperties recurrencePropertiesForCustomMonthlyAppointment =
        RecurrenceProperties(
            startDate: startTime6,
            recurrenceType: RecurrenceType.monthly,
            recurrenceRange: RecurrenceRange.count,
            interval: 1,
            dayOfWeek: DateTime.friday,
            week: 4,
            recurrenceCount: 12);

    final Appointment customMonthlyAppointment = Appointment(
        startTime: startTime6,
        endTime: endTime6,
        color: colorCollection[random.nextInt(9)],
        subject: 'Sprint end meeting',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomMonthlyAppointment,
            startTime6,
            endTime6));

    appointments.add(customMonthlyAppointment);

    final DateTime startTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    final RecurrenceProperties recurrencePropertiesForCustomYearlyAppointment =
        RecurrenceProperties(
            startDate: startTime7,
            recurrenceType: RecurrenceType.yearly,
            recurrenceRange: RecurrenceRange.count,
            interval: 2,
            month: DateTime.february,
            week: 2,
            dayOfWeek: DateTime.sunday,
            recurrenceCount: 10);

    final Appointment customYearlyAppointment = Appointment(
        startTime: startTime7,
        endTime: endTime7,
        color: colorCollection[random.nextInt(9)],
        subject: 'Alumini meet',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomYearlyAppointment,
            startTime7,
            endTime7));

    appointments.add(customYearlyAppointment);
    return appointments;
  }

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getRecurrenceCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      dynamic onViewChanged,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      showNavigationArrow: model.isWebFullView,
      controller: calendarController,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: true,
      onViewChanged: onViewChanged,
      dataSource: calendarDataSource,
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 4),
    );
  }
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
