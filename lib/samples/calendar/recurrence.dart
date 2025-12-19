/// Dart import.
import 'dart:math';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local imports.
import '../../model/sample_view.dart';
import 'appointment_editor.dart';
import 'getting_started.dart';
import 'pop_up_editor.dart';

/// Widget class of recurrence Calendar.
class RecurrenceCalendar extends SampleView {
  /// Creates recurrence Calendar.
  const RecurrenceCalendar(Key key) : super(key: key);

  @override
  RecurrenceCalendarState createState() => RecurrenceCalendarState();
}

/// Represents the the state class of RecurrenceCalendarState.
class RecurrenceCalendarState extends SampleViewState {
  /// Creates an instance of  state class of RecurrenceCalendarState.
  RecurrenceCalendarState();

  /// Represents the Calendar controller.
  final CalendarController calendarController = CalendarController();
  late _AppointmentDataSource _dataSource;
  final List<Color> _colorCollection = <Color>[];
  final List<String> _colorNames = <String>[];
  final List<String> _timeZoneCollection = <String>[];
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

  /// Represents the controller.
  final ScrollController controller = ScrollController();

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();
  late List<DateTime> _visibleDates;
  CalendarView _view = CalendarView.week;
  Appointment? _selectedAppointment;
  bool _isAllDay = false;
  String _subject = '';
  int _selectedColorIndex = 0;

  @override
  void initState() {
    calendarController.view = _view;
    _dataSource = _AppointmentDataSource(_getRecursiveAppointments());
    super.initState();
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the Calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      return;
    }
    _selectedAppointment = null;

    /// Navigates Calendar to day view, when we tap on month cells in mobile.
    if (!model.isWebFullView && calendarController.view == CalendarView.month) {
      calendarController.view = CalendarView.day;
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
        final dynamic appointment = calendarTapDetails.appointments![0];
        if (appointment is Appointment) {
          _selectedAppointment = appointment;
        }
      }
      final DateTime selectedDate = calendarTapDetails.date!;
      final CalendarElement targetElement = calendarTapDetails.targetElement;

