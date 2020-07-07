import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DivisorCustomizedSlider extends SampleView {
  @override
  _DivisorCustomizedSliderState createState() =>
      _DivisorCustomizedSliderState();
}

class _DivisorCustomizedSliderState
    extends SampleViewState {
  double _value = 60.0;

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
          inactiveTrackHeight: 5.0,
          activeTrackHeight: 5.0,
      ),
      child: SfSlider(
        min: 0.0,
        max: 100.0,
        value: _value,
        onChanged: (dynamic values) {
          setState(() {
            _value = values;
          });
        },
        interval: 10,
        showDivisors: true,
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
      Offset thumbCenter, Offset startThumbCenter, Offset endThumbCenter,
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
            center.dx <= thumbCenter.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter.dx;
        break;
    }

    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 5.0, height: 10.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive ? themeData.activeTrackColor : model.themeData.canvasColor);
  }
}
