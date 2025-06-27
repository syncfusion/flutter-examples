/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Widget of Calendar rtl.
class CalendarRtl extends DirectionalitySampleView {
  /// Creates default Calendar rtl.
  const CalendarRtl(Key key) : super(key: key);

  @override
  _CalendarRtlState createState() => _CalendarRtlState();
}

class _CalendarRtlState extends DirectionalitySampleViewState {
  /// Update the current view as month view.
  late CalendarView _currentView;
  late _DataSource _events;

  /// Global key used to maintain the state,
  /// when we change the parent of the widget.
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _currentView = CalendarView.month;
    _calendarController.view = _currentView;
    _events = _DataSource(getAppointmentList(getArabicTexts()));
    super.initState();
  }

  @override
  Widget buildSample(BuildContext context) {
    if (model.locale == const Locale('en', 'US')) {
      _events = _DataSource(getAppointmentList(getSubjectTexts()));
    } else {
      _events = _DataSource(getAppointmentList(getArabicTexts()));
    }
    final Widget calendar = Theme(
      /// The key set here to maintain the state,
      /// when we change the parent of the widget.
      key: _globalKey,
      data: model.themeData.copyWith(
        colorScheme: model.themeData.colorScheme.copyWith(
          secondary: model.primaryColor,
        ),
      ),
      child: _getCalendar(_calendarController, _events, _onViewChanged),
    );
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child:
                _calendarController.view == CalendarView.month &&
                    model.isWebFullView &&
                    screenHeight < 800
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      children: <Widget>[
                        Container(
                          color: model.sampleOutputCardColor,
                          height: 600,
                          child: calendar,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: model.sampleOutputCardColor,
                    child: calendar,
                  ),
          ),
        ],
      ),
    );
  }

  List<String> getSubjectTexts() {
    final List<String> subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Planning');
    subjectCollection.add('Automation');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Scrum');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Testing');
    return subjectCollection;
  }

  List<String> getArabicTexts() {
    final List<String> subjectCollection = <String>[];
    subjectCollection.add('اجتماع عام');
    subjectCollection.add('تخطيط');
    subjectCollection.add('التشغيل الآلي');
    subjectCollection.add('مستشار');
    subjectCollection.add('الدعم');
    subjectCollection.add('اجتماع التنمية');
    subjectCollection.add('سكرم');
    subjectCollection.add('اكتمال المشروع');
    subjectCollection.add('إصدار التحديثات');
    subjectCollection.add('اختبارات');
    return subjectCollection;
  }

  /// Creates the required appointment details as a list.
  List<Appointment> getAppointmentList(List<String> subjectCollection) {
    final List<Color> colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));
    final List<Appointment> appointmentCollection = <Appointment>[];
    final DateTime rangeStartDate = DateTime.now().add(
      const Duration(days: -10),
    );
    final DateTime rangeEndDate = DateTime.now().add(const Duration(days: 10));
    for (
      DateTime i = rangeStartDate;
      i.isBefore(rangeEndDate);
      i = i.add(const Duration(days: 1))
    ) {
      final DateTime date = i;
      for (int j = 0; j < 2; j++) {
        final DateTime startDate = DateTime(date.year, date.month, date.day);
        appointmentCollection.add(
          Appointment(
            startTime: startDate.add(Duration(hours: j == 0 ? 9 : 14)),
            endTime: startDate.add(const Duration(hours: 2)),
            subject: subjectCollection[j],
            color: colorCollection[j],
          ),
        );
      }
    }
    return appointmentCollection;
  }

  /// Update the current view when the view changed and update the scroll view
  /// when the view changes from or to month view because month view placed
  /// on scroll view.
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
    if (_currentView != CalendarView.month &&
        _calendarController.view != CalendarView.month) {
      _currentView = _calendarController.view!;
      return;
    }
    _currentView = _calendarController.view!;
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

  Widget _getCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
  ]) {
    return SfCalendar(
      allowedViews: const <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.month,
        CalendarView.timelineDay,
        CalendarView.timelineWeek,
        CalendarView.timelineWorkWeek,
        CalendarView.schedule,
      ],
      showDatePickerButton: true,
      controller: calendarController,
      dataSource: calendarDataSource,
      showNavigationArrow: model.isWebFullView,
      onViewChanged: viewChangedCallback,
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
