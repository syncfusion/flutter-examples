///Dart imports
import 'dart:core';
import 'dart:math';

///Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

///Local import
import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'getting_started.dart';

/// Render the widget of appointment editor calendar
class CalendarAppointmentEditor extends SampleView {
  /// creates the appointment editor
  const CalendarAppointmentEditor(Key key) : super(key: key);

  @override
  _CalendarAppointmentEditorState createState() =>
      _CalendarAppointmentEditorState();
}

/// Dropdown list items for recurrenceType
List<String> _repeatOption = <String>[
  'Never',
  'Daily',
  'Weekly',
  'Monthly',
  'Yearly'
];

/// Dropdown list items for day of week
List<String> _weekDay = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

/// Dropdown list items for end range
List<String> _ends = <String>[
  'Never',
  'Until',
  'Count',
];

/// Dropdown list items for months of year
List<String> _dayMonths = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

/// Dropdown list items for week number of the month.
List<String> _daysPosition = <String>[
  'First',
  'Second',
  'Third',
  'Fourth',
  'Last'
];

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
    CalendarView.schedule
  ];

  final ScrollController controller = ScrollController();
  final CalendarController calendarController = CalendarController();

  /// Global key used to maintain the state,
  /// when we change the parent of the widget
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
    //// Extra small devices (phones, 600px and down)
//// @media only screen and (max-width: 600px) {...}
////
//// Small devices (portrait tablets and large phones, 600px and up)
//// @media only screen and (min-width: 600px) {...}
////
//// Medium devices (landscape tablets, 768px and up)
//// media only screen and (min-width: 768px) {...}
////
//// Large devices (laptops/desktops, 992px and up)
//// media only screen and (min-width: 992px) {...}
////
//// Extra large devices (large laptops and desktops, 1200px and up)
//// media only screen and (min-width: 1200px) {...}
//// Default width to render the mobile UI in web, if the device width exceeds
//// the given width agenda view will render the web UI.
    _isMobile = MediaQuery.of(context).size.width < 767;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(
            colorScheme: model.themeData.colorScheme
                .copyWith(secondary: model.backgroundColor)),
        child: _getAppointmentEditorCalendar(calendarController, _events,
            _onCalendarTapped, _onViewChanged, scheduleViewBuilder));
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: calendarController.view == CalendarView.month &&
              model.isWebFullView &&
              screenHeight < 800
          ? Scrollbar(
              thumbVisibility: true,
              controller: controller,
              child: ListView(
                controller: controller,
                children: <Widget>[
                  Container(
                    color: model.cardThemeColor,
                    height: 600,
                    child: calendar,
                  )
                ],
              ))
          : Container(color: model.cardThemeColor, child: calendar),
    );
  }

  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view.
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

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  /// Navigates to appointment editor page when the calendar elements tapped
  /// other than the header, handled the editor fields based on tapped element.
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    _selectedAppointment = null;

    /// Navigates the calendar to day view,
    /// when we tap on month cells in mobile.
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
              /// calendar element, when the editor is opened.
              if (_selectedAppointment == null) {
                _isAllDay = calendarTapDetails.targetElement ==
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

                SchedulerBinding.instance
                    .addPostFrameCallback((Duration duration) {
                  _events.notifyListeners(
                      CalendarDataSourceAction.add, appointment);
                });

                _selectedAppointment = newAppointment;
              }

              return WillPopScope(
                onWillPop: () async {
                  if (newAppointment != null) {
                    /// To remove the created appointment when the pop-up closed
                    /// without saving the appointment.
                    _events.appointments
                        .removeAt(_events.appointments.indexOf(newAppointment));
                    _events.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[newAppointment]);
                  }
                  return true;
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
                              color: model.themeData != null &&
                                      model.themeData.colorScheme.brightness ==
                                          Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
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
                                      _visibleDates)
                                  : PopUpAppointmentEditor(
                                      model,
                                      newAppointment,
                                      appointment,
                                      _events,
                                      _colorCollection,
                                      _colorNames,
                                      _selectedAppointment!,
                                      _timeZoneCollection,
                                      _visibleDates),
                            )))),
              );
            });
      } else {
        /// Navigates to the appointment editor page on mobile
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
                  _timeZoneCollection)),
        );
      }
    }
  }

  /// Creates the required appointment details as a list, and created the data
  /// source for calendar with required information.
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
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          appointmentCollection.add(Appointment(
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
          ));
        }
      }
    }

    return appointmentCollection;
  }

  /// Returns the calendar based on the properties passed.
  SfCalendar _getAppointmentEditorCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      dynamic calendarTapCallback,
      ViewChangedCallback? viewChangedCallback,
      dynamic scheduleViewBuilder]) {
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
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }
}

/// Signature for callback which reports the picker value changed
typedef _PickerChanged = void Function(
    _PickerChangedDetails pickerChangedDetails);

/// Details for the [_PickerChanged].
class _PickerChangedDetails {
  _PickerChangedDetails(
      {this.index = -1,
      this.resourceId,
      this.selectedRule = _SelectRule.doesNotRepeat});

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
        selectedAppointment.startTime, selectedAppointment.endTime)) {
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
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat(endFormat).format(selectedAppointment.endTime);
  } else {
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('hh:mm a').format(selectedAppointment.endTime);
  }
}

/// To edit the series which has the exception appointments, and allows
/// to edit and cancel the edit series action.
Widget _editExceptionSeries(
    BuildContext context,
    SampleModel model,
    Appointment selectedAppointment,
    Appointment recurrenceAppointment,
    CalendarDataSource events) {
  final Color defaultColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;

  final Color defaultTextColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  return Dialog(
    child: Container(
      width: 400,
      height: 200,
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        Container(
          width: 360,
          height: 50,
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Text(
                    'Alert',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: defaultTextColor),
                  )),
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
            height: 80,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
                'Do you want to cancel the changes made to specific instances of this series and match it to the whole series again?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: defaultTextColor))),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RawMaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              fillColor: model.backgroundColor,
              onPressed: () {
                Navigator.pop(context);
                final List<DateTime>? exceptionDates =
                    selectedAppointment.recurrenceExceptionDates;
                for (int i = 0; i < exceptionDates!.length; i++) {
                  final Appointment? changedOccurrence =
                      events.getOccurrenceAppointment(
                          selectedAppointment, exceptionDates[i], '');
                  if (changedOccurrence != null) {
                    events.appointments!.removeAt(
                        events.appointments!.indexOf(changedOccurrence));
                    events.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[changedOccurrence]);
                  }
                }
                events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment));
                events.notifyListeners(CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment]);
                events.appointments!.add(recurrenceAppointment);
                events.notifyListeners(CalendarDataSourceAction.add,
                    <Appointment>[recurrenceAppointment]);
                Navigator.pop(context);
              },
              child: const Text(
                'YES',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 20,
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
                recurrenceAppointment.recurrenceExceptionDates =
                    selectedAppointment.recurrenceExceptionDates;
                recurrenceAppointment.recurrenceRule =
                    selectedAppointment.recurrenceRule;
                events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment));
                events.notifyListeners(CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment]);
                events.appointments!.add(recurrenceAppointment);
                events.notifyListeners(CalendarDataSourceAction.add,
                    <Appointment>[recurrenceAppointment]);
                Navigator.pop(context);
              },
              child: Text(
                'NO',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: defaultTextColor),
              ),
            ),
            Container(
              width: 20,
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: defaultTextColor),
              ),
            ),
            Container(
              width: 20,
            ),
          ],
        ),
      ]),
    ),
  );
}

/// Allows to delete the single appointment from a series and
/// delete the entire series.
Widget _deleteRecurrence(BuildContext context, SampleModel model,
    Appointment selectedAppointment, CalendarDataSource events) {
  final Color defaultColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;

  final Color defaultTextColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  return Dialog(
      child: Container(
    width: 400,
    height: 170,
    padding: const EdgeInsets.only(left: 20, top: 10),
    child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                      color: defaultTextColor),
                )),
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
                  color: defaultTextColor))),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: RawMaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              fillColor: model.backgroundColor,
              onPressed: () {
                if (selectedAppointment.recurrenceId != null) {
                  events.appointments!.remove(selectedAppointment);
                  events.notifyListeners(CalendarDataSourceAction.remove,
                      <Appointment>[selectedAppointment]);
                }
                final Appointment? parentAppointment =
                    events.getPatternAppointment(selectedAppointment, '')
                        as Appointment?;
                events.appointments!
                    .removeAt(events.appointments!.indexOf(parentAppointment));
                events.notifyListeners(CalendarDataSourceAction.remove,
                    <Appointment>[parentAppointment!]);
                parentAppointment.recurrenceExceptionDates != null
                    ? parentAppointment.recurrenceExceptionDates!
                        .add(selectedAppointment.startTime)
                    : parentAppointment.recurrenceExceptionDates = <DateTime>[
                        selectedAppointment.startTime
                      ];
                events.appointments!.add(parentAppointment);
                events.notifyListeners(CalendarDataSourceAction.add,
                    <Appointment>[parentAppointment]);
                Navigator.pop(context);
              },
              child: const Text(
                'DELETE EVENT',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            width: 20,
          ),
          SizedBox(
            width: 110,
            child: RawMaterialButton(
              onPressed: () {
                final Appointment? parentAppointment =
                    events.getPatternAppointment(selectedAppointment, '')
                        as Appointment?;
                if (parentAppointment!.recurrenceExceptionDates == null) {
                  events.appointments!.removeAt(
                      events.appointments!.indexOf(parentAppointment));
                  events.notifyListeners(CalendarDataSourceAction.remove,
                      <Appointment>[parentAppointment]);
                } else {
                  final List<DateTime>? exceptionDates =
                      parentAppointment.recurrenceExceptionDates;
                  for (int i = 0; i < exceptionDates!.length; i++) {
                    final Appointment? changedOccurrence =
                        events.getOccurrenceAppointment(
                            parentAppointment, exceptionDates[i], '');
                    if (changedOccurrence != null) {
                      events.appointments!.remove(changedOccurrence);
                      events.notifyListeners(CalendarDataSourceAction.remove,
                          <Appointment>[changedOccurrence]);
                    }
                  }
                  events.appointments!.removeAt(
                      events.appointments!.indexOf(parentAppointment));
                  events.notifyListeners(CalendarDataSourceAction.remove,
                      <Appointment>[parentAppointment]);
                }
                Navigator.pop(context);
              },
              child: Text(
                'ENTIRE SERIES',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: defaultTextColor),
              ),
            ),
          ),
          Container(
            width: 20,
          ),
        ],
      ),
    ]),
  ));
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
    List<DateTime> visibleDates) {
  final Color defaultColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;

  final Color defaultTextColor = model.themeData != null &&
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
    child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                      color: defaultTextColor),
                )),
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
                  color: defaultTextColor))),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RawMaterialButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            fillColor: model.backgroundColor,
            onPressed: () {
              selectedAppointment.recurrenceId = parentAppointment!.id;
              selectedAppointment.id = selectedAppointment.appointmentType ==
                      AppointmentType.changedOccurrence
                  ? selectedAppointment.id
                  : null;
              selectedAppointment.recurrenceRule = null;
              Navigator.pop(context);
              showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                        onWillPop: () async {
                          return true;
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
                              visibleDates),
                        ));
                  });
            },
            child: const Text(
              'EDIT EVENT',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: 20,
          ),
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
                    return WillPopScope(
                        onWillPop: () async {
                          return true;
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
                        ));
                  });
            },
            child: Text(
              'ENTIRE SERIES',
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: defaultTextColor),
            ),
          ),
          Container(
            width: 20,
          ),
        ],
      ),
    ]),
  ));
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
    List<DateTime> visibleDates) {
  final Color defaultColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black54;

  final Color defaultTextColor = model.themeData != null &&
          model.themeData.colorScheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  final List<Appointment> appointmentCollection = <Appointment>[];

  return ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                  return WillPopScope(
                      onWillPop: () async {
                        return true;
                      },
                      child: Theme(
                        data: model.themeData,
                        child: selectedAppointment.appointmentType ==
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
                                visibleDates),
                      ));
                });
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: defaultColor),
          splashRadius: 20,
          onPressed: () {
            if (selectedAppointment.appointmentType == AppointmentType.normal) {
              Navigator.pop(context);
              events.appointments!
                  .removeAt(events.appointments!.indexOf(selectedAppointment));
              events.notifyListeners(CalendarDataSourceAction.remove,
                  <Appointment>[selectedAppointment]);
            } else {
              Navigator.pop(context);
              showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                        onWillPop: () async {
                          return true;
                        },
                        child: Theme(
                          data: model.themeData,
                          child: _deleteRecurrence(
                              context, model, selectedAppointment, events),
                        ));
                  });
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
    )),
    ListTile(
        leading: Icon(
          Icons.lens,
          color: selectedAppointment.color,
          size: 20,
        ),
        title: Text(
            selectedAppointment.subject.isNotEmpty
                ? selectedAppointment.subject
                : '(No Text)',
            style: TextStyle(
                fontSize: 20,
                color: defaultTextColor,
                fontWeight: FontWeight.w400)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            _getAppointmentTimeText(selectedAppointment),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400),
          ),
        )),
    if (selectedAppointment.resourceIds == null ||
        selectedAppointment.resourceIds!.isEmpty)
      Container()
    else
      ListTile(
        leading: Icon(
          Icons.people,
          size: 20,
          color: defaultColor,
        ),
        title: Text(
            _getSelectedResourceText(
                selectedAppointment.resourceIds!, events.resources!),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400)),
      ),
    if (selectedAppointment.location == null ||
        selectedAppointment.location!.isEmpty)
      Container()
    else
      ListTile(
        leading: Icon(
          Icons.location_on,
          size: 20,
          color: defaultColor,
        ),
        title: Text(selectedAppointment.location ?? '',
            style: TextStyle(
                fontSize: 15,
                color: defaultColor,
                fontWeight: FontWeight.w400)),
      )
  ]);
}

/// Returns the selected resource display name based on the ids passed.
String _getSelectedResourceText(
    List<Object> resourceIds, List<CalendarResource> resourceCollection) {
  String? resourceNames;
  for (int i = 0; i < resourceIds.length; i++) {
    final String name = resourceCollection
        .firstWhere(
            (CalendarResource resource) => resource.id == resourceIds[i])
        .displayName;
    resourceNames = resourceNames == null ? name : resourceNames + ', ' + name;
  }

  return resourceNames!;
}

/// The color picker element for the appointment editor with the available
/// color collection, and returns the selection color index
class _CalendarColorPicker extends StatefulWidget {
  const _CalendarColorPicker(this.colorCollection, this.selectedColorIndex,
      this.colorNames, this.model,
      {required this.onChanged});

  final List<Color> colorCollection;

  final int selectedColorIndex;

