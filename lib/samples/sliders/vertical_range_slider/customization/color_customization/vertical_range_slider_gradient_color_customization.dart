///Package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

/// Renders range slider with gradient track
class VerticalGradientTrackRangeSlider extends SampleView {
  ///Creates range slider with gradient track
  const VerticalGradientTrackRangeSlider(Key key) : super(key: key);

  @override
  _VerticalGradientTrackRangeSliderState createState() =>
      _VerticalGradientTrackRangeSliderState();
}

class _VerticalGradientTrackRangeSliderState extends SampleViewState {
  SfRangeValues _blueGradientSliderValues = const SfRangeValues(2.0, 4.0);
  SfRangeValues _sliderValues = const SfRangeValues(30.0, 70.0);

  final Color _inactiveColor = const Color.fromRGBO(194, 194, 194, 0.5);

  LinearGradient get _blueGradientColor {
    final List<Color> colors = <Color>[];
    colors.add(const Color.fromARGB(255, 0, 238, 217));
    colors.add(const Color.fromARGB(255, 88, 124, 241));
    final List<double> stops = <double>[0.0, 1.0];
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: colors,
      stops: stops,
    );
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
      child: SfRangeSlider.vertical(
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
        labelOffset: const Offset(10, 0),
        thumbColor: Colors.white,
        thumbStrokeWidth: 2.0,
        thumbStrokeColor: Colors.tealAccent,
      ),
      child: SfRangeSlider.vertical(
        min: 10.0,
        max: 90.0,
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
    final double padding = MediaQuery.of(context).size.height / 10.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _TrackColorCustomizedRangeSlider()),
              const Text('Track'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _rangeSliderWithThumbCustomization()),
              const Text('Stroke'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _blueGradientRangeSlider()),
              const Text('Gradient'),
            ],
          ),
        ],
      ),
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
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Paint? paint,
    Animation<double>? animation,
    SfThumb? thumb,
  }) {
    final double radius = getPreferredSize(themeData!).width / 2;
    final Tween<double> tween = Tween<double>(begin: 0.0, end: radius);

    context.canvas.drawCircle(
      center,
      tween.evaluate(animation!),
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
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Animation<double>? enableAnimation,
    Paint? inactivePaint,
    Paint? activePaint,
    TextDirection? textDirection,
  }) {
    final Radius radius = Radius.circular(themeData!.trackCornerRadius!);
    final Rect actualTrackRect = getPreferredRect(
      parentBox!,
      themeData,
      offset,
    );

    if (endThumbCenter == null) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = themeData.activeTrackColor!;

      Rect trackRect = Rect.fromLTRB(
        actualTrackRect.left,
        thumbCenter!.dy,
        actualTrackRect.right,
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
        actualTrackRect.left,
        actualTrackRect.top,
        actualTrackRect.right,
        thumbCenter.dy,
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
        startThumbCenter!.dy,
        actualTrackRect.right,
        actualTrackRect.bottom,
      );
      final RRect leftRRect = RRect.fromRectAndCorners(
        trackRect,
        bottomRight: radius,
        bottomLeft: radius,
      );
      context.canvas.drawRRect(leftRRect, paint);

      // Drawing active track.
      trackRect = Rect.fromLTRB(
        actualTrackRect.left,
        endThumbCenter.dy,
        actualTrackRect.right,
        startThumbCenter.dy,
      );
      paint.shader = gradient.createShader(trackRect);
      paint.color = themeData.activeTrackColor!;
      final RRect centerRRect = RRect.fromRectAndCorners(trackRect);
      context.canvas.drawRRect(centerRRect, paint);

      // Drawing inactive track.
      paint.shader = null;
      paint.color = themeData.inactiveTrackColor!;
      trackRect = Rect.fromLTRB(
        actualTrackRect.left,
        actualTrackRect.top,
        actualTrackRect.right,
        endThumbCenter.dy,
      );
      final RRect rightRRect = RRect.fromRectAndCorners(
        trackRect,
        topLeft: radius,
        topRight: radius,
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
      child: SfRangeSlider.vertical(
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
