///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/model.dart';
import '../../../../../model/sample_view.dart';

///Renders range slider with customized divisor
class VerticalDivisorCustomizedRangeSlider extends SampleView {
  @override
  _VerticalDivisorCustomizedRangeSliderState createState() =>
      _VerticalDivisorCustomizedRangeSliderState();
}

class _VerticalDivisorCustomizedRangeSliderState extends SampleViewState {
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = Colors.blue;
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor.withOpacity(0.5),
          activeTrackColor: _activeColor,
          thumbColor: _activeColor,
          inactiveDivisorColor: const Color.fromARGB(255, 194, 194, 194),
          activeDivisorColor: Colors.blue,
          overlayColor: _activeColor.withOpacity(0.12),
          tooltipBackgroundColor: _activeColor),
      child: SfRangeSlider.vertical(
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
        enableTooltip: true,
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
    isActive =
        center.dy <= startThumbCenter!.dy && center.dy >= endThumbCenter!.dy;

    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 10.0, height: 5.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive
              ? themeData!.activeDivisorColor!
              : model.themeData.canvasColor);
  }
}