  final List<String> colorNames;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => _CalendarColorPickerState();
}

class _CalendarColorPickerState extends State<_CalendarColorPicker> {
  int _selectedColorIndex = -1;

  @override
  void initState() {
    _selectedColorIndex = widget.selectedColorIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarColorPicker oldWidget) {
    _selectedColorIndex = widget.selectedColorIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: AlertDialog(
        content: SizedBox(
            width: kIsWeb || widget.model.isWindows || widget.model.isMacOS
                ? 500
                : double.maxFinite,
            height: (widget.colorCollection.length * 50).toDouble(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.colorCollection.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 50,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Icon(
                          index == _selectedColorIndex
                              ? Icons.lens
                              : Icons.trip_origin,
                          color: widget.colorCollection[index]),
                      title: Text(widget.colorNames[index]),
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                          widget.onChanged(_PickerChangedDetails(index: index));
                        });

                        // ignore: always_specify_types
                        Future.delayed(const Duration(milliseconds: 200), () {
                          // When task is over, close the dialog
                          Navigator.pop(context);
                        });
                      },
                    ));
              },
            )),
      ),
    );
  }
}

/// Picker to display the available resource collection, and returns the
/// selected resource id.
class _ResourcePicker extends StatefulWidget {
  const _ResourcePicker(this.resourceCollection, this.model,
      {required this.onChanged});

  final List<CalendarResource> resourceCollection;

  final _PickerChanged onChanged;

  final SampleModel model;

  @override
  State<StatefulWidget> createState() => _ResourcePickerState();
}

class _ResourcePickerState extends State<_ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.model.themeData,
        child: AlertDialog(
          content: SizedBox(
              width: kIsWeb ? 500 : double.maxFinite,
              height: (widget.resourceCollection.length * 50).toDouble(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.resourceCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  final CalendarResource resource =
                      widget.resourceCollection[index];
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          backgroundColor: widget.model.backgroundColor,
                          backgroundImage: resource.image,
                          child: resource.image == null
                              ? Text(resource.displayName[0])
                              : null,
                        ),
                        title: Text(resource.displayName),
                        onTap: () {
                          setState(() {
                            widget.onChanged(
                                _PickerChangedDetails(resourceId: resource.id));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

///  The time zone picker element for the appointment editor with the available
///  time zone collection, and returns the selection time zone index
class _CalendarTimeZonePicker extends StatefulWidget {
  const _CalendarTimeZonePicker(this.backgroundColor, this.timeZoneCollection,
      this.selectedTimeZoneIndex, this.model,
      {required this.onChanged});

  final Color backgroundColor;

  final List<String> timeZoneCollection;

  final int selectedTimeZoneIndex;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() {
    return _CalendarTimeZonePickerState();
  }
}

class _CalendarTimeZonePickerState extends State<_CalendarTimeZonePicker> {
  int _selectedTimeZoneIndex = -1;

  @override
  void initState() {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarTimeZonePicker oldWidget) {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.model.themeData,
        child: AlertDialog(
          content: SizedBox(
              width: kIsWeb ? 500 : double.maxFinite,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.timeZoneCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: Icon(
                          index == _selectedTimeZoneIndex
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: widget.backgroundColor,
                        ),
                        title: Text(widget.timeZoneCollection[index]),
                        onTap: () {
                          setState(() {
                            _selectedTimeZoneIndex = index;
                            widget
                                .onChanged(_PickerChangedDetails(index: index));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

/// Builds the appointment editor with minimal elements in a pop-up based on the
/// tapped calendar element.
class PopUpAppointmentEditor extends StatefulWidget {
  /// Holds the data of appointment editor
  const PopUpAppointmentEditor(
      this.model,
      this.newAppointment,
      this.appointment,
      this.events,
      this.colorCollection,
      this.colorNames,
      this.selectedAppointment,
      this.timeZoneCollection,
      this.visibleDates);

  /// Model of appointment editor
  final SampleModel model;

  /// new appointment value
  final Appointment? newAppointment;

  /// List of appointments
  final List<Appointment> appointment;

  /// Holds the events value
  final CalendarDataSource events;

  /// Holds list of colors
  final List<Color> colorCollection;

  /// holds the names of colors
  final List<String> colorNames;

  /// Selected appointment value
  final Appointment selectedAppointment;

  /// Collection list of time zones
  final List<String> timeZoneCollection;

  /// The current visible dates collection
  final List<DateTime> visibleDates;

  @override
  _PopUpAppointmentEditorState createState() => _PopUpAppointmentEditorState();
}

class _PopUpAppointmentEditorState extends State<PopUpAppointmentEditor> {
  int _selectedColorIndex = 0;
  int _selectedTimeZoneIndex = 0;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  String _subject = '';
  String? _notes;
  String? _location;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(PopUpAppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment.startTime;
    _endDate = widget.selectedAppointment.endTime;
    _isAllDay = widget.selectedAppointment.isAllDay;
    _selectedColorIndex =
        widget.colorCollection.indexOf(widget.selectedAppointment.color);
    _selectedTimeZoneIndex = widget.selectedAppointment.startTimeZone == null ||
            widget.selectedAppointment.startTimeZone == ''
        ? 0
        : widget.timeZoneCollection
            .indexOf(widget.selectedAppointment.startTimeZone!);
    _subject = widget.selectedAppointment.subject == '(No title)'
        ? ''
        : widget.selectedAppointment.subject;
    _notes = widget.selectedAppointment.notes;
    _location = widget.selectedAppointment.location;

    _selectedColorIndex = _selectedColorIndex == -1 ? 0 : _selectedColorIndex;
    _selectedTimeZoneIndex =
        _selectedTimeZoneIndex == -1 ? 0 : _selectedTimeZoneIndex;
    _resourceIds = widget.selectedAppointment.resourceIds?.sublist(0);

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Color defaultTextColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    final Widget startDatePicker = RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onPressed: () async {
        final DateTime? date = await showDatePicker(
            context: context,
            initialDate: _startDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based
                ///  on the selected theme and primary color.
                data: ThemeData(
                  brightness: widget.model.themeData.colorScheme.brightness,
                  colorScheme: _getColorScheme(widget.model, true),
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(date.year, date.month, date.day,
                _startTime.hour, _startTime.minute);
            _endDate = _startDate.add(difference);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          });
        }
      },
      child: Text(DateFormat('MMM dd, yyyy').format(_startDate),
          style:
              TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
          textAlign: TextAlign.left),
    );

    final Widget startTimePicker = RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onPressed: () async {
        final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
            builder: (BuildContext context, Widget? child) {
              /// Theme widget used to apply the theme and primary color to the
              /// time picker.
              return Theme(
                /// The themedata created based
                /// on the selected theme and primary color.
                data: ThemeData(
                  brightness: widget.model.themeData.colorScheme.brightness,
                  colorScheme: _getColorScheme(widget.model, false),
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (time != null && time != _startTime) {
          setState(() {
            _startTime = time;
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(_startDate.year, _startDate.month,
                _startDate.day, _startTime.hour, _startTime.minute);
            _endDate = _startDate.add(difference);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          });
        }
      },
      child: Text(
        DateFormat('hh:mm a').format(_startDate),
        style: TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
        textAlign: TextAlign.left,
      ),
    );

    final Widget endTimePicker = RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onPressed: () async {
        final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
            builder: (BuildContext context, Widget? child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based
                /// on the selected theme and primary color.
                data: ThemeData(
                  brightness: widget.model.themeData.colorScheme.brightness,
                  colorScheme: _getColorScheme(widget.model, false),
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (time != null && time != _endTime) {
          setState(() {
            _endTime = time;
            final Duration difference = _endDate.difference(_startDate);
            _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day,
                _endTime.hour, _endTime.minute);
            if (_endDate.isBefore(_startDate)) {
              _startDate = _endDate.subtract(difference);
              _startTime =
                  TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            }
          });
        }
      },
      child: Text(
        DateFormat('hh:mm a').format(_endDate),
        style: TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
        textAlign: TextAlign.left,
      ),
    );

    final Widget endDatePicker = RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onPressed: () async {
        final DateTime? date = await showDatePicker(
            context: context,
            initialDate: _endDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              /// Theme widget used to apply the theme and primary color to the
              /// date picker.
              return Theme(
                /// The themedata created based
                /// on the selected theme and primary color.
                data: ThemeData(
                  brightness: widget.model.themeData.colorScheme.brightness,
                  colorScheme: _getColorScheme(widget.model, true),
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _endDate = DateTime(date.year, date.month, date.day, _endTime.hour,
                _endTime.minute);
            if (_endDate.isBefore(_startDate)) {
              _startDate = _endDate.subtract(difference);
              _startTime =
                  TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            }
          });
        }
      },
      child: Text(DateFormat('MMM dd, yyyy').format(_endDate),
          style:
              TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
          textAlign: TextAlign.left),
    );

    return ListView(padding: EdgeInsets.zero, children: <Widget>[
      SizedBox(
          height: 50,
          child: ListTile(
            trailing: IconButton(
              icon: Icon(Icons.close, color: defaultColor),
              splashRadius: 20,
              onPressed: () {
                if (widget.newAppointment != null &&
                    widget.events.appointments!
                        .contains(widget.newAppointment)) {
                  /// To remove the created appointment, when the appointment editor
                  /// closed without saving the appointment.
                  widget.events.appointments!.removeAt(widget
                      .events.appointments!
                      .indexOf(widget.newAppointment));
                  widget.events.notifyListeners(CalendarDataSourceAction.remove,
                      <Appointment>[widget.newAppointment!]);
                }

                Navigator.pop(context);
              },
            ),
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: const Text(''),
            title: TextField(
              autofocus: true,
              cursorColor: widget.model.backgroundColor,
              controller: TextEditingController(text: _subject),
              onChanged: (String value) {
                _subject = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                  fontSize: 20,
                  color: defaultTextColor,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                focusColor: widget.model.backgroundColor,
                border: const UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.model.backgroundColor, width: 2.0)),
                hintText: 'Add title and time',
              ),
            ),
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.access_time,
                  size: 20,
                  color: defaultColor,
                )),
            title: _isAllDay
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        startDatePicker,
                        const Text(' - '),
                        endDatePicker,
                        const Text(''),
                        const Text(''),
                      ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        startDatePicker,
                        startTimePicker,
                        const Text(' - '),
                        endTimePicker,
                        endDatePicker,
                      ]),
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.location_on,
                  color: defaultColor,
                  size: 20,
                )),
            title: TextField(
              cursorColor: widget.model.backgroundColor,
              controller: TextEditingController(text: _location),
              onChanged: (String value) {
                _location = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
              ),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add location',
              ),
            ),
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.subject,
                  size: 20,
                  color: defaultColor,
                )),
            title: TextField(
              controller: TextEditingController(text: _notes),
              onChanged: (String value) {
                _notes = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: widget.model.isWebFullView ? 1 : null,
              style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
              ),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add description',
              ),
            ),
          )),
      if (widget.events.resources == null || widget.events.resources!.isEmpty)
        Container()
      else
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 50,
            child: ListTile(
              leading: Container(
                  width: 30,
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.people,
                    color: defaultColor,
                    size: 20,
                  )),
              title: RawMaterialButton(
                padding: const EdgeInsets.only(left: 5),
                onPressed: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return _ResourcePicker(
                        _unSelectedResources,
                        widget.model,
                        onChanged: (_PickerChangedDetails details) {
                          _resourceIds = _resourceIds == null
                              ? <Object>[details.resourceId!]
                              : (_resourceIds!.sublist(0)
                                ..add(details.resourceId!));
                          _selectedResources = _getSelectedResources(
                              _resourceIds, widget.events.resources);
                          _unSelectedResources = _getUnSelectedResources(
                              _selectedResources, widget.events.resources);
                        },
                      );
                    },
                  ).then((dynamic value) => setState(() {
                        /// update the color picker changes
                      }));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: _getResourceEditor(TextStyle(
                      fontSize: 15,
                      color: defaultColor,
                      fontWeight: FontWeight.w300)),
                ),
              ),
            )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(Icons.lens,
                    size: 20,
                    color: widget.colorCollection[_selectedColorIndex])),
            title: RawMaterialButton(
              padding: const EdgeInsets.only(left: 5),
              onPressed: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CalendarColorPicker(
                      widget.colorCollection,
                      _selectedColorIndex,
                      widget.colorNames,
                      widget.model,
                      onChanged: (_PickerChangedDetails details) {
                        _selectedColorIndex = details.index;
                      },
                    );
                  },
                ).then((dynamic value) => setState(() {
                      /// update the color picker changes
                    }));
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.colorNames[_selectedColorIndex],
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: defaultTextColor),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          )),
      SizedBox(
          height: 50,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog<Widget>(
                            context: context,
                            builder: (BuildContext context) {
                              final Appointment selectedApp = Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
                                startTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                endTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                notes: _notes,
                                isAllDay: _isAllDay,
                                location: _location,
                                subject:
                                    _subject == '' ? '(No title)' : _subject,
                                resourceIds: _resourceIds,
                              );
                              return WillPopScope(
                                onWillPop: () async {
                                  if (widget.newAppointment != null) {
                                    widget.events.appointments!.removeAt(widget
                                        .events.appointments!
                                        .indexOf(widget.newAppointment));
                                    widget.events.notifyListeners(
                                        CalendarDataSourceAction.remove,
                                        <Appointment>[widget.newAppointment!]);
                                  }
                                  return true;
                                },
                                child: AppointmentEditorWeb(
                                  widget.model,
                                  selectedApp,
                                  widget.colorCollection,
                                  widget.colorNames,
                                  widget.events,
                                  widget.timeZoneCollection,
                                  widget.appointment,
                                  widget.visibleDates,
                                  widget.newAppointment,
                                ),
                              );
                            });
                      },
                      child: Text(
                        'MORE OPTIONS',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RawMaterialButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    fillColor: widget.model.backgroundColor,
                    onPressed: () {
                      if (widget.selectedAppointment != null ||
                          widget.newAppointment != null) {
                        if (widget.events.appointments!.isNotEmpty &&
                            widget.events.appointments!
                                .contains(widget.selectedAppointment)) {
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(widget.selectedAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[widget.selectedAppointment]);
                        }
                        if (widget.appointment.isNotEmpty &&
                            widget.appointment
                                .contains(widget.newAppointment)) {
                          widget.appointment.removeAt(widget.appointment
                              .indexOf(widget.newAppointment!));
                        }
                      }

                      widget.appointment.add(Appointment(
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
                        location: _location,
                        subject: _subject == '' ? '(No title)' : _subject,
                        resourceIds: _resourceIds,
                      ));

                      widget.events.appointments!.add(widget.appointment[0]);

                      widget.events.notifyListeners(
                          CalendarDataSourceAction.add, widget.appointment);

                      Navigator.pop(context);
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ]);
  }

  /// Return the resource editor to edit the resource collection for an
  /// appointment
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources == null || _selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: widget.model.backgroundColor,
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds!.removeAt(i);
          _unSelectedResources = _getUnSelectedResources(
              _selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }
}

