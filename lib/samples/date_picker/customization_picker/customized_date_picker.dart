import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

//ignore: must_be_immutable
class CustomizedDatePicker extends StatefulWidget {
  CustomizedDatePicker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _CustomizedDatePickerState createState() =>
      _CustomizedDatePickerState(sample);
}

class _CustomizedDatePickerState extends State<CustomizedDatePicker> {
  _CustomizedDatePickerState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<DateTime> _specialDates;

  Widget sampleWidget(SampleModel model) => CustomizedDatePicker();

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    _specialDates = _getSpecialDates();
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  List<DateTime> _getSpecialDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 200));
    final DateTime endDate = DateTime.now().add(const Duration(days: 500));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 25))) {
      for (int i = 0; i < 3; i++) {
        dates.add(date.add(Duration(days: random.nextInt(i + 4))));
      }
    }

    return dates;
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(CustomizedDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          final Widget _datePicker = Card(
            elevation: 10,
            margin: model.isWeb
                ? const EdgeInsets.fromLTRB(30, 60, 30, 0)
                : const EdgeInsets.all(30),
            child: Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                color: model.cardThemeColor,
                child: getCustomizedDatePicker(_specialDates, model.themeData)),
          );
          return Scaffold(
            backgroundColor: model.themeData == null ||
                    model.themeData.brightness == Brightness.light
                ? null
                : Colors.black,
            body: Column(children: <Widget>[
              Expanded(
                  flex: model.isWeb ? 9 : 8,
                  child: kIsWeb
                      ? Center(
                          child: Container(
                              width: 400, height: 600, child: _datePicker))
                      : _datePicker),
              Expanded(flex: model.isWeb ? 1 : 2, child: Container())
            ]),
          );
        });
  }
}

SfDateRangePicker getCustomizedDatePicker(
    [List<DateTime> specialDates, ThemeData theme]) {
  final bool isDark = theme != null &&
      theme.brightness != null &&
      theme.brightness == Brightness.dark;

  final Color monthCellBackground =
      isDark ? const Color(0xFF232731) : const Color(0xfff7f4ff);
  final Color indicatorColor =
      isDark ? const Color(0xFF5CFFB7) : const Color(0xFF1AC4C7);
  final Color highlightColor =
      isDark ? const Color(0xFF5CFFB7) : Colors.deepPurpleAccent;
  final Color cellTextColor =
      isDark ? const Color(0xFFDFD4FF) : const Color(0xFF130438);

  return SfDateRangePicker(
    selectionShape: DateRangePickerSelectionShape.rectangle,
    minDate: DateTime.now().add(const Duration(days: -200)),
    maxDate: DateTime.now().add(const Duration(days: 500)),
    headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 18,
          color: cellTextColor,
        )),
    monthCellStyle: DateRangePickerMonthCellStyle(
      cellDecoration: MonthCellDecoration(
          borderColor: null,
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor),
      todayCellDecoration: MonthCellDecoration(
          borderColor: highlightColor,
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor),
      specialDatesDecoration: MonthCellDecoration(
          borderColor: null,
          backgroundColor: monthCellBackground,
          showIndicator: true,
          indicatorColor: indicatorColor),
      disabledDatesTextStyle: TextStyle(
        color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe),
      ),
      selectionColor: highlightColor,
      weekendTextStyle: TextStyle(
        color: highlightColor,
      ),
      textStyle: TextStyle(color: cellTextColor, fontSize: 14),
      specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
      selectionTextStyle:
          TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 14),
      todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
    ),
    yearCellStyle: DateRangePickerYearCellStyle(
      todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
      textStyle: TextStyle(color: cellTextColor, fontSize: 14),
      disabledDatesTextStyle: TextStyle(
          color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe)),
      leadingDatesTextStyle:
          TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
    ),
    showNavigationArrow: true,
    todayHighlightColor: highlightColor,
    monthViewSettings: DateRangePickerMonthViewSettings(
      firstDayOfWeek: 1,
      viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
              fontSize: 10, color: cellTextColor, fontWeight: FontWeight.w600)),
      dayFormat: 'EEE',
      showTrailingAndLeadingDates: false,
      specialDates: specialDates,
    ),
  );
}

/// [MonthCellDecoration] used to customize the month cell background of [SfDateRangePicker].
/// [backgroundColor] property used to draw the fill color the month cell
/// [borderColor] property used to draw the border to highlight the today month cell
/// [showIndicator] property used to decide whether the cell have indicator or not. it is
/// enabled then draw the circle on right top corner with [indicatorColor].
class MonthCellDecoration extends Decoration {
  const MonthCellDecoration(
      {this.borderColor,
      this.backgroundColor,
      this.showIndicator,
      this.indicatorColor});

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _MonthCellDecorationPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        showIndicator: showIndicator,
        indicatorColor: indicatorColor);
  }
}

/// [_MonthCellDecorationPainter] used to paint month cell decoration.
class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter(
      {this.borderColor,
      this.backgroundColor,
      this.showIndicator,
      this.indicatorColor});

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor;
      canvas.drawRRect(
          RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }

    if (showIndicator) {
      paint.color = indicatorColor;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}
