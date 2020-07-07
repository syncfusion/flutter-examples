import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SpecialRegionsCalendar extends SampleView {
  const SpecialRegionsCalendar(Key key) : super(key: key);

  @override
  _SpecialRegionsCalendarState createState() => _SpecialRegionsCalendarState();
}

class _SpecialRegionsCalendarState extends SampleViewState {
  _SpecialRegionsCalendarState();

  CalendarView _calendarView;
  bool panelOpen;
  List<TimeRegion> regions;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  String _view = 'Week';
  final List<String> _viewList = <String>[
    'Day',
    'Week',
    'Work week',
    'Timeline day',
    'Timeline week',
    'Timeline work week'
  ].toList();

  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Appointment> _appointments;
  _DataSource events;

  @override
  void initState() {
    initProperties();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _appointments = <Appointment>[];
    addAppointmentDetails();
    addAppointments();
    events = _DataSource(_appointments);
    _addRegions();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _view = 'Week';
    _calendarView = CalendarView.week;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(
          <dynamic, dynamic>{'CalendarView': _calendarView, 'View': _view});
    }
  }

  void _addRegions() {
    regions = <TimeRegion>[];
    final DateTime date =
        DateTime.now().add(Duration(days: -DateTime.now().weekday));
    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day),
      endTime: DateTime(date.year, date.month, date.day, 9, 0, 0),
      enablePointerInteraction: false,
      textStyle: TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 18, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
      enablePointerInteraction: false,
      textStyle: TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 13, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 14, 0, 0),
      enablePointerInteraction: false,
      textStyle: TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR',
    ));

    regions.add(TimeRegion(
      startTime: DateTime(date.year, date.month, date.day, 0, 0, 0),
      endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
      enablePointerInteraction: false,
      textStyle: TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SA,SU',
    ));
  }

  void addAppointmentDetails() {
    subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Scrum');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

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

  void addAppointments() {
    final Random random = Random();
    final DateTime rangeStartDate =
        DateTime.now().add(const Duration(days: -(365 ~/ 2)));
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 365));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      if (date.weekday == 6 || date.weekday == 7) {
        continue;
      }

      final DateTime startDate = DateTime(date.year, date.month, date.day,
          (date.weekday % 2 == 0 ? 14 : 9) + random.nextInt(3), 0, 0);
      _appointments.add(Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(const Duration(hours: 1)),
          color: colorCollection[random.nextInt(9)]));
    }
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(SpecialRegionsCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
          Expanded(
              child: Container(
            color: model.isWeb
                ? model.webSampleBackgroundColor
                : model.cardThemeColor,
            child: Theme(
                data: model.themeData
                    .copyWith(accentColor: model.backgroundColor),
                child: getSpecialRegionCalendar(
                    regions: regions, view: _calendarView, dataSource: events)),
          ))
        ]));
  }

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Calendar View',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  // width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _view,
                          item: _viewList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'Week',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onCalendarViewChange(value, model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void onCalendarViewChange(String value, SampleModel model) {
    _view = value;
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    model.properties['View'] = _view;
    model.properties['CalendarView'] = _calendarView;
    setState(() {});
  }

  SfCalendar getSpecialRegionCalendar(
      {List<TimeRegion> regions, CalendarView view, _DataSource dataSource}) {
    return SfCalendar(
      view: view,
      showNavigationArrow: kIsWeb,
      specialRegions: regions,
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 30)),
      dataSource: dataSource,
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
