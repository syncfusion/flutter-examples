///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../../model/sample_view.dart';
import '../getting_started/getting_started.dart';

/// Widget class of recurrence calendar
class RecurrenceCalendar extends SampleView {
  /// Creates recurrence calendar
  const RecurrenceCalendar(Key key) : super(key: key);

  @override
  _RecurrenceCalendarState createState() => _RecurrenceCalendarState();
}

class _RecurrenceCalendarState extends SampleViewState {
  _RecurrenceCalendarState();

  List<Appointment> _appointments;
  List<Color> colorCollection;
  CalendarController calendarController;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  ScrollController controller;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  GlobalKey _globalKey;
  CalendarView _view;

  @override
  void initState() {
    _globalKey = GlobalKey();
    controller = ScrollController();
    calendarController = CalendarController();
    calendarController.view = CalendarView.week;
    _view = CalendarView.week;
    _appointments = <Appointment>[];
    _addColorCollection();
    _createRecursiveAppointments();
    super.initState();
  }

  @override
  Widget build([BuildContext context]) {
    final Widget _calendar = Theme(

        /// The key set here to maintain the state, when we change
        /// the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getRecurrenceCalendar(
            calendarController,
            _AppointmentDataSource(_appointments),
            _onViewChanged,
            scheduleViewBuilder));

    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: calendarController.view == CalendarView.month &&
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
  /// view or switched to different calendar view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == calendarController.view ||
        !model.isWeb ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _view = calendarController.view;

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  /// Creates the data source with the recurrence appointments by adding required
  /// information on it.
  void _createRecursiveAppointments() {
    final Random random = Random();
    //Recurrence Appointment 1
    final Appointment alternativeDayAppointment = Appointment();
    final DateTime currentDate = DateTime.now();
    final DateTime startTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 0, 0);
    final DateTime endTime = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 11, 0, 0);
    alternativeDayAppointment.startTime = startTime;
    alternativeDayAppointment.endTime = endTime;
    alternativeDayAppointment.color = colorCollection[random.nextInt(9)];
    alternativeDayAppointment.subject = 'Scrum meeting';
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties();
    recurrencePropertiesForAlternativeDay.recurrenceType = RecurrenceType.daily;
    recurrencePropertiesForAlternativeDay.interval = 2;
    recurrencePropertiesForAlternativeDay.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForAlternativeDay.recurrenceCount = 20;
    alternativeDayAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForAlternativeDay,
        alternativeDayAppointment.startTime,
        alternativeDayAppointment.endTime);
    _appointments.add(alternativeDayAppointment);

    //Recurrence Appointment 2
    final Appointment weeklyAppointment = Appointment();
    final DateTime startTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    final DateTime endTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    weeklyAppointment.startTime = startTime1;
    weeklyAppointment.endTime = endTime1;
    weeklyAppointment.color = colorCollection[random.nextInt(9)];
    weeklyAppointment.subject = 'product development status';

    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForWeeklyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForWeeklyAppointment.interval = 1;
    recurrencePropertiesForWeeklyAppointment.weekDays = <WeekDays>[]
      ..add(WeekDays.monday);
    recurrencePropertiesForWeeklyAppointment.recurrenceCount = 20;
    weeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForWeeklyAppointment,
        weeklyAppointment.startTime,
        weeklyAppointment.endTime);
    _appointments.add(weeklyAppointment);

    final Appointment monthlyAppointment = Appointment();
    final DateTime startTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    monthlyAppointment.startTime = startTime2;
    monthlyAppointment.endTime = endTime2;
    monthlyAppointment.color = colorCollection[random.nextInt(9)];
    monthlyAppointment.subject = 'Sprint planning meeting';

    final RecurrenceProperties recurrencePropertiesForMonthlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForMonthlyAppointment.recurrenceType =
        RecurrenceType.monthly;
    recurrencePropertiesForMonthlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForMonthlyAppointment.interval = 1;
    recurrencePropertiesForMonthlyAppointment.dayOfMonth = 1;
    recurrencePropertiesForMonthlyAppointment.recurrenceCount = 10;
    monthlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForMonthlyAppointment,
        monthlyAppointment.startTime,
        monthlyAppointment.endTime);
    _appointments.add(monthlyAppointment);

    final Appointment yearlyAppointment = Appointment();
    final DateTime startTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    yearlyAppointment.startTime = startTime3;
    yearlyAppointment.endTime = endTime3;
    yearlyAppointment.color = colorCollection[random.nextInt(9)];
    yearlyAppointment.isAllDay = true;
    yearlyAppointment.subject = 'Stephen birthday';

    final RecurrenceProperties recurrencePropertiesForYearlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForYearlyAppointment.recurrenceType =
        RecurrenceType.yearly;
    recurrencePropertiesForYearlyAppointment.recurrenceRange =
        RecurrenceRange.noEndDate;
    recurrencePropertiesForYearlyAppointment.interval = 1;
    recurrencePropertiesForYearlyAppointment.dayOfMonth = 5;
    yearlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForYearlyAppointment,
        yearlyAppointment.startTime,
        yearlyAppointment.endTime);
    _appointments.add(yearlyAppointment);

    final Appointment customDailyAppointment = Appointment();
    final DateTime startTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 17, 0, 0);
    final DateTime endTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);
    customDailyAppointment.startTime = startTime4;
    customDailyAppointment.endTime = endTime4;
    customDailyAppointment.color = colorCollection[random.nextInt(9)];
    customDailyAppointment.subject = 'General meeting';

    final RecurrenceProperties recurrencePropertiesForCustomDailyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomDailyAppointment.recurrenceType =
        RecurrenceType.daily;
    recurrencePropertiesForCustomDailyAppointment.recurrenceRange =
        RecurrenceRange.noEndDate;
    recurrencePropertiesForCustomDailyAppointment.interval = 1;
    customDailyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomDailyAppointment,
        customDailyAppointment.startTime,
        customDailyAppointment.endTime);
    _appointments.add(customDailyAppointment);

    final Appointment customWeeklyAppointment = Appointment();
    final DateTime startTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    customWeeklyAppointment.startTime = startTime5;
    customWeeklyAppointment.endTime = endTime5;
    customWeeklyAppointment.color = colorCollection[random.nextInt(9)];
    customWeeklyAppointment.subject = 'performance check';

    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceRange =
        RecurrenceRange.endDate;
    recurrencePropertiesForCustomWeeklyAppointment.interval = 1;
    recurrencePropertiesForCustomWeeklyAppointment.weekDays = <WeekDays>[
      WeekDays.monday,
      WeekDays.friday
    ];
    recurrencePropertiesForCustomWeeklyAppointment.endDate =
        DateTime.now().add(const Duration(days: 14));
    customWeeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomWeeklyAppointment,
        customWeeklyAppointment.startTime,
        customWeeklyAppointment.endTime);
    _appointments.add(customWeeklyAppointment);

    final Appointment customMonthlyAppointment = Appointment();
    final DateTime startTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 16, 0, 0);
    final DateTime endTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);
    customMonthlyAppointment.startTime = startTime6;
    customMonthlyAppointment.endTime = endTime6;
    customMonthlyAppointment.color = colorCollection[random.nextInt(9)];
    customMonthlyAppointment.subject = 'Sprint end meeting';

    final RecurrenceProperties recurrencePropertiesForCustomMonthlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceType =
        RecurrenceType.monthly;
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForCustomMonthlyAppointment.interval = 1;
    recurrencePropertiesForCustomMonthlyAppointment.dayOfWeek = DateTime.friday;
    recurrencePropertiesForCustomMonthlyAppointment.week = 4;
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceCount = 12;
    customMonthlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomMonthlyAppointment,
        customMonthlyAppointment.startTime,
        customMonthlyAppointment.endTime);
    _appointments.add(customMonthlyAppointment);

    final Appointment customYearlyAppointment = Appointment();
    final DateTime startTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    customYearlyAppointment.startTime = startTime7;
    customYearlyAppointment.endTime = endTime7;
    customYearlyAppointment.color = colorCollection[random.nextInt(9)];
    customYearlyAppointment.subject = 'Alumini meet';

    final RecurrenceProperties recurrencePropertiesForCustomYearlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomYearlyAppointment.recurrenceType =
        RecurrenceType.yearly;
    recurrencePropertiesForCustomYearlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForCustomYearlyAppointment.interval = 2;
    recurrencePropertiesForCustomYearlyAppointment.month = DateTime.february;
    recurrencePropertiesForCustomYearlyAppointment.week = 2;
    recurrencePropertiesForCustomYearlyAppointment.dayOfWeek = DateTime.sunday;
    recurrencePropertiesForCustomYearlyAppointment.recurrenceCount = 10;
    customYearlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomYearlyAppointment,
        customYearlyAppointment.startTime,
        customYearlyAppointment.endTime);
    _appointments.add(customYearlyAppointment);
  }

  /// Adds the collection of color in a list for the appointment data source for
  /// calendar.
  void _addColorCollection() {
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

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getRecurrenceCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      dynamic onViewChanged,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      showNavigationArrow: model.isWeb,
      controller: _calendarController,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: true,
      onViewChanged: onViewChanged,
      dataSource: _calendarDataSource,
      monthViewSettings: MonthViewSettings(
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
