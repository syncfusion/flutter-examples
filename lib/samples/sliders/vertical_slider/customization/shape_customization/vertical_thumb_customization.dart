///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders slider with customized thumb
class VerticalThumbCustomizedSlider extends SampleView {
  @override
  _VerticalThumbCustomizedSliderState createState() =>
      _VerticalThumbCustomizedSliderState();
}

class _VerticalThumbCustomizedSliderState extends SampleViewState {
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
          inactiveDivisorRadius: 2.0),
      child: SfSlider.vertical(
        min: 0.0,
        max: 100.0,
        value: _sliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _sliderValue = values as double;
          });
        },
        interval: 10,
        showDivisors: true,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: _RectThumbShape(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _thumbCustomizedSlider();
  }
}

class _RectThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
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

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 20, center.dy - 15);
    path.lineTo(center.dx + 20, center.dy + 15);
    path.close();
    context.canvas.drawPath(
        path,
        Paint()
          ..color = themeData.activeTrackColor!
          ..style = PaintingStyle.fill
          ..strokeWidth = 2);
  }
}
