import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:flutter_examples/samples/slider/slider_utils.dart';

class GradientTrackRangeSlider extends StatefulWidget {
  @override
  _GradientTrackRangeSliderState createState() =>
      _GradientTrackRangeSliderState();
}

LinearGradient get redGradientColor {
  final List<Color> colors = <Color>[];
  colors.add(const Color.fromARGB(255, 255, 148, 0));
  colors.add(const Color.fromARGB(255, 255, 0, 85));
  final List<double> stops = <double>[0.0, 1.0];
  return LinearGradient(colors: colors, stops: stops);
}

LinearGradient get blueGradientColor {
  final List<Color> colors = <Color>[];
  colors.add(const Color.fromARGB(255, 0, 238, 217));
  colors.add(const Color.fromARGB(255, 88, 124, 241));
  final List<double> stops = <double>[0.0, 1.0];
  return LinearGradient(colors: colors, stops: stops);
}

class _GradientTrackRangeSliderState extends State<GradientTrackRangeSlider> {
  SfRangeValues _redGradientSliderValues = const SfRangeValues(2.0, 4.0);
  SfRangeValues _blueGradientSliderValues = const SfRangeValues(2.0, 4.0);

  final Color _inactiveColor = const Color.fromRGBO(194, 194, 194, 0.5);

  SfRangeSliderTheme _redGradientRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor,
        thumbColor: Colors.white,
        overlayColor: const Color.fromARGB(255, 255, 146, 1).withOpacity(0.12),
        trackHeight: 8.0,
        trackCornerRadius: 4.0,
      ),
      child: SfRangeSlider(
        min: 0.0,
        max: 6.0,
        values: _redGradientSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _redGradientSliderValues = values;
          });
        },
        thumbShape:
            _ThumbShape(redGradientColor.colors[0], redGradientColor.colors[1]),
        overlayShape: _OverlayShape(
            redGradientColor.colors[0], redGradientColor.colors[1]),
        trackShape: _TrackShape(redGradientColor),
      ),
    );
  }

  SfRangeSliderTheme _blueGradientRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor,
        thumbColor: Colors.white,
        overlayColor: const Color.fromARGB(255, 0, 238, 217).withOpacity(0.12),
        trackHeight: 8.0,
        trackCornerRadius: 4.0,
      ),
      child: SfRangeSlider(
        min: 0.0,
        max: 6.0,
        values: _blueGradientSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _blueGradientSliderValues = values;
          });
        },
        thumbShape: _ThumbShape(
            blueGradientColor.colors[0], blueGradientColor.colors[1]),
        overlayShape: _OverlayShape(
            blueGradientColor.colors[0], blueGradientColor.colors[1]),
        trackShape: _TrackShape(blueGradientColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TrackColorCustomizedRangeSlider(),
        const SizedBox(height: 25),
        title('Gradient color'),
        columnSpacing10,
        _redGradientRangeSlider(),
        const SizedBox(height: 25.0),
        _blueGradientRangeSlider()
      ],
    );
  }
}

class _ThumbShape extends SfThumbShape {
  const _ThumbShape(this.leftThumbColor, this.rightThumbColor);

  final Color leftThumbColor;
  final Color rightThumbColor;

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
        textDirection: textDirection);

    context.canvas.drawCircle(
        center,
        getPreferredSize(themeData, isEnabled).width / 2,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..color = thumb == SfThumb.start ? leftThumbColor : rightThumbColor);
  }
}

class _OverlayShape extends SfOverlayShape {
  const _OverlayShape(this.leftThumbColor, this.rightThumbColor);

  final Color leftThumbColor;
  final Color rightThumbColor;

  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      SfThumb thumb}) {
    final double radius = getPreferredSize(themeData, isEnabled).width / 2;
    final Tween<double> tween = Tween<double>(begin: 0.0, end: radius);

    context.canvas.drawCircle(
        center,
        tween.evaluate(animation),
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 0
          ..color = (thumb == SfThumb.start ? leftThumbColor : rightThumbColor)
              .withOpacity(0.12));
  }
}

class _TrackShape extends SfTrackShape {
  const _TrackShape(this.gradient);
  final Gradient gradient;
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset startThumbCenter,
    Offset endThumbCenter, {
    bool isEnabled,
    RenderProxyBox parentBox,
    SfRangeSliderThemeData themeData,
    Animation<double> animation,
    TextDirection textDirection,
  }) {
    final Radius radius = Radius.circular(themeData.trackCornerRadius);
    final Rect actualTrackRect =
        getPreferredRect(parentBox, themeData, offset, isEnabled);

    if (endThumbCenter == null) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = themeData.activeTrackColor;

      Rect trackRect = Rect.fromLTRB(actualTrackRect.left, actualTrackRect.top,
          startThumbCenter.dx, actualTrackRect.bottom);
      final RRect leftRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: radius, bottomLeft: radius);
      context.canvas.drawRRect(leftRRect, paint);

      paint.color = themeData.inactiveTrackColor;
      trackRect = Rect.fromLTRB(startThumbCenter.dx, actualTrackRect.top,
          actualTrackRect.right, actualTrackRect.bottom);
      final RRect rightRRect = RRect.fromRectAndCorners(trackRect,
          topRight: radius, bottomRight: radius);
      context.canvas.drawRRect(rightRRect, paint);
    } else {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = themeData.inactiveTrackColor;

      // Drawing inactive track.
      Rect trackRect = Rect.fromLTRB(actualTrackRect.left, actualTrackRect.top,
          startThumbCenter.dx, actualTrackRect.bottom);
      final RRect leftRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: radius, bottomLeft: radius);
      context.canvas.drawRRect(leftRRect, paint);

      // Drawing active track.
      trackRect = Rect.fromLTRB(startThumbCenter.dx, actualTrackRect.top,
          endThumbCenter.dx, actualTrackRect.bottom);
      paint.shader = gradient.createShader(trackRect);
      final RRect centerRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero);
      context.canvas.drawRRect(centerRRect, paint);

      // Drawing inactive track.
      paint.shader = null;
      paint.color = themeData.inactiveTrackColor;
      trackRect = Rect.fromLTRB(endThumbCenter.dx, actualTrackRect.top,
          actualTrackRect.width + actualTrackRect.left, actualTrackRect.bottom);
      final RRect rightRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: Radius.zero,
          topRight: radius,
          bottomLeft: Radius.zero,
          bottomRight: radius);
      context.canvas.drawRRect(rightRRect, paint);
    }
  }
}

class TrackColorCustomizedRangeSlider extends StatefulWidget {
  @override
  _TrackColorCustomizedRangeSliderState createState() =>
      _TrackColorCustomizedRangeSliderState();
}

class _TrackColorCustomizedRangeSliderState
    extends State<TrackColorCustomizedRangeSlider> {
  final double _min = 0.0;
  final double _max = 6.0;
  final Color _activeColor = const Color.fromRGBO(255, 125, 30, 1);
  final Color _inactiveTickColor = const Color.fromRGBO(200, 200, 200, 1);
  SfRangeValues _values = const SfRangeValues(2.0, 4.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
          inactiveTickColor: _inactiveTickColor,
          activeTickColor: _activeColor,
          inactiveMinorTickColor: _inactiveTickColor,
          activeMinorTickColor: _activeColor,
          inactiveTrackColor: const Color.fromRGBO(194, 194, 194, 0.5)),
      child: SfRangeSlider(
        min: _min,
        max: _max,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        interval: 1,
        minorTicksPerInterval: 3,
        showTicks: true,
        activeColor: _activeColor,
      ),
    );
  }
}
