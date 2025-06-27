///Dart import
import 'dart:math' as math;

///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders range slider with customized tick
class VerticalTickCustomizedRangeSlider extends SampleView {
  /// Creates range slider with customized tick
  const VerticalTickCustomizedRangeSlider(Key key) : super(key: key);
  @override
  _VerticalTickCustomizedRangeSliderState createState() =>
      _VerticalTickCustomizedRangeSliderState();
}

class _VerticalTickCustomizedRangeSliderState extends SampleViewState {
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor.withValues(alpha: 0.5),
        activeTrackColor: _activeColor,
        inactiveTickColor: _inactiveColor.withValues(alpha: 0.8),
        activeTickColor: _activeColor,
        inactiveMinorTickColor: _inactiveColor,
        activeMinorTickColor: _activeColor,
        thumbColor: _activeColor,
        overlayColor: _activeColor.withValues(alpha: 0.24),
        tickOffset: Offset.zero,
        tooltipBackgroundColor: _activeColor,
      ),
      child: SfRangeSlider.vertical(
        max: 100.0,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        interval: 10,
        minorTicksPerInterval: 3,
        showTicks: true,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
        tickShape: _TickShape(),
        minorTickShape: _MinorTickShape(),
      ),
    );
  }
}

class _TickShape extends SfTickShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Animation<double>? enableAnimation,
    TextDirection? textDirection,
  }) {
    final Size tickSize = getPreferredSize(themeData!);
    final bool isTickRightOfThumb = endThumbCenter == null
        ? offset.dy < thumbCenter!.dy
        : offset.dy > startThumbCenter!.dy || offset.dy < endThumbCenter.dy;
    final Color begin = isTickRightOfThumb
        ? themeData.disabledInactiveTickColor!
        : themeData.disabledActiveTickColor!;
    final Color end = isTickRightOfThumb
        ? themeData.inactiveTickColor!
        : themeData.activeTickColor!;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = tickSize.height
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation!)!;
    context.canvas.drawLine(
      offset,
      Offset(offset.dx + tickSize.width, offset.dy),
      paint,
    );
    context.canvas.drawLine(
      Offset(
        offset.dx -
            2 * themeData.tickOffset!.dx -
            math.max(
              themeData.activeTrackHeight,
              themeData.inactiveTrackHeight,
            ),
        offset.dy,
      ),
      Offset(
        offset.dx -
            2 * themeData.tickOffset!.dx -
            math.max(
              themeData.activeTrackHeight,
              themeData.inactiveTrackHeight,
            ) -
            tickSize.width,
        offset.dy,
      ),
      paint,
    );
  }
}

class _MinorTickShape extends SfTickShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Animation<double>? enableAnimation,
    TextDirection? textDirection,
    bool? isVertical,
  }) {
    final Size minorTickSize = getPreferredSize(themeData!);
    final bool isMinorTickRightOfThumb = endThumbCenter == null
        ? offset.dy < thumbCenter!.dy
        : offset.dy > startThumbCenter!.dy || offset.dy < endThumbCenter.dy;
    final Color begin = isMinorTickRightOfThumb
        ? themeData.disabledInactiveMinorTickColor!
        : themeData.disabledActiveMinorTickColor!;
    final Color end = isMinorTickRightOfThumb
        ? themeData.inactiveMinorTickColor!
        : themeData.activeMinorTickColor!;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = minorTickSize.height
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation!)!;
    context.canvas.drawLine(
      offset,
      Offset(offset.dx + minorTickSize.width, offset.dy),
      paint,
    );
    context.canvas.drawLine(
      Offset(
        offset.dx -
            2 * themeData.tickOffset!.dx -
            math.max(
              themeData.activeTrackHeight,
              themeData.inactiveTrackHeight,
            ),
        offset.dy,
      ),
      Offset(
        offset.dx -
            2 * themeData.tickOffset!.dx -
            math.max(
              themeData.activeTrackHeight,
              themeData.inactiveTrackHeight,
            ) -
            minorTickSize.width,
        offset.dy,
      ),
      paint,
    );
  }
}
