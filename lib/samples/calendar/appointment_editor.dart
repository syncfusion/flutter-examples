///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';
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

class _CalendarAppointmentEditorState extends SampleViewState {
  _CalendarAppointmentEditorState();

  late List<String> _subjectCollection;
  late List<Appointment> _appointments;
  late bool _isMobile;

  late List<Color> _colorCollection;
  late List<String> _colorNames;
  int _selectedColorIndex = 0;
  late List<String> _timeZoneCollection;
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
    final Widget _calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getAppointmentEditorCalendar(calendarController, _events,
            _onCalendarTapped, _onViewChanged, scheduleViewBuilder));
    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: calendarController.view == CalendarView.month &&
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
        final bool _isAppointmentTapped =
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
                    ?.addPostFrameCallback((Duration duration) {
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
                        width: _isAppointmentTapped ? 400 : 500,
                        height: _isAppointmentTapped
                            ? _selectedAppointment!.location == null ||
                                    _selectedAppointment!.location!.isEmpty
                                ? 150
                                : 200
                            : 390,
                        child: Theme(
                            data: model.themeData,
                            child: Card(
                              margin: const EdgeInsets.all(0.0),
                              color: model.themeData != null &&
                                      model.themeData.brightness ==
                                          Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: _isAppointmentTapped
                                  ? displayAppointmentDetails(
                                      context,
                                      targetElement,
                                      selectedDate,
                                      model,
                                      _selectedAppointment!,
                                      _colorCollection,
                                      _colorNames,
                                      _events,
                                      _timeZoneCollection)
                                  : PopUpAppointmentEditor(
                                      model,
                                      newAppointment,
                                      appointment,
                                      _events,
                                      _colorCollection,
                                      _colorNames,
                                      _selectedAppointment!,
                                      _timeZoneCollection),
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
            isAllDay: false,
            subject: _subjectCollection[random.nextInt(7)],
          ));
        }
      }
    }

    return appointmentCollection;
  }

  /// Returns the calendar based on the properties passed.
  SfCalendar _getAppointmentEditorCalendar(
      [CalendarController? _calendarController,
      CalendarDataSource? _calendarDataSource,
      dynamic calendarTapCallback,
      ViewChangedCallback? viewChangedCallback,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
        controller: _calendarController,
        showNavigationArrow: model.isWebFullView,
        allowedViews: _allowedViews,
        showDatePickerButton: true,
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        onViewChanged: viewChangedCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 4),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }
}

/// Signature for callback which reports the picker value changed
typedef _PickerChanged = void Function(
    _PickerChangedDetails pickerChangedDetails);

/// Details for the [_PickerChanged].
class _PickerChangedDetails {
  _PickerChangedDetails({this.index = -1, this.resourceId});

  final int index;

