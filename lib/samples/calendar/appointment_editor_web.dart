/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local import.
import '../../model/model.dart';
import 'appointment_editor.dart';
import 'calendar_pickers.dart';

/// Dropdown list items for recurrenceType.
List<String> _repeatOption = <String>[
  'Never',
  'Daily',
  'Weekly',
  'Monthly',
  'Yearly',
];

/// Dropdown list items for day of week.
List<String> weekDay = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Dropdown list items for end range.
List<String> _ends = <String>['Never', 'Until', 'Count'];

/// Dropdown list items for months of year.
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
  'December',
];

/// Dropdown list items for week number of the month.
List<String> _daysPosition = <String>[
  'First',
  'Second',
  'Third',
  'Fourth',
  'Last',
];

/// To edit the series which has the exception appointments, and allows
/// to edit and cancel the edit series action.
Widget _editExceptionSeries(
  BuildContext context,
  SampleModel model,
  Appointment selectedAppointment,
  Appointment recurrenceAppointment,
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
      height: 200,
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
                    'Alert',
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
            height: 80,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Do you want to cancel the changes made to specific instances of this series and match it to the whole series again?',
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
                  Navigator.pop(context);
                  final List<DateTime>? exceptionDates =
                      selectedAppointment.recurrenceExceptionDates;
                  for (int i = 0; i < exceptionDates!.length; i++) {
                    final Appointment? changedOccurrence = events
                        .getOccurrenceAppointment(
                          selectedAppointment,
                          exceptionDates[i],
                          '',
                        );
                    if (changedOccurrence != null) {
                      events.appointments!.removeAt(
                        events.appointments!.indexOf(changedOccurrence),
                      );
                      events.notifyListeners(
                        CalendarDataSourceAction.remove,
                        <Appointment>[changedOccurrence],
                      );
                    }
                  }
                  events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment),
                  );
                  events.notifyListeners(
                    CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment],
                  );
                  events.appointments!.add(recurrenceAppointment);
                  events.notifyListeners(
                    CalendarDataSourceAction.add,
                    <Appointment>[recurrenceAppointment],
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'YES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(width: 20),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  recurrenceAppointment.recurrenceExceptionDates =
                      selectedAppointment.recurrenceExceptionDates;
                  recurrenceAppointment.recurrenceRule =
                      selectedAppointment.recurrenceRule;
                  events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment),
                  );
                  events.notifyListeners(
                    CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment],
                  );
                  events.appointments!.add(recurrenceAppointment);
                  events.notifyListeners(
                    CalendarDataSourceAction.add,
                    <Appointment>[recurrenceAppointment],
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'NO',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: defaultTextColor,
                  ),
                ),
              ),
              Container(width: 20),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
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

/// Builds the appointment editor with all the required elements in a pop-up
/// based on the tapped Calendar element.
class AppointmentEditorWeb extends StatefulWidget {
  /// Holds the information of appointments.
  const AppointmentEditorWeb(
    this.model,
    this.selectedAppointment,
    this.colorCollection,
    this.colorNames,
    this.events,
    this.timeZoneCollection,
    this.appointment,
    this.visibleDates, [
    this.newAppointment,
  ]);

  /// Current sample model.
  final SampleModel model;

  /// New appointment value.
  final Appointment? newAppointment;

  /// List of appointments.
  final List<Appointment> appointment;

  /// Selected appointment value.
  final Appointment selectedAppointment;

  /// List of colors.
  final List<Color> colorCollection;

  /// Collection of color names.
  final List<String> colorNames;

  /// Holds the events values.
  final CalendarDataSource events;

  /// Collection of time zones.
  final List<String> timeZoneCollection;

  /// The visible dates collection.
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
  IconData? _monthDayRadio;
  IconData? _weekDayRadio;
  IconData? _lastDayRadio;
  Color? _weekIconColor;
  Color? _monthIconColor;
  Color? _lastDayIconColor;
  String? _monthName;
  String? _weekNumberText;
  String? _dayOfWeekText;

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

