import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class ThumbCustomizedSlider extends SampleView {
  @override
  _ThumbCustomizedSliderState createState() =>
      _ThumbCustomizedSliderState();
}

class _ThumbCustomizedSliderState
    extends SampleViewState {
  double _sliderValue = 60.0;
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);

  SfSliderTheme _thumbCustomizedSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        inactiveTrackColor: _activeColor.withOpacity(0.40),
        activeTrackColor: _activeColor,
        thumbColor: Colors.transparent,
        tickOffset: const Offset(0, 13),
        overlayColor: Colors.transparent,
        tooltipBackgroundColor: _activeColor,
        activeDivisorColor: _activeColor,
        inactiveDivisorColor: _activeColor.withOpacity(0.80),
        activeDivisorRadius: 2.0,
        inactiveDivisorRadius: 2.0
      ),
      child: SfSlider(
        min: 0.0,
        max: 100.0,
        value: _sliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _sliderValue = values;
          });
        },
        interval: 10,
        showDivisors: true,
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: _RectThumbShape(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      title('Thumb'),
      _thumbCustomizedSlider(),
    ]);
  }
}

class _RectThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {RenderBox parentBox,
        RenderBox child,
        SfSliderThemeData themeData,
        SfRangeValues currentValues,
        dynamic currentValue,
        Paint paint,
        Animation<double> enableAnimation,
        TextDirection textDirection,
        SfThumb thumb}) {
    super.paint(context, center,
        parentBox: parentBox,
        child: child,
        themeData: themeData,
        currentValue: currentValue,
        paint: paint,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumb: thumb);

    final Path path = Path();

    path.moveTo(center.dx , center.dy);
    path.lineTo(center.dx + 10, center.dy - 15);
    path.lineTo(center.dx - 10, center.dy - 15);
    path.close();
    context.canvas.drawPath(path, Paint()
        ..color = themeData.activeTrackColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 2);
  }
}
