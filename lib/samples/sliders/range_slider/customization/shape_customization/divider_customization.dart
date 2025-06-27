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
import '../../../../../model/model.dart';
import '../../../../../model/sample_view.dart';

///Renders range slider with customized divider
class DividerCustomizedRangeSlider extends SampleView {
  /// Creates range slider with customized divider
  const DividerCustomizedRangeSlider(Key key) : super(key: key);

  @override
  _DividerCustomizedRangeSliderState createState() =>
      _DividerCustomizedRangeSliderState();
}

class _DividerCustomizedRangeSliderState extends SampleViewState {
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor.withValues(alpha: 0.5),
        activeTrackColor: _activeColor,
        thumbColor: _activeColor,
        inactiveDividerColor: const Color.fromARGB(
          255,
          214,
          214,
          214,
        ).withValues(alpha: 1),
        activeDividerColor: const Color.fromARGB(255, 255, 0, 58),
        overlayColor: _activeColor.withValues(alpha: 0.12),
        tooltipBackgroundColor: _activeColor,
      ),
      child: SfRangeSlider(
        max: 100.0,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        interval: 10,
        showDividers: true,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
        dividerShape: _DividerShape(model),
      ),
    );
  }
}

class _DividerShape extends SfDividerShape {
  _DividerShape(this.model);
  SampleModel model;

  @override
  void paint(
    PaintingContext context,
    Offset center,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
  }) {
    late bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive =
            center.dx >= startThumbCenter!.dx &&
            center.dx <= endThumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive =
            center.dx >= endThumbCenter!.dx &&
            center.dx <= startThumbCenter!.dx;
        break;
    }

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 5.0, height: 10.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = isActive
            ? themeData.activeDividerColor!
            : model.themeData.canvasColor,
    );
  }
}
