import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftScheduler extends SampleView {
  const ShiftScheduler(Key key) : super(key: key);

  @override
  _ShiftSchedulerState createState() => _ShiftSchedulerState();
}

class _ShiftSchedulerState extends SampleViewState {
  _ShiftSchedulerState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Shift> shiftCollection;
  List<String> employeeCollection;
  List<String> userImages;
  ShiftDataSource events;
  ScrollController controller;
  String _selectedEmployee;
  int _selectedEmployeeIndex;

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    shiftCollection = <Shift>[];
    userImages = <String>[];
    controller = ScrollController();
    _selectedEmployee = 'John';
    _selectedEmployeeIndex = 0;
    addAppointmentDetails();
    addAppointments();
    events = ShiftDataSource(shiftCollection);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(ShiftScheduler oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  void onSelectedEmployeeChange(String value, SampleModel model) {
    _selectedEmployee = value;
    _selectedEmployeeIndex = employeeCollection.indexOf(_selectedEmployee);
    addAppointments();
    events = ShiftDataSource(shiftCollection);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget _calendarUI = Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 50,
                  width: 200,
                  alignment: Alignment.centerRight,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                        value: _selectedEmployee,
                        isExpanded: true,
                        item: employeeCollection.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'John',
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: ExactAssetImage(userImages[
                                        employeeCollection.indexOf(value)]),
                                    minRadius: 10,
                                    maxRadius: 13,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Text('$value',
                                          style: TextStyle(
                                              color: model.textColor)))
                                ],
                              ));
                        }).toList(),
                        valueChanged: (dynamic value) {
                          onSelectedEmployeeChange(value, model);
                        }),
                  ),
                ))),
        Expanded(
            flex: 9,
            child: Theme(
                data: model.themeData
                    .copyWith(accentColor: model.backgroundColor),
                child: getShiftScheduler(events)))
      ],
    );
    final double _screenHeight = MediaQuery.of(context).size.height;
    return model.isWeb && _screenHeight < 800
        ? Scrollbar(
            isAlwaysShown: true,
            controller: controller,
            child: ListView(
              controller: controller,
              children: <Widget>[
                Container(
                  color: model.isWeb
                      ? model.webSampleBackgroundColor
                      : model.cardThemeColor,
                  height: 600,
                  child: _calendarUI,
                )
              ],
            ))
        : Container(
            color: model.isWeb
                ? model.webSampleBackgroundColor
                : model.cardThemeColor,
            child: _calendarUI,
          );
  }

  void addAppointmentDetails() {
    subjectCollection = <String>[];
    subjectCollection.add('Morning');
    subjectCollection.add('Evening');
    subjectCollection.add('Night');
    subjectCollection.add('General');

    colorCollection = <Color>[];
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFF8B1FA9));

    employeeCollection = <String>[];
    employeeCollection.add('John');
    employeeCollection.add('Bryan');
    employeeCollection.add('Robert');
    employeeCollection.add('Kenny');
    employeeCollection.add('Tia');
    employeeCollection.add('Theresa');
    employeeCollection.add('Edith');

    userImages = <String>[];
    userImages.add('images/people_1.png');
    userImages.add('images/people_2.png');
    userImages.add('images/people_3.png');
    userImages.add('images/people_4.png');
    userImages.add('images/people_5.png');
    userImages.add('images/people_6.png');
    userImages.add('images/people_7.png');
    userImages.add('images/people_8.png');
  }

  void addAppointments() {
    shiftCollection = <Shift>[];
    final DateTime date =
        DateTime.now().add(Duration(days: -210 + _selectedEmployeeIndex));
    final String _employeeName = employeeCollection[_selectedEmployeeIndex];
    for (int j = 0; j < 3; j++) {
      final DateTime _shiftStartTime = date.add(Duration(days: j * 2));
      shiftCollection.add(Shift(
          _employeeName,
          subjectCollection[j],
          _shiftStartTime,
          _shiftStartTime,
          true,
          colorCollection[j],
          _getWeeklyRecurrenceFromWeekday(_shiftStartTime.weekday)));
    }
  }

  String _getWeeklyRecurrenceFromWeekday(int weekday) {
    String endString = 'MO,TU';
    if (weekday == 2) {
      endString = 'TU,WE';
    } else if (weekday == 3) {
      endString = 'WE,TH';
    } else if (weekday == 4) {
      endString = 'TH,FR';
    } else if (weekday == 5) {
      endString = 'FR,SA';
    } else if (weekday == 6) {
      endString = 'SA,SU';
    } else if (weekday == 7) {
      endString = 'SU,MO';
    }

    return 'FREQ=WEEKLY;INTERVAL=1;BYDAY=' + endString + ';UNTIL=20301231';
  }

  SfCalendar getShiftScheduler([CalendarDataSource _calendarDataSource]) {
    return SfCalendar(
      view: CalendarView.month,
      showNavigationArrow: kIsWeb,
      dataSource: _calendarDataSource,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayCount: 3,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }
}

class ShiftDataSource extends CalendarDataSource {
  ShiftDataSource(this.source);

  List<Shift> source;

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
  String getSubject(int index) {
    return source[index].shift;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }
}

class Shift {
  Shift(this.employeeName, this.shift, this.from, this.to, this.isAllDay,
      this.background, this.recurrenceRule);

  String employeeName;
  String shift;
  DateTime from;
  DateTime to;
  bool isAllDay;
  Color background;
  String recurrenceRule;
}
