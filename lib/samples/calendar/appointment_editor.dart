/// Dart imports.
import 'dart:core';
import 'dart:math';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

/// Local imports.
import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'appointment_editor_web.dart';
import 'calendar_pickers.dart';
import 'getting_started.dart';
import 'pop_up_editor.dart';

/// Render the widget of appointment editor Calendar.
class CalendarAppointmentEditor extends SampleView {
  /// Creates the appointment editor.
  const CalendarAppointmentEditor(Key key) : super(key: key);

  @override
  _CalendarAppointmentEditorState createState() =>
      _CalendarAppointmentEditorState();
}

class _CalendarAppointmentEditorState extends SampleViewState {
  _CalendarAppointmentEditorState();

  late List<String> _subjectCollection;
  late List<Appointment> _appointments;
  late bool _isMobile;
  late List<Color> _colorCollection;
  late List<String> _colorNames;
  int _selectedColorIndex = 0;
  late List<String> _timeZoneCollection;
  late List<DateTime> _visibleDates;
  late _DataSource _events;
  Appointment? _selectedAppointment;
  bool _isAllDay = false;
  String _subject = '';

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

  final ScrollController controller = ScrollController();
  final CalendarController calendarController = CalendarController();

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();
  CalendarView _view = CalendarView.month;

  @override
  void initState() {
    _isMobile = false;
    calendarController.view = _view;
    _appointments = _getAppointmentDetails();
    _events = _DataSource(_appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _subject = '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /// Extra small devices (phones, 600px and down)
    /// @media only screen and (max-width: 600px) {...}

    /// Small devices (portrait tablets and large phones, 600px and up)
    /// @media only screen and (min-width: 600px) {...}

    /// Medium devices (landscape tablets, 768px and up)
    /// media only screen and (min-width: 768px) {...}

    /// Large devices (laptops/desktops, 992px and up)
    /// media only screen and (min-width: 992px) {...}

    /// Extra large devices (large laptops and desktops, 1200px and up)
    /// media only screen and (min-width: 1200px) {...}

    /// Default width to render the mobile UI in web,if the device width exceeds
    /// the given width agenda view will render the web UI.
    _isMobile = MediaQuery.of(context).size.width < 767;
    super.didChangeDependencies();
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
      child: _getAppointmentEditorCalendar(
        calendarController,
        _events,
        _onCalendarTapped,
        _onViewChanged,
        scheduleViewBuilder,
      ),
    );
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
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
          : Container(color: model.sampleOutputCardColor, child: calendar),
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

  /// Navigates to appointment editor page when the Calendar elements tapped
  /// other than the header, handled the editor fields based on tapped element.
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the Calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
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
      if (model.isWebFullView && !_isMobile) {
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
              _events.appointments.add(appointment[0]);
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
                  final int appointmentIndex = _events.appointments.indexOf(
                    newAppointment,
                  );
                  if ((appointmentIndex <= _events.appointments.length - 1) &&
                      appointmentIndex >= 0) {
                    _events.appointments.removeAt(
                      _events.appointments.indexOf(newAppointment),
                    );
                    _events.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Appointment>[newAppointment],
                    );
                  }
                }
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: isAppointmentTapped ? 400 : 500,
                  height: isAppointmentTapped
                      ? _selectedAppointment!.location == null ||
                                _selectedAppointment!.location!.isEmpty
                            ? 150
                            : 200
                      : 390,
                  child: Theme(
                    data: model.themeData,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color:
                          model.themeData != null &&
                              model.themeData.colorScheme.brightness ==
                                  Brightness.dark
                          ? Colors.grey[850]
                          : Colors.white,
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
            ),
          ),
        );
      }
    }
  }

  /// Creates the required appointment details as a list, and created the data
  /// source for Calendar with required information.
  List<Appointment> _getAppointmentDetails() {
    final List<Appointment> appointmentCollection = <Appointment>[];
    _subjectCollection = <String>[];
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

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
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

    final DateTime today = DateTime.now();
    final Random random = Random.secure();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          appointmentCollection.add(
            Appointment(
              startTime: today
                  .add(Duration(days: (month * 30) + day))
                  .add(Duration(hours: hour)),
              endTime: today
                  .add(Duration(days: (month * 30) + day))
                  .add(Duration(hours: hour + 2)),
              color: _colorCollection[random.nextInt(9)],
              startTimeZone: '',
              endTimeZone: '',
              notes: '',
              subject: _subjectCollection[random.nextInt(7)],
            ),
          );
        }
      }
    }
    return appointmentCollection;
  }

  /// Returns the Calendar based on the properties passed.
  SfCalendar _getAppointmentEditorCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    dynamic calendarTapCallback,
    ViewChangedCallback? viewChangedCallback,
    dynamic scheduleViewBuilder,
  ]) {
    return SfCalendar(
      controller: calendarController,
      showNavigationArrow: model.isWebFullView,
      allowedViews: _allowedViews,
      showDatePickerButton: true,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      dataSource: calendarDataSource,
      onTap: calendarTapCallback,
      onViewChanged: viewChangedCallback,
      initialDisplayDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
    );
  }
}

/// Signature for callback which reports the picker value changed.
typedef PickerChanged =
    void Function(PickerChangedDetails pickerChangedDetails);

/// Details for the [PickerChanged].
class PickerChangedDetails {
  PickerChangedDetails({
    this.index = -1,
    this.resourceId,
    this.selectedRule = _SelectRule.doesNotRepeat,
  });

  final int index;
  final Object? resourceId;
  final _SelectRule? selectedRule;
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

/// Formats the tapped appointment time text, to display on the pop-up view.
String _getAppointmentTimeText(Appointment selectedAppointment) {
  if (selectedAppointment.isAllDay) {
    if (isSameDate(
      selectedAppointment.startTime,
      selectedAppointment.endTime,
    )) {
      return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime);
    }
    return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('EEEE, MMM dd').format(selectedAppointment.endTime);
  } else if (selectedAppointment.startTime.day !=
          selectedAppointment.endTime.day ||
      selectedAppointment.startTime.month !=
          selectedAppointment.endTime.month ||
      selectedAppointment.startTime.year != selectedAppointment.endTime.year) {
    String endFormat = 'EEEE, ';
    if (selectedAppointment.startTime.month !=
        selectedAppointment.endTime.month) {
      endFormat += 'MMM';
    }

    endFormat += ' dd hh:mm a';
    return DateFormat(
          'EEEE, MMM dd hh:mm a',
        ).format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat(endFormat).format(selectedAppointment.endTime);
  } else {
    return DateFormat(
          'EEEE, MMM dd hh:mm a',
        ).format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('hh:mm a').format(selectedAppointment.endTime);
  }
}