  final Object? resourceId;
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
      return DateFormat('EEEE, MMM dd')
          .format(selectedAppointment.startTime)
          .toString();
    }
    return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('EEEE, MMM dd')
            .format(selectedAppointment.endTime)
            .toString();
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
    List<String> timeZoneCollection) {
  final Color defaultColor =
      model.themeData != null && model.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;

  final Color defaultTextColor =
      model.themeData != null && model.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;

  final List<Appointment> appointmentCollection = <Appointment>[];

  return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
    ListTile(
        trailing: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
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
                        // ignore: prefer_const_literals_to_create_immutables
                        child: AppointmentEditorWeb(
                            model,
                            selectedAppointment,
                            colorCollection,
                            colorNames,
                            events,
                            timeZoneCollection,
                            appointmentCollection),
                      ));
                });
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: defaultColor),
          onPressed: () {
            events.appointments!
                .removeAt(events.appointments!.indexOf(selectedAppointment));
            events.notifyListeners(CalendarDataSourceAction.remove,
                <Appointment>[selectedAppointment]);
            Navigator.pop(context);
          },
        ),
        IconButton(
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
        content: Container(
            width: kIsWeb ? 500 : double.maxFinite,
            height: (widget.colorCollection.length * 50).toDouble(),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: widget.colorCollection.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
          content: Container(
              width: kIsWeb ? 500 : double.maxFinite,
              height: (widget.resourceCollection.length * 50).toDouble(),
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: widget.resourceCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  final CalendarResource resource =
                      widget.resourceCollection[index];
                  return Container(
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
          content: Container(
              width: kIsWeb ? 500 : double.maxFinite,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: widget.timeZoneCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
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
      this.timeZoneCollection);

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

  /// Colllection list of time zones
  final List<String> timeZoneCollection;

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
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Color defaultTextColor = widget.model.themeData != null &&
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    final Widget _startDatePicker = RawMaterialButton(
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
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model, true),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(date.year, date.month, date.day,
                _startTime.hour, _startTime.minute, 0);
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

    final Widget _startTimePicker = RawMaterialButton(
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
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model, false),
                  accentColor: widget.model.backgroundColor,
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
                _startDate.day, _startTime.hour, _startTime.minute, 0);
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

    final Widget _endTimePicker = RawMaterialButton(
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
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model, false),
                  accentColor: widget.model.backgroundColor,
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
                _endTime.hour, _endTime.minute, 0);
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

    final Widget _endDatePicker = RawMaterialButton(
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
                  brightness: widget.model.themeData.brightness,
                  colorScheme: _getColorScheme(widget.model, true),
                  accentColor: widget.model.backgroundColor,
                  primaryColor: widget.model.backgroundColor,
                ),
                child: child!,
              );
            });

        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _endDate = DateTime(date.year, date.month, date.day, _endTime.hour,
                _endTime.minute, 0);
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

    return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
      Container(
          height: 50,
          child: ListTile(
            trailing: IconButton(
              icon: Icon(Icons.close, color: defaultColor),
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
                        color: widget.model.backgroundColor,
                        width: 2.0,
                        style: BorderStyle.solid)),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        _startDatePicker,
                        const Text(' - '),
                        _endDatePicker,
                        const Text(''),
                        const Text(''),
                      ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        _startDatePicker,
                        _startTimePicker,
                        const Text(' - '),
                        _endTimePicker,
                        _endDatePicker,
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
                    barrierDismissible: true,
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
                  barrierDismissible: true,
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
      Container(
          height: 50,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                    widget.newAppointment),
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
        padding: const EdgeInsets.only(left: 0),
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
      [this.newAppointment]);

  /// Current sample model
  final SampleModel model;

  /// new appointment calue
  final Appointment? newAppointment;

  /// List of appointments
  final List<Appointment> appointment;

  /// Selcted appointment value
  final Appointment selectedAppointment;

  /// List of colors
  final List<Color> colorCollection;

  /// Collection of color names
  final List<String> colorNames;

  /// Holds the Events values
  final CalendarDataSource events;

  /// Collection of time zones
  final List<String> timeZoneCollection;

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
        padding: const EdgeInsets.only(left: 0),
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
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Color defaultTextColor = widget.model.themeData != null &&
            widget.model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: widget.model.themeData != null &&
                  widget.model.themeData.brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
        ),
        height: widget.events.resources != null &&
                widget.events.resources!.isNotEmpty
            ? _isTimeZoneEnabled
                ? 560
                : 500
            : _isTimeZoneEnabled
                ? 480
                : 420,
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.all(0.0),
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
                child: ListTile(
                    title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 2, bottom: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  focusColor: widget.model.backgroundColor,
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget.model.backgroundColor,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                        color: widget.model.backgroundColor,
                                        width: 2.0,
                                        style: BorderStyle.solid)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ))),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: ListTile(
                    title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          ? DateFormat('dd/MM/yyyy')
                                          : DateFormat('dd/MM/yy h:mm a'))
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
                                suffix: Container(
                                  height: 20,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                      initialDate: _startDate,
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2100),
                                                      builder:
                                                          (BuildContext context,
                                                              Widget? child) {
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
                                                              accentColor: widget
                                                                  .model
                                                                  .backgroundColor,
                                                              primaryColor: widget
                                                                  .model
                                                                  .backgroundColor),
                                                          child: child!,
                                                        );
                                                      });

                                              if (date != null &&
                                                  date != _startDate) {
                                                setState(() {
                                                  final Duration difference =
                                                      _endDate.difference(
                                                          _startDate);
                                                  _startDate = DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      _startTime.hour,
                                                      _startTime.minute,
                                                      0);
                                                  _endDate = _startDate
                                                      .add(difference);
                                                  _endTime = TimeOfDay(
                                                      hour: _endDate.hour,
                                                      minute: _endDate.minute);
                                                });
                                              }
                                            },
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(0.0),
                                            child: Icon(
                                              Icons.date_range,
                                              color: defaultColor,
                                              size: 20,
                                            ),
                                          )),
                                      if (_isAllDay)
                                        const Text('')
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
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              onPressed: () async {
                                                final TimeOfDay? time =
                                                    await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay(
                                                            hour:
                                                                _startTime.hour,
                                                            minute: _startTime
                                                                .minute),
                                                        builder: (BuildContext
                                                                context,
                                                            Widget? child) {
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
                                                                      false),
                                                              accentColor: widget
                                                                  .model
                                                                  .backgroundColor,
                                                              primaryColor: widget
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
                                                    final Duration difference =
                                                        _endDate.difference(
                                                            _startDate);
                                                    _startDate = DateTime(
                                                        _startDate.year,
                                                        _startDate.month,
                                                        _startDate.day,
                                                        _startTime.hour,
                                                        _startTime.minute,
                                                        0);
                                                    _endDate = _startDate
                                                        .add(difference);
                                                    _endTime = TimeOfDay(
                                                        hour: _endDate.hour,
                                                        minute:
                                                            _endDate.minute);
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
                                        color: widget.model.backgroundColor,
                                        width: 2.0,
                                        style: BorderStyle.solid)),
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          ? DateFormat('dd/MM/yyyy')
                                          : DateFormat('dd/MM/yy h:mm a'))
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
                                suffix: Container(
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
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () async {
                                              final DateTime? date =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate: _endDate,
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2100),
                                                      builder:
                                                          (BuildContext context,
                                                              Widget? child) {
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
                                                            accentColor: widget
                                                                .model
                                                                .backgroundColor,
                                                            primaryColor: widget
                                                                .model
                                                                .backgroundColor,
                                                          ),
                                                          child: child!,
                                                        );
                                                      });

                                              if (date != null &&
                                                  date != _endDate) {
                                                setState(() {
                                                  final Duration difference =
                                                      _endDate.difference(
                                                          _startDate);
                                                  _endDate = DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      _endTime.hour,
                                                      _endTime.minute,
                                                      0);
                                                  if (_endDate
                                                      .isBefore(_startDate)) {
                                                    _startDate = _endDate
                                                        .subtract(difference);
                                                    _startTime = TimeOfDay(
                                                        hour: _startDate.hour,
                                                        minute:
                                                            _startDate.minute);
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
                                        const Text('')
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
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () async {
                                                final TimeOfDay? time =
                                                    await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay(
                                                            hour: _endTime.hour,
                                                            minute: _endTime
                                                                .minute),
                                                        builder: (BuildContext
                                                                context,
                                                            Widget? child) {
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
                                                                      false),
                                                              accentColor: widget
                                                                  .model
                                                                  .backgroundColor,
                                                              primaryColor: widget
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
                                                    final Duration difference =
                                                        _endDate.difference(
                                                            _startDate);
                                                    _endDate = DateTime(
                                                        _endDate.year,
                                                        _endDate.month,
                                                        _endDate.day,
                                                        _endTime.hour,
                                                        _endTime.minute,
                                                        0);
                                                    if (_endDate
                                                        .isBefore(_startDate)) {
                                                      _startDate = _endDate
                                                          .subtract(difference);
                                                      _startTime = TimeOfDay(
                                                          hour: _startDate.hour,
                                                          minute: _startDate
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
                                        color: widget.model.backgroundColor,
                                        width: 2.0,
                                        style: BorderStyle.solid)),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                  child: ListTile(
                contentPadding: const EdgeInsets.only(
                    left: 20, top: 2, bottom: 2, right: 305),
                title: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: defaultColor.withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: RawMaterialButton(
                        padding: const EdgeInsets.only(left: 5.0),
                        onPressed: () {
                          showDialog<Widget>(
                            context: context,
                            barrierDismissible: true,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.timeZoneCollection[_selectedTimeZoneIndex],
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
              ))
            else
              Container(),
            if (widget.events.resources == null ||
                widget.events.resources!.isEmpty)
              Container()
            else
              Container(
                  child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
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
                              width: 1.0,
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
                    barrierDismissible: true,
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
              )),
            Container(
                child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                        ),
                      )),
                ],
              ),
            )),
            Container(
                child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    title: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: defaultColor.withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.lens,
                            size: 20,
                            color: widget.colorCollection[_selectedColorIndex],
                          ),
                          Expanded(
                            child: RawMaterialButton(
                              padding: const EdgeInsets.only(left: 5),
                              onPressed: () {
                                showDialog<Widget>(
                                  context: context,
                                  barrierDismissible: true,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    widget.colorNames[_selectedColorIndex],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400),
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
                    ))),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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
                                resourceIds: _resourceIds));

                            widget.events.appointments!
                                .add(widget.appointment[0]);

                            widget.events.notifyListeners(
                                CalendarDataSourceAction.add,
                                widget.appointment);

                            Navigator.pop(context);
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
}