/// Builds the appointment editor with all the required elements in a pop-up
/// based on the tapped calendar element.
class AppointmentEditorWeb extends StatefulWidget {
  /// Holds the information of appointments
  const AppointmentEditorWeb(
      this.model,
      this.selectedAppointment,
      this.colorCollection,
      this.colorNames,
      this.events,
      this.timeZoneCollection,
      this.appointment,
      this.visibleDates,
      [this.newAppointment]);

  /// Current sample model
  final SampleModel model;

  /// new appointment value
  final Appointment? newAppointment;

  /// List of appointments
  final List<Appointment> appointment;

  /// Selected appointment value
  final Appointment selectedAppointment;

  /// List of colors
  final List<Color> colorCollection;

  /// Collection of color names
  final List<String> colorNames;

  /// Holds the Events values
  final CalendarDataSource events;

  /// Collection of time zones
  final List<String> timeZoneCollection;

  /// The visible dates collection
  final List<DateTime> visibleDates;

  @override
  _AppointmentEditorWebState createState() => _AppointmentEditorWebState();
}

class _AppointmentEditorWebState extends State<AppointmentEditorWeb> {
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
  bool _isTimeZoneEnabled = false;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];

  late String _selectedRecurrenceType, _selectedRecurrenceRange, _ruleType;
  int? _count, _interval, _month, _week, _lastDay;
  late int _dayOfWeek, _weekNumber, _dayOfMonth;
  late double _padding, _margin;
  late DateTime _selectedDate, _firstDate;
  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  late RecurrenceRange _recurrenceRange;
  List<WeekDays>? _days;
  IconData? _monthDayRadio, _weekDayRadio, _lastDayRadio;
  Color? _weekIconColor, _monthIconColor, _lastDayIconColor;
  String? _monthName, _weekNumberText, _dayOfWeekText;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(AppointmentEditorWeb oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment.startTime;
    _endDate = widget.selectedAppointment.endTime;
    _isAllDay = widget.selectedAppointment.isAllDay;
    _selectedColorIndex =
        widget.colorCollection.indexOf(widget.selectedAppointment.color);
    _selectedTimeZoneIndex = widget.selectedAppointment.startTimeZone == null ||
            widget.selectedAppointment.startTimeZone == ''
        ? 0
        : widget.timeZoneCollection
            .indexOf(widget.selectedAppointment.startTimeZone!);
    _subject = widget.selectedAppointment.subject == '(No title)'
        ? ''
        : widget.selectedAppointment.subject;
    _notes = widget.selectedAppointment.notes;
    _location = widget.selectedAppointment.location;

    _selectedColorIndex = _selectedColorIndex == -1 ? 0 : _selectedColorIndex;
    _selectedTimeZoneIndex =
        _selectedTimeZoneIndex == -1 ? 0 : _selectedTimeZoneIndex;
    _resourceIds = widget.selectedAppointment.resourceIds?.sublist(0);

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _isTimeZoneEnabled = widget.selectedAppointment.startTimeZone != null &&
        widget.selectedAppointment.startTimeZone!.isNotEmpty;
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
    _selectedDate = _startDate.add(const Duration(days: 30));
    _firstDate = _startDate;
    _month = _startDate.month;
    _monthName = _dayMonths[_month! - 1];
    _dayOfMonth = _startDate.day;
    _weekNumber = _getWeekNumber(_startDate);
    _weekNumberText = _daysPosition[_weekNumber == -1 ? 4 : _weekNumber - 1];
    _dayOfWeek = _startDate.weekday;
    _dayOfWeekText = _weekDay[_dayOfWeek - 1];
    if (_days == null) {
      _webInitialWeekdays(_startDate.weekday);
    }
    _recurrenceProperties = widget.selectedAppointment.recurrenceRule != null &&
            widget.selectedAppointment.recurrenceRule!.isNotEmpty
        ? SfCalendar.parseRRule(
            widget.selectedAppointment.recurrenceRule!, _startDate)
        : null;
    _recurrenceProperties == null
        ? _neverRule()
        : _updateWebRecurrenceProperties();
  }

  void _updateWebRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _week = _recurrenceProperties!.week;
    _weekNumber = _recurrenceProperties!.week == 0
        ? _weekNumber
        : _recurrenceProperties!.week;
    _lastDay = _recurrenceProperties!.dayOfMonth;
    if (_lastDay != -1) {
      _dayOfMonth = _recurrenceProperties!.dayOfMonth == 1
          ? _startDate.day
          : _recurrenceProperties!.dayOfMonth;
    }
    switch (_recurrenceType) {
      case RecurrenceType.daily:
        _dailyRule();
        break;
      case RecurrenceType.weekly:
        _days = _recurrenceProperties!.weekDays;
        _weeklyRule();
        break;
      case RecurrenceType.monthly:
        _monthlyRule();
        break;
      case RecurrenceType.yearly:
        _month = _recurrenceProperties!.month;
        _yearlyRule();
        break;
    }
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    switch (_recurrenceRange) {
      case RecurrenceRange.noEndDate:
        _noEndDateRange();
        break;
      case RecurrenceRange.endDate:
        final Appointment? parentAppointment =
            widget.events.getPatternAppointment(widget.selectedAppointment, '')
                as Appointment?;
        _firstDate = parentAppointment!.startTime;
        _endDateRange();
        break;
      case RecurrenceRange.count:
        _countRange();
        break;
    }
  }

  void _neverRule() {
    setState(() {
      _recurrenceProperties = null;
      _selectedRecurrenceType = 'Never';
      _selectedRecurrenceRange = 'Never';
      _padding = 0;
      _margin = 0;
      _ruleType = '';
    });
  }

  void _dailyRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.daily;
      _ruleType = 'Day(s)';
      _selectedRecurrenceType = 'Daily';
      _padding = 6;
      _margin = 0;
    });
  }

  void _weeklyRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.weekly;
      _selectedRecurrenceType = 'Weekly';
      _ruleType = 'Week(s)';
      _recurrenceProperties!.weekDays = _days!;
      _padding = 0;
      _margin = 6;
    });
  }

  void _monthlyRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthDayIcon();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        if (_lastDay != null && _lastDay == -1) {
          _monthLastDayIcon();
        } else if (_week != null && _week != 0) {
          _monthWeekIcon();
        } else {
          _monthDayIcon();
        }
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.monthly;
      _selectedRecurrenceType = 'Monthly';
      _ruleType = 'Month(s)';
      _padding = 0;
      _margin = 6;
    });
  }

  void _yearlyRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthDayIcon();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        _monthName = _dayMonths[_month! - 1];
        if (_lastDay != null && _lastDay == -1) {
          _monthLastDayIcon();
        } else if (_week != null && _week != 0) {
          _monthWeekIcon();
        } else {
          _monthDayIcon();
        }
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.yearly;
      _selectedRecurrenceType = 'Yearly';
      _ruleType = 'Year(s)';
      _recurrenceProperties!.month = _month!;
      _padding = 0;
      _margin = 6;
    });
  }

  void _noEndDateRange() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
    _selectedRecurrenceRange = 'Never';
  }

  void _endDateRange() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.endDate;
    _selectedDate = _recurrenceProperties!.endDate ??
        _startDate.add(const Duration(days: 30));
    _selectedRecurrenceRange = 'Until';
    _recurrenceProperties!.endDate = _selectedDate;
  }

  void _countRange() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.count;
    _count = _recurrenceProperties!.recurrenceCount == 0
        ? 10
        : _recurrenceProperties!.recurrenceCount;
    _selectedRecurrenceRange = 'Count';
    _recurrenceProperties!.recurrenceCount = _count!;
  }

  void _addInterval() {
    setState(() {
      if (_interval! >= 999) {
        _interval = 999;
      } else {
        _interval = _interval! + 1;
      }
      _recurrenceProperties!.interval = _interval!;
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

  void _removeInterval() {
    setState(() {
      if (_interval! > 1) {
        _interval = _interval! - 1;
      }
      _recurrenceProperties!.interval = _interval!;
    });
  }

  void _monthWeekIcon() {
    setState(() {
      _weekNumberText = _daysPosition[_weekNumber == -1 ? 4 : _weekNumber - 1];
      _dayOfWeekText = _weekDay[_dayOfWeek - 1];
      _recurrenceProperties!.week = _weekNumber;
      _recurrenceProperties!.dayOfWeek = _dayOfWeek;
      _monthIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _weekIconColor = widget.model.backgroundColor;
      _lastDayRadio = Icons.radio_button_unchecked;
      _monthDayRadio = Icons.radio_button_unchecked;
      _weekDayRadio = Icons.radio_button_checked;
    });
  }

  void _monthDayIcon() {
    setState(() {
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = _dayOfMonth;
      _weekIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _monthIconColor = widget.model.backgroundColor;
      _monthDayRadio = Icons.radio_button_checked;
      _weekDayRadio = Icons.radio_button_unchecked;
      _lastDayRadio = Icons.radio_button_unchecked;
    });
  }

  void _monthLastDayIcon() {
    setState(() {
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = -1;
      _monthIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _weekIconColor = widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor = widget.model.backgroundColor;
      _lastDayRadio = Icons.radio_button_checked;
      _monthDayRadio = Icons.radio_button_unchecked;
      _weekDayRadio = Icons.radio_button_unchecked;
    });
  }

  void _addDay() {
    setState(() {
      if (_dayOfMonth < 31) {
        _dayOfMonth = _dayOfMonth + 1;
      }
      _monthDayIcon();
    });
  }

  void _removeDay() {
    setState(() {
      if (_dayOfMonth > 1) {
        _dayOfMonth = _dayOfMonth - 1;
      }
      _monthDayIcon();
    });
  }

  void _addCount() {
    setState(() {
      if (_count! >= 999) {
        _count = 999;
      } else {
        _count = _count! + 1;
      }
      _recurrenceProperties!.recurrenceCount = _count!;
    });
  }

  void _removeCount() {
    setState(() {
      if (_count! > 1) {
        _count = _count! - 1;
      }
      _recurrenceProperties!.recurrenceCount = _count!;
    });
  }

  void _webSelectWeekDays(WeekDays day) {
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

  void _webInitialWeekdays(int day) {
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

  /// Return the resource editor to edit the resource collection for an
  /// appointment
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 5),
        child: Text(
          'Add people',
          style: hintTextStyle,
        ),
      );
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: widget.model.backgroundColor,
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds!.removeAt(i);
          _unSelectedResources = _getUnSelectedResources(
              _selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Color defaultTextColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    final Color defaultButtonColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    final Color borderColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.transparent;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: widget.model.themeData != null &&
                  widget.model.themeData.colorScheme.brightness ==
                      Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
        ),
        height: widget.events.resources != null &&
                widget.events.resources!.isNotEmpty
            ? widget.selectedAppointment.recurrenceId == null
                ? _isTimeZoneEnabled || _selectedRecurrenceType != 'Never'
                    ? 640
                    : 580
                : _isTimeZoneEnabled || _selectedRecurrenceType != 'Never'
                    ? 560
                    : 480
            : widget.selectedAppointment.recurrenceId == null
                ? _isTimeZoneEnabled || _selectedRecurrenceType != 'Never'
                    ? 560
                    : 500
                : _isTimeZoneEnabled || _selectedRecurrenceType != 'Never'
                    ? 480
                    : 420,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: ListTile(
                        title: Text(
                          widget.selectedAppointment != null &&
                                  widget.newAppointment == null
                              ? 'Edit appointment'
                              : 'New appointment',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: defaultTextColor),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: defaultColor),
                          onPressed: () {
                            if (widget.newAppointment != null &&
                                widget.events.appointments!
                                    .contains(widget.newAppointment)) {
                              /// To remove the created appointment when the pop-up closed
                              /// without saving the appointment.
                              widget.events.appointments!.removeAt(widget
                                  .events.appointments!
                                  .indexOf(widget.newAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.newAppointment!]);
                            }

                            Navigator.pop(context);
                          },
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Title',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: defaultColor,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      autofocus: true,
                                      cursorColor: widget.model.backgroundColor,
                                      controller:
                                          TextEditingController(text: _subject),
                                      onChanged: (String value) {
                                        _subject = value;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: defaultTextColor,
                                          fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        focusColor:
                                            widget.model.backgroundColor,
                                        border: const UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: widget
                                                    .model.backgroundColor,
                                                width: 2.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.start,
                                  ),
                                  TextField(
                                    controller:
                                        TextEditingController(text: _location),
                                    cursorColor: widget.model.backgroundColor,
                                    onChanged: (String value) {
                                      _location = value;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      focusColor: widget.model.backgroundColor,
                                      isDense: true,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  widget.model.backgroundColor,
                                              width: 2.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Start',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.start,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: (_isAllDay
                                                ? DateFormat('MM/dd/yyyy')
                                                : DateFormat('MM/dd/yy h:mm a'))
                                            .format(_startDate)),
                                    onChanged: (String value) {
                                      _startDate = DateTime.parse(value);
                                      _startTime = TimeOfDay(
                                          hour: _startDate.hour,
                                          minute: _startDate.minute);
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffix: SizedBox(
                                        height: 20,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            ButtonTheme(
                                                minWidth: 50.0,
                                                child: MaterialButton(
                                                  elevation: 0,
                                                  focusElevation: 0,
                                                  highlightElevation: 0,
                                                  disabledElevation: 0,
                                                  hoverElevation: 0,
                                                  onPressed: () async {
                                                    final DateTime? date =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                _startDate,
                                                            firstDate:
                                                                DateTime(1900),
                                                            lastDate:
                                                                DateTime(2100),
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget?
                                                                        child) {
                                                              return Theme(
                                                                data: ThemeData(
                                                                    brightness: widget
                                                                        .model
                                                                        .themeData
                                                                        .brightness,
                                                                    colorScheme:
                                                                        _getColorScheme(
                                                                            widget
                                                                                .model,
                                                                            true),
                                                                    primaryColor:
                                                                        widget
                                                                            .model
                                                                            .backgroundColor),
                                                                child: child!,
                                                              );
                                                            });

                                                    if (date != null &&
                                                        date != _startDate) {
                                                      setState(() {
                                                        final Duration
                                                            difference =
                                                            _endDate.difference(
                                                                _startDate);
                                                        _startDate = DateTime(
                                                            date.year,
                                                            date.month,
                                                            date.day,
                                                            _startTime.hour,
                                                            _startTime.minute);
                                                        _endDate = _startDate
                                                            .add(difference);
                                                        _endTime = TimeOfDay(
                                                            hour: _endDate.hour,
                                                            minute: _endDate
                                                                .minute);
                                                      });
                                                    }
                                                  },
                                                  shape: const CircleBorder(),
                                                  padding: EdgeInsets.zero,
                                                  child: Icon(
                                                    Icons.date_range,
                                                    color: defaultColor,
                                                    size: 20,
                                                  ),
                                                )),
                                            if (_isAllDay)
                                              const SizedBox(
                                                width: 0,
                                                height: 0,
                                              )
                                            else
                                              ButtonTheme(
                                                  minWidth: 50.0,
                                                  child: MaterialButton(
                                                    elevation: 0,
                                                    focusElevation: 0,
                                                    highlightElevation: 0,
                                                    disabledElevation: 0,
                                                    hoverElevation: 0,
                                                    shape: const CircleBorder(),
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () async {
                                                      final TimeOfDay? time =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour:
                                                                      _startTime
                                                                          .hour,
                                                                  minute:
                                                                      _startTime
                                                                          .minute),
                                                              builder: (BuildContext
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                                return Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    brightness: widget
                                                                        .model
                                                                        .themeData
                                                                        .brightness,
                                                                    colorScheme:
                                                                        _getColorScheme(
                                                                            widget.model,
                                                                            false),
                                                                    primaryColor:
                                                                        widget
                                                                            .model
                                                                            .backgroundColor,
                                                                  ),
                                                                  child: child!,
                                                                );
                                                              });

                                                      if (time != null &&
                                                          time != _startTime) {
                                                        setState(() {
                                                          _startTime = time;
                                                          final Duration
                                                              difference =
                                                              _endDate.difference(
                                                                  _startDate);
                                                          _startDate = DateTime(
                                                              _startDate.year,
                                                              _startDate.month,
                                                              _startDate.day,
                                                              _startTime.hour,
                                                              _startTime
                                                                  .minute);
                                                          _endDate = _startDate
                                                              .add(difference);
                                                          _endTime = TimeOfDay(
                                                              hour:
                                                                  _endDate.hour,
                                                              minute: _endDate
                                                                  .minute);
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.access_time,
                                                      color: defaultColor,
                                                      size: 20,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                      ),
                                      focusColor: widget.model.backgroundColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  widget.model.backgroundColor,
                                              width: 2.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('End',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: defaultColor,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.start),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: (_isAllDay
                                                ? DateFormat('MM/dd/yyyy')
                                                : DateFormat('MM/dd/yy h:mm a'))
                                            .format(_endDate)),
                                    onChanged: (String value) {
                                      _endDate = DateTime.parse(value);
                                      _endTime = TimeOfDay(
                                          hour: _endDate.hour,
                                          minute: _endDate.minute);
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffix: SizedBox(
                                        height: 20,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ButtonTheme(
                                                minWidth: 50.0,
                                                child: MaterialButton(
                                                  elevation: 0,
                                                  focusElevation: 0,
                                                  highlightElevation: 0,
                                                  disabledElevation: 0,
                                                  hoverElevation: 0,
                                                  shape: const CircleBorder(),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    final DateTime? date =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                _endDate,
                                                            firstDate:
                                                                DateTime(1900),
                                                            lastDate:
                                                                DateTime(2100),
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget?
                                                                        child) {
                                                              return Theme(
                                                                data: ThemeData(
                                                                  brightness: widget
                                                                      .model
                                                                      .themeData
                                                                      .brightness,
                                                                  colorScheme:
                                                                      _getColorScheme(
                                                                          widget
                                                                              .model,
                                                                          true),
                                                                  primaryColor:
                                                                      widget
                                                                          .model
                                                                          .backgroundColor,
                                                                ),
                                                                child: child!,
                                                              );
                                                            });

                                                    if (date != null &&
                                                        date != _endDate) {
                                                      setState(() {
                                                        final Duration
                                                            difference =
                                                            _endDate.difference(
                                                                _startDate);
                                                        _endDate = DateTime(
                                                            date.year,
                                                            date.month,
                                                            date.day,
                                                            _endTime.hour,
                                                            _endTime.minute);
                                                        if (_endDate.isBefore(
                                                            _startDate)) {
                                                          _startDate =
                                                              _endDate.subtract(
                                                                  difference);
                                                          _startTime = TimeOfDay(
                                                              hour: _startDate
                                                                  .hour,
                                                              minute: _startDate
                                                                  .minute);
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.date_range,
                                                    color: defaultColor,
                                                    size: 20,
                                                  ),
                                                )),
                                            if (_isAllDay)
                                              const SizedBox(
                                                width: 0,
                                                height: 0,
                                              )
                                            else
                                              ButtonTheme(
                                                  minWidth: 50.0,
                                                  child: MaterialButton(
                                                    elevation: 0,
                                                    focusElevation: 0,
                                                    highlightElevation: 0,
                                                    disabledElevation: 0,
                                                    hoverElevation: 0,
                                                    shape: const CircleBorder(),
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () async {
                                                      final TimeOfDay? time =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour: _endTime
                                                                      .hour,
                                                                  minute: _endTime
                                                                      .minute),
                                                              builder: (BuildContext
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                                return Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    brightness: widget
                                                                        .model
                                                                        .themeData
                                                                        .brightness,
                                                                    colorScheme:
                                                                        _getColorScheme(
                                                                            widget.model,
                                                                            false),
                                                                    primaryColor:
                                                                        widget
                                                                            .model
                                                                            .backgroundColor,
                                                                  ),
                                                                  child: child!,
                                                                );
                                                              });

                                                      if (time != null &&
                                                          time != _endTime) {
                                                        setState(() {
                                                          _endTime = time;
                                                          final Duration
                                                              difference =
                                                              _endDate.difference(
                                                                  _startDate);
                                                          _endDate = DateTime(
                                                              _endDate.year,
                                                              _endDate.month,
                                                              _endDate.day,
                                                              _endTime.hour,
                                                              _endTime.minute);
                                                          if (_endDate.isBefore(
                                                              _startDate)) {
                                                            _startDate = _endDate
                                                                .subtract(
                                                                    difference);
                                                            _startTime = TimeOfDay(
                                                                hour: _startDate
                                                                    .hour,
                                                                minute:
                                                                    _startDate
                                                                        .minute);
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.access_time,
                                                      color: defaultColor,
                                                      size: 20,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                      ),
                                      focusColor: widget.model.backgroundColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  widget.model.backgroundColor,
                                              width: 2.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Checkbox(
                              focusColor: widget.model.backgroundColor,
                              activeColor: widget.model.backgroundColor,
                              value: _isAllDay,
                              onChanged: (bool? value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _isAllDay = value;
                                  if (_isAllDay) {
                                    _isTimeZoneEnabled = false;
                                  }
                                });
                              },
                            ),
                            Text(
                              'All day',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: defaultColor,
                                  fontWeight: FontWeight.w300),
                            ),
                            Container(width: 10),
                            if (_isAllDay)
                              Container()
                            else
                              Checkbox(
                                focusColor: widget.model.backgroundColor,
                                activeColor: widget.model.backgroundColor,
                                value: _isTimeZoneEnabled,
                                onChanged: (bool? value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _isTimeZoneEnabled = value;
                                    if (!_isTimeZoneEnabled &&
                                        _selectedTimeZoneIndex != 0) {
                                      _selectedTimeZoneIndex = 0;
                                    }
                                  });
                                },
                              ),
                            if (_isAllDay)
                              Container()
                            else
                              Text(
                                'Time zone',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: defaultColor,
                                    fontWeight: FontWeight.w300),
                              ),
                          ],
                        ),
                      )),
                  if (_isTimeZoneEnabled)
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 20, top: 2, bottom: 2, right: 305),
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: defaultColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                                child: RawMaterialButton(
                              padding: const EdgeInsets.only(left: 5.0),
                              onPressed: () {
                                showDialog<Widget>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _CalendarTimeZonePicker(
                                      widget.model.backgroundColor,
                                      widget.timeZoneCollection,
                                      _selectedTimeZoneIndex,
                                      widget.model,
                                      onChanged:
                                          (_PickerChangedDetails details) {
                                        _selectedTimeZoneIndex = details.index;
                                      },
                                    );
                                  },
                                ).then((dynamic value) => setState(() {
                                      /// update the time zone changes
                                    }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    size: 24,
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(),
                  Visibility(
                    visible: widget.selectedAppointment.recurrenceId == null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 2),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Repeat',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: defaultColor,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.start,
                                      ),
                                      TextField(
                                        mouseCursor:
                                            MaterialStateMouseCursor.clickable,
                                        controller: TextEditingController(
                                            text: _selectedRecurrenceType),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          suffix: SizedBox(
                                              height: 28,
                                              child: DropdownButton<String>(
                                                  focusColor:
                                                      Colors.transparent,
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: defaultTextColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  value:
                                                      _selectedRecurrenceType,
                                                  items: _repeatOption
                                                      .map((String item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? value) {
                                                    if (value == 'Weekly') {
                                                      _weeklyRule();
                                                    } else if (value ==
                                                        'Monthly') {
                                                      _monthlyRule();
                                                    } else if (value ==
                                                        'Yearly') {
                                                      _yearlyRule();
                                                    } else if (value ==
                                                        'Daily') {
                                                      _dailyRule();
                                                    } else if (value ==
                                                        'Never') {
                                                      _neverRule();
                                                    }
                                                  })),
                                          focusColor:
                                              widget.model.backgroundColor,
                                          border: const UnderlineInputBorder(),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: widget
                                                      .model.backgroundColor,
                                                  width: 2.0)),
                                        ),
                                      )
                                    ]),
                              )),
                          Expanded(
                            flex: 3,
                            child: Visibility(
                                visible: _selectedRecurrenceType != 'Never',
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 2),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Repeat every',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: defaultColor,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.start,
                                        ),
                                        TextField(
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          controller: TextEditingController
                                              .fromValue(TextEditingValue(
                                                  text: _interval.toString(),
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: _interval
                                                              .toString()
                                                              .length))),
                                          cursorColor:
                                              widget.model.backgroundColor,
                                          onChanged: (String value) {
                                            if (value != null &&
                                                value.isNotEmpty) {
                                              _interval = int.parse(value);
                                              if (_interval == 0) {
                                                _interval = 1;
                                              } else if (_interval! >= 999) {
                                                _interval = 999;
                                              }
                                            } else if (value.isEmpty ||
                                                value == null) {
                                              _interval = 1;
                                            }
                                            _recurrenceProperties!.interval =
                                                _interval!;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLines: null,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            // isCollapsed: true,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 15, bottom: 5),
                                            suffixIconConstraints:
                                                const BoxConstraints(
                                              maxHeight: 35,
                                            ),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Material(
                                                    child: IconButton(
                                                        icon: Icon(
                                                            Icons
                                                                .arrow_drop_down_outlined,
                                                            color:
                                                                defaultColor),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 3,
                                                        ),
                                                        onPressed:
                                                            _removeInterval),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Material(
                                                        child: IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .arrow_drop_up_outlined,
                                                              color:
                                                                  defaultColor,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 3),
                                                            onPressed:
                                                                _addInterval))),
                                              ],
                                            ),
                                            focusColor:
                                                widget.model.backgroundColor,
                                            border:
                                                const UnderlineInputBorder(),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: widget
                                                        .model.backgroundColor,
                                                    width: 2.0)),
                                          ),
                                        )
                                      ],
                                    ))),
                          ),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text('  ' + _ruleType,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: defaultTextColor,
                                          fontWeight: FontWeight.w400)))),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _selectedRecurrenceType != 'Never',
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: _selectedRecurrenceType == 'Weekly' ? 4 : 0,
                              child: Visibility(
                                  visible: _selectedRecurrenceType == 'Weekly',
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 5, top: 2, bottom: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Repeat On',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: defaultColor,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.start,
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Wrap(
                                              spacing: 3.0,
                                              runSpacing: 10.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                Tooltip(
                                                  message: 'Sunday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.sunday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .sunday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .sunday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('S'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Monday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.monday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .monday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .monday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('M'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Tuesday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.tuesday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .tuesday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .tuesday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('T'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Wednesday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.wednesday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .wednesday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .wednesday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('W'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Thursday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.thursday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .thursday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .thursday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('T'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Friday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.friday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .friday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .friday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('F'),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Saturday',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _webSelectWeekDays(
                                                            WeekDays.saturday);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.black26,
                                                      disabledBackgroundColor:
                                                          Colors.black26,
                                                      side: BorderSide(
                                                          color: borderColor),
                                                      backgroundColor: _days!
                                                              .contains(WeekDays
                                                                  .saturday)
                                                          ? widget.model
                                                              .backgroundColor
                                                          : defaultButtonColor,
                                                      foregroundColor: _days!
                                                              .contains(WeekDays
                                                                  .saturday)
                                                          ? Colors.white
                                                          : defaultTextColor,
                                                      shape:
                                                          const CircleBorder(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    child: const Text('S'),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: _selectedRecurrenceType == 'Yearly' ? 4 : 0,
                              child: Visibility(
                                visible: _selectedRecurrenceType == 'Yearly',
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 2, bottom: 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Repeat On',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: defaultColor,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.start,
                                          ),
                                          TextField(
                                            mouseCursor:
                                                MaterialStateMouseCursor
                                                    .clickable,
                                            controller: TextEditingController(
                                                text: _monthName),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              suffix: SizedBox(
                                                height: 27,
                                                child: DropdownButton<String>(
                                                    focusColor:
                                                        Colors.transparent,
                                                    isExpanded: true,
                                                    underline: Container(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: defaultTextColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    value: _monthName,
                                                    items: _dayMonths
                                                        .map((String item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        if (value ==
                                                            'January') {
                                                          _monthName =
                                                              'January';
                                                          _month = 1;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'February') {
                                                          _monthName =
                                                              'February';
                                                          _month = 2;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'March') {
                                                          _monthName = 'March';
                                                          _month = 3;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'April') {
                                                          _monthName = 'April';
                                                          _month = 4;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'May') {
                                                          _monthName = 'May';
                                                          _month = 5;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'June') {
                                                          _monthName = 'June';
                                                          _month = 6;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'July') {
                                                          _monthName = 'July';
                                                          _month = 7;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'August') {
                                                          _monthName = 'August';
                                                          _month = 8;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'September') {
                                                          _monthName =
                                                              'September';
                                                          _month = 9;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'October') {
                                                          _monthName =
                                                              'October';
                                                          _month = 10;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'November') {
                                                          _monthName =
                                                              'November';
                                                          _month = 11;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        } else if (value ==
                                                            'December') {
                                                          _monthName =
                                                              'December';
                                                          _month = 12;
                                                          _recurrenceProperties!
                                                              .month = _month!;
                                                        }
                                                      });
                                                    }),
                                              ),
                                              focusColor:
                                                  widget.model.backgroundColor,
                                              border:
                                                  const UnderlineInputBorder(),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: widget.model
                                                              .backgroundColor,
                                                          width: 2.0)),
                                            ),
                                          ),
                                        ])),
                              ),
                            ),
                            Expanded(
                              flex:
                                  _selectedRecurrenceType == 'Monthly' ? 4 : 0,
                              child: Visibility(
                                visible: _selectedRecurrenceType == 'Monthly',
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 2, bottom: 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Repeat On',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: defaultColor,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.start,
                                          ),
                                          Row(children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: IconButton(
                                                  onPressed: () {
                                                    _monthDayIcon();
                                                  },
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  icon: Icon(_monthDayRadio),
                                                  color: _monthIconColor,
                                                  focusColor: widget
                                                      .model.backgroundColor,
                                                  iconSize: 20,
                                                )),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: Text(
                                                'Day',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: defaultTextColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, bottom: 5),
                                                  child: TextField(
                                                    controller: TextEditingController
                                                        .fromValue(TextEditingValue(
                                                            text: _dayOfMonth
                                                                .toString(),
                                                            selection: TextSelection
                                                                .collapsed(
                                                                    offset: _dayOfMonth
                                                                        .toString()
                                                                        .length))),
                                                    cursorColor: widget
                                                        .model.backgroundColor,
                                                    onChanged: (String value) {
                                                      if (value != null &&
                                                          value.isNotEmpty) {
                                                        _dayOfMonth =
                                                            int.parse(value);
                                                        if (_dayOfMonth <= 1) {
                                                          _dayOfMonth = 1;
                                                        } else if (_dayOfMonth >=
                                                            31) {
                                                          _dayOfMonth = 31;
                                                        }
                                                      } else if (value
                                                          .isEmpty) {
                                                        _dayOfMonth =
                                                            _startDate.day;
                                                      }
                                                      _recurrenceProperties!
                                                          .dayOfWeek = 0;
                                                      _recurrenceProperties!
                                                          .week = 0;
                                                      _recurrenceProperties!
                                                              .dayOfMonth =
                                                          _dayOfMonth;
                                                      _weekIconColor = widget
                                                                      .model
                                                                      .themeData !=
                                                                  null &&
                                                              widget
                                                                      .model
                                                                      .themeData
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                          ? Colors.white
                                                          : Colors.black54;
                                                      _monthIconColor = widget
                                                          .model
                                                          .backgroundColor;
                                                      _monthDayRadio = Icons
                                                          .radio_button_checked;
                                                      _weekDayRadio = Icons
                                                          .radio_button_unchecked;
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    maxLines: null,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: defaultTextColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      suffix: SizedBox(
                                                        height: 25,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Material(
                                                              child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                icon: Icon(
                                                                    Icons
                                                                        .arrow_drop_down_outlined,
                                                                    color:
                                                                        defaultColor),
                                                                onPressed: () {
                                                                  _removeDay();
                                                                },
                                                              ),
                                                            ),
                                                            Material(
                                                              child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_drop_up_outlined,
                                                                  color:
                                                                      defaultColor,
                                                                ),
                                                                onPressed: () {
                                                                  _addDay();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      focusColor: widget.model
                                                          .backgroundColor,
                                                      border:
                                                          const UnderlineInputBorder(),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: widget
                                                                      .model
                                                                      .backgroundColor,
                                                                  width: 2.0)),
                                                    ),
                                                  )),
                                            ),
                                          ]),
                                        ])),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Visibility(
                                  visible: _selectedRecurrenceType != 'Never',
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: _padding, top: 2, bottom: 2),
                                    margin: EdgeInsets.only(left: _margin),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('End',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: defaultColor,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.start),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: _selectedRecurrenceType ==
                                                        'Monthly'
                                                    ? 9
                                                    : 0),
                                            child: Row(
                                                crossAxisAlignment:
                                                    _selectedRecurrenceType ==
                                                            'Monthly'
                                                        ? CrossAxisAlignment
                                                            .center
                                                        : CrossAxisAlignment
                                                            .start,
                                                mainAxisSize:
                                                    _selectedRecurrenceType ==
                                                            'Monthly'
                                                        ? MainAxisSize.max
                                                        : MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 6),
                                                          child: TextField(
                                                            mouseCursor:
                                                                MaterialStateMouseCursor
                                                                    .clickable,
                                                            controller:
                                                                TextEditingController(
                                                                    text:
                                                                        _selectedRecurrenceRange),
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              suffix: SizedBox(
                                                                height: 27,
                                                                child: DropdownButton<
                                                                        String>(
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    isExpanded:
                                                                        true,
                                                                    underline:
                                                                        Container(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color:
                                                                            defaultTextColor,
                                                                        fontWeight: FontWeight
                                                                            .w400),
                                                                    value:
                                                                        _selectedRecurrenceRange,
                                                                    items: _ends
                                                                        .map((String
                                                                            item) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        child: Text(
                                                                            item),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        if (value ==
                                                                            'Never') {
                                                                          _noEndDateRange();
                                                                        } else if (value ==
                                                                            'Count') {
                                                                          _countRange();
                                                                        } else if (value ==
                                                                            'Until') {
                                                                          _endDateRange();
                                                                        }
                                                                      });
                                                                    }),
                                                              ),
                                                              focusColor: widget
                                                                  .model
                                                                  .backgroundColor,
                                                              border:
                                                                  const UnderlineInputBorder(),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: widget
                                                                          .model
                                                                          .backgroundColor,
                                                                      width:
                                                                          2.0)),
                                                            ),
                                                          ))),
                                                  Expanded(
                                                      flex:
                                                          _selectedRecurrenceRange ==
                                                                  'Count'
                                                              ? 3
                                                              : 0,
                                                      child: Visibility(
                                                        visible:
                                                            _selectedRecurrenceRange ==
                                                                'Count',
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 9),
                                                            child: TextField(
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .center,
                                                              controller: TextEditingController.fromValue(TextEditingValue(
                                                                  text: _count
                                                                      .toString(),
                                                                  selection: TextSelection.collapsed(
                                                                      offset: _count
                                                                          .toString()
                                                                          .length))),
                                                              cursorColor: widget
                                                                  .model
                                                                  .backgroundColor,
                                                              onChanged: (String
                                                                  value) async {
                                                                if (value !=
                                                                        null &&
                                                                    value
                                                                        .isNotEmpty) {
                                                                  _count =
                                                                      int.parse(
                                                                          value);
                                                                  if (_count ==
                                                                      0) {
                                                                    _count = 1;
                                                                  } else if (_count! >=
                                                                      999) {
                                                                    _count =
                                                                        999;
                                                                  }
                                                                  _recurrenceProperties!
                                                                          .recurrenceRange =
                                                                      RecurrenceRange
                                                                          .count;
                                                                  _selectedRecurrenceRange =
                                                                      'Count';
                                                                  _recurrenceProperties!
                                                                          .recurrenceCount =
                                                                      _count!;
                                                                } else if (value
                                                                        .isEmpty ||
                                                                    value ==
                                                                        null) {
                                                                  _noEndDateRange();
                                                                }
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              maxLines: null,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      defaultTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        top: _selectedRecurrenceType ==
                                                                                'Monthly'
                                                                            ? 13
                                                                            : 18,
                                                                        bottom:
                                                                            10),
                                                                suffixIconConstraints:
                                                                    const BoxConstraints(
                                                                        maxHeight:
                                                                            30),
                                                                suffixIcon: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: <Widget>[
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_drop_down,
                                                                          color:
                                                                              defaultColor,
                                                                        ),
                                                                        padding:
                                                                            EdgeInsets
                                                                                .zero,
                                                                        onPressed:
                                                                            _removeCount),
                                                                    IconButton(
                                                                        padding:
                                                                            EdgeInsets
                                                                                .zero,
                                                                        icon: Icon(
                                                                            Icons
                                                                                .arrow_drop_up,
                                                                            color:
                                                                                defaultColor),
                                                                        onPressed:
                                                                            _addCount),
                                                                  ],
                                                                ),
                                                                focusColor: widget
                                                                    .model
                                                                    .backgroundColor,
                                                                border:
                                                                    const UnderlineInputBorder(),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: widget
                                                                            .model
                                                                            .backgroundColor,
                                                                        width:
                                                                            2.0)),
                                                              ),
                                                            )),
                                                      )),
                                                  Expanded(
                                                      flex:
                                                          _selectedRecurrenceRange ==
                                                                  'Until'
                                                              ? 3
                                                              : 0,
                                                      child: Visibility(
                                                          visible:
                                                              _selectedRecurrenceRange ==
                                                                  'Until',
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 9),
                                                            child: TextField(
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .top,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: DateFormat(
                                                                          'MM/dd/yyyy')
                                                                      .format(
                                                                          _selectedDate)),
                                                              onChanged: (String
                                                                  value) {
                                                                _selectedDate =
                                                                    DateTime.parse(
                                                                        value);
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .datetime,
                                                              maxLines: null,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      defaultTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.only(
                                                                    top: _selectedRecurrenceType ==
                                                                            'Monthly'
                                                                        ? 10
                                                                        : 15,
                                                                    bottom: _selectedRecurrenceType ==
                                                                            'Monthly'
                                                                        ? 10
                                                                        : 13),
                                                                suffixIconConstraints:
                                                                    const BoxConstraints(
                                                                        maxHeight:
                                                                            30),
                                                                suffixIcon:
                                                                    ButtonTheme(
                                                                        minWidth:
                                                                            30.0,
                                                                        child:
                                                                            MaterialButton(
                                                                          elevation:
                                                                              0,
                                                                          focusElevation:
                                                                              0,
                                                                          highlightElevation:
                                                                              0,
                                                                          disabledElevation:
                                                                              0,
                                                                          hoverElevation:
                                                                              0,
                                                                          onPressed:
                                                                              () async {
                                                                            final DateTime? pickedDate = await showDatePicker(
                                                                                context: context,
                                                                                initialDate: _selectedDate,
                                                                                firstDate: _startDate.isBefore(_firstDate) ? _startDate : _firstDate,
                                                                                currentDate: _selectedDate,
                                                                                lastDate: DateTime(2050),
                                                                                builder: (BuildContext context, Widget? child) {
                                                                                  return Theme(
                                                                                    data: ThemeData(brightness: widget.model.themeData.colorScheme.brightness, colorScheme: _getColorScheme(widget.model, true), primaryColor: widget.model.backgroundColor),
                                                                                    child: child!,
                                                                                  );
                                                                                });
                                                                            if (pickedDate ==
                                                                                null) {
                                                                              return;
                                                                            }
                                                                            setState(() {
                                                                              _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
                                                                              _recurrenceProperties!.endDate = _selectedDate;
                                                                            });
                                                                          },
                                                                          shape:
                                                                              const CircleBorder(),
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.date_range,
                                                                            color:
                                                                                defaultColor,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                        )),
                                                                focusColor: widget
                                                                    .model
                                                                    .backgroundColor,
                                                                border:
                                                                    const UnderlineInputBorder(),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: widget
                                                                            .model
                                                                            .backgroundColor,
                                                                        width:
                                                                            2.0)),
                                                              ),
                                                            ),
                                                          ))),
                                                  Spacer(
                                                      flex: _selectedRecurrenceType ==
                                                              'Daily'
                                                          ? _selectedRecurrenceRange ==
                                                                  'Never'
                                                              ? 8
                                                              : 6
                                                          : _selectedRecurrenceRange ==
                                                                  'Never'
                                                              ? 2
                                                              : 1)
                                                ])),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _selectedRecurrenceType == 'Yearly',
                    child: SizedBox(
                      width: 284,
                      height: 50,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Row(children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                width: 50,
                                child: IconButton(
                                  onPressed: () {
                                    _monthDayIcon();
                                  },
                                  icon: Icon(_monthDayRadio),
                                  color: _monthIconColor,
                                  focusColor: widget.model.backgroundColor,
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('  Day   ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400)),
                              ),
                              SizedBox(
                                width: 208,
                                height: 28,
                                child: TextField(
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          text: _dayOfMonth.toString(),
                                          selection: TextSelection.collapsed(
                                              offset: _dayOfMonth
                                                  .toString()
                                                  .length))),
                                  cursorColor: widget.model.backgroundColor,
                                  onChanged: (String value) {
                                    if (value != null && value.isNotEmpty) {
                                      _dayOfMonth = int.parse(value);
                                      if (_dayOfMonth == 0) {
                                        _dayOfMonth = _startDate.day;
                                      } else if (_dayOfMonth >= 31) {
                                        _dayOfMonth = 31;
                                      }
                                    } else if (value.isEmpty || value == null) {
                                      _dayOfMonth = _startDate.day;
                                    }
                                    _recurrenceProperties!.dayOfWeek = 0;
                                    _recurrenceProperties!.week = 0;
                                    _recurrenceProperties!.dayOfMonth =
                                        _dayOfMonth;
                                    _weekIconColor =
                                        widget.model.themeData != null &&
                                                widget
                                                        .model
                                                        .themeData
                                                        .colorScheme
                                                        .brightness ==
                                                    Brightness.dark
                                            ? Colors.white
                                            : Colors.black54;
                                    _monthIconColor =
                                        widget.model.backgroundColor;
                                    _monthDayRadio = Icons.radio_button_checked;
                                    _weekDayRadio =
                                        Icons.radio_button_unchecked;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLines: null,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffix: SizedBox(
                                      height: 25,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Material(
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    color: defaultColor),
                                                onPressed: _removeDay),
                                          ),
                                          Material(
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  Icons.arrow_drop_up_outlined,
                                                  color: defaultColor,
                                                ),
                                                onPressed: _addDay),
                                          ),
                                        ],
                                      ),
                                    ),
                                    focusColor: widget.model.backgroundColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: widget.model.backgroundColor,
                                            width: 2.0)),
                                  ),
                                ),
                              ),
                              _lastDayOfMonth(defaultTextColor),
                            ])),
                          ]),
                    ),
                  ),
                  Visibility(
                      visible: _selectedRecurrenceType == 'Monthly' ||
                          _selectedRecurrenceType == 'Yearly',
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        width: 284,
                        height: 40,
                        child: Row(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: 50,
                            child: IconButton(
                              onPressed: () {
                                _monthWeekIcon();
                              },
                              icon: Icon(_weekDayRadio),
                              color: _weekIconColor,
                              iconSize: 20,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 102,
                                child: TextField(
                                  mouseCursor:
                                      MaterialStateMouseCursor.clickable,
                                  controller: TextEditingController(
                                      text: _weekNumberText),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffix: SizedBox(
                                      height: 25,
                                      child: DropdownButton<String>(
                                          focusColor: Colors.transparent,
                                          isExpanded: true,
                                          value: _weekNumberText,
                                          underline: Container(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400),
                                          items:
                                              _daysPosition.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              if (value == 'First') {
                                                _weekNumberText = 'First';
                                                _weekNumber = 1;
                                                _recurrenceProperties!.week =
                                                    _weekNumber;
                                                _monthWeekIcon();
                                              } else if (value == 'Second') {
                                                _weekNumberText = 'Second';
                                                _weekNumber = 2;
                                                _recurrenceProperties!.week =
                                                    _weekNumber;
                                                _monthWeekIcon();
                                              } else if (value == 'Third') {
                                                _weekNumberText = 'Third';
                                                _weekNumber = 3;
                                                _recurrenceProperties!.week =
                                                    _weekNumber;
                                                _monthWeekIcon();
                                              } else if (value == 'Fourth') {
                                                _weekNumberText = 'Fourth';
                                                _weekNumber = 4;
                                                _recurrenceProperties!.week =
                                                    _weekNumber;
                                                _monthWeekIcon();
                                              } else if (value == 'Last') {
                                                _weekNumberText = 'Last';
                                                _weekNumber = -1;
                                                _recurrenceProperties!.week =
                                                    _weekNumber;
                                                _monthWeekIcon();
                                              }
                                            });
                                          }),
                                    ),
                                    focusColor: widget.model.backgroundColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: widget.model.backgroundColor,
                                            width: 2.0)),
                                  ),
                                ),
                              ),
                              Container(
                                width: 127,
                                margin: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  mouseCursor:
                                      MaterialStateMouseCursor.clickable,
                                  controller: TextEditingController(
                                      text: _dayOfWeekText),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffix: SizedBox(
                                      height: 25,
                                      child: DropdownButton<String>(
                                          focusColor: Colors.transparent,
                                          isExpanded: true,
                                          value: _dayOfWeekText,
                                          underline: Container(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400),
                                          items: _weekDay.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              if (value == 'Sunday') {
                                                _dayOfWeekText = 'Sunday';
                                                _dayOfWeek = 7;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Monday') {
                                                _dayOfWeekText = 'Monday';
                                                _dayOfWeek = 1;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Tuesday') {
                                                _dayOfWeekText = 'Tuesday';
                                                _dayOfWeek = 2;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Wednesday') {
                                                _dayOfWeekText = 'Wednesday';
                                                _dayOfWeek = 3;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Thursday') {
                                                _dayOfWeekText = 'Thursday';
                                                _dayOfWeek = 4;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Friday') {
                                                _dayOfWeekText = 'Friday';
                                                _dayOfWeek = 5;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              } else if (value == 'Saturday') {
                                                _dayOfWeekText = 'Saturday';
                                                _dayOfWeek = 6;
                                                _recurrenceProperties!
                                                    .dayOfWeek = _dayOfWeek;
                                                _monthWeekIcon();
                                              }
                                            });
                                          }),
                                    ),
                                    focusColor: widget.model.backgroundColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: widget.model.backgroundColor,
                                            width: 2.0)),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _selectedRecurrenceType == 'Monthly',
                                child: _lastDayOfMonth(defaultTextColor),
                              ),
                            ],
                          ),
                        ]),
                      )),
                  Container(
                    height: 5,
                  ),
                  if (widget.events.resources == null ||
                      widget.events.resources!.isEmpty)
                    Container()
                  else
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 20),
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Employees',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: defaultColor,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              width: 600,
                              height: 50,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: _getResourceEditor(TextStyle(
                                  fontSize: 13,
                                  color: defaultColor,
                                  fontWeight: FontWeight.w400)),
                            )
                          ]),
                      onTap: () {
                        showDialog<Widget>(
                          context: context,
                          builder: (BuildContext context) {
                            return _ResourcePicker(
                              _unSelectedResources,
                              widget.model,
                              onChanged: (_PickerChangedDetails details) {
                                _resourceIds = _resourceIds == null
                                    ? <Object>[details.resourceId!]
                                    : (_resourceIds!.sublist(0)
                                      ..add(details.resourceId!));
                                _selectedResources = _getSelectedResources(
                                    _resourceIds, widget.events.resources);
                                _unSelectedResources = _getUnSelectedResources(
                                    _selectedResources,
                                    widget.events.resources);
                              },
                            );
                          },
                        ).then((dynamic value) => setState(() {
                              /// update the color picker changes
                            }));
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextField(
                              controller: TextEditingController(text: _notes),
                              cursorColor: widget.model.backgroundColor,
                              onChanged: (String value) {
                                _notes = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: widget.model.isWebFullView ? 1 : null,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: defaultTextColor,
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                isDense: true,
                                focusColor: widget.model.backgroundColor,
                                border: const UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget.model.backgroundColor,
                                        width: 2.0)),
                              ),
                            )),
                      ],
                    ),
                  ),
                  ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 20),
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: defaultColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RawMaterialButton(
                                padding: const EdgeInsets.only(left: 5),
                                onPressed: () {
                                  showDialog<Widget>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _CalendarColorPicker(
                                        widget.colorCollection,
                                        _selectedColorIndex,
                                        widget.colorNames,
                                        widget.model,
                                        onChanged:
                                            (_PickerChangedDetails details) {
                                          _selectedColorIndex = details.index;
                                        },
                                      );
                                    },
                                  ).then((dynamic value) => setState(() {
                                        /// update the color picker changes
                                      }));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.lens,
                                      size: 20,
                                      color: widget
                                          .colorCollection[_selectedColorIndex],
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.colorNames[
                                                _selectedColorIndex],
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: defaultTextColor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: RawMaterialButton(
                          onPressed: () {
                            if (widget.newAppointment != null) {
                              widget.events.appointments!.removeAt(widget
                                  .events.appointments!
                                  .indexOf(widget.newAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.newAppointment!]);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: defaultTextColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RawMaterialButton(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          fillColor: widget.model.backgroundColor,
                          onPressed: () {
                            if ((widget.selectedAppointment.recurrenceRule !=
                                        null &&
                                    widget.selectedAppointment.recurrenceRule!
                                        .isNotEmpty) ||
                                widget.selectedAppointment.recurrenceId !=
                                    null) {
                              if (!_canAddRecurrenceAppointment(
                                  widget.visibleDates,
                                  widget.events,
                                  widget.selectedAppointment,
                                  _startDate)) {
                                showDialog<Widget>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                          onWillPop: () async {
                                            return true;
                                          },
                                          child: Theme(
                                            data: widget.model.themeData,
                                            child: AlertDialog(
                                                title: const Text('Alert'),
                                                content: const Text(
                                                    'Two occurrences of the same event cannot occur on the same day'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('OK'),
                                                  ),
                                                ]),
                                          ));
                                    });
                                return;
                              }
                            }

                            /// Add conditional code here recurrence can add re
                            if (widget.selectedAppointment.appointmentType !=
                                    AppointmentType.normal &&
                                widget.selectedAppointment.recurrenceId ==
                                    null) {
                              if (widget.selectedAppointment
                                      .recurrenceExceptionDates ==
                                  null) {
                                widget.events.appointments!.removeAt(widget
                                    .events.appointments!
                                    .indexOf(widget.selectedAppointment));
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[widget.selectedAppointment]);
                                final Appointment newAppointment = Appointment(
                                  startTime: _startDate,
                                  endTime: _endDate,
                                  color: widget
                                      .colorCollection[_selectedColorIndex],
                                  startTimeZone: _selectedTimeZoneIndex == 0
                                      ? ''
                                      : widget.timeZoneCollection[
                                          _selectedTimeZoneIndex],
                                  endTimeZone: _selectedTimeZoneIndex == 0
                                      ? ''
                                      : widget.timeZoneCollection[
                                          _selectedTimeZoneIndex],
                                  notes: _notes,
                                  isAllDay: _isAllDay,
                                  location: _location,
                                  subject:
                                      _subject == '' ? '(No title)' : _subject,
                                  resourceIds: _resourceIds,
                                  id: widget.selectedAppointment.id,
                                  recurrenceRule: _recurrenceProperties ==
                                              null ||
                                          _selectedRecurrenceType == 'Never' ||
                                          widget.selectedAppointment
                                                  .recurrenceId !=
                                              null
                                      ? null
                                      : SfCalendar.generateRRule(
                                          _recurrenceProperties!,
                                          _startDate,
                                          _endDate),
                                );
                                widget.events.appointments!.add(newAppointment);
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.add,
                                    <Appointment>[newAppointment]);
                                Navigator.pop(context);
                              } else {
                                final Appointment recurrenceAppointment =
                                    Appointment(
                                  startTime: _startDate,
                                  endTime: _endDate,
                                  color: widget
                                      .colorCollection[_selectedColorIndex],
                                  startTimeZone: _selectedTimeZoneIndex == 0
                                      ? ''
                                      : widget.timeZoneCollection[
                                          _selectedTimeZoneIndex],
                                  endTimeZone: _selectedTimeZoneIndex == 0
                                      ? ''
                                      : widget.timeZoneCollection[
                                          _selectedTimeZoneIndex],
                                  notes: _notes,
                                  isAllDay: _isAllDay,
                                  location: _location,
                                  subject:
                                      _subject == '' ? '(No title)' : _subject,
                                  resourceIds: _resourceIds,
                                  id: widget.selectedAppointment.id,
                                  recurrenceRule: _recurrenceProperties ==
                                              null ||
                                          _selectedRecurrenceType == 'Never' ||
                                          widget.selectedAppointment
                                                  .recurrenceId !=
                                              null
                                      ? null
                                      : SfCalendar.generateRRule(
                                          _recurrenceProperties!,
                                          _startDate,
                                          _endDate),
                                );
                                showDialog<Widget>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                          onWillPop: () async {
                                            return true;
                                          },
                                          child: Theme(
                                              data: widget.model.themeData,
                                              child: _editExceptionSeries(
                                                  context,
                                                  widget.model,
                                                  widget.selectedAppointment,
                                                  recurrenceAppointment,
                                                  widget.events)));
                                    });
                              }
                            } else if (widget
                                    .selectedAppointment.recurrenceId !=
                                null) {
                              final Appointment? parentAppointment =
                                  widget.events.getPatternAppointment(
                                          widget.selectedAppointment, '')
                                      as Appointment?;
                              widget.events.appointments!.removeAt(widget
                                  .events.appointments!
                                  .indexOf(parentAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[parentAppointment!]);
                              parentAppointment.recurrenceExceptionDates != null
                                  ? parentAppointment.recurrenceExceptionDates!
                                      .add(widget.selectedAppointment.startTime)
                                  : parentAppointment.recurrenceExceptionDates =
                                      <DateTime>[
                                      widget.selectedAppointment.startTime
                                    ];
                              widget.events.appointments!
                                  .add(parentAppointment);
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.add,
                                  <Appointment>[parentAppointment]);
                              if (widget.selectedAppointment != null ||
                                  widget.newAppointment != null) {
                                if (widget.events.appointments!.isNotEmpty &&
                                    widget.events.appointments!
                                        .contains(widget.selectedAppointment)) {
                                  widget.events.appointments!.removeAt(widget
                                      .events.appointments!
                                      .indexOf(widget.selectedAppointment));
                                  widget.events.notifyListeners(
                                      CalendarDataSourceAction.remove,
                                      <Appointment>[
                                        widget.selectedAppointment
                                      ]);
                                }
                                if (widget.appointment.isNotEmpty &&
                                    widget.appointment
                                        .contains(widget.newAppointment)) {
                                  widget.appointment.removeAt(widget.appointment
                                      .indexOf(widget.newAppointment!));
                                }

                                if (widget.newAppointment != null &&
                                    widget.events.appointments!.isNotEmpty &&
                                    widget.events.appointments!
                                        .contains(widget.newAppointment)) {
                                  widget.events.appointments!.removeAt(widget
                                      .events.appointments!
                                      .indexOf(widget.newAppointment));
                                  widget.events.notifyListeners(
                                      CalendarDataSourceAction.remove,
                                      <Appointment>[widget.newAppointment!]);
                                }
                              }
                              widget.appointment.add(Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
                                startTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                endTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                notes: _notes,
                                isAllDay: _isAllDay,
                                location: _location,
                                subject:
                                    _subject == '' ? '(No title)' : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceId:
                                    widget.selectedAppointment.recurrenceId,
                              ));
                              widget.events.appointments!
                                  .add(widget.appointment[0]);
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.add,
                                  widget.appointment);
                              Navigator.pop(context);
                            } else {
                              if (widget.selectedAppointment != null ||
                                  widget.newAppointment != null) {
                                if (widget.events.appointments!.isNotEmpty &&
                                    widget.events.appointments!
                                        .contains(widget.selectedAppointment)) {
                                  widget.events.appointments!.removeAt(widget
                                      .events.appointments!
                                      .indexOf(widget.selectedAppointment));
                                  widget.events.notifyListeners(
                                      CalendarDataSourceAction.remove,
                                      <Appointment>[
                                        widget.selectedAppointment
                                      ]);
                                }
                                if (widget.appointment.isNotEmpty &&
                                    widget.appointment
                                        .contains(widget.newAppointment)) {
                                  widget.appointment.removeAt(widget.appointment
                                      .indexOf(widget.newAppointment!));
                                }

                                if (widget.newAppointment != null &&
                                    widget.events.appointments!.isNotEmpty &&
                                    widget.events.appointments!
                                        .contains(widget.newAppointment)) {
                                  widget.events.appointments!.removeAt(widget
                                      .events.appointments!
                                      .indexOf(widget.newAppointment));
                                  widget.events.notifyListeners(
                                      CalendarDataSourceAction.remove,
                                      <Appointment>[widget.newAppointment!]);
                                }
                              }
                              widget.appointment.add(Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
                                startTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                endTimeZone: _selectedTimeZoneIndex == 0
                                    ? ''
                                    : widget.timeZoneCollection[
                                        _selectedTimeZoneIndex],
                                notes: _notes,
                                isAllDay: _isAllDay,
                                location: _location,
                                subject:
                                    _subject == '' ? '(No title)' : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceId:
                                    widget.selectedAppointment.recurrenceId,
                                recurrenceRule: _recurrenceProperties == null ||
                                        _selectedRecurrenceType == 'Never' ||
                                        widget.selectedAppointment
                                                .recurrenceId !=
                                            null
                                    ? null
                                    : SfCalendar.generateRRule(
                                        _recurrenceProperties!,
                                        _startDate,
                                        _endDate),
                              ));
                              widget.events.appointments!
                                  .add(widget.appointment[0]);
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.add,
                                  widget.appointment);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'SAVE',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _lastDayOfMonth(Color textColor) {
    return Row(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: () {
              _monthLastDayIcon();
            },
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            icon: Icon(_lastDayRadio),
            color: _lastDayIconColor,
            focusColor: widget.model.backgroundColor,
            iconSize: 20,
          )),
      Container(
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: Text(
          'Last day of month',
          style: TextStyle(
              fontSize: 13, color: textColor, fontWeight: FontWeight.w400),
        ),
      ),
    ]);
  }
}

