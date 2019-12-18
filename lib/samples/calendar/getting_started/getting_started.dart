import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/customDropDown.dart';

//ignore: must_be_immutable
class GettingStartedCalendar extends StatefulWidget {
  GettingStartedCalendar({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _GettingStartedCalendarState createState() => _GettingStartedCalendarState(sample);
}

class _GettingStartedCalendarState extends State<GettingStartedCalendar> {
  _GettingStartedCalendarState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Meeting> meetings;
  MeetingDataSource events;

  String _view = 'Month';

  final List<String> _viewList = <String>[
    'Day',
    'Week',
    'Work week',
    'Month',
    'Timeline day',
    'Timeline week',
    'Timeline work week'
  ].toList();


  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _calendarView = CalendarView.month;
    meetings = <Meeting>[];
    addAppointmentDetails();
    events = MeetingDataSource(meetings);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(GettingStartedCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                    child: getGettingStartedCalendar(
                        _calendarView, events, onViewChanged)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }

  void onCalendarViewChange(String value, SampleModel model) {
    _view = value;
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    }
    else if (value == 'Week') {
      _calendarView = CalendarView.week;
    }
    else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    }
    else if (value == 'Month') {
      _calendarView = CalendarView.month;
    }
    else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    }
    else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    }
    else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    setState(() {});
  }

  void onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<Meeting> appointment = <Meeting>[];
    events.appointments.clear();
    final Random random = Random();
    for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
      final DateTime date = visibleDatesChangedDetails.visibleDates[i];
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        appointment.add(Meeting(
            subjectCollection[random.nextInt(7)],
            '',
            '',
            null,
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            colorCollection[random.nextInt(9)],
            false,
            '',
            '')
        );
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      events.appointments.add(appointment[i]);
    }

    events.notifyListeners(CalendarDataSourceAction.reset, appointment);
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

  void _showSettingsPanel(SampleModel model) {
    final double height =
    (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
        ? 0.3
        : 0.4;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleModel model) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                    height: 170,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * height,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                              child: Stack(children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Settings',
                                          style: TextStyle(
                                              color: model.textColor,
                                              fontSize: 18,
                                              letterSpacing: 0.34,
                                              fontWeight: FontWeight.w500)),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: model.textColor,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 50, 0, 0),
                                  child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Calendar View   ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                                padding:
                                                const EdgeInsets.fromLTRB(
                                                    15, 0, 0, 0),
                                                height: 50,
                                                width: 200,
                                                child: Align(
                                                  alignment:
                                                  Alignment.bottomCenter,
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                        canvasColor: model
                                                            .bottomSheetBackgroundColor),
                                                    child: DropDown(
                                                        value:
                                                        _view,
                                                        item: _viewList.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                  value: (value !=
                                                                      null)
                                                                      ? value
                                                                      : 'Month',
                                                                  child: Text(
                                                                      '$value',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          color: model
                                                                              .textColor)));
                                                            }).toList(),
                                                        valueChanged: (dynamic value) {
                                                          onCalendarViewChange(
                                                              value, model);
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                ),
                              ]),
                            )))))));
  }
}
SfCalendar getGettingStartedCalendar([CalendarView _calendarView, CalendarDataSource _calendarDataSource, ViewChangedCallback viewChangedCallback]) {
  return SfCalendar(view: _calendarView,
      dataSource: _calendarDataSource,
      onViewChanged: viewChangedCallback,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      timeSlotViewSettings: TimeSlotViewSettings(
          minimumAppointmentDuration: const Duration(minutes: 60)));
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

class Meeting {
  Meeting(this.eventName, this.organizer, this.contactID, this.capacity,
      this.from, this.to, this.background, this.isAllDay, this.startTimeZone,
      this.endTimeZone);

  String eventName;
  String organizer;
  String contactID;
  int capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
}