/// Returns color scheme based on dark and light theme.
ColorScheme _getColorScheme(SampleModel model, bool isDatePicker) {
  /// For time picker used the default surface color based for corresponding
  /// theme, so that the picker background color doesn't cover with the model's
  /// background color.
  if (model.themeData.brightness == Brightness.dark) {
    return ColorScheme.dark(
      primary: model.backgroundColor,
      surface: isDatePicker ? model.backgroundColor : Colors.grey[850]!,
    );
  }

  return ColorScheme.light(
    primary: model.backgroundColor,
    surface: isDatePicker ? model.backgroundColor : Colors.white,
  );
}

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
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  Widget _getAppointmentEditor(
      BuildContext context, Color backgroundColor, Color defaultColor) {
    return Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(0),
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
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                          widget.model.themeData.brightness,
                                      colorScheme:
                                          _getColorScheme(widget.model, true),
                                      accentColor: widget.model.backgroundColor,
                                      primaryColor:
                                          widget.model.backgroundColor,
                                    ),
                                    child: child!,
                                  );
                                });

                            if (date != null && date != _startDate) {
                              setState(() {
                                final Duration difference =
                                    _endDate.difference(_startDate);
                                _startDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    _startTime.hour,
                                    _startTime.minute,
                                    0);
                                _endDate = _startDate.add(difference);
                                _endTime = TimeOfDay(
                                    hour: _endDate.hour,
                                    minute: _endDate.minute);
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
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _startTime.hour,
                                                minute: _startTime.minute),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data: ThemeData(
                                                  brightness: widget.model
                                                      .themeData.brightness,
                                                  colorScheme: _getColorScheme(
                                                      widget.model, false),
                                                  accentColor: widget
                                                      .model.backgroundColor,
                                                  primaryColor: widget
                                                      .model.backgroundColor,
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
                                            _startTime.minute,
                                            0);
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
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                          widget.model.themeData.brightness,
                                      colorScheme:
                                          _getColorScheme(widget.model, true),
                                      accentColor: widget.model.backgroundColor,
                                      primaryColor:
                                          widget.model.backgroundColor,
                                    ),
                                    child: child!,
                                  );
                                });

                            if (date != null && date != _endDate) {
                              setState(() {
                                final Duration difference =
                                    _endDate.difference(_startDate);
                                _endDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    _endTime.hour,
                                    _endTime.minute,
                                    0);
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
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _endTime.hour,
                                                minute: _endTime.minute),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data: ThemeData(
                                                  brightness: widget.model
                                                      .themeData.brightness,
                                                  colorScheme: _getColorScheme(
                                                      widget.model, false),
                                                  accentColor: widget
                                                      .model.backgroundColor,
                                                  primaryColor: widget
                                                      .model.backgroundColor,
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
                                            _endTime.minute,
                                            0);
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
                  barrierDismissible: true,
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
                    barrierDismissible: true,
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
                  barrierDismissible: true,
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
                    widget.model.themeData.brightness == Brightness.dark
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
                          resourceIds: _resourceIds));

                      widget.events.appointments!.add(appointment[0]);

                      widget.events.notifyListeners(
                          CalendarDataSourceAction.add, appointment);
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[
                  _getAppointmentEditor(
                      context,
                      (widget.model.themeData.brightness == Brightness.dark
                          ? Colors.grey[850]
                          : Colors.white)!,
                      widget.model.themeData.brightness != null &&
                              widget.model.themeData.brightness ==
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
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment!]);
                            Navigator.pop(context);
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
        padding: const EdgeInsets.only(left: 0),
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
  final List<CalendarResource> _selectedResources = <CalendarResource>[];
  if (resourceIds == null ||
      resourceIds.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return _selectedResources;
  }

  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName =
        _getResourceFromId(resourceIds[i], resourceCollection);
    _selectedResources.add(resourceName);
  }

  return _selectedResources;
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
