import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TickCustomizedRangeSlider extends StatefulWidget {
  @override
  _TickCustomizedRangeSliderState createState() =>
      _TickCustomizedRangeSliderState();
}

class _TickCustomizedRangeSliderState extends State<TickCustomizedRangeSlider> {
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor.withOpacity(0.5),
          activeTrackColor: _activeColor,
          inactiveTickColor: _inactiveColor.withOpacity(0.8),
          activeTickColor: _activeColor,
          inactiveMinorTickColor: _inactiveColor,
          activeMinorTickColor: _activeColor,
          thumbColor: _activeColor,
          tickOffset: const Offset(0, 4),
          tooltipBackgroundColor: _activeColor),
      child: SfRangeSlider(
        min: 0.0,
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
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        tickShape: _TickShape(),
        minorTickShape: _MinorTickShape(),
      ),
    );
  }
}

class _TickShape extends SfTickShape {
  @override
  void paint(PaintingContext context, Offset offset, Offset startThumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection}) {
    final Size tickSize = getPreferredSize(themeData, isEnabled);
    final bool isTickRightOfThumb = endThumbCenter == null
        ? offset.dx > startThumbCenter.dx
        : offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter.dx;
    final Color begin = isTickRightOfThumb
        ? themeData.disabledInactiveTickColor
        : themeData.disabledActiveTickColor;
    final Color end = isTickRightOfThumb
        ? themeData.inactiveTickColor
        : themeData.activeTickColor;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = tickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(animation);
    context.canvas.drawLine(
        offset, Offset(offset.dx, offset.dy + tickSize.height), paint);
    context.canvas.drawLine(
        Offset(offset.dx,
            offset.dy - 2 * themeData.tickOffset.dy - themeData.trackHeight),
        Offset(
            offset.dx,
            offset.dy -
                2 * themeData.tickOffset.dy -
                themeData.trackHeight -
                tickSize.height),
        paint);
  }
}

class _MinorTickShape extends SfMinorTickShape {
  @override
  void paint(PaintingContext context, Offset offset, Offset startThumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection}) {
    final Size minorTickSize = getPreferredSize(themeData, isEnabled);
    final bool isMinorTickRightOfThumb = endThumbCenter == null
        ? offset.dx > startThumbCenter.dx
        : offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter.dx;

    final Color begin = isMinorTickRightOfThumb
        ? themeData.disabledInactiveMinorTickColor
        : themeData.disabledActiveMinorTickColor;
    final Color end = isMinorTickRightOfThumb
        ? themeData.inactiveMinorTickColor
        : themeData.activeMinorTickColor;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = minorTickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(animation);
    context.canvas.drawLine(
        offset, Offset(offset.dx, offset.dy + minorTickSize.height), paint);
    context.canvas.drawLine(
        Offset(offset.dx,
            offset.dy - 2 * themeData.tickOffset.dy - themeData.trackHeight),
        Offset(
            offset.dx,
            offset.dy -
                2 * themeData.tickOffset.dy -
                themeData.trackHeight -
                minorTickSize.height),
        paint);
  }
}