/// Returns color scheme based on dark and light theme.
ColorScheme _getColorScheme(SampleModel model, bool isDatePicker) {
  /// For time picker used the default surface color based for corresponding
  /// theme, so that the picker background color doesn't cover with the model's
  /// background color.
  if (model.themeData.colorScheme.brightness == Brightness.dark) {
    return ColorScheme.dark(
      primary: model.backgroundColor,
      secondary: model.backgroundColor,
      surface: isDatePicker ? model.backgroundColor : Colors.grey[850]!,
    );
  }

  return ColorScheme.light(
    primary: model.backgroundColor,
    secondary: model.backgroundColor,
    surface: isDatePicker ? model.backgroundColor : Colors.white,
  );
}

enum _SelectRule {
  doesNotRepeat,
  everyDay,
  everyWeek,
  everyMonth,
  everyYear,
  custom
}

enum _Edit { event, series }

enum _Delete { event, series }

/// Builds the appointment editor with all the required elements based on the
/// tapped calendar element for mobile.
class AppointmentEditor extends StatefulWidget {
  /// Holds the value of appointment editor
  const AppointmentEditor(
      this.model,
      this.selectedAppointment,
      this.targetElement,
      this.selectedDate,
      this.colorCollection,
      this.colorNames,
      this.events,
      this.timeZoneCollection,
      [this.selectedResource]);