      /// To open the appointment editor for web,
      /// when the screen width is greater than 767.
      if (model.isWebFullView && !model.isMobileResolution) {
        final bool isAppointmentTapped =
            calendarTapDetails.targetElement == CalendarElement.appointment;
        showDialog<Widget>(
          context: context,
          builder: (BuildContext context) {
            final List<Appointment> appointment = <Appointment>[];
            Appointment? newAppointment;

            /// Creates a new appointment, which is displayed on the tapped
            /// Calendar element, when the editor is opened.
            if (_selectedAppointment == null) {
              _isAllDay =
                  calendarTapDetails.targetElement ==
                  CalendarElement.allDayPanel;
              _selectedColorIndex = 0;
              _subject = '';
              final DateTime date = calendarTapDetails.date!;
              newAppointment = Appointment(
                startTime: date,
                endTime: date.add(const Duration(hours: 1)),
                color: _colorCollection[_selectedColorIndex],
                isAllDay: _isAllDay,
                subject: _subject == '' ? '(No title)' : _subject,
              );
              appointment.add(newAppointment);
              _dataSource.appointments.add(appointment[0]);
              SchedulerBinding.instance.addPostFrameCallback((
                Duration duration,
              ) {
                _dataSource.notifyListeners(
                  CalendarDataSourceAction.add,
                  appointment,
                );
              });
              _selectedAppointment = newAppointment;
            }
            return PopScope(
              onPopInvokedWithResult: (bool value, Object? result) async {
                if (newAppointment != null) {
                  /// To remove the created appointment when the pop-up closed
                  /// without saving the appointment.
                  final int appointmentIndex = _dataSource.appointments.indexOf(
                    newAppointment,
                  );
                  if (appointmentIndex <= _dataSource.appointments.length - 1 &&
                      appointmentIndex >= 0) {
                    _dataSource.appointments.removeAt(
                      _dataSource.appointments.indexOf(newAppointment),
                    );
                    _dataSource.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Appointment>[newAppointment],
                    );
                  }
                }
              },
              child: Center(
                child: SizedBox(
                  width: isAppointmentTapped ? 400 : 500,
                  height: isAppointmentTapped
                      ? (_selectedAppointment!.location == null ||
                                _selectedAppointment!.location!.isEmpty
                            ? 150
                            : 200)
                      : 400,
                  child: Theme(
                    data: model.themeData,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: model.sampleOutputCardColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: isAppointmentTapped
                          ? displayAppointmentDetails(
                              context,
                              targetElement,
                              selectedDate,
                              model,
                              _selectedAppointment!,
                              _colorCollection,
                              _colorNames,
                              _dataSource,
                              _timeZoneCollection,
                              _visibleDates,
                            )
                          : PopUpAppointmentEditor(
                              model,
                              newAppointment,
                              appointment,
                              _dataSource,
                              _colorCollection,
                              _colorNames,
                              _selectedAppointment!,
                              _timeZoneCollection,
                              _visibleDates,
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        /// Navigates to the appointment editor page on mobile.
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) => AppointmentEditor(
              model,
              _selectedAppointment,
              targetElement,
              selectedDate,
              _colorCollection,
              _colorNames,
              _dataSource,
              _timeZoneCollection,
            ),
          ),
        );
      }
    }
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
      child: _getRecurrenceCalendar(
        calendarController,
        _dataSource,
        _onViewChanged,
        scheduleViewBuilder,
        _onCalendarTapped,
      ),
    );

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child:
                calendarController.view == CalendarView.month &&
                    model.isWebFullView &&
                    screenHeight < 800
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: controller,
                    child: ListView(
                      controller: controller,
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
  /// view or switched to different Calendar view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;
    if (_view == calendarController.view ||
        !model.isWebFullView ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view!;

        /// Update the current view when the Calendar view changed to
        /// month view or from month view.
      });
    });
  }

  /// Creates data source with the recurrence appointments by adding required
  /// information on it.
  List<Appointment> _getRecursiveAppointments() {
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
    _timeZoneCollection.add('Central America Standard Time');
    _timeZoneCollection.add('Central Asia Standard Time');
    _timeZoneCollection.add('Central Brazilian Standard Time');
    _timeZoneCollection.add('Central Europe Standard Time');
    _timeZoneCollection.add('Central European Standard Time');
    _timeZoneCollection.add('Central Pacific Standard Time');
    _timeZoneCollection.add('Central Standard Time');
    _timeZoneCollection.add('China Standard Time');
    _timeZoneCollection.add('Dateline Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('E. Australia Standard Time');
    _timeZoneCollection.add('E. South America Standard Time');
    _timeZoneCollection.add('Eastern Standard Time');
    _timeZoneCollection.add('Egypt Standard Time');
    _timeZoneCollection.add('Ekaterinburg Standard Time');
    _timeZoneCollection.add('FLE Standard Time');
    _timeZoneCollection.add('Fiji Standard Time');
    _timeZoneCollection.add('GMT Standard Time');
    _timeZoneCollection.add('GTB Standard Time');
    _timeZoneCollection.add('Georgian Standard Time');
    _timeZoneCollection.add('Greenland Standard Time');
    _timeZoneCollection.add('Greenwich Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('India Standard Time');
    _timeZoneCollection.add('Iran Standard Time');
    _timeZoneCollection.add('Israel Standard Time');
    _timeZoneCollection.add('Jordan Standard Time');
    _timeZoneCollection.add('Kaliningrad Standard Time');
    _timeZoneCollection.add('Korea Standard Time');
    _timeZoneCollection.add('Libya Standard Time');
    _timeZoneCollection.add('Line Islands Standard Time');
    _timeZoneCollection.add('Magadan Standard Time');
    _timeZoneCollection.add('Mauritius Standard Time');
    _timeZoneCollection.add('Middle East Standard Time');
    _timeZoneCollection.add('Montevideo Standard Time');
    _timeZoneCollection.add('Morocco Standard Time');
    _timeZoneCollection.add('Mountain Standard Time');
    _timeZoneCollection.add('Mountain Standard Time (Mexico)');
    _timeZoneCollection.add('Myanmar Standard Time');
    _timeZoneCollection.add('N. Central Asia Standard Time');
    _timeZoneCollection.add('Namibia Standard Time');
    _timeZoneCollection.add('Nepal Standard Time');
    _timeZoneCollection.add('New Zealand Standard Time');
    _timeZoneCollection.add('Newfoundland Standard Time');
    _timeZoneCollection.add('North Asia East Standard Time');
    _timeZoneCollection.add('North Asia Standard Time');
    _timeZoneCollection.add('Pacific SA Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('Pakistan Standard Time');
    _timeZoneCollection.add('Paraguay Standard Time');
    _timeZoneCollection.add('Romance Standard Time');
    _timeZoneCollection.add('Russia Time Zone 10');
    _timeZoneCollection.add('Russia Time Zone 11');
    _timeZoneCollection.add('Russia Time Zone 3');
    _timeZoneCollection.add('Russian Standard Time');
    _timeZoneCollection.add('SA Eastern Standard Time');
    _timeZoneCollection.add('SA Pacific Standard Time');
    _timeZoneCollection.add('SA Western Standard Time');
    _timeZoneCollection.add('SE Asia Standard Time');
    _timeZoneCollection.add('Samoa Standard Time');
    _timeZoneCollection.add('Singapore Standard Time');
    _timeZoneCollection.add('South Africa Standard Time');
    _timeZoneCollection.add('Sri Lanka Standard Time');
    _timeZoneCollection.add('Syria Standard Time');
    _timeZoneCollection.add('Taipei Standard Time');
    _timeZoneCollection.add('Tasmania Standard Time');
    _timeZoneCollection.add('Tokyo Standard Time');
    _timeZoneCollection.add('Tonga Standard Time');
    _timeZoneCollection.add('Turkey Standard Time');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');
    _timeZoneCollection.add('UTC');
    _timeZoneCollection.add('UTC+12');
    _timeZoneCollection.add('UTC-02');
    _timeZoneCollection.add('UTC-11');
    _timeZoneCollection.add('Ulaanbaatar Standard Time');
    _timeZoneCollection.add('Venezuela Standard Time');
    _timeZoneCollection.add('Vladivostok Standard Time');
    _timeZoneCollection.add('W. Australia Standard Time');
    _timeZoneCollection.add('W. Central Africa Standard Time');
    _timeZoneCollection.add('W. Europe Standard Time');
    _timeZoneCollection.add('West Asia Standard Time');
    _timeZoneCollection.add('West Pacific Standard Time');
    _timeZoneCollection.add('Yakutsk Standard Time');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    final List<Appointment> appointments = <Appointment>[];
    final Random random = Random.secure();
    final DateTime currentDate = DateTime.now();

    final DateTime startTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      9,
    );
    final DateTime endTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      11,
    );
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties(
          startDate: startTime,
          interval: 2,
          recurrenceRange: RecurrenceRange.count,
          recurrenceCount: 20,
        );
    final Appointment alternativeDayAppointment = Appointment(
      startTime: startTime,
      endTime: endTime,
      color: _colorCollection[random.nextInt(8)],
      subject: 'Scrum meeting',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForAlternativeDay,
        startTime,
        endTime,
      ),
    );
    appointments.add(alternativeDayAppointment);

    final DateTime startTime1 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      13,
    );
    final DateTime endTime1 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      15,
    );
    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties(
          startDate: startTime1,
          recurrenceType: RecurrenceType.weekly,
          recurrenceRange: RecurrenceRange.count,
          weekDays: <WeekDays>[WeekDays.monday],
          recurrenceCount: 20,
        );
    final Appointment weeklyAppointment = Appointment(
      startTime: startTime1,
      endTime: endTime1,
      color: _colorCollection[random.nextInt(8)],
      subject: 'product development status',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForWeeklyAppointment,
        startTime1,
        endTime1,
      ),
    );
    appointments.add(weeklyAppointment);

    final DateTime startTime2 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      14,
    );
    final DateTime endTime2 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      15,
    );
    final RecurrenceProperties recurrencePropertiesForMonthlyAppointment =
        RecurrenceProperties(
          startDate: startTime2,
          recurrenceType: RecurrenceType.monthly,
          recurrenceRange: RecurrenceRange.count,
          recurrenceCount: 10,
        );
    final Appointment monthlyAppointment = Appointment(
      startTime: startTime2,
      endTime: endTime2,
      color: _colorCollection[random.nextInt(8)],
      subject: 'Sprint planning meeting',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForMonthlyAppointment,
        startTime2,
        endTime2,
      ),
    );
    appointments.add(monthlyAppointment);

    final DateTime startTime3 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      12,
    );
    final DateTime endTime3 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      14,
    );
    final RecurrenceProperties recurrencePropertiesForYearlyAppointment =
        RecurrenceProperties(
          startDate: startTime3,
          recurrenceType: RecurrenceType.yearly,
          dayOfMonth: 5,
        );
    final Appointment yearlyAppointment = Appointment(
      startTime: startTime3,
      endTime: endTime3,
      color: _colorCollection[random.nextInt(8)],
      isAllDay: true,
      subject: 'Stephen birthday',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForYearlyAppointment,
        startTime3,
        endTime3,
      ),
    );
    appointments.add(yearlyAppointment);

    final DateTime startTime4 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      17,
    );
    final DateTime endTime4 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      18,
    );
    final RecurrenceProperties recurrencePropertiesForCustomDailyAppointment =
        RecurrenceProperties(startDate: startTime4);
    final Appointment customDailyAppointment = Appointment(
      startTime: startTime4,
      endTime: endTime4,
      color: _colorCollection[random.nextInt(8)],
      subject: 'General meeting',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForCustomDailyAppointment,
        startTime4,
        endTime4,
      ),
    );
    appointments.add(customDailyAppointment);

    final DateTime startTime5 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      12,
    );
    final DateTime endTime5 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      13,
    );
    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
        RecurrenceProperties(
          startDate: startTime5,
          recurrenceType: RecurrenceType.weekly,
          recurrenceRange: RecurrenceRange.endDate,
          weekDays: <WeekDays>[WeekDays.monday, WeekDays.friday],
          endDate: DateTime.now().add(const Duration(days: 14)),
        );
    final Appointment customWeeklyAppointment = Appointment(
      startTime: startTime5,
      endTime: endTime5,
      color: _colorCollection[random.nextInt(8)],
      subject: 'performance check',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForCustomWeeklyAppointment,
        startTime5,
        endTime5,
      ),
    );
    appointments.add(customWeeklyAppointment);

    final DateTime startTime6 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      16,
    );
    final DateTime endTime6 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      18,
    );
    final RecurrenceProperties recurrencePropertiesForCustomMonthlyAppointment =
        RecurrenceProperties(
          startDate: startTime6,
          recurrenceType: RecurrenceType.monthly,
          recurrenceRange: RecurrenceRange.count,
          dayOfWeek: DateTime.friday,
          week: 4,
          recurrenceCount: 12,
        );
    final Appointment customMonthlyAppointment = Appointment(
      startTime: startTime6,
      endTime: endTime6,
      color: _colorCollection[random.nextInt(8)],
      subject: 'Sprint end meeting',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForCustomMonthlyAppointment,
        startTime6,
        endTime6,
      ),
    );
    appointments.add(customMonthlyAppointment);

    final DateTime startTime7 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      14,
    );
    final DateTime endTime7 = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      15,
    );
    final RecurrenceProperties recurrencePropertiesForCustomYearlyAppointment =
        RecurrenceProperties(
          startDate: startTime7,
          recurrenceType: RecurrenceType.yearly,
          recurrenceRange: RecurrenceRange.count,
          interval: 2,
          month: DateTime.february,
          week: 2,
          dayOfWeek: DateTime.sunday,
          recurrenceCount: 10,
        );
    final Appointment customYearlyAppointment = Appointment(
      startTime: startTime7,
      endTime: endTime7,
      color: _colorCollection[random.nextInt(8)],
      subject: 'Alumini meet',
      recurrenceRule: SfCalendar.generateRRule(
        recurrencePropertiesForCustomYearlyAppointment,
        startTime7,
        endTime7,
      ),
    );
    appointments.add(customYearlyAppointment);
    return appointments;
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getRecurrenceCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    dynamic onViewChanged,
    dynamic scheduleViewBuilder,
    dynamic calendarTapCallback,
  ]) {
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
      ),
      onTap: calendarTapCallback,
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
