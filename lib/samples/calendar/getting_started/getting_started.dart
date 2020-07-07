import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/customDropDown.dart';

//ignore: must_be_immutable
class GettingStartedCalendar extends StatefulWidget {
  GettingStartedCalendar({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _GettingStartedCalendarState createState() =>
      _GettingStartedCalendarState(sample);
}

class _GettingStartedCalendarState extends State<GettingStartedCalendar> {
  _GettingStartedCalendarState(this.sample);

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) => GettingStartedCalendar();

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Meeting> meetings;
  MeetingDataSource events;
  DateTime _minDate, _maxDate;

  String _view;

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
    initProperties();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    meetings = <Meeting>[];
    addAppointmentDetails();
    events = MeetingDataSource(meetings);
    _minDate = DateTime.now().subtract(const Duration(days: 365 ~/ 2));
    _maxDate = DateTime.now().add(const Duration(days: 365 ~/ 2));
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _view = 'Month';
    _calendarView = CalendarView.month;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(
          <dynamic, dynamic>{'CalendarView': _calendarView, 'View': _view});
    }
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
          if (model != null && model.isWeb && model.properties.isEmpty) {
            initProperties(model, true);
          }
          return Scaffold(
              backgroundColor: model.themeData == null ||
                      model.themeData.brightness == Brightness.light
                  ? null
                  : Colors.black,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Container(
                          color: model.cardThemeColor,
                          child: getGettingStartedCalendar(
                              _calendarView,
                              events,
                              onViewChanged,
                              _minDate,
                              _maxDate,
                              model)),
                    )
                  : Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                            color: model.cardThemeColor,
                            child: getGettingStartedCalendar(
                                _calendarView,
                                events,
                                onViewChanged,
                                _minDate,
                                _maxDate,
                                model)),
                      ))
                    ]),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        _showSettingsPanel(model, false, context);
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
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    model.properties['View'] = _view;
    model.properties['CalendarView'] = _calendarView;
    if (model.isWeb) {
      model.sampleOutputContainer.outputKey.currentState.refresh();
    } else {
      setState(() {});
    }
  }

  void onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<Meeting> appointment = <Meeting>[];
    events.appointments.clear();
    final Random random = Random();
    for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
      final DateTime date = visibleDatesChangedDetails.visibleDates[i];
      final int count = kIsWeb ? 1 + random.nextInt(2) : 1 + random.nextInt(3);
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
            ''));
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

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Properties',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  HandCursor(
                      child: IconButton(
                    icon: Icon(Icons.close, color: model.textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ]),
            const Divider(
              thickness: 1,
            ),
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
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: model.bottomSheetBackgroundColor),
                          child: DropDown(
                              value: model.properties['View'],
                              item: _viewList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'Month',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
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
        ),
      );
    } else {
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
                              height:
                                  MediaQuery.of(context).size.height * height,
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
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value: _view,
                                                      item: _viewList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value: (value !=
                                                                    null)
                                                                ? value
                                                                : 'Month',
                                                            child: Text(
                                                                '$value',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
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
    return widget ?? Container();
  }
}

SfCalendar getGettingStartedCalendar(
    [CalendarView _calendarView,
    CalendarDataSource _calendarDataSource,
    ViewChangedCallback viewChangedCallback,
    DateTime _minDate,
    DateTime _maxDate,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCalendar(
      view: isExistModel ? model.properties['CalendarView'] : _calendarView,
      dataSource: _calendarDataSource,
      onViewChanged: viewChangedCallback,
      minDate: _minDate,
      maxDate: _maxDate,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: isExistModel ? 3 : 4),
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
  Meeting(
      this.eventName,
      this.organizer,
      this.contactID,
      this.capacity,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.startTimeZone,
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