  /// Current sample model
  final SampleModel model;

  /// Selected appointment
  final Appointment? selectedAppointment;

  /// Calendar element
  final CalendarElement targetElement;

  /// Seelcted date value
  final DateTime selectedDate;

  /// Collection of colors
  final List<Color> colorCollection;

  /// List of colors name
  final List<String> colorNames;

  /// Holds the events value
  final CalendarDataSource events;

  /// Collection of time zone values
  final List<String> timeZoneCollection;

  /// Selected calendar resource
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

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment!.startTime;
      _endDate = widget.selectedAppointment!.endTime;
      _isAllDay = widget.selectedAppointment!.isAllDay;
      _selectedColorIndex =
          widget.colorCollection.indexOf(widget.selectedAppointment!.color);
      _selectedTimeZoneIndex =
          widget.selectedAppointment!.startTimeZone == null ||
                  widget.selectedAppointment!.startTimeZone == ''
              ? 0
              : widget.timeZoneCollection
                  .indexOf(widget.selectedAppointment!.startTimeZone!);
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
                  widget.selectedAppointment!.recurrenceRule!, _startDate)
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
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
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
      BuildContext context, Color backgroundColor, Color defaultColor) {
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
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.access_time,
                  color: defaultColor,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
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
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(children: <Widget>[
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
                                  brightness: widget
                                      .model.themeData.colorScheme.brightness,
                                  colorScheme:
                                      _getColorScheme(widget.model, true),
                                  primaryColor: widget.model.backgroundColor,
                                ),
                                child: child!,
                              );
                            });

                        if (date != null && date != _startDate) {
                          setState(() {
                            final Duration difference =
                                _endDate.difference(_startDate);
                            _startDate = DateTime(date.year, date.month,
                                date.day, _startTime.hour, _startTime.minute);
                            _endDate = _startDate.add(difference);
                            _endTime = TimeOfDay(
                                hour: _endDate.hour, minute: _endDate.minute);
                          });
                        }
                      },
                      child: Text(
                          DateFormat('EEE, MMM dd yyyy').format(_startDate),
                          textAlign: TextAlign.left),
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
                                        minute: _startTime.minute),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData(
                                          brightness: widget.model.themeData
                                              .colorScheme.brightness,
                                          colorScheme: _getColorScheme(
                                              widget.model, false),
                                          primaryColor:
                                              widget.model.backgroundColor,
                                        ),
                                        child: child!,
                                      );
                                    });

                                if (time != null && time != _startTime) {
                                  setState(() {
                                    _startTime = time;
                                    final Duration difference =
                                        _endDate.difference(_startDate);
                                    _startDate = DateTime(
                                        _startDate.year,
                                        _startDate.month,
                                        _startDate.day,
                                        _startTime.hour,
                                        _startTime.minute);
                                    _endDate = _startDate.add(difference);
                                    _endTime = TimeOfDay(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute);
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('hh:mm a').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                            )),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(children: <Widget>[
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
                                  brightness: widget
                                      .model.themeData.colorScheme.brightness,
                                  colorScheme:
                                      _getColorScheme(widget.model, true),
                                  primaryColor: widget.model.backgroundColor,
                                ),
                                child: child!,
                              );
                            });

                        if (date != null && date != _endDate) {
                          setState(() {
                            final Duration difference =
                                _endDate.difference(_startDate);
                            _endDate = DateTime(date.year, date.month, date.day,
                                _endTime.hour, _endTime.minute);
                            if (_endDate.isBefore(_startDate)) {
                              _startDate = _endDate.subtract(difference);
                              _startTime = TimeOfDay(
                                  hour: _startDate.hour,
                                  minute: _startDate.minute);
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
                                        minute: _endTime.minute),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData(
                                          brightness: widget.model.themeData
                                              .colorScheme.brightness,
                                          colorScheme: _getColorScheme(
                                              widget.model, false),
                                          primaryColor:
                                              widget.model.backgroundColor,
                                        ),
                                        child: child!,
                                      );
                                    });

                                if (time != null && time != _endTime) {
                                  setState(() {
                                    _endTime = time;
                                    final Duration difference =
                                        _endDate.difference(_startDate);
                                    _endDate = DateTime(
                                        _endDate.year,
                                        _endDate.month,
                                        _endDate.day,
                                        _endTime.hour,
                                        _endTime.minute);
                                    if (_endDate.isBefore(_startDate)) {
                                      _startDate =
                                          _endDate.subtract(difference);
                                      _startTime = TimeOfDay(
                                          hour: _startDate.hour,
                                          minute: _startDate.minute);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('hh:mm a').format(_endDate),
                                textAlign: TextAlign.right,
                              ),
                            )),
                ])),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.public,
                color: defaultColor,
              ),
              title: Text(widget.timeZoneCollection[_selectedTimeZoneIndex]),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CalendarTimeZonePicker(
                      widget.model.backgroundColor,
                      widget.timeZoneCollection,
                      _selectedTimeZoneIndex,
                      widget.model,
                      onChanged: (_PickerChangedDetails details) {
                        _selectedTimeZoneIndex = details.index;
                      },
                    );
                  },
                ).then((dynamic value) => setState(() {
                      /// update the time zone changes
                    }));
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.refresh,
                color: defaultColor,
              ),
              title: Text(_rule == _SelectRule.doesNotRepeat
                  ? 'Does not repeat'
                  : _rule == _SelectRule.everyDay
                      ? 'Every day'
                      : _rule == _SelectRule.everyWeek
                          ? 'Every week'
                          : _rule == _SelectRule.everyMonth
                              ? 'Every month'
                              : _rule == _SelectRule.everyYear
                                  ? 'Every year'
                                  : 'Custom'),
              onTap: () async {
                final dynamic properties = await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          onWillPop: () async {
                            return true;
                          },
                          child: Theme(
                            data: widget.model.themeData,
                            // ignore: prefer_const_literals_to_create_immutables
                            child: _SelectRuleDialog(
                              widget.model,
                              _recurrenceProperties,
                              widget.colorCollection[_selectedColorIndex],
                              widget.events,
                              selectedAppointment: widget.selectedAppointment ??
                                  Appointment(
                                    startTime: _startDate,
                                    endTime: _endDate,
                                    isAllDay: _isAllDay,
                                    subject: _subject == ''
                                        ? '(No title)'
                                        : _subject,
                                  ),
                              onChanged: (_PickerChangedDetails details) {
                                setState(() {
                                  _rule = details.selectedRule;
                                });
                              },
                            ),
                          ));
                    });
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
                title: _getResourceEditor(TextStyle(
                    fontSize: 18,
                    color: defaultColor,
                    fontWeight: FontWeight.w300)),
                onTap: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return _ResourcePicker(
                        _unSelectedResources,
                        widget.model,
                        onChanged: (_PickerChangedDetails details) {
                          _resourceIds = _resourceIds == null
                              ? <Object>[details.resourceId!]
                              : (_resourceIds!.sublist(0)
                                ..add(details.resourceId!));
                          _selectedResources = _getSelectedResources(
                              _resourceIds, widget.events.resources);
                          _unSelectedResources = _getUnSelectedResources(
                              _selectedResources, widget.events.resources);
                        },
                      );
                    },
                  ).then((dynamic value) => setState(() {
                        /// update the color picker changes
                      }));
                },
              ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: widget.colorCollection[_selectedColorIndex]),
              title: Text(
                widget.colorNames[_selectedColorIndex],
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CalendarColorPicker(
                      widget.colorCollection,
                      _selectedColorIndex,
                      widget.colorNames,
                      widget.model,
                      onChanged: (_PickerChangedDetails details) {
                        _selectedColorIndex = details.index;
                      },
                    );
                  },
                ).then((dynamic value) => setState(() {
                      /// update the color picker changes
                    }));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            if (widget.model.isWebFullView)
              ListTile(
                contentPadding: const EdgeInsets.all(5),
                leading: Icon(
                  Icons.location_on,
                  color: defaultColor,
                ),
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
                      fontWeight: FontWeight.w300),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add location',
                  ),
                ),
              )
            else
              Container(),
            if (widget.model.isWebFullView)
              const Divider(
                height: 1.0,
                thickness: 1,
              )
            else
              Container(),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: defaultColor,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                cursorColor: widget.model.backgroundColor,
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: widget.model.isWebFullView ? 1 : null,
                style: TextStyle(
                    fontSize: 18,
                    color: defaultColor,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.model.themeData,
        child: Scaffold(
            backgroundColor: widget.model.themeData != null &&
                    widget.model.themeData.colorScheme.brightness ==
                        Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
            appBar: AppBar(
              backgroundColor: widget.colorCollection[_selectedColorIndex],
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
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
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
                            endTimeZone: _selectedTimeZoneIndex == 0
                                ? ''
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
                            notes: _notes,
                            isAllDay: _isAllDay,
                            subject: _subject == '' ? '(No title)' : _subject,
                            recurrenceExceptionDates: widget
                                .selectedAppointment!.recurrenceExceptionDates,
                            resourceIds: _resourceIds,
                            id: widget.selectedAppointment!.id,
                            recurrenceId:
                                widget.selectedAppointment!.recurrenceId,
                            recurrenceRule: _recurrenceProperties == null
                                ? null
                                : SfCalendar.generateRRule(
                                    _recurrenceProperties!,
                                    _startDate,
                                    _endDate),
                          );
                          showDialog<Widget>(
                              context: context,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                    onWillPop: () async {
                                      return true;
                                    },
                                    child: Theme(
                                      data: widget.model.themeData,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      child: _EditDialog(
                                          widget.model,
                                          newAppointment,
                                          widget.selectedAppointment!,
                                          _recurrenceProperties,
                                          widget.events),
                                    ));
                              });
                        } else {
                          final List<Appointment> appointment = <Appointment>[];
                          if (widget.selectedAppointment != null) {
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment!]);
                          }
                          appointment.add(Appointment(
                            startTime: _startDate,
                            endTime: _endDate,
                            color: widget.colorCollection[_selectedColorIndex],
                            startTimeZone: _selectedTimeZoneIndex == 0
                                ? ''
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
                            endTimeZone: _selectedTimeZoneIndex == 0
                                ? ''
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
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
                                    _endDate),
                          ));
                          widget.events.appointments!.add(appointment[0]);

                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add, appointment);
                          Navigator.pop(context);
                        }
                      } else {
                        final List<Appointment> appointment = <Appointment>[];
                        if (widget.selectedAppointment != null) {
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(widget.selectedAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[widget.selectedAppointment!]);
                        }
                        appointment.add(Appointment(
                          startTime: _startDate,
                          endTime: _endDate,
                          color: widget.colorCollection[_selectedColorIndex],
                          startTimeZone: _selectedTimeZoneIndex == 0
                              ? ''
                              : widget
                                  .timeZoneCollection[_selectedTimeZoneIndex],
                          endTimeZone: _selectedTimeZoneIndex == 0
                              ? ''
                              : widget
                                  .timeZoneCollection[_selectedTimeZoneIndex],
                          notes: _notes,
                          isAllDay: _isAllDay,
                          subject: _subject == '' ? '(No title)' : _subject,
                          resourceIds: _resourceIds,
                          recurrenceRule: _rule == _SelectRule.doesNotRepeat ||
                                  _recurrenceProperties == null
                              ? null
                              : SfCalendar.generateRRule(
                                  _recurrenceProperties!, _startDate, _endDate),
                        ));

                        widget.events.appointments!.add(appointment[0]);

                        widget.events.notifyListeners(
                            CalendarDataSourceAction.add, appointment);
                        Navigator.pop(context);
                      }
                    })
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
                          : Colors.black87)
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
                              widget.events.appointments!.removeAt(widget
                                  .events.appointments!
                                  .indexOf(widget.selectedAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.selectedAppointment!]);
                              Navigator.pop(context);
                            } else {
                              showDialog<Widget>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async {
                                          return true;
                                        },
                                        child: Theme(
                                          data: widget.model.themeData,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          child: _DeleteDialog(
                                              widget.model,
                                              widget.selectedAppointment!,
                                              widget.events),
                                        ));
                                  });
                            }
                          }
                        },
                        backgroundColor: widget.model.backgroundColor,
                        child: const Icon(Icons.delete_outline,
                            color: Colors.white),
                      )));
  }

  /// Return the resource editor to edit the resource collection for an
  /// appointment
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources == null || _selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: widget.model.backgroundColor,
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds?.removeAt(i);
          _unSelectedResources = _getUnSelectedResources(
              _selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }
}

