///Package imports
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders range slider with customized thumb
class VerticalThumbCustomizedRangeSlider extends SampleView {
  /// Creates range slider with customized thumb
  const VerticalThumbCustomizedRangeSlider(Key key) : super(key: key);
  @override
  _VerticalThumbCustomizedRangeSliderState createState() =>
      _VerticalThumbCustomizedRangeSliderState();
}

class _VerticalThumbCustomizedRangeSliderState extends SampleViewState {
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
        overlayColor: _activeColor.withValues(alpha: 0.12),
        tickOffset: const Offset(13, 0),
        inactiveTickColor: _inactiveColor,
        activeTickColor: _activeColor,
        inactiveMinorTickColor: _inactiveColor,
        activeMinorTickColor: _activeColor,
        tooltipBackgroundColor: _activeColor,
      ),
      child: SfRangeSlider.vertical(
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
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: _RectThumbShape(),
      ),
    );
  }

  SfRangeSliderTheme _doubleStrokeThumbRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: const Color.fromARGB(
          255,
          200,
          200,
          200,
        ).withValues(alpha: 0.5),
        tooltipBackgroundColor: const Color.fromARGB(255, 0, 178, 206),
      ),
      child: SfRangeSlider.vertical(
        max: 100.0,
        values: _doubleStrokeSliderValues,
        tooltipPosition: SliderTooltipPosition.right,
        onChanged: (SfRangeValues values) {
          setState(() {
            _doubleStrokeSliderValues = values;
          });
        },
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
        thumbShape: const _ThumbShape(true),
        activeColor: const Color.fromARGB(255, 0, 178, 206),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double padding =
        MediaQuery.of(context).orientation == Orientation.landscape
        ? 80.0
        : 50.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _doubleStrokeThumbRangeSlider(),
        Padding(
          padding: EdgeInsets.only(left: padding),
          child: _strokeThumbRangeSlider(),
        ),
      ],
    );
  }
}

class _ThumbShape extends SfThumbShape {
  const _ThumbShape(this.isDoubleStroke);

  final bool isDoubleStroke;

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
        ..color = themeData.activeTrackColor!,
    );

    if (isDoubleStroke) {
      context.canvas.drawCircle(
        center,
        getPreferredSize(themeData).width / 3,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..color = Colors.white,
      );
    }
  }
}

class _RectThumbShape extends SfThumbShape {
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

    final double width = getPreferredSize(themeData).width;
    final double height = getPreferredSize(themeData).height;

    context.canvas.drawRRect(
      RRect.fromLTRBR(
        center.dx - width / 2,
        center.dy - height / 2,
        center.dx + width / 2,
        center.dy + height / 2,
        const Radius.circular(5.0),
      ),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = themeData.activeTrackColor!,
    );
  }
}
