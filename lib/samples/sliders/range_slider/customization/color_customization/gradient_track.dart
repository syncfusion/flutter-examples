///Package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';

/// Renders range slider with gradient track
class GradientTrackRangeSlider extends SampleView {
  ///Creates range slider with gradient track.
  const GradientTrackRangeSlider(Key key) : super(key: key);

  @override
  _GradientTrackRangeSliderState createState() =>
      _GradientTrackRangeSliderState();
}

class _GradientTrackRangeSliderState extends SampleViewState {
  SfRangeValues _blueGradientSliderValues = const SfRangeValues(2.0, 4.0);
  SfRangeValues _sliderValues = const SfRangeValues(20.0, 80.0);

  final Color _inactiveColor = const Color.fromRGBO(194, 194, 194, 0.5);
  LinearGradient get _blueGradientColor {
    final List<Color> colors = <Color>[];
    colors.add(const Color.fromARGB(255, 0, 238, 217));
    colors.add(const Color.fromARGB(255, 88, 124, 241));
    final List<double> stops = <double>[0.0, 1.0];
    return LinearGradient(colors: colors, stops: stops);
  }

  SfRangeSliderTheme _blueGradientRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor,
        thumbColor: Colors.white,
        overlayColor: const Color.fromARGB(
          255,
          0,
          238,
          217,
        ).withValues(alpha: 0.12),
        activeTrackHeight: 8.0,
        inactiveTrackHeight: 8.0,
        trackCornerRadius: 4.0,
      ),
      child: SfRangeSlider(
        max: 6.0,
        values: _blueGradientSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _blueGradientSliderValues = values;
          });
        },
        thumbShape: _ThumbShape(
          _blueGradientColor.colors[0],
          _blueGradientColor.colors[1],
        ),
        overlayShape: _OverlayShape(
          _blueGradientColor.colors[0],
          _blueGradientColor.colors[1],
        ),
        trackShape: _TrackShape(_blueGradientColor),
      ),
    );
  }

  SfRangeSliderTheme _rangeSliderWithThumbCustomization() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveDividerColor: Colors.white,
        activeDividerColor: Colors.white,
        activeDividerStrokeWidth: 2,
        activeDividerStrokeColor: _inactiveColor,
        inactiveDividerStrokeWidth: 2,
        inactiveDividerStrokeColor: Colors.tealAccent,
        activeDividerRadius: 5.0,
        inactiveDividerRadius: 5.0,
        activeTrackColor: Colors.tealAccent,
        inactiveTrackColor: _inactiveColor,
        overlayColor: Colors.tealAccent.withValues(alpha: 0.12),
        thumbColor: Colors.white,
        thumbStrokeWidth: 2.0,
        thumbStrokeColor: Colors.tealAccent,
      ),
      child: SfRangeSlider(
        max: 100.0,
        interval: 20.0,
        showLabels: true,
        showDividers: true,
        values: _sliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _sliderValues = values;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TrackColorCustomizedRangeSlider(),
        const SizedBox(height: 25),
        title('Thumb and divider stroke color'),
        columnSpacing10,
        _rangeSliderWithThumbCustomization(),
        const SizedBox(height: 25),
        title('Gradient color'),
        columnSpacing10,
        _blueGradientRangeSlider(),
        const SizedBox(height: 25),
      ],
    );
  }
}

class _ThumbShape extends SfThumbShape {
  const _ThumbShape(this.leftThumbColor, this.rightThumbColor);

  final Color leftThumbColor;
  final Color rightThumbColor;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    super.paint(
      context,
      center,
      parentBox: parentBox,
      child: child,
      themeData: themeData,
      currentValues: currentValues,
      paint: paint,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumb: thumb,
    );

    context.canvas.drawCircle(
      center,
      getPreferredSize(themeData).width / 2,
      Paint()
        ..isAntiAlias = true
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..color = thumb == SfThumb.start ? leftThumbColor : rightThumbColor,
    );
  }
}

class _OverlayShape extends SfOverlayShape {
  const _OverlayShape(this.leftThumbColor, this.rightThumbColor);

  final Color leftThumbColor;
  final Color rightThumbColor;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> animation,
    required SfThumb? thumb,
  }) {
    final double radius = getPreferredSize(themeData).width / 2;
    final Tween<double> tween = Tween<double>(begin: 0.0, end: radius);

    context.canvas.drawCircle(
      center,
      tween.evaluate(animation),
      Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = (thumb == SfThumb.start ? leftThumbColor : rightThumbColor)
            .withValues(alpha: 0.12),
    );
  }
}

class _TrackShape extends SfTrackShape {
  const _TrackShape(this.gradient);

  final Gradient gradient;

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
  }) {
    final Radius radius = Radius.circular(themeData.trackCornerRadius!);
    final Rect actualTrackRect = getPreferredRect(parentBox, themeData, offset);

    if (endThumbCenter == null) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = themeData.activeTrackColor!;

      Rect trackRect = Rect.fromLTRB(
        actualTrackRect.left,
        actualTrackRect.top,
        startThumbCenter!.dx,
        actualTrackRect.bottom,
      );
      final RRect leftRRect = RRect.fromRectAndCorners(
        trackRect,
        topLeft: radius,
        bottomLeft: radius,
      );
      context.canvas.drawRRect(leftRRect, paint);

      paint.color = themeData.inactiveTrackColor!;
      trackRect = Rect.fromLTRB(
        startThumbCenter.dx,
        actualTrackRect.top,
        actualTrackRect.right,
        actualTrackRect.bottom,
      );
      final RRect rightRRect = RRect.fromRectAndCorners(
        trackRect,
        topRight: radius,
        bottomRight: radius,
      );
      context.canvas.drawRRect(rightRRect, paint);
    } else {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = themeData.inactiveTrackColor!;

      // Drawing inactive track.
      Rect trackRect = Rect.fromLTRB(
        actualTrackRect.left,
        actualTrackRect.top,
        startThumbCenter!.dx,
        actualTrackRect.bottom,
      );
      final RRect leftRRect = RRect.fromRectAndCorners(
        trackRect,
        topLeft: radius,
        bottomLeft: radius,
      );
      context.canvas.drawRRect(leftRRect, paint);

      // Drawing active track.
      trackRect = Rect.fromLTRB(
        startThumbCenter.dx,
        actualTrackRect.top,
        endThumbCenter.dx,
        actualTrackRect.bottom,
      );
      paint.shader = gradient.createShader(trackRect);
      final RRect centerRRect = RRect.fromRectAndCorners(trackRect);
      context.canvas.drawRRect(centerRRect, paint);

      // Drawing inactive track.
      paint.shader = null;
      paint.color = themeData.inactiveTrackColor!;
      trackRect = Rect.fromLTRB(
        endThumbCenter.dx,
        actualTrackRect.top,
        actualTrackRect.width + actualTrackRect.left,
        actualTrackRect.bottom,
      );
      final RRect rightRRect = RRect.fromRectAndCorners(
        trackRect,
        topRight: radius,
        bottomRight: radius,
      );
      context.canvas.drawRRect(rightRRect, paint);
    }
  }
}

class _TrackColorCustomizedRangeSlider extends SampleView {
  @override
  _TrackColorCustomizedRangeSliderState createState() =>
      _TrackColorCustomizedRangeSliderState();
}

class _TrackColorCustomizedRangeSliderState extends SampleViewState {
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
        inactiveTrackColor: const Color.fromRGBO(194, 194, 194, 0.5),
      ),
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
