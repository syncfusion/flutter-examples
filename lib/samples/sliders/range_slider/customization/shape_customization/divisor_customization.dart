import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DivisorCustomizedRangeSlider extends SampleView {
  @override
  _DivisorCustomizedRangeSliderState createState() =>
      _DivisorCustomizedRangeSliderState();
}

class _DivisorCustomizedRangeSliderState
    extends SampleViewState {
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor.withOpacity(0.5),
          activeTrackColor: _activeColor,
          inactiveTrackHeight: 5.0,
          activeTrackHeight: 5.0,
          thumbColor: _activeColor,
          inactiveDivisorColor:
              const Color.fromARGB(255, 214, 214, 214).withOpacity(1),
          activeDivisorColor: const Color.fromARGB(255, 255, 0, 58),
          overlayColor: _activeColor.withOpacity(0.12),
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
        showDivisors: true,
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        divisorShape: _DivisorShape(model),
      ),
    );
  }
}

 class _DivisorShape extends SfDivisorShape {

   _DivisorShape(this.model);
   SampleModel model;

  @override
  void paint(PaintingContext context, Offset center,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      {RenderBox parentBox,
        SfSliderThemeData themeData,
        SfRangeValues currentValues,
        dynamic currentValue,
        Paint paint,
        Animation<double> enableAnimation,
        TextDirection textDirection})
  {
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive =
            center.dx >= startThumbCenter.dx && center.dx <= endThumbCenter.dx;
        break;
      case TextDirection.rtl:
        isActive =
            center.dx >= endThumbCenter.dx && center.dx <= startThumbCenter.dx;
        break;
    }

    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 5.0, height: 10.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive ? themeData.activeDivisorColor : model.themeData.canvasColor);
  }
}
