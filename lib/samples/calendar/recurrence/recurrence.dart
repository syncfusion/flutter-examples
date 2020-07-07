import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class RecurrenceCalendar extends StatefulWidget {
  RecurrenceCalendar({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  RecurrenceCalendarState createState() => RecurrenceCalendarState(sample);
}

class RecurrenceCalendarState extends State<RecurrenceCalendar> {
  RecurrenceCalendarState([this.sample]);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  CalendarView _calendarView;
  List<Appointment> _appointments;
  bool _showAgenda;
  List<Color> colorCollection;

  String _view;

  final List<String> _viewList = <String>[
    'Day',
    'Week',
    'Work week',
    'Month',
    'Month agenda',
    'Timeline day',
    'Timeline week',
    'Timeline work week'
  ].toList();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) => RecurrenceCalendar();

  @override
  void initState() {
    initProperties();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _appointments = <Appointment>[];
    _addColorCollection();
    createRecursiveAppointments();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _view = 'Week';
    _calendarView = CalendarView.week;
    _showAgenda = false;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'CalendarView': _calendarView,
        'View': _view,
        'ShowAgenda': _showAgenda
      });
    }
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(RecurrenceCalendar oldWidget) {
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
                          child: getRecurrenceCalendar(
                              _calendarView,
                              AppointmentDataSource(_appointments),
                              _showAgenda,
                              model)),
                    )
                  : Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                            color: model.cardThemeColor,
                            child: getRecurrenceCalendar(
                                _calendarView,
                                AppointmentDataSource(_appointments),
                                _showAgenda,
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

  void createRecursiveAppointments() {
    final Random random = Random();
    //Recurrence Appointment 1
    final Appointment alternativeDayAppointment = Appointment();
    final DateTime currentDate = DateTime.now();
    final DateTime startTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 0, 0);
    final DateTime endTime = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 11, 0, 0);
    alternativeDayAppointment.startTime = startTime;
    alternativeDayAppointment.endTime = endTime;
    alternativeDayAppointment.color = colorCollection[random.nextInt(9)];
    alternativeDayAppointment.subject = 'Scrum meeting';
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties();
    recurrencePropertiesForAlternativeDay.recurrenceType = RecurrenceType.daily;
    recurrencePropertiesForAlternativeDay.interval = 2;
    recurrencePropertiesForAlternativeDay.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForAlternativeDay.recurrenceCount = 20;
    alternativeDayAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForAlternativeDay,
        alternativeDayAppointment.startTime,
        alternativeDayAppointment.endTime);
    _appointments.add(alternativeDayAppointment);

    //Recurrence Appointment 2
    final Appointment weeklyAppointment = Appointment();
    final DateTime startTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    final DateTime endTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    weeklyAppointment.startTime = startTime1;
    weeklyAppointment.endTime = endTime1;
    weeklyAppointment.color = colorCollection[random.nextInt(9)];
    weeklyAppointment.subject = 'product development status';

    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForWeeklyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForWeeklyAppointment.interval = 1;
    recurrencePropertiesForWeeklyAppointment.weekDays = <WeekDays>[]
      ..add(WeekDays.monday);
    recurrencePropertiesForWeeklyAppointment.recurrenceCount = 20;
    weeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForWeeklyAppointment,
        weeklyAppointment.startTime,
        weeklyAppointment.endTime);
    _appointments.add(weeklyAppointment);

    final Appointment monthlyAppointment = Appointment();
    final DateTime startTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime2 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    monthlyAppointment.startTime = startTime2;
    monthlyAppointment.endTime = endTime2;
    monthlyAppointment.color = colorCollection[random.nextInt(9)];
    monthlyAppointment.subject = 'Sprint planning meeting';

    final RecurrenceProperties recurrencePropertiesForMonthlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForMonthlyAppointment.recurrenceType =
        RecurrenceType.monthly;
    recurrencePropertiesForMonthlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForMonthlyAppointment.interval = 1;
    recurrencePropertiesForMonthlyAppointment.dayOfMonth = 1;
    recurrencePropertiesForMonthlyAppointment.recurrenceCount = 10;
    monthlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForMonthlyAppointment,
        monthlyAppointment.startTime,
        monthlyAppointment.endTime);
    _appointments.add(monthlyAppointment);

    final Appointment yearlyAppointment = Appointment();
    final DateTime startTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime3 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    yearlyAppointment.startTime = startTime3;
    yearlyAppointment.endTime = endTime3;
    yearlyAppointment.color = colorCollection[random.nextInt(9)];
    yearlyAppointment.isAllDay = true;
    yearlyAppointment.subject = 'Stephen birthday';

    final RecurrenceProperties recurrencePropertiesForYearlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForYearlyAppointment.recurrenceType =
        RecurrenceType.yearly;
    recurrencePropertiesForYearlyAppointment.recurrenceRange =
        RecurrenceRange.noEndDate;
    recurrencePropertiesForYearlyAppointment.interval = 1;
    recurrencePropertiesForYearlyAppointment.dayOfMonth = 5;
    yearlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForYearlyAppointment,
        yearlyAppointment.startTime,
        yearlyAppointment.endTime);
    _appointments.add(yearlyAppointment);

    final Appointment customDailyAppointment = Appointment();
    final DateTime startTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 17, 0, 0);
    final DateTime endTime4 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);
    customDailyAppointment.startTime = startTime4;
    customDailyAppointment.endTime = endTime4;
    customDailyAppointment.color = colorCollection[random.nextInt(9)];
    customDailyAppointment.subject = 'General meeting';

    final RecurrenceProperties recurrencePropertiesForCustomDailyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomDailyAppointment.recurrenceType =
        RecurrenceType.daily;
    recurrencePropertiesForCustomDailyAppointment.recurrenceRange =
        RecurrenceRange.noEndDate;
    recurrencePropertiesForCustomDailyAppointment.interval = 1;
    customDailyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomDailyAppointment,
        customDailyAppointment.startTime,
        customDailyAppointment.endTime);
    _appointments.add(customDailyAppointment);

    final Appointment customWeeklyAppointment = Appointment();
    final DateTime startTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    customWeeklyAppointment.startTime = startTime5;
    customWeeklyAppointment.endTime = endTime5;
    customWeeklyAppointment.color = colorCollection[random.nextInt(9)];
    customWeeklyAppointment.subject = 'performance check';

    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceRange =
        RecurrenceRange.endDate;
    recurrencePropertiesForCustomWeeklyAppointment.interval = 1;
    recurrencePropertiesForCustomWeeklyAppointment.weekDays = <WeekDays>[
      WeekDays.monday,
      WeekDays.friday
    ];
    recurrencePropertiesForCustomWeeklyAppointment.endDate =
        DateTime.now().add(const Duration(days: 14));
    customWeeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomWeeklyAppointment,
        customWeeklyAppointment.startTime,
        customWeeklyAppointment.endTime);
    _appointments.add(customWeeklyAppointment);

    final Appointment customMonthlyAppointment = Appointment();
    final DateTime startTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 16, 0, 0);
    final DateTime endTime6 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 18, 0, 0);
    customMonthlyAppointment.startTime = startTime6;
    customMonthlyAppointment.endTime = endTime6;
    customMonthlyAppointment.color = colorCollection[random.nextInt(9)];
    customMonthlyAppointment.subject = 'Sprint end meeting';

    final RecurrenceProperties recurrencePropertiesForCustomMonthlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceType =
        RecurrenceType.monthly;
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForCustomMonthlyAppointment.interval = 1;
    recurrencePropertiesForCustomMonthlyAppointment.dayOfWeek = DateTime.friday;
    recurrencePropertiesForCustomMonthlyAppointment.week = 4;
    recurrencePropertiesForCustomMonthlyAppointment.recurrenceCount = 12;
    customMonthlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomMonthlyAppointment,
        customMonthlyAppointment.startTime,
        customMonthlyAppointment.endTime);
    _appointments.add(customMonthlyAppointment);

    final Appointment customYearlyAppointment = Appointment();
    final DateTime startTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 14, 0, 0);
    final DateTime endTime7 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    customYearlyAppointment.startTime = startTime7;
    customYearlyAppointment.endTime = endTime7;
    customYearlyAppointment.color = colorCollection[random.nextInt(9)];
    customYearlyAppointment.subject = 'Alumini meet';

    final RecurrenceProperties recurrencePropertiesForCustomYearlyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForCustomYearlyAppointment.recurrenceType =
        RecurrenceType.yearly;
    recurrencePropertiesForCustomYearlyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForCustomYearlyAppointment.interval = 2;
    recurrencePropertiesForCustomYearlyAppointment.month = DateTime.february;
    recurrencePropertiesForCustomYearlyAppointment.week = 2;
    recurrencePropertiesForCustomYearlyAppointment.dayOfWeek = DateTime.sunday;
    recurrencePropertiesForCustomYearlyAppointment.recurrenceCount = 10;
    customYearlyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomYearlyAppointment,
        customYearlyAppointment.startTime,
        customYearlyAppointment.endTime);
    _appointments.add(customYearlyAppointment);
  }

  void _addColorCollection() {
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
      _showAgenda = false;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    } else if (value == 'Month agenda') {
      _calendarView = CalendarView.month;
      _showAgenda = true;
    }

    model.properties['View'] = _view;
    model.properties['CalendarView'] = _calendarView;
    model.properties['ShowAgenda'] = _showAgenda;
    if (model.isWeb) {
      model.sampleOutputContainer.outputKey.currentState.refresh();
    } else {
      setState(() {});
    }
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

SfCalendar getRecurrenceCalendar(
    [CalendarView _calendarView,
    CalendarDataSource _calendarDataSource,
    bool showAgenda,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCalendar(
    view: isExistModel ? model.properties['CalendarView'] : _calendarView,
    dataSource: _calendarDataSource,
    monthViewSettings: MonthViewSettings(
        showAgenda: isExistModel ? model.properties['ShowAgenda'] : showAgenda,
        appointmentDisplayMode:
            isExistModel && model.properties['ShowAgenda'] ||
                    !isExistModel && showAgenda != null && showAgenda
                ? MonthAppointmentDisplayMode.indicator
                : MonthAppointmentDisplayMode.appointment,
        appointmentDisplayCount: isExistModel ? 3 : 4),
  );
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
