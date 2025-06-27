/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local imports.
import '../../model/model.dart';
import 'appointment_editor.dart';
import 'appointment_editor_web.dart';
import 'calendar_pickers.dart';

/// Builds the appointment editor with minimal elements in a pop-up based on the
/// tapped Calendar element.
class PopUpAppointmentEditor extends StatefulWidget {
  /// Holds the data of appointment editor.
  const PopUpAppointmentEditor(
    this.model,
    this.newAppointment,
    this.appointment,
    this.events,
    this.colorCollection,
    this.colorNames,
    this.selectedAppointment,
    this.timeZoneCollection,
    this.visibleDates,
  );

  /// Model of appointment editor.
  final SampleModel model;

  /// New appointment value.
  final Appointment? newAppointment;

  /// List of appointments.
  final List<Appointment> appointment;

  /// Holds the events value.
  final CalendarDataSource events;

  /// Holds list of colors.
  final List<Color> colorCollection;

  /// Holds the names of colors.
  final List<String> colorNames;

  /// Selected appointment value.
  final Appointment selectedAppointment;

  /// Collection list of time zones.
  final List<String> timeZoneCollection;

  /// The current visible dates collection.
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
    _selectedResources = getSelectedResources(
      _resourceIds,
      widget.events.resources,
    );
    _unSelectedResources = getUnSelectedResources(
      _selectedResources,
      widget.events.resources,
    );
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
              /// The theme data created based on the selected theme and
              /// primary color.
              data: ThemeData(
                brightness: widget.model.themeData.colorScheme.brightness,
                colorScheme: getColorScheme(widget.model, true),
              ),
              child: child!,
            );
          },
        );
        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(
              date.year,
              date.month,
              date.day,
              _startTime.hour,
              _startTime.minute,
            );
            _endDate = _startDate.add(difference);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          });
        }
      },
      child: Text(
        DateFormat('MMM dd, yyyy').format(_startDate),
        style: TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
        textAlign: TextAlign.left,
      ),
    );
    final Widget startTimePicker = RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onPressed: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: _startTime.hour,
            minute: _startTime.minute,
          ),
          builder: (BuildContext context, Widget? child) {
            /// Theme widget used to apply the theme and primary color to the
            /// time picker.
            return Theme(
              /// The theme data created based on the selected theme and
              /// primary color.
              data: ThemeData(
                brightness: widget.model.themeData.colorScheme.brightness,
                colorScheme: getColorScheme(widget.model, false),
              ),
              child: child!,
            );
          },
        );
        if (time != null && time != _startTime) {
          setState(() {
            _startTime = time;
            final Duration difference = _endDate.difference(_startDate);
            _startDate = DateTime(
              _startDate.year,
              _startDate.month,
              _startDate.day,
              _startTime.hour,
              _startTime.minute,
            );
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
          initialTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
          builder: (BuildContext context, Widget? child) {
            /// Theme widget used to apply the theme and primary color to the
            /// date picker.
            return Theme(
              /// The theme data created based on the selected theme and
              /// primary color.
              data: ThemeData(
                brightness: widget.model.themeData.colorScheme.brightness,
                colorScheme: getColorScheme(widget.model, false),
              ),
              child: child!,
            );
          },
        );
        if (time != null && time != _endTime) {
          setState(() {
            _endTime = time;
            final Duration difference = _endDate.difference(_startDate);
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
              /// The theme data created based on the selected theme and
              /// primary color.
              data: ThemeData(
                brightness: widget.model.themeData.colorScheme.brightness,
                colorScheme: getColorScheme(widget.model, true),
              ),
              child: child!,
            );
          },
        );
        if (date != null && date != _startDate) {
          setState(() {
            final Duration difference = _endDate.difference(_startDate);
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
        DateFormat('MMM dd, yyyy').format(_endDate),
        style: TextStyle(fontWeight: FontWeight.w500, color: defaultTextColor),
        textAlign: TextAlign.left,
      ),
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ListTile(
            trailing: IconButton(
              icon: Icon(Icons.close, color: defaultColor),
              splashRadius: 20,
              onPressed: () {
                if (widget.newAppointment != null &&
                    widget.events.appointments!.contains(
                      widget.newAppointment,
                    )) {
                  /// To remove the created appointment, when the appointment
                  /// editor closed without saving the appointment.
                  widget.events.appointments!.removeAt(
                    widget.events.appointments!.indexOf(widget.newAppointment),
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
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: const Text(''),
            title: TextField(
              autofocus: true,
              cursorColor: widget.model.primaryColor,
              controller: TextEditingController(text: _subject),
              onChanged: (String value) {
                _subject = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 20,
                color: defaultTextColor,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                focusColor: widget.model.primaryColor,
                border: const UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.model.primaryColor,
                    width: 2.0,
                  ),
                ),
                hintText: 'Add title and time',
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Icon(Icons.access_time, size: 20, color: defaultColor),
            ),
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
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      startDatePicker,
                      startTimePicker,
                      const Text(' - '),
                      endTimePicker,
                      endDatePicker,
                    ],
                  ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Icon(Icons.location_on, color: defaultColor, size: 20),
            ),
            title: TextField(
              cursorColor: widget.model.primaryColor,
              controller: TextEditingController(text: _location),
              onChanged: (String value) {
                _location = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(fontSize: 15, color: defaultTextColor),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add location',
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Icon(Icons.subject, size: 20, color: defaultColor),
            ),
            title: TextField(
              controller: TextEditingController(text: _notes),
              onChanged: (String value) {
                _notes = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: widget.model.isWebFullView ? 1 : null,
              style: TextStyle(fontSize: 15, color: defaultTextColor),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add description',
              ),
            ),
          ),
        ),
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
                child: Icon(Icons.people, color: defaultColor, size: 20),
              ),
              title: RawMaterialButton(
                padding: const EdgeInsets.only(left: 5),
                onPressed: () {
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
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: _getResourceEditor(
                    TextStyle(
                      fontSize: 15,
                      color: defaultColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.lens,
                size: 20,
                color: widget.colorCollection[_selectedColorIndex],
              ),
            ),
            title: RawMaterialButton(
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
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.colorNames[_selectedColorIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: defaultTextColor,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ),
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
                            location: _location,
                            subject: _subject == '' ? '(No title)' : _subject,
                            resourceIds: _resourceIds,
                          );
                          return PopScope(
                            onPopInvokedWithResult:
                                (bool value, Object? result) async {
                                  if (widget.newAppointment != null) {
                                    final int appointmentIndex = widget
                                        .events
                                        .appointments!
                                        .indexOf(widget.newAppointment);
                                    if (appointmentIndex <=
                                            widget.events.appointments!.length -
                                                1 &&
                                        appointmentIndex >= 0) {
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
                        },
                      );
                    },
                    child: Text(
                      'MORE OPTIONS',
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
                            widget.appointment.indexOf(widget.newAppointment!),
                          );
                        }
                      }
                      widget.appointment.add(
                        Appointment(
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
                          location: _location,
                          subject: _subject == '' ? '(No title)' : _subject,
                          resourceIds: _resourceIds,
                        ),
                      );
                      widget.events.appointments!.add(widget.appointment[0]);
                      widget.events.notifyListeners(
                        CalendarDataSourceAction.add,
                        widget.appointment,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
}