/// Returns the resource from the id passed.
CalendarResource _getResourceFromId(
    Object resourceId, List<CalendarResource> resourceCollection) {
  return resourceCollection
      .firstWhere((CalendarResource resource) => resource.id == resourceId);
}

/// Returns the selected resources based on the id collection passed
List<CalendarResource> _getSelectedResources(
    List<Object>? resourceIds, List<CalendarResource>? resourceCollection) {
  final List<CalendarResource> selectedResources = <CalendarResource>[];
  if (resourceIds == null ||
      resourceIds.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return selectedResources;
  }

  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName =
        _getResourceFromId(resourceIds[i], resourceCollection);
    selectedResources.add(resourceName);
  }

  return selectedResources;
}

/// Returns the available resource, by filtering the resource collection from
/// the selected resource collection.
List<CalendarResource> _getUnSelectedResources(
    List<CalendarResource>? selectedResources,
    List<CalendarResource>? resourceCollection) {
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
      this.model, this.recurrenceProperties, this.appointmentColor, this.events,
      {required this.onChanged, this.selectedAppointment});

  final SampleModel model;

  final Appointment? selectedAppointment;

  RecurrenceProperties? recurrenceProperties;

  final Color appointmentColor;

  final CalendarDataSource events;

  final _PickerChanged onChanged;

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

  /// Updates the required editor's default field
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
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(
            width: 360,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                RadioListTile<_SelectRule>(
                  title: const Text('Does not repeat'),
                  value: _SelectRule.doesNotRepeat,
                  groupValue: _rule,
                  toggleable: true,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = null;
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every day'),
                  value: _SelectRule.everyDay,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties =
                            RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType =
                            RecurrenceType.daily;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange =
                            RecurrenceRange.noEndDate;
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every week'),
                  value: _SelectRule.everyWeek,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties =
                            RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType =
                            RecurrenceType.weekly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange =
                            RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.weekDays = _startDate
                                    .weekday ==
                                1
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
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every month'),
                  value: _SelectRule.everyMonth,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties =
                            RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType =
                            RecurrenceType.monthly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange =
                            RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.dayOfMonth =
                            widget.selectedAppointment!.startTime.day;
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every year'),
                  value: _SelectRule.everyYear,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties =
                            RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType =
                            RecurrenceType.yearly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange =
                            RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.month =
                            widget.selectedAppointment!.startTime.month;
                        widget.recurrenceProperties!.dayOfMonth =
                            widget.selectedAppointment!.startTime.day;
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Custom'),
                  value: _SelectRule.custom,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) async {
                    final dynamic properties = await Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => _CustomRule(
                              widget.model,
                              widget.selectedAppointment!,
                              widget.appointmentColor,
                              widget.events,
                              widget.recurrenceProperties)),
                    );
                    if (properties != widget.recurrenceProperties) {
                      setState(() {
                        _rule = _SelectRule.custom;
                        widget.onChanged(
                            _PickerChangedDetails(selectedRule: _rule));
                      });
                    }
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context, properties);
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
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
    final Color defaultTextColor = widget.model.themeData != null &&
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: Text(
                    'Delete recurring event',
                    style: TextStyle(
                        color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<_Delete>(
                  title: const Text('This event'),
                  value: _Delete.event,
                  groupValue: _delete,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Delete? value) {
                    setState(() {
                      _delete = value!;
                    });
                  },
                ),
                RadioListTile<_Delete>(
                  title: const Text('All events'),
                  value: _Delete.series,
                  groupValue: _delete,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Delete? value) {
                    setState(() {
                      _delete = value!;
                    });
                  },
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
                            color: widget.model.backgroundColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        final Appointment? parentAppointment = widget.events
                            .getPatternAppointment(
                                widget.selectedAppointment, '') as Appointment?;
                        if (_delete == _Delete.event) {
                          if (widget.selectedAppointment.recurrenceId != null) {
                            widget.events.appointments!
                                .remove(widget.selectedAppointment);
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment!]);
                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!
                                  .add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates =
                                  <DateTime>[
                                  widget.selectedAppointment.startTime
                                ];
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                        } else {
                          if (parentAppointment!.recurrenceExceptionDates ==
                              null) {
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(parentAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment]);
                          } else {
                            final List<DateTime>? exceptionDates =
                                parentAppointment.recurrenceExceptionDates;
                            for (int i = 0; i < exceptionDates!.length; i++) {
                              final Appointment? changedOccurrence =
                                  widget.events.getOccurrenceAppointment(
                                      parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!
                                    .remove(changedOccurrence);
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[changedOccurrence]);
                              }
                            }
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(parentAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment]);
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: widget.model.backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog(this.model, this.newAppointment, this.selectedAppointment,
      this.recurrenceProperties, this.events);

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
    final Color defaultTextColor = widget.model.themeData != null &&
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: Text(
                    'Save recurring event',
                    style: TextStyle(
                        color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<_Edit>(
                  title: const Text('This event'),
                  value: _Edit.event,
                  groupValue: _edit,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
                ),
                RadioListTile<_Edit>(
                  title: const Text('All events'),
                  value: _Edit.series,
                  groupValue: _edit,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
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
                            color: widget.model.backgroundColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        if (_edit == _Edit.event) {
                          final Appointment? parentAppointment = widget.events
                                  .getPatternAppointment(
                                      widget.selectedAppointment, '')
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
                              id: widget.selectedAppointment.appointmentType ==
                                      AppointmentType.changedOccurrence
                                  ? widget.selectedAppointment.id
                                  : null,
                              recurrenceId: parentAppointment!.id,
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);

                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!
                                  .add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates =
                                  <DateTime>[
                                  widget.selectedAppointment.startTime
                                ];
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment]);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                          if (widget.selectedAppointment.appointmentType ==
                              AppointmentType.changedOccurrence) {
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.add(newAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[newAppointment]);
                        } else {
                          Appointment? parentAppointment = widget.events
                                  .getPatternAppointment(
                                      widget.selectedAppointment, '')
                              as Appointment?;
                          final List<DateTime>? exceptionDates =
                              parentAppointment!.recurrenceExceptionDates;
                          if (exceptionDates != null &&
                              exceptionDates.isNotEmpty) {
                            for (int i = 0; i < exceptionDates.length; i++) {
                              final Appointment? changedOccurrence =
                                  widget.events.getOccurrenceAppointment(
                                      parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!
                                    .remove(changedOccurrence);
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[changedOccurrence]);
                              }
                            }
                          }

                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment]);
                          DateTime startDate, endDate;
                          if (widget.newAppointment.startTime
                              .isBefore(parentAppointment.startTime)) {
                            startDate = widget.newAppointment.startTime;
                            endDate = widget.newAppointment.endTime;
                          } else {
                            startDate = DateTime(
                                parentAppointment.startTime.year,
                                parentAppointment.startTime.month,
                                parentAppointment.startTime.day,
                                widget.newAppointment.startTime.hour,
                                widget.newAppointment.startTime.minute);
                            endDate = DateTime(
                                parentAppointment.endTime.year,
                                parentAppointment.endTime.month,
                                parentAppointment.endTime.day,
                                widget.newAppointment.endTime.hour,
                                widget.newAppointment.endTime.minute);
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
                                          endDate),
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: widget.model.backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown list items for mobile recurrenceType
List<String> _mobileRecurrence = <String>['day', 'week', 'month', 'year'];

