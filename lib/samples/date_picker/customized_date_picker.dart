/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Date picker import.
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Render date picker widget with customized options.
class CustomizedDatePicker extends SampleView {
  /// Creates date picker widget with customized options.
  const CustomizedDatePicker(Key key) : super(key: key);

  @override
  _CustomizedDatePickerState createState() => _CustomizedDatePickerState();
}

class _CustomizedDatePickerState extends SampleViewState {
  _CustomizedDatePickerState();

  late List<DateTime> _specialDates;
  late Orientation _deviceOrientation;

  @override
  void initState() {
    _specialDates = _buildSpecialDates();
    super.initState();
  }

  /// Returns the list of dates which will set to the special dates of the
  /// date range picker.
  List<DateTime> _buildSpecialDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate = DateTime.now().subtract(
      const Duration(days: 200),
    );
    final DateTime endDate = DateTime.now().add(const Duration(days: 500));
    final Random random = Random.secure();
    for (
      DateTime date = startDate;
      date.isBefore(endDate);
      date = date.add(const Duration(days: 25))
    ) {
      for (int i = 0; i < 3; i++) {
        dates.add(date.add(Duration(days: random.nextInt(i + 4))));
      }
    }

    return dates;
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget datePicker = Card(
      elevation: 10,
      margin: model.isWebFullView
          ? const EdgeInsets.fromLTRB(30, 60, 30, 0)
          : const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        color: model.sampleOutputCardColor,
        child: _buildCustomizedDatePicker(_specialDates, model.themeData),
      ),
    );
    return Scaffold(
      backgroundColor:
          model.themeData == null ||
              model.themeData.colorScheme.brightness == Brightness.light
          ? null
          : const Color(0x00171a21),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: model.isWebFullView ? 9 : 8,
            child: model.isWebFullView
                ? Center(
                    child: SizedBox(width: 400, height: 600, child: datePicker),
                  )
                : ListView(
                    children: <Widget>[
                      SizedBox(height: 450, child: datePicker),
                    ],
                  ),
          ),
          Expanded(
            flex: model.isWebFullView
                ? 1
                : model.isMobileResolution &&
                      _deviceOrientation == Orientation.landscape
                ? 0
                : 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  /// Returns the date range picker based on the properties passed.
  SfDateRangePicker _buildCustomizedDatePicker(
    List<DateTime> specialDates,
    ThemeData theme,
  ) {
    final bool isDark =
        theme != null &&
        theme.brightness != null &&
        theme.brightness == Brightness.dark;

    final Color monthCellBackground = isDark
        ? const Color(0xFF232731)
        : const Color(0xfff7f4ff);
    final Color indicatorColor = isDark
        ? const Color(0xFF5CFFB7)
        : const Color(0xFF1AC4C7);
    final Color highlightColor = isDark
        ? const Color(0xFF5CFFB7)
        : Colors.deepPurpleAccent;
    final Color cellTextColor = isDark
        ? const Color(0xFFDFD4FF)
        : const Color(0xFF130438);

    return SfDateRangePicker(
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionColor: highlightColor,
      selectionTextStyle: TextStyle(
        color: isDark ? Colors.black : Colors.white,
        fontSize: 14,
      ),
      minDate: DateTime.now().add(const Duration(days: -200)),
      maxDate: DateTime.now().add(const Duration(days: 500)),
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(fontSize: 18, color: cellTextColor),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        cellDecoration: _MonthCellDecoration(
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor,
        ),
        todayCellDecoration: _MonthCellDecoration(
          borderColor: highlightColor,
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor,
        ),
        specialDatesDecoration: _MonthCellDecoration(
          backgroundColor: monthCellBackground,
          showIndicator: true,
          indicatorColor: indicatorColor,
        ),
        disabledDatesTextStyle: TextStyle(
          color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe),
        ),
        weekendTextStyle: TextStyle(color: highlightColor),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
      ),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        disabledDatesTextStyle: TextStyle(
          color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe),
        ),
        leadingDatesTextStyle: TextStyle(
          color: cellTextColor.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      showNavigationArrow: true,
      todayHighlightColor: highlightColor,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            fontSize: 10,
            color: cellTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        dayFormat: 'EEE',
        specialDates: specialDates,
      ),
    );
  }
}

/// [_MonthCellDecoration] customizes the background of month cells
/// in the [SfDateRangePicker].
/// [backgroundColor] property used to draw the fill color the month cell.
/// [borderColor] property used to draw the border to highlight the
/// today month cell.
/// [showIndicator] property used to decide whether the cell
/// have indicator or not.
/// If it is enabled a circle is drawn in the top right corner
/// using [indicatorColor].
class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration({
    this.borderColor,
    this.backgroundColor,
    required this.showIndicator,
    this.indicatorColor,
  });

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MonthCellDecorationPainter(
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      showIndicator: showIndicator,
      indicatorColor: indicatorColor,
    );
  }
}

/// [_MonthCellDecorationPainter] used to paint month cell decoration.
class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter({
    this.borderColor,
    this.backgroundColor,
    required this.showIndicator,
    this.indicatorColor,
  });

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size!;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(5)),
      paint,
    );
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor!;
      canvas.drawRRect(
        RRect.fromRectAndRadius(bounds, const Radius.circular(5)),
        paint,
      );
    }

    if (showIndicator) {
      paint.color = indicatorColor!;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}
