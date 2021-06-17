///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/model.dart';
import '../../../../../model/sample_view.dart';

///Renders slider with customized divisor
class VerticalDivisorCustomizedSlider extends SampleView {
  @override
  _VerticalDivisorCustomizedSliderState createState() =>
      _VerticalDivisorCustomizedSliderState();
}

class _VerticalDivisorCustomizedSliderState extends SampleViewState {
  double _value = 60.0;

  @override
  Widget build(BuildContext context) {
    return SfSlider.vertical(
      min: 0.0,
      max: 100.0,
      value: _value,
      onChanged: (dynamic values) {
        setState(() {
          _value = values as double;
        });
      },
      interval: 10,
      showDivisors: true,
      numberFormat: NumberFormat('#'),
      divisorShape: _DivisorShape(model),
    );
  }
}

class _DivisorShape extends SfDivisorShape {
  _DivisorShape(this.model);

  SampleModel model;

  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {RenderBox? parentBox,
      SfSliderThemeData? themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      Paint? paint,
      Animation<double>? enableAnimation,
      TextDirection? textDirection}) {
    bool isActive;

    isActive = center.dy >= thumbCenter!.dy;

    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 10.0, height: 5.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive
              ? themeData!.activeTrackColor!
              : model.themeData.canvasColor);
  }
}