enum _EndRule { never, endDate, count }

/// Dropdown list items for week number of the month.
List<String> _weekDayPosition = <String>[
  'first',
  'second',
  'third',
  'fourth',
  'last'
];

class _CustomRule extends StatefulWidget {
  const _CustomRule(this.model, this.selectedAppointment, this.appointmentColor,
      this.events, this.recurrenceProperties);

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
    _weekNumberDay = _weekDayPosition[_weekNumber == -1 ? 4 : _weekNumber - 1] +
        ' ' +
        _weekDay[_dayOfWeek - 1];
    if (_days == null) {
      _mobileInitialWeekdays(_startDate.weekday);
    }
    final Appointment? parentAppointment = widget.events
        .getPatternAppointment(widget.selectedAppointment, '') as Appointment?;
    if (parentAppointment == null) {
      _firstDate = _startDate;
    } else {
      _firstDate = parentAppointment.startTime;
    }
    _recurrenceProperties = widget.selectedAppointment.recurrenceRule != null &&
            widget.selectedAppointment.recurrenceRule!.isNotEmpty
        ? SfCalendar.parseRRule(
            widget.selectedAppointment.recurrenceRule!, _firstDate)
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
    _selectedDate = _recurrenceProperties!.endDate ??
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
    const TextStyle textStyle =
        TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.width + 60;
  }

  Widget _getCustomRule(
      BuildContext context, Color backgroundColor, Color defaultColor) {
    final Color defaultTextColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    final Color defaultButtonColor = widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    return Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 20,
            ),
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
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: TextField(
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: _interval.toString(),
                              selection: TextSelection.collapsed(
                                  offset: _interval.toString().length))),
                      cursorColor: widget.model.backgroundColor,
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
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Container(
                    height: 40,
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        underline: Container(),
                        style: TextStyle(
                            fontSize: 13,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w400),
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
                        }),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
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
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 15, top: 5),
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
                                backgroundColor:
                                    _days!.contains(WeekDays.sunday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.sunday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.monday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.monday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.tuesday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.tuesday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.wednesday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.wednesday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.thursday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.thursday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.friday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.friday)
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
                                backgroundColor:
                                    _days!.contains(WeekDays.saturday)
                                        ? widget.model.backgroundColor
                                        : defaultButtonColor,
                                foregroundColor:
                                    _days!.contains(WeekDays.saturday)
                                        ? Colors.white
                                        : defaultTextColor,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                              ),
                              child: const Text('S'),
                            ),
                          ],
                        )),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                )),
            Visibility(
              visible: _selectedRecurrenceType == 'month',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: _width,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.all(15),
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        underline: Container(),
                        style: TextStyle(
                            fontSize: 13,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w400),
                        value: _monthlyRule,
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'Monthly on day ' +
                                _startDate.day.toString() +
                                'th',
                            child: Text('Monthly on day ' +
                                _startDate.day.toString() +
                                'th'),
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
                              _width = _textSize('Monthly on day ' +
                                  _startDate.day.toString() +
                                  'th');
                              _monthlyDay();
                            } else if (value ==
                                'Monthly on the ' + _weekNumberDay!) {
                              _width = _textSize(
                                  'Monthly on the ' + _weekNumberDay!);
                              _monthlyWeek();
                            } else if (value == 'Last day of month') {
                              _width = _textSize('Last day of month');
                              _lastDayOfMonth();
                            }
                          });
                        }),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _selectedRecurrenceType == 'year',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    focusColor: widget.model.backgroundColor,
                    activeColor: widget.model.backgroundColor,
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
                  const Text(
                    'Last day of month',
                  ),
                ],
              ),
            ),
            if (_selectedRecurrenceType == 'year')
              const Divider(
                thickness: 1,
              ),
            Column(
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
                  groupValue: _endRule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_EndRule? value) {
                    setState(() {
                      _endRule = _EndRule.never;
                      _rangeNoEndDate();
                    });
                  },
                ),
                const Divider(
                  indent: 50,
                  height: 1.0,
                  thickness: 1,
                ),
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
                          color: Colors.grey.withOpacity(0.1),
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
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: _selectedDate,
                                          firstDate:
                                              _startDate.isBefore(_firstDate)
                                                  ? _startDate
                                                  : _firstDate,
                                          currentDate: _selectedDate,
                                          lastDate: DateTime(2050),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: ThemeData(
                                                  brightness: widget
                                                      .model
                                                      .themeData
                                                      .colorScheme
                                                      .brightness,
                                                  colorScheme: _getColorScheme(
                                                      widget.model, true),
                                                  primaryColor: widget
                                                      .model.backgroundColor),
                                              child: child!,
                                            );
                                          });
                                  if (pickedDate == null) {
                                    return;
                                  }
                                  setState(() {
                                    _endRule = _EndRule.endDate;
                                    _recurrenceProperties!.recurrenceRange =
                                        RecurrenceRange.endDate;
                                    _selectedDate = DateTime(pickedDate.year,
                                        pickedDate.month, pickedDate.day);
                                    _recurrenceProperties!.endDate =
                                        _selectedDate;
                                  });
                                },
                                shape: const CircleBorder(),
                                child: Text(
                                  DateFormat('MM/dd/yyyy')
                                      .format(_selectedDate),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400),
                                ))),
                      ),
                    ],
                  ),
                  value: _EndRule.endDate,
                  groupValue: _endRule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_EndRule? value) {
                    setState(() {
                      _endRule = value;
                      _rangeEndDate();
                    });
                  },
                ),
                const Divider(
                  indent: 50,
                  height: 1.0,
                  thickness: 1,
                ),
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
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextField(
                            readOnly: _endRule != _EndRule.count,
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: _count.toString(),
                                    selection: TextSelection.collapsed(
                                        offset: _count.toString().length))),
                            cursorColor: widget.model.backgroundColor,
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
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(
                                fontSize: 13,
                                color: defaultTextColor,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text('occurrence'),
                      ],
                    ),
                    value: _EndRule.count,
                    groupValue: _endRule,
                    activeColor: widget.model.backgroundColor,
                    onChanged: (_EndRule? value) {
                      setState(() {
                        _endRule = value;
                        _recurrenceProperties!.recurrenceRange =
                            RecurrenceRange.count;
                        _recurrenceProperties!.recurrenceCount = _count!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.model.themeData,
        child: Scaffold(
          backgroundColor: widget.model.themeData != null &&
                  widget.model.themeData.colorScheme.brightness ==
                      Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
          appBar: AppBar(
            title: const Text('Custom Recurrence'),
            backgroundColor: widget.appointmentColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, widget.recurrenceProperties);
              },
            ),
            actions: <Widget>[
              IconButton(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, _recurrenceProperties);
                  })
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
                        : Colors.black87)
              ],
            ),
          ),
        ));
  }
}

