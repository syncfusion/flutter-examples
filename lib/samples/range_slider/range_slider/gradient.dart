import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

bool isLeftThumb = true;

class GradientRangeSlider extends StatefulWidget {
  @override
  _GradientRangeSliderState createState() => _GradientRangeSliderState();
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

class _GradientRangeSliderState extends State<GradientRangeSlider> {
  final double _redGradientSliderMin = 0.0;
  final double _redGradientSliderMax = 6.0;

  final double _blueGradientSliderMin = 0.0;
  final double _blueGradientSliderMax = 6.0;

  SfRangeValues _redGradientSliderValues = const SfRangeValues(2.0, 4.0);
  SfRangeValues _blueGradientSliderValues = const SfRangeValues(2.0, 4.0);

  final Color _inactiveColor = const Color.fromRGBO(194, 194, 194, 0.5);

  SfRangeSliderTheme get redGradientRangeSlider => SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor,
          thumbColor: Colors.white,
          overlayColor:
              const Color.fromARGB(255, 255, 146, 1).withOpacity(0.12),
          trackHeight: 8.0,
          trackCornerRadius: 4.0,
        ),
        child: SfRangeSlider(
          min: _redGradientSliderMin,
          max: _redGradientSliderMax,
          values: _redGradientSliderValues,
          onChanged: (SfRangeValues values) {
            setState(() {
              _redGradientSliderValues = values;
            });
          },
          thumbShape: _ThumbShape(
              redGradientColor.colors[0], redGradientColor.colors[1]),
          overlayShape: _OverlayShape(
              redGradientColor.colors[0], redGradientColor.colors[1]),
          trackShape: _TrackShape(redGradientColor),
        ),
      );

  SfRangeSliderTheme get blueGradientRangeSlider => SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor,
          thumbColor: Colors.white,
          overlayColor:
              const Color.fromARGB(255, 0, 238, 217).withOpacity(0.12),
          trackHeight: 8.0,
          trackCornerRadius: 4.0,
        ),
        child: SfRangeSlider(
          min: _blueGradientSliderMin,
          max: _blueGradientSliderMax,
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
  Widget _getAlignedTextWidget(String text,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        padding: const EdgeInsets.only(left: 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getAlignedTextWidget('Gradient color'),
        const SizedBox(
          height: 10,
        ),
        redGradientRangeSlider,
        const SizedBox(height: 25.0),
        blueGradientRangeSlider
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
    final ColorTween activeTrackColorTween = ColorTween(
        begin: themeData.disabledActiveTrackColor,
        end: themeData.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: themeData.disabledInactiveTrackColor,
        end: themeData.inactiveTrackColor);

    final Radius radius = Radius.circular(themeData.trackCornerRadius);
    final Rect actualTrackRect =
        getPreferredRect(parentBox, themeData, offset, isEnabled);

    if (endThumbCenter == null) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = activeTrackColorTween.evaluate(animation);

      Rect trackRect = Rect.fromLTRB(actualTrackRect.left, actualTrackRect.top,
          startThumbCenter.dx, actualTrackRect.bottom);
      final RRect leftRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: radius, bottomLeft: radius);
      context.canvas.drawRRect(leftRRect, paint);

      paint.color = inactiveTrackColorTween.evaluate(animation);
      trackRect = Rect.fromLTRB(startThumbCenter.dx, actualTrackRect.top,
          actualTrackRect.right, actualTrackRect.bottom);
      final RRect rightRRect = RRect.fromRectAndCorners(trackRect,
          topRight: radius, bottomRight: radius);
      context.canvas.drawRRect(rightRRect, paint);
    } else {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = inactiveTrackColorTween.evaluate(animation);

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
      paint.color = inactiveTrackColorTween.evaluate(animation);
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
