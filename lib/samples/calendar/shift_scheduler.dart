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
import 'pop_up_editor.dart';

/// Widget class of shift scheduler Calendar.
class ShiftScheduler extends SampleView {
  /// Creates Calendar of shift scheduler.
  const ShiftScheduler(Key key) : super(key: key);

  @override
  _ShiftSchedulerState createState() => _ShiftSchedulerState();
}

class _ShiftSchedulerState extends SampleViewState {
  _ShiftSchedulerState();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final List<Appointment> _shiftCollection = <Appointment>[];
  final List<CalendarResource> _employeeCollection = <CalendarResource>[];
  final List<TimeRegion> _specialTimeRegions = <TimeRegion>[];
  final List<String> _nameCollection = <String>[];
  final List<String> _userImages = <String>[];
  final List<String> _colorNames = <String>[];
  final List<String> _timeZoneCollection = <String>[];
  final CalendarController _calendarController = CalendarController();
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];
  late List<DateTime> _visibleDates;
  bool _isAllDay = false;
  String _subject = '';
  int _selectedColorIndex = 0;
  Appointment? _selectedAppointment;
  late _ShiftDataSource _events;

  @override
  void initState() {
    _calendarController.view = CalendarView.timelineWeek;
    _selectedAppointment = null;
    _events = _ShiftDataSource(_shiftCollection, _employeeCollection);
    _addResourceDetails();
    _addResources();
    _addSpecialRegions();
    _addAppointmentDetails();
    _addAppointments();
    super.initState();
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;
  }

  /// Navigates to appointment editor page when the Calendar elements tapped
  /// other than the header, handled the editor fields based on tapped element.
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the Calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }
    _selectedAppointment = null;

    /// Navigates Calendar to day view, when we tap on month cells in mobile.
    if (!model.isWebFullView &&
        _calendarController.view == CalendarView.month) {
      _calendarController.view = CalendarView.day;
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
                resourceIds: <Object>[calendarTapDetails.resource!.id],
                color: _colorCollection[_selectedColorIndex],
                isAllDay: _isAllDay,
                subject: _subject == '' ? '(No title)' : _subject,
              );
              appointment.add(newAppointment);
              _events.appointments!.add(appointment[0]);
              SchedulerBinding.instance.addPostFrameCallback((
                Duration duration,
              ) {
                _events.notifyListeners(
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
                  final int appointmentIndex = _events.appointments!.indexOf(
                    newAppointment,
                  );
                  if (appointmentIndex <= _events.appointments!.length - 1 &&
                      appointmentIndex >= 0) {
                    _events.appointments!.removeAt(
                      _events.appointments!.indexOf(newAppointment),
                    );
                    _events.notifyListeners(
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
                            ? 200
                            : 250)
                      : 450,
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
                              _events,
                              _timeZoneCollection,
                              _visibleDates,
                            )
                          : PopUpAppointmentEditor(
                              model,
                              newAppointment,
                              appointment,
                              _events,
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
              _events,
              _timeZoneCollection,
              calendarTapDetails.resource,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: model.sampleOutputCardColor,
      child: Theme(
        data: model.themeData.copyWith(
          colorScheme: model.themeData.colorScheme.copyWith(
            secondary: model.primaryColor,
          ),
        ),
        child: _getShiftScheduler(_events, _onCalendarTapped, _onViewChanged),
      ),
    );
  }

  /// Creates the required resource details as list.
  void _addResourceDetails() {
    _nameCollection.add('John');
    _nameCollection.add('Bryan');
    _nameCollection.add('Robert');
    _nameCollection.add('Kenny');
    _nameCollection.add('Tia');
    _nameCollection.add('Theresa');
    _nameCollection.add('Edith');
    _nameCollection.add('Brooklyn');
    _nameCollection.add('James William');
    _nameCollection.add('Sophia');
    _nameCollection.add('Elena');
    _nameCollection.add('Stephen');
    _nameCollection.add('Zoey Addison');
    _nameCollection.add('Daniel');
    _nameCollection.add('Emilia');
    _nameCollection.add('Kinsley Elena');
    _nameCollection.add('Daniel');
    _nameCollection.add('William');
    _nameCollection.add('Addison');
    _nameCollection.add('Ruby');

    _userImages.add('images/People_Circle5.png');
    _userImages.add('images/People_Circle8.png');
    _userImages.add('images/People_Circle18.png');
    _userImages.add('images/People_Circle23.png');
    _userImages.add('images/People_Circle25.png');
    _userImages.add('images/People_Circle20.png');
    _userImages.add('images/People_Circle13.png');
    _userImages.add('images/People_Circle11.png');
    _userImages.add('images/People_Circle27.png');
    _userImages.add('images/People_Circle26.png');
    _userImages.add('images/People_Circle24.png');
    _userImages.add('images/People_Circle15.png');
  }

  /// Creates the required appointment details as a list.
  void _addAppointmentDetails() {
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
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

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
  }

  /// Method that creates the resource collection for the Calendar, with the
  /// required information.
  void _addResources() {
    final Random random = Random.secure();
    for (int i = 0; i < _nameCollection.length; i++) {
      _employeeCollection.add(
        CalendarResource(
          displayName: _nameCollection[i],
          id: '000' + i.toString(),
          color: Color.fromRGBO(
            random.nextInt(255),
            random.nextInt(255),
            random.nextInt(255),
            1,
          ),
          image: i < _userImages.length
              ? ExactAssetImage(_userImages[i])
              : null,
        ),
      );
    }
  }

  /// Method that creates the collection the time region for Calendar, with
  /// required information.
  void _addSpecialRegions() {
    final DateTime date = DateTime.now();
    final Random random = Random.secure();
    for (int i = 0; i < _employeeCollection.length; i++) {
      _specialTimeRegions.add(
        TimeRegion(
          startTime: DateTime(date.year, date.month, date.day, 13),
          endTime: DateTime(date.year, date.month, date.day, 14),
          text: 'Lunch',
          color: Colors.grey.withValues(alpha: 0.2),
          resourceIds: <Object>[_employeeCollection[i].id],
          recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
        ),
      );
      if (i.isEven) {
        continue;
      }
      final DateTime startDate = DateTime(
        date.year,
        date.month,
        date.day,
        17 + random.nextInt(7),
      );
      _specialTimeRegions.add(
        TimeRegion(
          startTime: startDate,
          endTime: startDate.add(const Duration(hours: 1)),
          text: 'Not Available',
          color: Colors.grey.withValues(alpha: 0.2),
          enablePointerInteraction: false,
          resourceIds: <Object>[_employeeCollection[i].id],
        ),
      );
    }
  }

  /// Method that creates the collection the data source for Calendar, with
  /// required information.
  void _addAppointments() {
    final Random random = Random.secure();
    for (int i = 0; i < _employeeCollection.length; i++) {
      final List<Object> employeeIds = <Object>[_employeeCollection[i].id];
      if (i == _employeeCollection.length - 1) {
        int index = random.nextInt(5);
        index = index == i ? index + 1 : index;
        final Object employeeId = _employeeCollection[index].id;
        if (employeeId is String) {
          employeeIds.add(employeeId);
        }
      }
      for (int k = 0; k < 365; k++) {
        if (employeeIds.length > 1 && k.isEven) {
          continue;
        }
        for (int j = 0; j < 2; j++) {
          final DateTime date = DateTime.now().add(Duration(days: k + j));
          int startHour = 9 + random.nextInt(6);
          startHour = startHour >= 13 && startHour <= 14
              ? startHour + 1
              : startHour;
          final DateTime shiftStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            startHour,
          );
          _shiftCollection.add(
            Appointment(
              startTime: shiftStartTime,
              endTime: shiftStartTime.add(const Duration(hours: 1)),
              subject: _subjectCollection[random.nextInt(8)],
              color: _colorCollection[random.nextInt(8)],
              startTimeZone: '',
              endTimeZone: '',
              resourceIds: employeeIds,
            ),
          );
        }
      }
    }
  }

  Widget _getSpecialRegionWidget(
    BuildContext context,
    TimeRegionDetails details,
  ) {
    if (details.region.text == 'Lunch') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.grey.withValues(alpha: 0.5),
        ),
      );
    } else if (details.region.text == 'Not Available') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(Icons.block, color: Colors.grey.withValues(alpha: 0.5)),
      );
    }
    return Container(color: details.region.color);
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _getShiftScheduler([
    CalendarDataSource? calendarDataSource,
    dynamic calendarTapCallback,
    dynamic viewChangedCallback,
  ]) {
    return SfCalendar(
      showDatePickerButton: true,
      controller: _calendarController,
      allowedViews: _allowedViews,
      timeRegionBuilder: _getSpecialRegionWidget,
      specialRegions: _specialTimeRegions,
      showNavigationArrow: model.isWebFullView,
      dataSource: calendarDataSource,
      onViewChanged: viewChangedCallback,
      onTap: calendarTapCallback,
    );
  }
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the Calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(
    List<Appointment> source,
    List<CalendarResource> resourceColl,
  ) {
    appointments = source;
    resources = resourceColl;
  }
}