bool _canAddRecurrenceAppointment(
    List<DateTime> visibleDates,
    CalendarDataSource dataSource,
    Appointment occurrenceAppointment,
    DateTime startTime) {
  final Appointment parentAppointment = dataSource.getPatternAppointment(
      occurrenceAppointment, '')! as Appointment;
  final List<DateTime> recurrenceDates =
      SfCalendar.getRecurrenceDateTimeCollection(
          parentAppointment.recurrenceRule ?? '', parentAppointment.startTime,
          specificStartDate: visibleDates[0],
          specificEndDate: visibleDates[visibleDates.length - 1]);

  for (int i = 0; i < dataSource.appointments!.length; i++) {
    final Appointment calendarApp = dataSource.appointments![i] as Appointment;
    if (calendarApp.recurrenceId != null &&
        calendarApp.recurrenceId == parentAppointment.id) {
      recurrenceDates.add(calendarApp.startTime);
    }
  }

  if (parentAppointment.recurrenceExceptionDates != null) {
    for (int i = 0;
        i < parentAppointment.recurrenceExceptionDates!.length;
        i++) {
      recurrenceDates.remove(parentAppointment.recurrenceExceptionDates![i]);
    }
  }

  recurrenceDates.sort();
  bool canAddRecurrence =
      isSameDate(occurrenceAppointment.startTime, startTime);
  if (!_isDateInDateCollection(recurrenceDates, startTime)) {
    final int currentRecurrenceIndex =
        recurrenceDates.indexOf(occurrenceAppointment.startTime);
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
      canAddRecurrence = (isDateWithInDateRange(
                  previousRecurrence, nextRecurrence, startTime) &&
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
