import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:flutter_examples/samples/slider/slider_utils.dart';

class ThumbCustomizedRangeSlider extends StatefulWidget {
  @override
  _ThumbCustomizedRangeSliderState createState() =>
      _ThumbCustomizedRangeSliderState();
}

class _ThumbCustomizedRangeSliderState
    extends State<ThumbCustomizedRangeSlider> {
  SfRangeValues _singleStrokeSliderValues = const SfRangeValues(30.0, 70.0);
  SfRangeValues _doubleStrokeSliderValues = const SfRangeValues(30.0, 70.0);
  final Color _inactiveColor = const Color.fromARGB(255, 255, 146, 176);
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);

  SfRangeSliderTheme _strokeThumbRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor,
        activeTrackColor: _activeColor,
        thumbColor: Colors.white,
        overlayColor: _activeColor.withOpacity(0.12),
        tickOffset: const Offset(0, 13),
        inactiveTickColor: _inactiveColor,
        activeTickColor: _activeColor,
        inactiveMinorTickColor: _inactiveColor,
        activeMinorTickColor: _activeColor,
        tooltipBackgroundColor: _activeColor,
      ),
      child: SfRangeSlider(
        min: 0.0,
        max: 100.0,
        values: _singleStrokeSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _singleStrokeSliderValues = values;
          });
        },
        interval: 10,
        minorTicksPerInterval: 3,
        showTicks: true,
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: const _ThumbShape(false),
      ),
    );
  }

  SfRangeSliderTheme _doubleStrokeThumbRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor:
            const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
        tooltipBackgroundColor: const Color.fromARGB(255, 0, 178, 206),
      ),
      child: SfRangeSlider(
        min: 0.0,
        max: 100.0,
        values: _doubleStrokeSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _doubleStrokeSliderValues = values;
          });
        },
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: const _ThumbShape(true),
        activeColor: const Color.fromARGB(255, 0, 178, 206),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      title('Thumb'),
      _doubleStrokeThumbRangeSlider(),
      const SizedBox(height: 30),
      _strokeThumbRangeSlider(),
    ]);
  }
}

class _ThumbShape extends SfThumbShape {
  const _ThumbShape(this.isDoubleStroke);
  final bool isDoubleStroke;
  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection,
      SfThumb thumb}) {
    super.paint(context, center,
        isEnabled: isEnabled,
        parentBox: parentBox,
        themeData: themeData,
        animation: animation,
        textDirection: textDirection,
        thumb: thumb);

    context.canvas.drawCircle(
        center,
        getPreferredSize(themeData, isEnabled).width / 2,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..color = themeData.activeTrackColor);

    if (isDoubleStroke) {
      context.canvas.drawCircle(
          center,
          getPreferredSize(themeData, isEnabled).width / 3,
          Paint()
            ..isAntiAlias = true
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..color = Colors.white);
    }
  }
}