/// Allows to delete the single appointment from a series and
/// delete the entire series.
Widget _deleteRecurrence(
  BuildContext context,
  SampleModel model,
  Appointment selectedAppointment,
  CalendarDataSource events,
) {
  final Color defaultColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;

  final Color defaultTextColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  return Dialog(
    child: Container(
      width: 400,
      height: 170,
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: 360,
            height: 50,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    'Delete Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: defaultTextColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    splashRadius: 15,
                    tooltip: 'Close',
                    icon: Icon(Icons.close, color: defaultColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 360,
            height: 50,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'How would you like to change the appointment in the series?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: defaultTextColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 110,
                child: RawMaterialButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  fillColor: model.primaryColor,
                  onPressed: () {
                    if (selectedAppointment.recurrenceId != null) {
                      events.appointments!.remove(selectedAppointment);
                      events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[selectedAppointment],
                      );
                    }
                    final Appointment? parentAppointment =
                        events.getPatternAppointment(selectedAppointment, '')
                            as Appointment?;
                    events.appointments!.removeAt(
                      events.appointments!.indexOf(parentAppointment),
                    );
                    events.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Appointment>[parentAppointment!],
                    );
                    parentAppointment.recurrenceExceptionDates != null
                        ? parentAppointment.recurrenceExceptionDates!.add(
                            selectedAppointment.startTime,
                          )
                        : parentAppointment.recurrenceExceptionDates =
                              <DateTime>[selectedAppointment.startTime];
                    events.appointments!.add(parentAppointment);
                    events.notifyListeners(
                      CalendarDataSourceAction.add,
                      <Appointment>[parentAppointment],
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'DELETE EVENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(width: 20),
              SizedBox(
                width: 110,
                child: RawMaterialButton(
                  onPressed: () {
                    final Appointment? parentAppointment =
                        events.getPatternAppointment(selectedAppointment, '')
                            as Appointment?;
                    if (parentAppointment!.recurrenceExceptionDates == null) {
                      events.appointments!.removeAt(
                        events.appointments!.indexOf(parentAppointment),
                      );
                      events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[parentAppointment],
                      );
                    } else {
                      final List<DateTime>? exceptionDates =
                          parentAppointment.recurrenceExceptionDates;
                      for (int i = 0; i < exceptionDates!.length; i++) {
                        final Appointment? changedOccurrence = events
                            .getOccurrenceAppointment(
                              parentAppointment,
                              exceptionDates[i],
                              '',
                            );
                        if (changedOccurrence != null) {
                          events.appointments!.remove(changedOccurrence);
                          events.notifyListeners(
                            CalendarDataSourceAction.remove,
                            <Appointment>[changedOccurrence],
                          );
                        }
                      }
                      events.appointments!.removeAt(
                        events.appointments!.indexOf(parentAppointment),
                      );
                      events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[parentAppointment],
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ENTIRE SERIES',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: defaultTextColor,
                    ),
                  ),
                ),
              ),
              Container(width: 20),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Allows to edit single appointment from a series and edit entire series.
Widget _editRecurrence(
  BuildContext context,
  SampleModel model,
  Appointment selectedAppointment,
  List<Color> colorCollection,
  List<String> colorNames,
  CalendarDataSource events,
  List<String> timeZoneCollection,
  List<DateTime> visibleDates,
) {
  final Color defaultColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;
  final Color defaultTextColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;
  final List<Appointment> appointmentCollection = <Appointment>[];
  final Appointment? parentAppointment =
      events.getPatternAppointment(selectedAppointment, '') as Appointment?;
  return Dialog(
    child: Container(
      width: 400,
      height: 170,
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: 360,
            height: 50,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    'Edit Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: defaultTextColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    splashRadius: 20,
                    tooltip: 'Close',
                    icon: Icon(Icons.close, color: defaultColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 360,
            height: 50,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'How would you like to change the appointment in the series?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: defaultTextColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RawMaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                fillColor: model.primaryColor,
                onPressed: () {
                  selectedAppointment.recurrenceId = parentAppointment!.id;
                  selectedAppointment.id =
                      selectedAppointment.appointmentType ==
                          AppointmentType.changedOccurrence
                      ? selectedAppointment.id
                      : null;
                  selectedAppointment.recurrenceRule = null;
                  Navigator.pop(context);
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return PopScope(
                        onPopInvokedWithResult:
                            (bool value, Object? result) async {
                              if (value) {
                                return;
                              }
                            },
                        child: Theme(
                          data: model.themeData,
                          child: AppointmentEditorWeb(
                            model,
                            selectedAppointment,
                            colorCollection,
                            colorNames,
                            events,
                            timeZoneCollection,
                            appointmentCollection,
                            visibleDates,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'EDIT EVENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(width: 20),
              RawMaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  Navigator.pop(context);
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return PopScope(
                        onPopInvokedWithResult:
                            (bool value, Object? result) async {
                              if (value) {
                                return;
                              }
                            },
                        child: Theme(
                          data: model.themeData,
                          child: AppointmentEditorWeb(
                            model,
                            parentAppointment!,
                            colorCollection,
                            colorNames,
                            events,
                            timeZoneCollection,
                            appointmentCollection,
                            visibleDates,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'ENTIRE SERIES',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: defaultTextColor,
                  ),
                ),
              ),
              Container(width: 20),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Displays the tapped appointment details in a pop-up view.
Widget displayAppointmentDetails(
  BuildContext context,
  CalendarElement targetElement,
  DateTime selectedDate,
  SampleModel model,
  Appointment selectedAppointment,
  List<Color> colorCollection,
  List<String> colorNames,
  CalendarDataSource events,
  List<String> timeZoneCollection,
  List<DateTime> visibleDates,
) {
  final Color defaultColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;
  final Color defaultTextColor =
      model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;
  final List<Appointment> appointmentCollection = <Appointment>[];
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.edit, color: defaultColor),
              onPressed: () {
                Navigator.pop(context);
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return PopScope(
                      onPopInvokedWithResult:
                          (bool value, Object? result) async {
                            if (value) {
                              return;
                            }
                          },
                      child: Theme(
                        data: model.themeData,
                        child:
                            selectedAppointment.appointmentType ==
                                AppointmentType.normal
                            ? AppointmentEditorWeb(
                                model,
                                selectedAppointment,
                                colorCollection,
                                colorNames,
                                events,
                                timeZoneCollection,
                                appointmentCollection,
                                visibleDates,
                              )
                            : _editRecurrence(
                                context,
                                model,
                                selectedAppointment,
                                colorCollection,
                                colorNames,
                                events,
                                timeZoneCollection,
                                visibleDates,
                              ),
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: defaultColor),
              splashRadius: 20,
              onPressed: () {
                if (selectedAppointment.appointmentType ==
                    AppointmentType.normal) {
                  Navigator.pop(context);
                  events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment),
                  );
                  events.notifyListeners(
                    CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment],
                  );
                } else {
                  Navigator.pop(context);
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return PopScope(
                        onPopInvokedWithResult:
                            (bool value, Object? result) async {
                              if (value) {
                                return;
                              }
                            },
                        child: Theme(
                          data: model.themeData,
                          child: _deleteRecurrence(
                            context,
                            model,
                            selectedAppointment,
                            events,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.close, color: defaultColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.lens, color: selectedAppointment.color, size: 20),
        title: Text(
          selectedAppointment.subject.isNotEmpty
              ? selectedAppointment.subject
              : '(No Text)',
          style: TextStyle(
            fontSize: 20,
            color: defaultTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            _getAppointmentTimeText(selectedAppointment),
            style: TextStyle(
              fontSize: 15,
              color: defaultTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      if (selectedAppointment.resourceIds == null ||
          selectedAppointment.resourceIds!.isEmpty)
        Container()
      else
        ListTile(
          leading: Icon(Icons.people, size: 20, color: defaultColor),
          title: Text(
            _getSelectedResourceText(
              selectedAppointment.resourceIds!,
              events.resources!,
            ),
            style: TextStyle(
              fontSize: 15,
              color: defaultTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      if (selectedAppointment.location == null ||
          selectedAppointment.location!.isEmpty)
        Container()
      else
        ListTile(
          leading: Icon(Icons.location_on, size: 20, color: defaultColor),
          title: Text(
            selectedAppointment.location ?? '',
            style: TextStyle(
              fontSize: 15,
              color: defaultColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
    ],
  );
}

/// Returns the selected resource display name based on the ids passed.
String _getSelectedResourceText(
  List<Object> resourceIds,
  List<CalendarResource> resourceCollection,
) {
  String? resourceNames;
  for (int i = 0; i < resourceIds.length; i++) {
    final String name = resourceCollection
        .firstWhere(
          (CalendarResource resource) => resource.id == resourceIds[i],
        )
        .displayName;
    resourceNames = resourceNames == null ? name : resourceNames + ', ' + name;
  }
  return resourceNames!;
}

/// Returns color scheme based on dark and light theme.
ColorScheme getColorScheme(SampleModel model, bool isDatePicker) {
  /// For time picker used the default surface color based for corresponding
  /// theme, so that the picker background color doesn't cover with the model's
  /// background color.
  if (model.themeData.colorScheme.brightness == Brightness.dark) {
    return ColorScheme.dark(
      primary: model.primaryColor,
      secondary: model.primaryColor,
      surface: isDatePicker ? model.backgroundColor : Colors.grey[850]!,
    );
  }

  return ColorScheme.light(
    primary: model.primaryColor,
    secondary: model.primaryColor,
    surface: isDatePicker ? model.backgroundColor : Colors.white,
  );
}

enum _SelectRule {
  doesNotRepeat,
  everyDay,
  everyWeek,
  everyMonth,
  everyYear,
  custom,
}

enum _Edit { event, series }

enum _Delete { event, series }

/// Builds the appointment editor with all the required elements based on the
/// tapped Calendar element for mobile.
class AppointmentEditor extends StatefulWidget {
  /// Holds the value of appointment editor.
  const AppointmentEditor(
    this.model,
    this.selectedAppointment,
    this.targetElement,
    this.selectedDate,
    this.colorCollection,
    this.colorNames,
    this.events,
    this.timeZoneCollection, [
    this.selectedResource,
  ]);

  /// Current sample model.
  final SampleModel model;

  /// Selected appointment.
  final Appointment? selectedAppointment;

  /// Calendar element.
  final CalendarElement targetElement;

  /// Selected date value.
  final DateTime selectedDate;

  /// Collection of colors.
  final List<Color> colorCollection;

  /// List of colors name.
  final List<String> colorNames;

  /// Holds the events value.
  final CalendarDataSource events;

  /// Collection of time zone values.
  final List<String> timeZoneCollection;

  /// Selected Calendar resource.
  final CalendarResource? selectedResource;

  @override
  _AppointmentEditorState createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  int _selectedColorIndex = 0;
  int _selectedTimeZoneIndex = 0;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  String _subject = '';
  String? _notes;
  String? _location;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];
  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  RecurrenceRange? _recurrenceRange;
  late int _interval;
  _SelectRule? _rule = _SelectRule.doesNotRepeat;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(AppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field.
  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment!.startTime;
      _endDate = widget.selectedAppointment!.endTime;
      _isAllDay = widget.selectedAppointment!.isAllDay;
      _selectedColorIndex = widget.colorCollection.indexOf(
        widget.selectedAppointment!.color,
      );
      _selectedTimeZoneIndex =
          widget.selectedAppointment!.startTimeZone == null ||
              widget.selectedAppointment!.startTimeZone == ''
          ? 0
          : widget.timeZoneCollection.indexOf(
              widget.selectedAppointment!.startTimeZone!,
            );
      _subject = widget.selectedAppointment!.subject == '(No title)'
          ? ''
          : widget.selectedAppointment!.subject;
      _notes = widget.selectedAppointment!.notes;
      _location = widget.selectedAppointment!.location;
      _resourceIds = widget.selectedAppointment!.resourceIds?.sublist(0);
      _recurrenceProperties =
          widget.selectedAppointment!.recurrenceRule != null &&
              widget.selectedAppointment!.recurrenceRule!.isNotEmpty
          ? SfCalendar.parseRRule(
              widget.selectedAppointment!.recurrenceRule!,
              _startDate,
            )
          : null;
      if (_recurrenceProperties == null) {
        _rule = _SelectRule.doesNotRepeat;
      } else {
        _updateMobileRecurrenceProperties();
      }
    } else {
      _isAllDay = widget.targetElement == CalendarElement.allDayPanel;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      _location = '';
      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      if (widget.selectedResource != null) {
        _resourceIds = <Object>[widget.selectedResource!.id];
      }
      _rule = _SelectRule.doesNotRepeat;
      _recurrenceProperties = null;
    }
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources = getSelectedResources(
      _resourceIds,
      widget.events.resources,
    );
    _unSelectedResources = getUnSelectedResources(
      _selectedResources,
      widget.events.resources,
    );
  }

  void _updateMobileRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    _interval = _recurrenceProperties!.interval;
    if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
      switch (_recurrenceType) {
        case RecurrenceType.daily:
          _rule = _SelectRule.everyDay;
          break;
        case RecurrenceType.weekly:
          if (_recurrenceProperties!.weekDays.length == 1) {
            _rule = _SelectRule.everyWeek;
          } else {
            _rule = _SelectRule.custom;
          }
          break;
        case RecurrenceType.monthly:
          _rule = _SelectRule.everyMonth;
          break;
        case RecurrenceType.yearly:
          _rule = _SelectRule.everyYear;
          break;
      }
    } else {
      _rule = _SelectRule.custom;
    }
  }

  Widget _getAppointmentEditor(
    BuildContext context,
    Color backgroundColor,
    Color defaultColor,
  ) {
    return Container(
      color: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            leading: const Text(''),
            title: TextField(
              controller: TextEditingController(text: _subject),
              onChanged: (String value) {
                _subject = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 25,
                color: defaultColor,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add title',
              ),
            ),
          ),
          const Divider(height: 1.0, thickness: 1),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: Icon(Icons.access_time, color: defaultColor),
            title: Row(
              children: <Widget>[
                const Expanded(child: Text('All-day')),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: _isAllDay,
                      onChanged: (bool value) {
                        setState(() {
                          _isAllDay = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData(
                              brightness:
                                  widget.model.themeData.colorScheme.brightness,
                              colorScheme: getColorScheme(widget.model, true),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null && date != _startDate) {
                        setState(() {
                          final Duration difference = _endDate.difference(
                            _startDate,
                          );
                          _startDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _startTime.hour,
                            _startTime.minute,
                          );
                          _endDate = _startDate.add(difference);
                          _endTime = TimeOfDay(
                            hour: _endDate.hour,
                            minute: _endDate.minute,
                          );
                        });
                      }
                    },
                    child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(_startDate),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _isAllDay
                      ? const Text('')
                      : GestureDetector(
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: _startTime.hour,
                                minute: _startTime.minute,
                              ),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    brightness: widget
                                        .model
                                        .themeData
                                        .colorScheme
                                        .brightness,
                                    colorScheme: getColorScheme(
                                      widget.model,
                                      false,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (time != null && time != _startTime) {
                              setState(() {
                                _startTime = time;
                                final Duration difference = _endDate.difference(
                                  _startDate,
                                );
                                _startDate = DateTime(
                                  _startDate.year,
                                  _startDate.month,
                                  _startDate.day,
                                  _startTime.hour,
                                  _startTime.minute,
                                );
                                _endDate = _startDate.add(difference);
                                _endTime = TimeOfDay(
                                  hour: _endDate.hour,
                                  minute: _endDate.minute,
                                );
                              });
                            }
                          },
                          child: Text(
                            DateFormat('hh:mm a').format(_startDate),
                            textAlign: TextAlign.right,
                          ),
                        ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData(
                              brightness:
                                  widget.model.themeData.colorScheme.brightness,
                              colorScheme: getColorScheme(widget.model, true),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null && date != _endDate) {
                        setState(() {
                          final Duration difference = _endDate.difference(
                            _startDate,
                          );
                          _endDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _endTime.hour,
                            _endTime.minute,
                          );
                          if (_endDate.isBefore(_startDate)) {
                            _startDate = _endDate.subtract(difference);
                            _startTime = TimeOfDay(
                              hour: _startDate.hour,
                              minute: _startDate.minute,
                            );
                          }
                        });
                      }
                    },
                    child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(_endDate),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _isAllDay
                      ? const Text('')
                      : GestureDetector(
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: _endTime.hour,
                                minute: _endTime.minute,
                              ),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    brightness: widget
                                        .model
                                        .themeData
                                        .colorScheme
                                        .brightness,
                                    colorScheme: getColorScheme(
                                      widget.model,
                                      false,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (time != null && time != _endTime) {
                              setState(() {
                                _endTime = time;
                                final Duration difference = _endDate.difference(
                                  _startDate,
                                );
                                _endDate = DateTime(
                                  _endDate.year,
                                  _endDate.month,
                                  _endDate.day,
                                  _endTime.hour,
                                  _endTime.minute,
                                );
                                if (_endDate.isBefore(_startDate)) {
                                  _startDate = _endDate.subtract(difference);
                                  _startTime = TimeOfDay(
                                    hour: _startDate.hour,
                                    minute: _startDate.minute,
                                  );
                                }
                              });
                            }
                          },
                          child: Text(
                            DateFormat('hh:mm a').format(_endDate),
                            textAlign: TextAlign.right,
                          ),
                        ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: Icon(Icons.public, color: defaultColor),
            title: Text(widget.timeZoneCollection[_selectedTimeZoneIndex]),
            onTap: () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return CalendarTimeZonePicker(
                    widget.model.primaryColor,
                    widget.timeZoneCollection,
                    _selectedTimeZoneIndex,
                    widget.model,
                    onChanged: (PickerChangedDetails details) {
                      _selectedTimeZoneIndex = details.index;
                    },
                  );
                },
              ).then(
                (dynamic value) => setState(() {
                  /// Update the time zone changes.
                }),
              );
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: Icon(Icons.refresh, color: defaultColor),
            title: Text(
              _rule == _SelectRule.doesNotRepeat
                  ? 'Does not repeat'
                  : _rule == _SelectRule.everyDay
                  ? 'Every day'
                  : _rule == _SelectRule.everyWeek
                  ? 'Every week'
                  : _rule == _SelectRule.everyMonth
                  ? 'Every month'
                  : _rule == _SelectRule.everyYear
                  ? 'Every year'
                  : 'Custom',
            ),
            onTap: () async {
              final dynamic properties = await showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return PopScope(
                    onPopInvokedWithResult: (bool value, Object? result) async {
                      if (value) {
                        return;
                      }
                    },
                    child: Theme(
                      data: widget.model.themeData,
                      // ignore: prefer_const_literals_to_create_immutables
                      child: _SelectRuleDialog(
                        widget.model,
                        _recurrenceProperties,
                        widget.colorCollection[_selectedColorIndex],
                        widget.events,
                        selectedAppointment:
                            widget.selectedAppointment ??
                            Appointment(
                              startTime: _startDate,
                              endTime: _endDate,
                              isAllDay: _isAllDay,
                              subject: _subject == '' ? '(No title)' : _subject,
                            ),
                        onChanged: (PickerChangedDetails details) {
                          setState(() {
                            _rule = details.selectedRule;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
              _recurrenceProperties = properties as RecurrenceProperties?;
            },
          ),
          if (widget.events.resources == null ||
              widget.events.resources!.isEmpty)
            Container()
          else
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.people, color: defaultColor),
              title: _getResourceEditor(
                TextStyle(
                  fontSize: 18,
                  color: defaultColor,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return ResourcePicker(
                      _unSelectedResources,
                      widget.model,
                      onChanged: (PickerChangedDetails details) {
                        _resourceIds = _resourceIds == null
                            ? <Object>[details.resourceId!]
                            : (_resourceIds!.sublist(0)
                                ..add(details.resourceId!));
                        _selectedResources = getSelectedResources(
                          _resourceIds,
                          widget.events.resources,
                        );
                        _unSelectedResources = getUnSelectedResources(
                          _selectedResources,
                          widget.events.resources,
                        );
                      },
                    );
                  },
                ).then(
                  (dynamic value) => setState(() {
                    /// Update the color picker changes.
                  }),
                );
              },
            ),
          const Divider(height: 1.0, thickness: 1),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: Icon(
              Icons.lens,
              color: widget.colorCollection[_selectedColorIndex],
            ),
            title: Text(widget.colorNames[_selectedColorIndex]),
            onTap: () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return CalendarColorPicker(
                    widget.colorCollection,
                    _selectedColorIndex,
                    widget.colorNames,
                    widget.model,
                    onChanged: (PickerChangedDetails details) {
                      _selectedColorIndex = details.index;
                    },
                  );
                },
              ).then(
                (dynamic value) => setState(() {
                  /// Update the color picker changes.
                }),
              );
            },
          ),
          const Divider(height: 1.0, thickness: 1),
          if (widget.model.isWebFullView)
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(Icons.location_on, color: defaultColor),
              title: TextField(
                controller: TextEditingController(text: _location),
                onChanged: (String value) {
                  _location = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                  fontSize: 18,
                  color: defaultColor,
                  fontWeight: FontWeight.w300,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add location',
                ),
              ),
            )
          else
            Container(),
          if (widget.model.isWebFullView)
            const Divider(height: 1.0, thickness: 1)
          else
            Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(5),
            leading: Icon(Icons.subject, color: defaultColor),
            title: TextField(
              controller: TextEditingController(text: _notes),
              cursorColor: widget.model.primaryColor,
              onChanged: (String value) {
                _notes = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: widget.model.isWebFullView ? 1 : null,
              style: TextStyle(
                fontSize: 18,
                color: defaultColor,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add description',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: Scaffold(
        backgroundColor:
            widget.model.themeData != null &&
                widget.model.themeData.colorScheme.brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        appBar: AppBar(
          backgroundColor: widget.colorCollection[_selectedColorIndex],
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              icon: const Icon(Icons.done, color: Colors.white),
              onPressed: () {
                if (widget.selectedAppointment != null) {
                  if (widget.selectedAppointment!.appointmentType !=
                      AppointmentType.normal) {
                    final Appointment newAppointment = Appointment(
                      startTime: _startDate,
                      endTime: _endDate,
                      color: widget.colorCollection[_selectedColorIndex],
                      startTimeZone: _selectedTimeZoneIndex == 0
                          ? ''
                          : widget.timeZoneCollection[_selectedTimeZoneIndex],
                      endTimeZone: _selectedTimeZoneIndex == 0
                          ? ''
                          : widget.timeZoneCollection[_selectedTimeZoneIndex],
                      notes: _notes,
                      isAllDay: _isAllDay,
                      subject: _subject == '' ? '(No title)' : _subject,
                      recurrenceExceptionDates:
                          widget.selectedAppointment!.recurrenceExceptionDates,
                      resourceIds: _resourceIds,
                      id: widget.selectedAppointment!.id,
                      recurrenceId: widget.selectedAppointment!.recurrenceId,
                      recurrenceRule: _recurrenceProperties == null
                          ? null
                          : SfCalendar.generateRRule(
                              _recurrenceProperties!,
                              _startDate,
                              _endDate,
                            ),
                    );
                    showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return PopScope(
                          onPopInvokedWithResult:
                              (bool value, Object? result) async {
                                if (value) {
                                  return;
                                }
                              },
                          child: Theme(
                            data: widget.model.themeData,
                            // ignore: prefer_const_literals_to_create_immutables
                            child: _EditDialog(
                              widget.model,
                              newAppointment,
                              widget.selectedAppointment!,
                              _recurrenceProperties,
                              widget.events,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    final List<Appointment> appointment = <Appointment>[];
                    if (widget.selectedAppointment != null) {
                      widget.events.appointments!.removeAt(
                        widget.events.appointments!.indexOf(
                          widget.selectedAppointment,
                        ),
                      );
                      widget.events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[widget.selectedAppointment!],
                      );
                    }
                    appointment.add(
                      Appointment(
                        startTime: _startDate,
                        endTime: _endDate,
                        color: widget.colorCollection[_selectedColorIndex],
                        startTimeZone: _selectedTimeZoneIndex == 0
                            ? ''
                            : widget.timeZoneCollection[_selectedTimeZoneIndex],
                        endTimeZone: _selectedTimeZoneIndex == 0
                            ? ''
                            : widget.timeZoneCollection[_selectedTimeZoneIndex],
                        notes: _notes,
                        isAllDay: _isAllDay,
                        subject: _subject == '' ? '(No title)' : _subject,
                        resourceIds: _resourceIds,
                        id: widget.selectedAppointment!.id,
                        recurrenceRule: _recurrenceProperties == null
                            ? null
                            : SfCalendar.generateRRule(
                                _recurrenceProperties!,
                                _startDate,
                                _endDate,
                              ),
                      ),
                    );
                    widget.events.appointments!.add(appointment[0]);
                    widget.events.notifyListeners(
                      CalendarDataSourceAction.add,
                      appointment,
                    );
                    Navigator.pop(context);
                  }
                } else {
                  final List<Appointment> appointment = <Appointment>[];
                  if (widget.selectedAppointment != null) {
                    widget.events.appointments!.removeAt(
                      widget.events.appointments!.indexOf(
                        widget.selectedAppointment,
                      ),
                    );
                    widget.events.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Appointment>[widget.selectedAppointment!],
                    );
                  }
                  appointment.add(
                    Appointment(
                      startTime: _startDate,
                      endTime: _endDate,
                      color: widget.colorCollection[_selectedColorIndex],
                      startTimeZone: _selectedTimeZoneIndex == 0
                          ? ''
                          : widget.timeZoneCollection[_selectedTimeZoneIndex],
                      endTimeZone: _selectedTimeZoneIndex == 0
                          ? ''
                          : widget.timeZoneCollection[_selectedTimeZoneIndex],
                      notes: _notes,
                      isAllDay: _isAllDay,
                      subject: _subject == '' ? '(No title)' : _subject,
                      resourceIds: _resourceIds,
                      recurrenceRule:
                          _rule == _SelectRule.doesNotRepeat ||
                              _recurrenceProperties == null
                          ? null
                          : SfCalendar.generateRRule(
                              _recurrenceProperties!,
                              _startDate,
                              _endDate,
                            ),
                    ),
                  );
                  widget.events.appointments!.add(appointment[0]);
                  widget.events.notifyListeners(
                    CalendarDataSourceAction.add,
                    appointment,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Stack(
            children: <Widget>[
              _getAppointmentEditor(
                context,
                (widget.model.themeData.colorScheme.brightness ==
                        Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white)!,
                widget.model.themeData.colorScheme.brightness != null &&
                        widget.model.themeData.colorScheme.brightness ==
                            Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ],
          ),
        ),
        floatingActionButton: widget.model.isWebFullView
            ? null
            : widget.selectedAppointment == null
            ? const Text('')
            : FloatingActionButton(
                onPressed: () {
                  if (widget.selectedAppointment != null) {
                    if (widget.selectedAppointment!.appointmentType ==
                        AppointmentType.normal) {
                      widget.events.appointments!.removeAt(
                        widget.events.appointments!.indexOf(
                          widget.selectedAppointment,
                        ),
                      );
                      widget.events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[widget.selectedAppointment!],
                      );
                      Navigator.pop(context);
                    } else {
                      showDialog<Widget>(
                        context: context,
                        builder: (BuildContext context) {
                          return PopScope(
                            onPopInvokedWithResult:
                                (bool value, Object? result) async {
                                  if (value) {
                                    return;
                                  }
                                },
                            child: Theme(
                              data: widget.model.themeData,
                              // ignore: prefer_const_literals_to_create_immutables
                              child: _DeleteDialog(
                                widget.model,
                                widget.selectedAppointment!,
                                widget.events,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                backgroundColor: widget.model.primaryColor,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
      ),
    );
  }

  /// Return the resource editor to edit the resource collection for an
  /// appointment.
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources == null || _selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }
    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(
        Chip(
          padding: EdgeInsets.zero,
          avatar: CircleAvatar(
            backgroundColor: widget.model.primaryColor,
            backgroundImage: selectedResource.image,
            child: selectedResource.image == null
                ? Text(selectedResource.displayName[0])
                : null,
          ),
          label: Text(selectedResource.displayName),
          onDeleted: () {
            _selectedResources.removeAt(i);
            _resourceIds?.removeAt(i);
            _unSelectedResources = getUnSelectedResources(
              _selectedResources,
              widget.events.resources,
            );
            setState(() {});
          },
        ),
      );
    }
    return Wrap(spacing: 6.0, runSpacing: 6.0, children: chipWidgets);
  }
}

/// Returns the resource from the id passed.
CalendarResource _getResourceFromId(
  Object resourceId,
  List<CalendarResource> resourceCollection,
) {
  return resourceCollection.firstWhere(
    (CalendarResource resource) => resource.id == resourceId,
  );
}

/// Returns the selected resources based on the id collection passed.
List<CalendarResource> getSelectedResources(
  List<Object>? resourceIds,
  List<CalendarResource>? resourceCollection,
) {
  final List<CalendarResource> selectedResources = <CalendarResource>[];
  if (resourceIds == null ||
      resourceIds.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return selectedResources;
  }
  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName = _getResourceFromId(
      resourceIds[i],
      resourceCollection,
    );
    selectedResources.add(resourceName);
  }
  return selectedResources;
}

/// Returns the available resource, by filtering the resource collection from
/// the selected resource collection.
List<CalendarResource> getUnSelectedResources(
  List<CalendarResource>? selectedResources,
  List<CalendarResource>? resourceCollection,
) {
  if (selectedResources == null ||
      selectedResources.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return resourceCollection ?? <CalendarResource>[];
  }

  final List<CalendarResource> collection = resourceCollection.sublist(0);
  for (int i = 0; i < resourceCollection.length; i++) {
    final CalendarResource resource = resourceCollection[i];
    for (int j = 0; j < selectedResources.length; j++) {
      final CalendarResource selectedResource = selectedResources[j];
      if (resource.id == selectedResource.id) {
        collection.remove(resource);
      }
    }
  }
  return collection;
}

// ignore: must_be_immutable
class _SelectRuleDialog extends StatefulWidget {
  _SelectRuleDialog(
    this.model,
    this.recurrenceProperties,
    this.appointmentColor,
    this.events, {
    required this.onChanged,
    this.selectedAppointment,
  });

  final SampleModel model;
  final Appointment? selectedAppointment;
  RecurrenceProperties? recurrenceProperties;
  final Color appointmentColor;
  final CalendarDataSource events;
  final PickerChanged onChanged;

  @override
  _SelectRuleDialogState createState() => _SelectRuleDialogState();
}

class _SelectRuleDialogState extends State<_SelectRuleDialog> {
  late DateTime _startDate;
  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  late RecurrenceRange _recurrenceRange;
  late int _interval;
  _SelectRule? _rule;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(_SelectRuleDialog oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field.
  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment!.startTime;
    _recurrenceProperties = widget.recurrenceProperties;
    if (widget.recurrenceProperties == null) {
      _rule = _SelectRule.doesNotRepeat;
    } else {
      _updateRecurrenceType();
    }
  }

  void _updateRecurrenceType() {
    _recurrenceType = widget.recurrenceProperties!.recurrenceType;
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    _interval = _recurrenceProperties!.interval;
    if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
      switch (_recurrenceType) {
        case RecurrenceType.daily:
          _rule = _SelectRule.everyDay;
          break;
        case RecurrenceType.weekly:
          if (_recurrenceProperties!.weekDays.length == 1) {
            _rule = _SelectRule.everyWeek;
          } else {
            _rule = _SelectRule.custom;
          }
          break;
        case RecurrenceType.monthly:
          _rule = _SelectRule.everyMonth;
          break;
        case RecurrenceType.yearly:
          _rule = _SelectRule.everyYear;
          break;
      }
    } else {
      _rule = _SelectRule.custom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 360,
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              width: 360,
              padding: const EdgeInsets.only(bottom: 10),
              child: RadioGroup<_SelectRule>(
                groupValue: _rule,
                onChanged: (_SelectRule? value) async {
                  dynamic properties;
                  if (value != null && value == _SelectRule.custom) {
                    properties = await _navigateToCustomRule(context);
                  }
                  _handleSpecificRuleLogics(value, properties);
                  if (context.mounted && value != null) {
                    if (value == _SelectRule.custom) {
                      Navigator.pop(context, properties);
                    } else {
                      Navigator.pop(context, widget.recurrenceProperties);
                    }
                  }
                },
                child: Column(
                  children: <Widget>[
                    RadioListTile<_SelectRule>(
                      title: const Text('Does not repeat'),
                      value: _SelectRule.doesNotRepeat,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                    RadioListTile<_SelectRule>(
                      title: const Text('Every day'),
                      value: _SelectRule.everyDay,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                    RadioListTile<_SelectRule>(
                      title: const Text('Every week'),
                      value: _SelectRule.everyWeek,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                    RadioListTile<_SelectRule>(
                      title: const Text('Every month'),
                      value: _SelectRule.everyMonth,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                    RadioListTile<_SelectRule>(
                      title: const Text('Every year'),
                      value: _SelectRule.everyYear,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                    RadioListTile<_SelectRule>(
                      title: const Text('Custom'),
                      value: _SelectRule.custom,
                      toggleable: true,
                      activeColor: widget.model.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSpecificRuleLogics(_SelectRule? value, properties) {
    setState(() {
      if (value != null) {
        switch (value) {
          case _SelectRule.doesNotRepeat:
            {
              _doesNotRepeatRule(value);
              break;
            }
          case _SelectRule.everyDay:
            {
              _everyDayRule(value);
              break;
            }
          case _SelectRule.everyWeek:
            {
              _everyWeekRule(value);
              break;
            }
          case _SelectRule.everyMonth:
            {
              _everyMonthRule(value);
              break;
            }
          case _SelectRule.everyYear:
            {
              _everyYearRule(value);
              break;
            }
          case _SelectRule.custom:
            {
              _onChangedCustomRule(properties);
              if (!mounted) {
                return;
              }
              break;
            }
        }
      }
    });
  }

  void _onChangedCustomRule(properties) {
    if (properties != widget.recurrenceProperties) {
      _rule = _SelectRule.custom;
      widget.onChanged(PickerChangedDetails(selectedRule: _rule));
    }
  }

  Future<dynamic> _navigateToCustomRule(BuildContext context) async {
    final dynamic properties = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => _CustomRule(
          widget.model,
          widget.selectedAppointment!,
          widget.appointmentColor,
          widget.events,
          widget.recurrenceProperties,
        ),
      ),
    );
    return properties;
  }

  void _everyYearRule(_SelectRule value) {
    _rule = value;
    widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
    widget.recurrenceProperties!.recurrenceType = RecurrenceType.yearly;
    widget.recurrenceProperties!.interval = 1;
    widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
    widget.recurrenceProperties!.month =
        widget.selectedAppointment!.startTime.month;
    widget.recurrenceProperties!.dayOfMonth =
        widget.selectedAppointment!.startTime.day;
    widget.onChanged(PickerChangedDetails(selectedRule: _rule));
  }

  void _everyMonthRule(_SelectRule value) {
    _rule = value;
    widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
    widget.recurrenceProperties!.recurrenceType = RecurrenceType.monthly;
    widget.recurrenceProperties!.interval = 1;
    widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
    widget.recurrenceProperties!.dayOfMonth =
        widget.selectedAppointment!.startTime.day;
    widget.onChanged(PickerChangedDetails(selectedRule: _rule));
  }

  void _everyWeekRule(_SelectRule value) {
    _rule = value;
    widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
    widget.recurrenceProperties!.recurrenceType = RecurrenceType.weekly;
    widget.recurrenceProperties!.interval = 1;
    widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
    widget.recurrenceProperties!.weekDays = _startDate.weekday == 1
        ? <WeekDays>[WeekDays.monday]
        : _startDate.weekday == 2
        ? <WeekDays>[WeekDays.tuesday]
        : _startDate.weekday == 3
        ? <WeekDays>[WeekDays.wednesday]
        : _startDate.weekday == 4
        ? <WeekDays>[WeekDays.thursday]
        : _startDate.weekday == 5
        ? <WeekDays>[WeekDays.friday]
        : _startDate.weekday == 6
        ? <WeekDays>[WeekDays.saturday]
        : <WeekDays>[WeekDays.sunday];
    widget.onChanged(PickerChangedDetails(selectedRule: _rule));
  }

  void _everyDayRule(_SelectRule value) {
    _rule = value;
    widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
    widget.recurrenceProperties!.recurrenceType = RecurrenceType.daily;
    widget.recurrenceProperties!.interval = 1;
    widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
    widget.onChanged(PickerChangedDetails(selectedRule: _rule));
  }

  void _doesNotRepeatRule(_SelectRule? value) {
    if (value != null) {
      _rule = value;
      widget.recurrenceProperties = null;
      widget.onChanged(PickerChangedDetails(selectedRule: _rule));
    }
  }
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog(this.model, this.selectedAppointment, this.events);

  final SampleModel model;
  final Appointment selectedAppointment;
  final CalendarDataSource events;

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  _Delete _delete = _Delete.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultTextColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: 380,
          height: 210,
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 370,
            padding: const EdgeInsets.only(bottom: 10),
            child: RadioGroup<_Delete>(
              groupValue: _delete,
              onChanged: (_Delete? value) {
                setState(() {
                  _delete = value!;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(left: 25, top: 5),
                    child: Text(
                      'Delete recurring event',
                      style: TextStyle(
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(width: 20),
                  RadioListTile<_Delete>(
                    title: const Text('This event'),
                    value: _Delete.event,
                    activeColor: widget.model.primaryColor,
                  ),
                  RadioListTile<_Delete>(
                    title: const Text('All events'),
                    value: _Delete.series,
                    activeColor: widget.model.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RawMaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: widget.model.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          final Appointment? parentAppointment =
                              widget.events.getPatternAppointment(
                                    widget.selectedAppointment,
                                    '',
                                  )
                                  as Appointment?;
                          if (_delete == _Delete.event) {
                            if (widget.selectedAppointment.recurrenceId !=
                                null) {
                              widget.events.appointments!.remove(
                                widget.selectedAppointment,
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment],
                              );
                            }
                            widget.events.appointments!.removeAt(
                              widget.events.appointments!.indexOf(
                                parentAppointment,
                              ),
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment!],
                            );
                            parentAppointment.recurrenceExceptionDates != null
                                ? parentAppointment.recurrenceExceptionDates!
                                      .add(widget.selectedAppointment.startTime)
                                : parentAppointment.recurrenceExceptionDates =
                                      <DateTime>[
                                        widget.selectedAppointment.startTime,
                                      ];
                            widget.events.appointments!.add(parentAppointment);
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment],
                            );
                          } else {
                            if (parentAppointment!.recurrenceExceptionDates ==
                                null) {
                              widget.events.appointments!.removeAt(
                                widget.events.appointments!.indexOf(
                                  parentAppointment,
                                ),
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment],
                              );
                            } else {
                              final List<DateTime>? exceptionDates =
                                  parentAppointment.recurrenceExceptionDates;
                              for (int i = 0; i < exceptionDates!.length; i++) {
                                final Appointment? changedOccurrence = widget
                                    .events
                                    .getOccurrenceAppointment(
                                      parentAppointment,
                                      exceptionDates[i],
                                      '',
                                    );
                                if (changedOccurrence != null) {
                                  widget.events.appointments!.remove(
                                    changedOccurrence,
                                  );
                                  widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[changedOccurrence],
                                  );
                                }
                              }
                              widget.events.appointments!.removeAt(
                                widget.events.appointments!.indexOf(
                                  parentAppointment,
                                ),
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment],
                              );
                            }
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: widget.model.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog(
    this.model,
    this.newAppointment,
    this.selectedAppointment,
    this.recurrenceProperties,
    this.events,
  );

  final SampleModel model;
  final Appointment newAppointment, selectedAppointment;
  final RecurrenceProperties? recurrenceProperties;
  final CalendarDataSource events;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  _Edit _edit = _Edit.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultTextColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: 380,
          height: 210,
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 370,
            padding: const EdgeInsets.only(bottom: 10),
            child: RadioGroup<_Edit>(
              groupValue: _edit,
              onChanged: (_Edit? value) {
                setState(() {
                  _edit = value!;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(left: 25, top: 5),
                    child: Text(
                      'Save recurring event',
                      style: TextStyle(
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(width: 20),
                  RadioListTile<_Edit>(
                    title: const Text('This event'),
                    value: _Edit.event,
                    activeColor: widget.model.primaryColor,
                  ),
                  RadioListTile<_Edit>(
                    title: const Text('All events'),
                    value: _Edit.series,
                    activeColor: widget.model.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RawMaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: widget.model.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        onPressed: () {
                          if (_edit == _Edit.event) {
                            final Appointment? parentAppointment =
                                widget.events.getPatternAppointment(
                                      widget.selectedAppointment,
                                      '',
                                    )
                                    as Appointment?;
                            final Appointment newAppointment = Appointment(
                              startTime: widget.newAppointment.startTime,
                              endTime: widget.newAppointment.endTime,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id:
                                  widget.selectedAppointment.appointmentType ==
                                      AppointmentType.changedOccurrence
                                  ? widget.selectedAppointment.id
                                  : null,
                              recurrenceId: parentAppointment!.id,
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone,
                            );
                            parentAppointment.recurrenceExceptionDates != null
                                ? parentAppointment.recurrenceExceptionDates!
                                      .add(widget.selectedAppointment.startTime)
                                : parentAppointment.recurrenceExceptionDates =
                                      <DateTime>[
                                        widget.selectedAppointment.startTime,
                                      ];
                            widget.events.appointments!.removeAt(
                              widget.events.appointments!.indexOf(
                                parentAppointment,
                              ),
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment],
                            );
                            widget.events.appointments!.add(parentAppointment);
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment],
                            );
                            if (widget.selectedAppointment.appointmentType ==
                                AppointmentType.changedOccurrence) {
                              widget.events.appointments!.removeAt(
                                widget.events.appointments!.indexOf(
                                  widget.selectedAppointment,
                                ),
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment],
                              );
                            }
                            widget.events.appointments!.add(newAppointment);
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[newAppointment],
                            );
                          } else {
                            Appointment? parentAppointment =
                                widget.events.getPatternAppointment(
                                      widget.selectedAppointment,
                                      '',
                                    )
                                    as Appointment?;
                            final List<DateTime>? exceptionDates =
                                parentAppointment!.recurrenceExceptionDates;
                            if (exceptionDates != null &&
                                exceptionDates.isNotEmpty) {
                              for (int i = 0; i < exceptionDates.length; i++) {
                                final Appointment? changedOccurrence = widget
                                    .events
                                    .getOccurrenceAppointment(
                                      parentAppointment,
                                      exceptionDates[i],
                                      '',
                                    );
                                if (changedOccurrence != null) {
                                  widget.events.appointments!.remove(
                                    changedOccurrence,
                                  );
                                  widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[changedOccurrence],
                                  );
                                }
                              }
                            }
                            widget.events.appointments!.removeAt(
                              widget.events.appointments!.indexOf(
                                parentAppointment,
                              ),
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment],
                            );
                            DateTime startDate, endDate;
                            if (widget.newAppointment.startTime.isBefore(
                              parentAppointment.startTime,
                            )) {
                              startDate = widget.newAppointment.startTime;
                              endDate = widget.newAppointment.endTime;
                            } else {
                              startDate = DateTime(
                                parentAppointment.startTime.year,
                                parentAppointment.startTime.month,
                                parentAppointment.startTime.day,
                                widget.newAppointment.startTime.hour,
                                widget.newAppointment.startTime.minute,
                              );
                              endDate = DateTime(
                                parentAppointment.endTime.year,
                                parentAppointment.endTime.month,
                                parentAppointment.endTime.day,
                                widget.newAppointment.endTime.hour,
                                widget.newAppointment.endTime.minute,
                              );
                            }
                            parentAppointment = Appointment(
                              startTime: startDate,
                              endTime: endDate,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id: parentAppointment.id,
                              recurrenceRule:
                                  widget.recurrenceProperties == null
                                  ? null
                                  : SfCalendar.generateRRule(
                                      widget.recurrenceProperties!,
                                      startDate,
                                      endDate,
                                    ),
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone,
                            );
                            widget.events.appointments!.add(parentAppointment);
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment],
                            );
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: widget.model.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown list items for mobile recurrenceType.
List<String> _mobileRecurrence = <String>['day', 'week', 'month', 'year'];

enum _EndRule { never, endDate, count }

/// Dropdown list items for week number of the month.
List<String> _weekDayPosition = <String>[
  'first',
  'second',
  'third',
  'fourth',
  'last',
];

class _CustomRule extends StatefulWidget {
  const _CustomRule(
    this.model,
    this.selectedAppointment,
    this.appointmentColor,
    this.events,
    this.recurrenceProperties,
  );

  final SampleModel model;
  final Appointment selectedAppointment;
  final Color appointmentColor;
  final CalendarDataSource events;
  final RecurrenceProperties? recurrenceProperties;

  @override
  _CustomRuleState createState() => _CustomRuleState();
}

class _CustomRuleState extends State<_CustomRule> {
  late DateTime _startDate;
  _EndRule? _endRule;
  RecurrenceProperties? _recurrenceProperties;
  String? _selectedRecurrenceType, _monthlyRule, _weekNumberDay;
  int? _count, _interval, _month, _week;
  late int _dayOfWeek, _weekNumber, _dayOfMonth;
  late DateTime _selectedDate, _firstDate;
  late RecurrenceType _recurrenceType;
  late RecurrenceRange _recurrenceRange;
  List<WeekDays>? _days;
  late double _width;
  bool _isLastDay = false;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  void _updateAppointmentProperties() {
    _width = 180;
    _startDate = widget.selectedAppointment.startTime;
    _selectedDate = _startDate.add(const Duration(days: 30));
    _count = 1;
    _interval = 1;
    _selectedRecurrenceType = _selectedRecurrenceType ?? 'day';
    _dayOfMonth = _startDate.day;
    _dayOfWeek = _startDate.weekday;
    _monthlyRule = 'Monthly on day ' + _startDate.day.toString() + 'th';
    _endRule = _EndRule.never;
    _month = _startDate.month;
    _weekNumber = _getWeekNumber(_startDate);
    _weekNumberDay =
        _weekDayPosition[_weekNumber == -1 ? 4 : _weekNumber - 1] +
        ' ' +
        weekDay[_dayOfWeek - 1];
    if (_days == null) {
      _mobileInitialWeekdays(_startDate.weekday);
    }
    final Appointment? parentAppointment =
        widget.events.getPatternAppointment(widget.selectedAppointment, '')
            as Appointment?;
    if (parentAppointment == null) {
      _firstDate = _startDate;
    } else {
      _firstDate = parentAppointment.startTime;
    }
    _recurrenceProperties =
        widget.selectedAppointment.recurrenceRule != null &&
            widget.selectedAppointment.recurrenceRule!.isNotEmpty
        ? SfCalendar.parseRRule(
            widget.selectedAppointment.recurrenceRule!,
            _firstDate,
          )
        : null;
    _recurrenceProperties == null
        ? _recurrenceProperties = RecurrenceProperties(startDate: _firstDate)
        : _updateCustomRecurrenceProperties();
  }

  void _updateCustomRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _week = _recurrenceProperties!.week;
    _weekNumber = _recurrenceProperties!.week == 0
        ? _weekNumber
        : _recurrenceProperties!.week;
    _month = _recurrenceProperties!.month;
    _dayOfMonth = _recurrenceProperties!.dayOfMonth == 1
        ? _startDate.day
        : _recurrenceProperties!.dayOfMonth;
    _dayOfWeek = _recurrenceProperties!.dayOfWeek;

    switch (_recurrenceType) {
      case RecurrenceType.daily:
        _dayRule();
        break;
      case RecurrenceType.weekly:
        _days = _recurrenceProperties!.weekDays;
        _weekRule();
        break;
      case RecurrenceType.monthly:
        _monthRule();
        break;
      case RecurrenceType.yearly:
        _month = _recurrenceProperties!.month;
        _yearRule();
        break;
    }
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    switch (_recurrenceRange) {
      case RecurrenceRange.noEndDate:
        _endRule = _EndRule.never;
        _rangeNoEndDate();
        break;
      case RecurrenceRange.endDate:
        _endRule = _EndRule.endDate;
        final Appointment? parentAppointment =
            widget.events.getPatternAppointment(widget.selectedAppointment, '')
                as Appointment?;
        _firstDate = parentAppointment!.startTime;
        _rangeEndDate();
        break;
      case RecurrenceRange.count:
        _endRule = _EndRule.count;
        _rangeCount();
        break;
    }
  }

  void _dayRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.daily;
      _selectedRecurrenceType = 'day';
    });
  }

  void _weekRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.weekly;
      _selectedRecurrenceType = 'week';
      _recurrenceProperties!.weekDays = _days!;
    });
  }

  void _monthRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthlyDay();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        _week == 0 || _week == null ? _monthlyDay() : _monthlyWeek();
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.monthly;
      _selectedRecurrenceType = 'month';
    });
  }

  void _yearRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthlyDay();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        _week == 0 || _week == null ? _monthlyDay() : _monthlyWeek();
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.yearly;
      _selectedRecurrenceType = 'year';
      _recurrenceProperties!.month = _month!;
    });
  }

  void _rangeNoEndDate() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
  }

  void _rangeEndDate() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.endDate;
    _selectedDate =
        _recurrenceProperties!.endDate ??
        _startDate.add(const Duration(days: 30));
    _recurrenceProperties!.endDate = _selectedDate;
  }

  void _rangeCount() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.count;
    _count = _recurrenceProperties!.recurrenceCount == 0
        ? 1
        : _recurrenceProperties!.recurrenceCount;
    _recurrenceProperties!.recurrenceCount = _count!;
  }

  void _monthlyWeek() {
    setState(() {
      _monthlyRule = 'Monthly on the ' + _weekNumberDay!;
      _recurrenceProperties!.week = _weekNumber;
      _recurrenceProperties!.dayOfWeek = _dayOfWeek;
    });
  }

  void _monthlyDay() {
    setState(() {
      _monthlyRule = 'Monthly on day ' + _startDate.day.toString() + 'th';
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = _dayOfMonth;
    });
  }

  void _lastDayOfMonth() {
    setState(() {
      _monthlyRule = 'Last day of month';
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = -1;
    });
  }

  int _getWeekNumber(DateTime startDate) {
    int weekOfMonth;
    weekOfMonth = (startDate.day / 7).ceil();
    if (weekOfMonth == 5) {
      return -1;
    }
    return weekOfMonth;
  }

  void _mobileSelectWeekDays(WeekDays day) {
    switch (day) {
      case WeekDays.sunday:
        if (_days!.contains(WeekDays.sunday) && _days!.length > 1) {
          _days!.remove(WeekDays.sunday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.sunday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.monday:
        if (_days!.contains(WeekDays.monday) && _days!.length > 1) {
          _days!.remove(WeekDays.monday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.monday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.tuesday:
        if (_days!.contains(WeekDays.tuesday) && _days!.length > 1) {
          _days!.remove(WeekDays.tuesday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.tuesday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.wednesday:
        if (_days!.contains(WeekDays.wednesday) && _days!.length > 1) {
          _days!.remove(WeekDays.wednesday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.wednesday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.thursday:
        if (_days!.contains(WeekDays.thursday) && _days!.length > 1) {
          _days!.remove(WeekDays.thursday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.thursday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.friday:
        if (_days!.contains(WeekDays.friday) && _days!.length > 1) {
          _days!.remove(WeekDays.friday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.friday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.saturday:
        if (_days!.contains(WeekDays.saturday) && _days!.length > 1) {
          _days!.remove(WeekDays.saturday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.saturday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
    }
  }

  void _mobileInitialWeekdays(int day) {
    switch (_startDate.weekday) {
      case DateTime.monday:
        _days = <WeekDays>[WeekDays.monday];
        break;
      case DateTime.tuesday:
        _days = <WeekDays>[WeekDays.tuesday];
        break;
      case DateTime.wednesday:
        _days = <WeekDays>[WeekDays.wednesday];
        break;
      case DateTime.thursday:
        _days = <WeekDays>[WeekDays.thursday];
        break;
      case DateTime.friday:
        _days = <WeekDays>[WeekDays.friday];
        break;
      case DateTime.saturday:
        _days = <WeekDays>[WeekDays.saturday];
        break;
      case DateTime.sunday:
        _days = <WeekDays>[WeekDays.sunday];
        break;
    }
  }

  double _textSize(String text) {
    const TextStyle textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width + 60;
  }

  Widget _getCustomRule(
    BuildContext context,
    Color backgroundColor,
    Color defaultColor,
  ) {
    final Color defaultTextColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    final Color defaultButtonColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    return Container(
      color: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 15),
            child: Text('REPEATS EVERY'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _interval.toString(),
                        selection: TextSelection.collapsed(
                          offset: _interval.toString().length,
                        ),
                      ),
                    ),
                    cursorColor: widget.model.primaryColor,
                    onChanged: (String value) {
                      if (value != null && value.isNotEmpty) {
                        _interval = int.parse(value);
                        if (_interval == 0) {
                          _interval = 1;
                        } else if (_interval! >= 999) {
                          setState(() {
                            _interval = 999;
                          });
                        }
                      } else if (value.isEmpty || value == null) {
                        _interval = 1;
                      }
                      _recurrenceProperties!.interval = _interval!;
                    },
                    keyboardType: TextInputType.number,
                    // ignore: always_specify_types
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      fontSize: 13,
                      color: defaultTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                Container(width: 20),
                Container(
                  height: 40,
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: widget.model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                      fontSize: 13,
                      color: defaultTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    value: _selectedRecurrenceType,
                    items: _mobileRecurrence.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value == 'day') {
                          _selectedRecurrenceType = 'day';
                          _dayRule();
                        } else if (value == 'week') {
                          _selectedRecurrenceType = 'week';
                          _weekRule();
                        } else if (value == 'month') {
                          _selectedRecurrenceType = 'month';
                          _monthRule();
                        } else if (value == 'year') {
                          _selectedRecurrenceType = 'year';
                          _yearRule();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          Visibility(
            visible: _selectedRecurrenceType == 'week',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Text('REPEATS ON'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 15, top: 5),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.sunday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(5, 5),
                          backgroundColor: _days!.contains(WeekDays.sunday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.sunday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text('S'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.monday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.monday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.monday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text('M'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.tuesday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.tuesday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.tuesday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text('T'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.wednesday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.wednesday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.wednesday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text('W'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.thursday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.thursday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.thursday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text('T'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.friday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.friday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.friday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text('F'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mobileSelectWeekDays(WeekDays.saturday);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(7, 7),
                          disabledForegroundColor: Colors.black26,
                          disabledBackgroundColor: Colors.black26,
                          backgroundColor: _days!.contains(WeekDays.saturday)
                              ? widget.model.primaryColor
                              : defaultButtonColor,
                          foregroundColor: _days!.contains(WeekDays.saturday)
                              ? Colors.white
                              : defaultTextColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text('S'),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
          Visibility(
            visible: _selectedRecurrenceType == 'month',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  width: _width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.all(15),
                  child: DropdownButton<String>(
                    dropdownColor: widget.model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                      fontSize: 13,
                      color: defaultTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    value: _monthlyRule,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value:
                            'Monthly on day ' +
                            _startDate.day.toString() +
                            'th',
                        child: Text(
                          'Monthly on day ' + _startDate.day.toString() + 'th',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Monthly on the ' + _weekNumberDay!,
                        child: Text('Monthly on the ' + _weekNumberDay!),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'Last day of month',
                        child: Text('Last day of month'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        if (value ==
                            'Monthly on day ' +
                                _startDate.day.toString() +
                                'th') {
                          _width = _textSize(
                            'Monthly on day ' +
                                _startDate.day.toString() +
                                'th',
                          );
                          _monthlyDay();
                        } else if (value ==
                            'Monthly on the ' + _weekNumberDay!) {
                          _width = _textSize(
                            'Monthly on the ' + _weekNumberDay!,
                          );
                          _monthlyWeek();
                        } else if (value == 'Last day of month') {
                          _width = _textSize('Last day of month');
                          _lastDayOfMonth();
                        }
                      });
                    },
                  ),
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
          Visibility(
            visible: _selectedRecurrenceType == 'year',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  focusColor: widget.model.primaryColor,
                  activeColor: widget.model.primaryColor,
                  value: _isLastDay,
                  onChanged: (bool? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _isLastDay = value;
                      _lastDayOfMonth();
                    });
                  },
                ),
                const Text('Last day of month'),
              ],
            ),
          ),
          if (_selectedRecurrenceType == 'year') const Divider(thickness: 1),
          RadioGroup<_EndRule>(
            groupValue: _endRule,
            onChanged: (_EndRule? value) {
              if (value != null) {
                setState(() {
                  switch (value) {
                    case _EndRule.never:
                      {
                        _neverEndRule();
                        break;
                      }
                    case _EndRule.endDate:
                      {
                        _endDateEndRule(value);
                        break;
                      }
                    case _EndRule.count:
                      {
                        _countEndRule(value);
                        break;
                      }
                  }
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Text('ENDS'),
                ),
                RadioListTile<_EndRule>(
                  contentPadding: const EdgeInsets.only(left: 7),
                  title: const Text('Never'),
                  value: _EndRule.never,
                  activeColor: widget.model.primaryColor,
                ),
                const Divider(indent: 50, height: 1.0, thickness: 1),
                RadioListTile<_EndRule>(
                  contentPadding: const EdgeInsets.only(left: 7),
                  title: Row(
                    children: <Widget>[
                      const Text('On'),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: ButtonTheme(
                          minWidth: 30.0,
                          child: MaterialButton(
                            elevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            disabledElevation: 0,
                            hoverElevation: 0,
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: _startDate.isBefore(_firstDate)
                                    ? _startDate
                                    : _firstDate,
                                currentDate: _selectedDate,
                                lastDate: DateTime(2050),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData(
                                      brightness: widget
                                          .model
                                          .themeData
                                          .colorScheme
                                          .brightness,
                                      colorScheme: getColorScheme(
                                        widget.model,
                                        true,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate == null) {
                                return;
                              }
                              setState(() {
                                _endRule = _EndRule.endDate;
                                _recurrenceProperties!.recurrenceRange =
                                    RecurrenceRange.endDate;
                                _selectedDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                );
                                _recurrenceProperties!.endDate = _selectedDate;
                              });
                            },
                            shape: const CircleBorder(),
                            child: Text(
                              DateFormat('MM/dd/yyyy').format(_selectedDate),
                              style: TextStyle(
                                fontSize: 13,
                                color: defaultTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: _EndRule.endDate,
                  activeColor: widget.model.primaryColor,
                ),
                const Divider(indent: 50, height: 1.0, thickness: 1),
                SizedBox(
                  height: 40,
                  child: RadioListTile<_EndRule>(
                    contentPadding: const EdgeInsets.only(left: 7),
                    title: Row(
                      children: <Widget>[
                        const Text('After'),
                        Container(
                          height: 40,
                          width: 60,
                          padding: const EdgeInsets.only(left: 5, bottom: 10),
                          margin: const EdgeInsets.only(left: 5),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextField(
                            readOnly: _endRule != _EndRule.count,
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: _count.toString(),
                                selection: TextSelection.collapsed(
                                  offset: _count.toString().length,
                                ),
                              ),
                            ),
                            cursorColor: widget.model.primaryColor,
                            onTap: () {
                              setState(() {
                                _endRule = _EndRule.count;
                              });
                            },
                            onChanged: (String value) async {
                              if (value != null && value.isNotEmpty) {
                                _count = int.parse(value);
                                if (_count == 0) {
                                  _count = 1;
                                } else if (_count! >= 999) {
                                  setState(() {
                                    _count = 999;
                                  });
                                }
                              } else if (value.isEmpty || value == null) {
                                _count = 1;
                              }
                              _endRule = _EndRule.count;
                              _recurrenceProperties!.recurrenceRange =
                                  RecurrenceRange.count;
                              _recurrenceProperties!.recurrenceCount = _count!;
                            },
                            keyboardType: TextInputType.number,
                            // ignore: always_specify_types
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 13,
                              color: defaultTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(width: 10),
                        const Text('occurrence'),
                      ],
                    ),
                    value: _EndRule.count,
                    activeColor: widget.model.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _countEndRule(_EndRule value) {
    _endRule = value;
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.count;
    _recurrenceProperties!.recurrenceCount = _count!;
  }

  void _endDateEndRule(_EndRule value) {
    _endRule = value;
    _rangeEndDate();
  }

  void _neverEndRule() {
    _endRule = _EndRule.never;
    _rangeNoEndDate();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: Scaffold(
        backgroundColor:
            widget.model.themeData != null &&
                widget.model.themeData.colorScheme.brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        appBar: AppBar(
          title: const Text('Custom Recurrence'),
          backgroundColor: widget.appointmentColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, widget.recurrenceProperties);
            },
          ),
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              icon: const Icon(Icons.done, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, _recurrenceProperties);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Stack(
            children: <Widget>[
              _getCustomRule(
                context,
                (widget.model.themeData.colorScheme.brightness ==
                        Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white)!,
                widget.model.themeData.colorScheme.brightness != null &&
                        widget.model.themeData.colorScheme.brightness ==
                            Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool canAddRecurrenceAppointment(
  List<DateTime> visibleDates,
  CalendarDataSource dataSource,
  Appointment occurrenceAppointment,
  DateTime startTime,
) {
  final Appointment parentAppointment =
      dataSource.getPatternAppointment(occurrenceAppointment, '')!
          as Appointment;
  final List<DateTime> recurrenceDates =
      SfCalendar.getRecurrenceDateTimeCollection(
        parentAppointment.recurrenceRule ?? '',
        parentAppointment.startTime,
        specificStartDate: visibleDates[0],
        specificEndDate: visibleDates[visibleDates.length - 1],
      );
  for (int i = 0; i < dataSource.appointments!.length; i++) {
    final Appointment calendarApp = dataSource.appointments![i] as Appointment;
    if (calendarApp.recurrenceId != null &&
        calendarApp.recurrenceId == parentAppointment.id) {
      recurrenceDates.add(calendarApp.startTime);
    }
  }
  if (parentAppointment.recurrenceExceptionDates != null) {
    for (
      int i = 0;
      i < parentAppointment.recurrenceExceptionDates!.length;
      i++
    ) {
      recurrenceDates.remove(parentAppointment.recurrenceExceptionDates![i]);
    }
  }
  recurrenceDates.sort();
  bool canAddRecurrence = isSameDate(
    occurrenceAppointment.startTime,
    startTime,
  );
  if (!_isDateInDateCollection(recurrenceDates, startTime)) {
    final int currentRecurrenceIndex = recurrenceDates.indexOf(
      occurrenceAppointment.startTime,
    );
    if (currentRecurrenceIndex == 0 ||
        currentRecurrenceIndex == recurrenceDates.length - 1) {
      canAddRecurrence = true;
    } else if (currentRecurrenceIndex < 0) {
      canAddRecurrence = false;
    } else {
      final DateTime previousRecurrence =
          recurrenceDates[currentRecurrenceIndex - 1];
      final DateTime nextRecurrence =
          recurrenceDates[currentRecurrenceIndex + 1];
      canAddRecurrence =
          (isDateWithInDateRange(
                previousRecurrence,
                nextRecurrence,
                startTime,
              ) &&
              !isSameDate(previousRecurrence, startTime) &&
              !isSameDate(nextRecurrence, startTime)) ||
          canAddRecurrence;
    }
  }

  return canAddRecurrence;
}

bool _isDateInDateCollection(List<DateTime>? dates, DateTime date) {
  if (dates == null || dates.isEmpty) {
    return false;
  }
  for (final DateTime currentDate in dates) {
    if (isSameDate(currentDate, date)) {
      return true;
    }
  }
  return false;
}