  /// Updates the required editor's default field.
  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment.startTime;
    _endDate = widget.selectedAppointment.endTime;
    _isAllDay = widget.selectedAppointment.isAllDay;
    _selectedColorIndex = widget.colorCollection.indexOf(
      widget.selectedAppointment.color,
    );
    _selectedTimeZoneIndex =
        widget.selectedAppointment.startTimeZone == null ||
            widget.selectedAppointment.startTimeZone == ''
        ? 0
        : widget.timeZoneCollection.indexOf(
            widget.selectedAppointment.startTimeZone!,
          );
    _subject = widget.selectedAppointment.subject == '(No title)'
        ? ''
        : widget.selectedAppointment.subject;
    _notes = widget.selectedAppointment.notes;
    _location = widget.selectedAppointment.location;
    _selectedColorIndex = _selectedColorIndex == -1 ? 0 : _selectedColorIndex;
    _selectedTimeZoneIndex = _selectedTimeZoneIndex == -1
        ? 0
        : _selectedTimeZoneIndex;
    _resourceIds = widget.selectedAppointment.resourceIds?.sublist(0);
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _isTimeZoneEnabled =
        widget.selectedAppointment.startTimeZone != null &&
        widget.selectedAppointment.startTimeZone!.isNotEmpty;
    _selectedResources = getSelectedResources(
      _resourceIds,
      widget.events.resources,
    );
    _unSelectedResources = getUnSelectedResources(
      _selectedResources,
      widget.events.resources,
    );
    _selectedDate = _startDate.add(const Duration(days: 30));
    _firstDate = _startDate;
    _month = _startDate.month;
    _monthName = _dayMonths[_month! - 1];
    _dayOfMonth = _startDate.day;
    _weekNumber = _getWeekNumber(_startDate);
    _weekNumberText = _daysPosition[_weekNumber == -1 ? 4 : _weekNumber - 1];
    _dayOfWeek = _startDate.weekday;
    _dayOfWeekText = weekDay[_dayOfWeek - 1];
    if (_days == null) {
      _webInitialWeekdays(_startDate.weekday);
    }
    _recurrenceProperties =
        widget.selectedAppointment.recurrenceRule != null &&
            widget.selectedAppointment.recurrenceRule!.isNotEmpty
        ? SfCalendar.parseRRule(
            widget.selectedAppointment.recurrenceRule!,
            _startDate,
          )
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
    _selectedDate =
        _recurrenceProperties!.endDate ??
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
      _dayOfWeekText = weekDay[_dayOfWeek - 1];
      _recurrenceProperties!.week = _weekNumber;
      _recurrenceProperties!.dayOfWeek = _dayOfWeek;
      _monthIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _weekIconColor = widget.model.primaryColor;
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
      _weekIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _monthIconColor = widget.model.primaryColor;
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
      _monthIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _weekIconColor =
          widget.model.themeData != null &&
              widget.model.themeData.colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;
      _lastDayIconColor = widget.model.primaryColor;
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
  /// appointment.
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 5),
        child: Text('Add people', style: hintTextStyle),
      );
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
            _resourceIds!.removeAt(i);
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

  @override
  Widget build(BuildContext context) {
    final Color defaultColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;
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
    final Color borderColor =
        widget.model.themeData != null &&
            widget.model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.transparent;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color:
              widget.model.themeData != null &&
                  widget.model.themeData.colorScheme.brightness ==
                      Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
        ),
        height:
            widget.events.resources != null &&
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
                          color: defaultTextColor,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: defaultColor),
                        onPressed: () {
                          if (widget.newAppointment != null &&
                              widget.events.appointments!.contains(
                                widget.newAppointment,
                              )) {
                            /// To remove the created appointment when the pop-up closed
                            /// without saving the appointment.
                            widget.events.appointments!.removeAt(
                              widget.events.appointments!.indexOf(
                                widget.newAppointment,
                              ),
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[widget.newAppointment!],
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
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
                              left: 5,
                              right: 5,
                              top: 2,
                              bottom: 2,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Title',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: defaultColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: widget.model.primaryColor,
                                  controller: TextEditingController(
                                    text: _subject,
                                  ),
                                  onChanged: (String value) {
                                    _subject = value;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: defaultTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    focusColor: widget.model.primaryColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: widget.model.primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
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
                              left: 5,
                              right: 5,
                              top: 2,
                              bottom: 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: defaultColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                TextField(
                                  controller: TextEditingController(
                                    text: _location,
                                  ),
                                  cursorColor: widget.model.primaryColor,
                                  onChanged: (String value) {
                                    _location = value;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: defaultTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    focusColor: widget.model.primaryColor,
                                    isDense: true,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: widget.model.primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                left: 5,
                                right: 5,
                                top: 5,
                                bottom: 2,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: defaultColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text:
                                          (_isAllDay
                                                  ? DateFormat('MM/dd/yyyy')
                                                  : DateFormat(
                                                      'MM/dd/yy h:mm a',
                                                    ))
                                              .format(_startDate),
                                    ),
                                    onChanged: (String value) {
                                      _startDate = DateTime.parse(value);
                                      _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute,
                                      );
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                                  final DateTime?
                                                  date = await showDatePicker(
                                                    context: context,
                                                    initialDate: _startDate,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100),
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                          Widget? child,
                                                        ) {
                                                          return Theme(
                                                            data: ThemeData(
                                                              useMaterial3:
                                                                  false,
                                                              brightness: widget
                                                                  .model
                                                                  .themeData
                                                                  .brightness,
                                                              colorScheme:
                                                                  getColorScheme(
                                                                    widget
                                                                        .model,
                                                                    true,
                                                                  ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                  );
                                                  if (date != null &&
                                                      date != _startDate) {
                                                    setState(() {
                                                      final Duration
                                                      difference = _endDate
                                                          .difference(
                                                            _startDate,
                                                          );
                                                      _startDate = DateTime(
                                                        date.year,
                                                        date.month,
                                                        date.day,
                                                        _startTime.hour,
                                                        _startTime.minute,
                                                      );
                                                      _endDate = _startDate.add(
                                                        difference,
                                                      );
                                                      _endTime = TimeOfDay(
                                                        hour: _endDate.hour,
                                                        minute: _endDate.minute,
                                                      );
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
                                              ),
                                            ),
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
                                                    final TimeOfDay?
                                                    time = await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                        hour: _startTime.hour,
                                                        minute:
                                                            _startTime.minute,
                                                      ),
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                            Widget? child,
                                                          ) {
                                                            return Theme(
                                                              data: ThemeData(
                                                                useMaterial3:
                                                                    false,
                                                                brightness: widget
                                                                    .model
                                                                    .themeData
                                                                    .brightness,
                                                                colorScheme:
                                                                    getColorScheme(
                                                                      widget
                                                                          .model,
                                                                      false,
                                                                    ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          },
                                                    );
                                                    if (time != null &&
                                                        time != _startTime) {
                                                      setState(() {
                                                        _startTime = time;
                                                        final Duration
                                                        difference = _endDate
                                                            .difference(
                                                              _startDate,
                                                            );
                                                        _startDate = DateTime(
                                                          _startDate.year,
                                                          _startDate.month,
                                                          _startDate.day,
                                                          _startTime.hour,
                                                          _startTime.minute,
                                                        );
                                                        _endDate = _startDate
                                                            .add(difference);
                                                        _endTime = TimeOfDay(
                                                          hour: _endDate.hour,
                                                          minute:
                                                              _endDate.minute,
                                                        );
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.access_time,
                                                    color: defaultColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      focusColor: widget.model.primaryColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: widget.model.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
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
                                left: 5,
                                right: 5,
                                top: 5,
                                bottom: 2,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'End',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: defaultColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text:
                                          (_isAllDay
                                                  ? DateFormat('MM/dd/yyyy')
                                                  : DateFormat(
                                                      'MM/dd/yy h:mm a',
                                                    ))
                                              .format(_endDate),
                                    ),
                                    onChanged: (String value) {
                                      _endDate = DateTime.parse(value);
                                      _endTime = TimeOfDay(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute,
                                      );
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                                  final DateTime?
                                                  date = await showDatePicker(
                                                    context: context,
                                                    initialDate: _endDate,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100),
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                          Widget? child,
                                                        ) {
                                                          return Theme(
                                                            data: ThemeData(
                                                              useMaterial3:
                                                                  false,
                                                              brightness: widget
                                                                  .model
                                                                  .themeData
                                                                  .brightness,
                                                              colorScheme:
                                                                  getColorScheme(
                                                                    widget
                                                                        .model,
                                                                    true,
                                                                  ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                  );
                                                  if (date != null &&
                                                      date != _endDate) {
                                                    setState(() {
                                                      final Duration
                                                      difference = _endDate
                                                          .difference(
                                                            _startDate,
                                                          );
                                                      _endDate = DateTime(
                                                        date.year,
                                                        date.month,
                                                        date.day,
                                                        _endTime.hour,
                                                        _endTime.minute,
                                                      );
                                                      if (_endDate.isBefore(
                                                        _startDate,
                                                      )) {
                                                        _startDate = _endDate
                                                            .subtract(
                                                              difference,
                                                            );
                                                        _startTime = TimeOfDay(
                                                          hour: _startDate.hour,
                                                          minute:
                                                              _startDate.minute,
                                                        );
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.date_range,
                                                  color: defaultColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
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
                                                    final TimeOfDay?
                                                    time = await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                        hour: _endTime.hour,
                                                        minute: _endTime.minute,
                                                      ),
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                            Widget? child,
                                                          ) {
                                                            return Theme(
                                                              data: ThemeData(
                                                                useMaterial3:
                                                                    false,
                                                                brightness: widget
                                                                    .model
                                                                    .themeData
                                                                    .brightness,
                                                                colorScheme:
                                                                    getColorScheme(
                                                                      widget
                                                                          .model,
                                                                      false,
                                                                    ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          },
                                                    );
                                                    if (time != null &&
                                                        time != _endTime) {
                                                      setState(() {
                                                        _endTime = time;
                                                        final Duration
                                                        difference = _endDate
                                                            .difference(
                                                              _startDate,
                                                            );
                                                        _endDate = DateTime(
                                                          _endDate.year,
                                                          _endDate.month,
                                                          _endDate.day,
                                                          _endTime.hour,
                                                          _endTime.minute,
                                                        );
                                                        if (_endDate.isBefore(
                                                          _startDate,
                                                        )) {
                                                          _startDate = _endDate
                                                              .subtract(
                                                                difference,
                                                              );
                                                          _startTime =
                                                              TimeOfDay(
                                                                hour: _startDate
                                                                    .hour,
                                                                minute:
                                                                    _startDate
                                                                        .minute,
                                                              );
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.access_time,
                                                    color: defaultColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      focusColor: widget.model.primaryColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: widget.model.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Checkbox(
                            focusColor: widget.model.primaryColor,
                            activeColor: widget.model.primaryColor,
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
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Container(width: 10),
                          if (_isAllDay)
                            Container()
                          else
                            Checkbox(
                              focusColor: widget.model.primaryColor,
                              activeColor: widget.model.primaryColor,
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
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_isTimeZoneEnabled)
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        top: 2,
                        bottom: 2,
                        right: 305,
                      ),
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: defaultColor.withValues(alpha: 0.4),
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
                                      return CalendarTimeZonePicker(
                                        widget.model.primaryColor,
                                        widget.timeZoneCollection,
                                        _selectedTimeZoneIndex,
                                        widget.model,
                                        onChanged:
                                            (PickerChangedDetails details) {
                                              _selectedTimeZoneIndex =
                                                  details.index;
                                            },
                                      );
                                    },
                                  ).then(
                                    (dynamic value) => setState(() {
                                      /// Update the time zone changes.
                                    }),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      widget
                                          .timeZoneCollection[_selectedTimeZoneIndex],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down, size: 24),
                                  ],
                                ),
                              ),
                            ),
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
                                left: 5,
                                right: 5,
                                top: 2,
                                bottom: 2,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Repeat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: defaultColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  TextField(
                                    mouseCursor:
                                        WidgetStateMouseCursor.clickable,
                                    controller: TextEditingController(
                                      text: _selectedRecurrenceType,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffix: SizedBox(
                                        height: 28,
                                        child: DropdownButton<String>(
                                          dropdownColor: widget
                                              .model
                                              .drawerBackgroundColor,
                                          focusColor: Colors.transparent,
                                          isExpanded: true,
                                          underline: Container(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: defaultTextColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          value: _selectedRecurrenceType,
                                          items: _repeatOption.map((
                                            String item,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            if (value == 'Weekly') {
                                              _weeklyRule();
                                            } else if (value == 'Monthly') {
                                              _monthlyRule();
                                            } else if (value == 'Yearly') {
                                              _yearlyRule();
                                            } else if (value == 'Daily') {
                                              _dailyRule();
                                            } else if (value == 'Never') {
                                              _neverRule();
                                            }
                                          },
                                        ),
                                      ),
                                      focusColor: widget.model.primaryColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: widget.model.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Visibility(
                              visible: _selectedRecurrenceType != 'Never',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  top: 2,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Repeat every',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      controller:
                                          TextEditingController.fromValue(
                                            TextEditingValue(
                                              text: _interval.toString(),
                                              selection:
                                                  TextSelection.collapsed(
                                                    offset: _interval
                                                        .toString()
                                                        .length,
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
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      maxLines: null,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 5,
                                        ),
                                        suffixIconConstraints:
                                            const BoxConstraints(maxHeight: 35),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 5,
                                                  ),
                                              child: Material(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    color: defaultColor,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 3,
                                                      ),
                                                  onPressed: _removeInterval,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 5,
                                                  ),
                                              child: Material(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_drop_up_outlined,
                                                    color: defaultColor,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 3,
                                                      ),
                                                  onPressed: _addInterval,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        focusColor: widget.model.primaryColor,
                                        border: const UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: widget.model.primaryColor,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                '  ' + _ruleType,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: defaultTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
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
                                  left: 6,
                                  right: 5,
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Repeat On',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
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
                                                    WeekDays.sunday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.sunday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.sunday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.monday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.monday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.monday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.tuesday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.tuesday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.tuesday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.wednesday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.wednesday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.wednesday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.thursday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.thursday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.thursday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.friday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.friday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.friday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
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
                                                    WeekDays.saturday,
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                disabledForegroundColor:
                                                    Colors.black26,
                                                disabledBackgroundColor:
                                                    Colors.black26,
                                                side: BorderSide(
                                                  color: borderColor,
                                                ),
                                                backgroundColor:
                                                    _days!.contains(
                                                      WeekDays.saturday,
                                                    )
                                                    ? widget.model.primaryColor
                                                    : defaultButtonColor,
                                                foregroundColor:
                                                    _days!.contains(
                                                      WeekDays.saturday,
                                                    )
                                                    ? Colors.white
                                                    : defaultTextColor,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
                                              ),
                                              child: const Text('S'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: _selectedRecurrenceType == 'Yearly' ? 4 : 0,
                            child: Visibility(
                              visible: _selectedRecurrenceType == 'Yearly',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Repeat On',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      mouseCursor:
                                          WidgetStateMouseCursor.clickable,
                                      controller: TextEditingController(
                                        text: _monthName,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        suffix: SizedBox(
                                          height: 27,
                                          child: DropdownButton<String>(
                                            dropdownColor: widget
                                                .model
                                                .drawerBackgroundColor,
                                            focusColor: Colors.transparent,
                                            isExpanded: true,
                                            underline: Container(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            value: _monthName,
                                            items: _dayMonths.map((
                                              String item,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                if (value == 'January') {
                                                  _monthName = 'January';
                                                  _month = 1;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value ==
                                                    'February') {
                                                  _monthName = 'February';
                                                  _month = 2;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'March') {
                                                  _monthName = 'March';
                                                  _month = 3;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'April') {
                                                  _monthName = 'April';
                                                  _month = 4;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'May') {
                                                  _monthName = 'May';
                                                  _month = 5;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'June') {
                                                  _monthName = 'June';
                                                  _month = 6;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'July') {
                                                  _monthName = 'July';
                                                  _month = 7;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'August') {
                                                  _monthName = 'August';
                                                  _month = 8;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value ==
                                                    'September') {
                                                  _monthName = 'September';
                                                  _month = 9;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value == 'October') {
                                                  _monthName = 'October';
                                                  _month = 10;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value ==
                                                    'November') {
                                                  _monthName = 'November';
                                                  _month = 11;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                } else if (value ==
                                                    'December') {
                                                  _monthName = 'December';
                                                  _month = 12;
                                                  _recurrenceProperties!.month =
                                                      _month!;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        focusColor: widget.model.primaryColor,
                                        border: const UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: widget.model.primaryColor,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: _selectedRecurrenceType == 'Monthly' ? 4 : 0,
                            child: Visibility(
                              visible: _selectedRecurrenceType == 'Monthly',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Repeat On',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _monthDayIcon();
                                            },
                                            padding: const EdgeInsets.only(
                                              left: 2,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            icon: Icon(_monthDayRadio),
                                            color: _monthIconColor,
                                            focusColor:
                                                widget.model.primaryColor,
                                            iconSize: 20,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            top: 10,
                                          ),
                                          child: Text(
                                            'Day',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              bottom: 5,
                                            ),
                                            child: TextField(
                                              controller:
                                                  TextEditingController.fromValue(
                                                    TextEditingValue(
                                                      text: _dayOfMonth
                                                          .toString(),
                                                      selection:
                                                          TextSelection.collapsed(
                                                            offset: _dayOfMonth
                                                                .toString()
                                                                .length,
                                                          ),
                                                    ),
                                                  ),
                                              cursorColor:
                                                  widget.model.primaryColor,
                                              onChanged: (String value) {
                                                if (value != null &&
                                                    value.isNotEmpty) {
                                                  _dayOfMonth = int.parse(
                                                    value,
                                                  );
                                                  if (_dayOfMonth <= 1) {
                                                    _dayOfMonth = 1;
                                                  } else if (_dayOfMonth >=
                                                      31) {
                                                    _dayOfMonth = 31;
                                                  }
                                                } else if (value.isEmpty) {
                                                  _dayOfMonth = _startDate.day;
                                                }
                                                _recurrenceProperties!
                                                        .dayOfWeek =
                                                    0;
                                                _recurrenceProperties!.week = 0;
                                                _recurrenceProperties!
                                                        .dayOfMonth =
                                                    _dayOfMonth;
                                                _weekIconColor =
                                                    widget.model.themeData !=
                                                            null &&
                                                        widget
                                                                .model
                                                                .themeData
                                                                .brightness ==
                                                            Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black54;
                                                _monthIconColor =
                                                    widget.model.primaryColor;
                                                _monthDayRadio =
                                                    Icons.radio_button_checked;
                                                _weekDayRadio = Icons
                                                    .radio_button_unchecked;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters:
                                                  <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                              maxLines: null,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: defaultTextColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                suffix: SizedBox(
                                                  height: 25,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Material(
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down_outlined,
                                                            color: defaultColor,
                                                          ),
                                                          onPressed: () {
                                                            _removeDay();
                                                          },
                                                        ),
                                                      ),
                                                      Material(
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_up_outlined,
                                                            color: defaultColor,
                                                          ),
                                                          onPressed: () {
                                                            _addDay();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                focusColor:
                                                    widget.model.primaryColor,
                                                border:
                                                    const UnderlineInputBorder(),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: widget
                                                            .model
                                                            .primaryColor,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                              ),
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
                          Expanded(
                            flex: 4,
                            child: Visibility(
                              visible: _selectedRecurrenceType != 'Never',
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: _padding,
                                  top: 2,
                                  bottom: 2,
                                ),
                                margin: EdgeInsets.only(left: _margin),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'End',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            _selectedRecurrenceType == 'Monthly'
                                            ? 9
                                            : 0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            _selectedRecurrenceType == 'Monthly'
                                            ? CrossAxisAlignment.center
                                            : CrossAxisAlignment.start,
                                        mainAxisSize:
                                            _selectedRecurrenceType == 'Monthly'
                                            ? MainAxisSize.max
                                            : MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 6,
                                              ),
                                              child: TextField(
                                                mouseCursor:
                                                    WidgetStateMouseCursor
                                                        .clickable,
                                                controller: TextEditingController(
                                                  text:
                                                      _selectedRecurrenceRange,
                                                ),
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
                                                            FontWeight.w400,
                                                      ),
                                                      value:
                                                          _selectedRecurrenceRange,
                                                      items: _ends.map((
                                                        String item,
                                                      ) {
                                                        return DropdownMenuItem<
                                                          String
                                                        >(
                                                          value: item,
                                                          child: Text(item),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        setState(() {
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
                                                      },
                                                    ),
                                                  ),
                                                  focusColor:
                                                      widget.model.primaryColor,
                                                  border:
                                                      const UnderlineInputBorder(),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: widget
                                                              .model
                                                              .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                padding: const EdgeInsets.only(
                                                  left: 9,
                                                ),
                                                child: TextField(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  controller:
                                                      TextEditingController.fromValue(
                                                        TextEditingValue(
                                                          text: _count
                                                              .toString(),
                                                          selection:
                                                              TextSelection.collapsed(
                                                                offset: _count
                                                                    .toString()
                                                                    .length,
                                                              ),
                                                        ),
                                                      ),
                                                  cursorColor:
                                                      widget.model.primaryColor,
                                                  onChanged: (String value) async {
                                                    if (value != null &&
                                                        value.isNotEmpty) {
                                                      _count = int.parse(value);
                                                      if (_count == 0) {
                                                        _count = 1;
                                                      } else if (_count! >=
                                                          999) {
                                                        _count = 999;
                                                      }
                                                      _recurrenceProperties!
                                                              .recurrenceRange =
                                                          RecurrenceRange.count;
                                                      _selectedRecurrenceRange =
                                                          'Count';
                                                      _recurrenceProperties!
                                                              .recurrenceCount =
                                                          _count!;
                                                    } else if (value.isEmpty ||
                                                        value == null) {
                                                      _noEndDateRange();
                                                    }
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters:
                                                      <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                  maxLines: null,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: defaultTextColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.only(
                                                      top:
                                                          _selectedRecurrenceType ==
                                                              'Monthly'
                                                          ? 13
                                                          : 18,
                                                      bottom: 10,
                                                    ),
                                                    suffixIconConstraints:
                                                        const BoxConstraints(
                                                          maxHeight: 30,
                                                        ),
                                                    suffixIcon: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: defaultColor,
                                                          ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed:
                                                              _removeCount,
                                                        ),
                                                        IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.arrow_drop_up,
                                                            color: defaultColor,
                                                          ),
                                                          onPressed: _addCount,
                                                        ),
                                                      ],
                                                    ),
                                                    focusColor: widget
                                                        .model
                                                        .primaryColor,
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: widget
                                                                .model
                                                                .primaryColor,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                padding: const EdgeInsets.only(
                                                  left: 9,
                                                ),
                                                child: TextField(
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  readOnly: true,
                                                  controller:
                                                      TextEditingController(
                                                        text: DateFormat(
                                                          'MM/dd/yyyy',
                                                        ).format(_selectedDate),
                                                      ),
                                                  onChanged: (String value) {
                                                    _selectedDate =
                                                        DateTime.parse(value);
                                                  },
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  maxLines: null,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: defaultTextColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.only(
                                                      top:
                                                          _selectedRecurrenceType ==
                                                              'Monthly'
                                                          ? 10
                                                          : 15,
                                                      bottom:
                                                          _selectedRecurrenceType ==
                                                              'Monthly'
                                                          ? 10
                                                          : 13,
                                                    ),
                                                    suffixIconConstraints:
                                                        const BoxConstraints(
                                                          maxHeight: 30,
                                                        ),
                                                    suffixIcon: ButtonTheme(
                                                      minWidth: 30.0,
                                                      child: MaterialButton(
                                                        elevation: 0,
                                                        focusElevation: 0,
                                                        highlightElevation: 0,
                                                        disabledElevation: 0,
                                                        hoverElevation: 0,
                                                        onPressed: () async {
                                                          final DateTime?
                                                          pickedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                _selectedDate,
                                                            firstDate:
                                                                _startDate
                                                                    .isBefore(
                                                                      _firstDate,
                                                                    )
                                                                ? _startDate
                                                                : _firstDate,
                                                            currentDate:
                                                                _selectedDate,
                                                            lastDate: DateTime(
                                                              2050,
                                                            ),
                                                            builder:
                                                                (
                                                                  BuildContext
                                                                  context,
                                                                  Widget? child,
                                                                ) {
                                                                  return Theme(
                                                                    data: ThemeData(
                                                                      brightness: widget
                                                                          .model
                                                                          .themeData
                                                                          .colorScheme
                                                                          .brightness,
                                                                      colorScheme:
                                                                          getColorScheme(
                                                                            widget.model,
                                                                            true,
                                                                          ),
                                                                    ),
                                                                    child:
                                                                        child!,
                                                                  );
                                                                },
                                                          );
                                                          if (pickedDate ==
                                                              null) {
                                                            return;
                                                          }
                                                          setState(() {
                                                            _selectedDate =
                                                                DateTime(
                                                                  pickedDate
                                                                      .year,
                                                                  pickedDate
                                                                      .month,
                                                                  pickedDate
                                                                      .day,
                                                                );
                                                            _recurrenceProperties!
                                                                    .endDate =
                                                                _selectedDate;
                                                          });
                                                        },
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10.0,
                                                            ),
                                                        child: Icon(
                                                          Icons.date_range,
                                                          color: defaultColor,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    focusColor: widget
                                                        .model
                                                        .primaryColor,
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: widget
                                                                .model
                                                                .primaryColor,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(
                                            flex:
                                                _selectedRecurrenceType ==
                                                    'Daily'
                                                ? _selectedRecurrenceRange ==
                                                          'Never'
                                                      ? 8
                                                      : 6
                                                : _selectedRecurrenceRange ==
                                                      'Never'
                                                ? 2
                                                : 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _selectedRecurrenceType == 'Yearly',
                    child: SizedBox(
                      width: 284,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  width: 50,
                                  child: IconButton(
                                    onPressed: () {
                                      _monthDayIcon();
                                    },
                                    icon: Icon(_monthDayRadio),
                                    color: _monthIconColor,
                                    focusColor: widget.model.primaryColor,
                                    iconSize: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '  Day   ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 208,
                                  height: 28,
                                  child: TextField(
                                    controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                        text: _dayOfMonth.toString(),
                                        selection: TextSelection.collapsed(
                                          offset: _dayOfMonth.toString().length,
                                        ),
                                      ),
                                    ),
                                    cursorColor: widget.model.primaryColor,
                                    onChanged: (String value) {
                                      if (value != null && value.isNotEmpty) {
                                        _dayOfMonth = int.parse(value);
                                        if (_dayOfMonth == 0) {
                                          _dayOfMonth = _startDate.day;
                                        } else if (_dayOfMonth >= 31) {
                                          _dayOfMonth = 31;
                                        }
                                      } else if (value.isEmpty ||
                                          value == null) {
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
                                          widget.model.primaryColor;
                                      _monthDayRadio =
                                          Icons.radio_button_checked;
                                      _weekDayRadio =
                                          Icons.radio_button_unchecked;
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: defaultTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                                  color: defaultColor,
                                                ),
                                                onPressed: _removeDay,
                                              ),
                                            ),
                                            Material(
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  Icons.arrow_drop_up_outlined,
                                                  color: defaultColor,
                                                ),
                                                onPressed: _addDay,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      focusColor: widget.model.primaryColor,
                                      border: const UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: widget.model.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _lastDayOfMonth(defaultTextColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _selectedRecurrenceType == 'Monthly' ||
                        _selectedRecurrenceType == 'Yearly',
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: 284,
                      height: 40,
                      child: Row(
                        children: <Widget>[
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
                                  mouseCursor: WidgetStateMouseCursor.clickable,
                                  controller: TextEditingController(
                                    text: _weekNumberText,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffix: SizedBox(
                                      height: 25,
                                      child: DropdownButton<String>(
                                        dropdownColor:
                                            widget.model.drawerBackgroundColor,
                                        focusColor: Colors.transparent,
                                        isExpanded: true,
                                        value: _weekNumberText,
                                        underline: Container(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: defaultTextColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        items: _daysPosition.map((String item) {
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
                                        },
                                      ),
                                    ),
                                    focusColor: widget.model.primaryColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: widget.model.primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 127,
                                margin: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  mouseCursor: WidgetStateMouseCursor.clickable,
                                  controller: TextEditingController(
                                    text: _dayOfWeekText,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffix: SizedBox(
                                      height: 25,
                                      child: DropdownButton<String>(
                                        dropdownColor:
                                            widget.model.drawerBackgroundColor,
                                        focusColor: Colors.transparent,
                                        isExpanded: true,
                                        value: _dayOfWeekText,
                                        underline: Container(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: defaultTextColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        items: weekDay.map((String item) {
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
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Monday') {
                                              _dayOfWeekText = 'Monday';
                                              _dayOfWeek = 1;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Tuesday') {
                                              _dayOfWeekText = 'Tuesday';
                                              _dayOfWeek = 2;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Wednesday') {
                                              _dayOfWeekText = 'Wednesday';
                                              _dayOfWeek = 3;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Thursday') {
                                              _dayOfWeekText = 'Thursday';
                                              _dayOfWeek = 4;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Friday') {
                                              _dayOfWeekText = 'Friday';
                                              _dayOfWeek = 5;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            } else if (value == 'Saturday') {
                                              _dayOfWeekText = 'Saturday';
                                              _dayOfWeek = 6;
                                              _recurrenceProperties!.dayOfWeek =
                                                  _dayOfWeek;
                                              _monthWeekIcon();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    focusColor: widget.model.primaryColor,
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: widget.model.primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _selectedRecurrenceType == 'Monthly',
                                child: _lastDayOfMonth(defaultTextColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 5),
                  if (widget.events.resources == null ||
                      widget.events.resources!.isEmpty)
                    Container()
                  else
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 20,
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Employees',
                            style: TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            width: 600,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: defaultColor.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            child: _getResourceEditor(
                              TextStyle(
                                fontSize: 13,
                                color: defaultColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            controller: TextEditingController(text: _notes),
                            cursorColor: widget.model.primaryColor,
                            onChanged: (String value) {
                              _notes = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: widget.model.isWebFullView ? 1 : null,
                            style: TextStyle(
                              fontSize: 13,
                              color: defaultTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              focusColor: widget.model.primaryColor,
                              border: const UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.model.primaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 20,
                    ),
                    title: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: defaultColor.withValues(alpha: 0.4),
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
                                    return CalendarColorPicker(
                                      widget.colorCollection,
                                      _selectedColorIndex,
                                      widget.colorNames,
                                      widget.model,
                                      onChanged:
                                          (PickerChangedDetails details) {
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
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        widget.colorNames[_selectedColorIndex],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: defaultTextColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                            final int index = widget.events.appointments!
                                .indexOf(widget.newAppointment);
                            if ((index <=
                                    widget.events.appointments!.length - 1) &&
                                index >= 0) {
                              widget.events.appointments!.removeAt(
                                widget.events.appointments!.indexOf(
                                  widget.newAppointment,
                                ),
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.newAppointment!],
                              );
                            }
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: RawMaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        fillColor: widget.model.primaryColor,
                        onPressed: () {
                          if ((widget.selectedAppointment.recurrenceRule !=
                                      null &&
                                  widget
                                      .selectedAppointment
                                      .recurrenceRule!
                                      .isNotEmpty) ||
                              widget.selectedAppointment.recurrenceId != null) {
                            if (!canAddRecurrenceAppointment(
                              widget.visibleDates,
                              widget.events,
                              widget.selectedAppointment,
                              _startDate,
                            )) {
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
                                      child: AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text(
                                          'Two occurrences of the same event cannot occur on the same day',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              return;
                            }
                          }
                          if (widget.selectedAppointment.appointmentType !=
                                  AppointmentType.normal &&
                              widget.selectedAppointment.recurrenceId == null) {
                            if (widget
                                    .selectedAppointment
                                    .recurrenceExceptionDates ==
                                null) {
                              widget.events.appointments!.removeAt(
                                widget.events.appointments!.indexOf(
                                  widget.selectedAppointment,
                                ),
                              );
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment],
                              );
                              final Appointment newAppointment = Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
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
                                location: _location,
                                subject: _subject == ''
                                    ? '(No title)'
                                    : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceRule:
                                    _recurrenceProperties == null ||
                                        _selectedRecurrenceType == 'Never' ||
                                        widget
                                                .selectedAppointment
                                                .recurrenceId !=
                                            null
                                    ? null
                                    : SfCalendar.generateRRule(
                                        _recurrenceProperties!,
                                        _startDate,
                                        _endDate,
                                      ),
                              );
                              widget.events.appointments!.add(newAppointment);
                              widget.events.notifyListeners(
                                CalendarDataSourceAction.add,
                                <Appointment>[newAppointment],
                              );
                              Navigator.pop(context);
                            } else {
                              final Appointment
                              recurrenceAppointment = Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
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
                                location: _location,
                                subject: _subject == ''
                                    ? '(No title)'
                                    : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceRule:
                                    _recurrenceProperties == null ||
                                        _selectedRecurrenceType == 'Never' ||
                                        widget
                                                .selectedAppointment
                                                .recurrenceId !=
                                            null
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
                                      child: _editExceptionSeries(
                                        context,
                                        widget.model,
                                        widget.selectedAppointment,
                                        recurrenceAppointment,
                                        widget.events,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else if (widget.selectedAppointment.recurrenceId !=
                              null) {
                            final Appointment? parentAppointment =
                                widget.events.getPatternAppointment(
                                      widget.selectedAppointment,
                                      '',
                                    )
                                    as Appointment?;
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
                            if (widget.selectedAppointment != null ||
                                widget.newAppointment != null) {
                              if (widget.events.appointments!.isNotEmpty &&
                                  widget.events.appointments!.contains(
                                    widget.selectedAppointment,
                                  )) {
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
                              if (widget.appointment.isNotEmpty &&
                                  widget.appointment.contains(
                                    widget.newAppointment,
                                  )) {
                                widget.appointment.removeAt(
                                  widget.appointment.indexOf(
                                    widget.newAppointment!,
                                  ),
                                );
                              }
                              if (widget.newAppointment != null &&
                                  widget.events.appointments!.isNotEmpty &&
                                  widget.events.appointments!.contains(
                                    widget.newAppointment,
                                  )) {
                                widget.events.appointments!.removeAt(
                                  widget.events.appointments!.indexOf(
                                    widget.newAppointment,
                                  ),
                                );
                                widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.newAppointment!],
                                );
                              }
                            }
                            widget.appointment.add(
                              Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
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
                                location: _location,
                                subject: _subject == ''
                                    ? '(No title)'
                                    : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceId:
                                    widget.selectedAppointment.recurrenceId,
                              ),
                            );
                            widget.events.appointments!.add(
                              widget.appointment[0],
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              widget.appointment,
                            );
                            Navigator.pop(context);
                          } else {
                            if (widget.selectedAppointment != null ||
                                widget.newAppointment != null) {
                              if (widget.events.appointments!.isNotEmpty &&
                                  widget.events.appointments!.contains(
                                    widget.selectedAppointment,
                                  )) {
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
                              if (widget.appointment.isNotEmpty &&
                                  widget.appointment.contains(
                                    widget.newAppointment,
                                  )) {
                                widget.appointment.removeAt(
                                  widget.appointment.indexOf(
                                    widget.newAppointment!,
                                  ),
                                );
                              }
                              if (widget.newAppointment != null &&
                                  widget.events.appointments!.isNotEmpty &&
                                  widget.events.appointments!.contains(
                                    widget.newAppointment,
                                  )) {
                                widget.events.appointments!.removeAt(
                                  widget.events.appointments!.indexOf(
                                    widget.newAppointment,
                                  ),
                                );
                                widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.newAppointment!],
                                );
                              }
                            }
                            widget.appointment.add(
                              Appointment(
                                startTime: _startDate,
                                endTime: _endDate,
                                color:
                                    widget.colorCollection[_selectedColorIndex],
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
                                location: _location,
                                subject: _subject == ''
                                    ? '(No title)'
                                    : _subject,
                                resourceIds: _resourceIds,
                                id: widget.selectedAppointment.id,
                                recurrenceId:
                                    widget.selectedAppointment.recurrenceId,
                                recurrenceRule:
                                    _recurrenceProperties == null ||
                                        _selectedRecurrenceType == 'Never' ||
                                        widget
                                                .selectedAppointment
                                                .recurrenceId !=
                                            null
                                    ? null
                                    : SfCalendar.generateRRule(
                                        _recurrenceProperties!,
                                        _startDate,
                                        _endDate,
                                      ),
                              ),
                            );
                            widget.events.appointments!.add(
                              widget.appointment[0],
                            );
                            widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              widget.appointment,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  Widget _lastDayOfMonth(Color textColor) {
    return Row(
      children: <Widget>[
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
            focusColor: widget.model.primaryColor,
            iconSize: 20,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: Text(
            'Last day of month',
            style: TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
