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
class VerticalDividerCustomizedRangeSlider extends SampleView {
  /// Creates range slider with customized divider
  const VerticalDividerCustomizedRangeSlider(Key key) : super(key: key);
  @override
  _VerticalDividerCustomizedRangeSliderState createState() =>
      _VerticalDividerCustomizedRangeSliderState();
}

class _VerticalDividerCustomizedRangeSliderState extends SampleViewState {
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = Colors.blue;
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTrackColor: _inactiveColor.withValues(alpha: 0.5),
        activeTrackColor: _activeColor,
        thumbColor: _activeColor,
        inactiveDividerColor: const Color.fromARGB(255, 194, 194, 194),
        activeDividerColor: Colors.blue,
        overlayColor: _activeColor.withValues(alpha: 0.12),
        tooltipBackgroundColor: _activeColor,
      ),
      child: SfRangeSlider.vertical(
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
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Paint? paint,
    Animation<double>? enableAnimation,
    TextDirection? textDirection,
  }) {
    bool isActive;
    isActive =
        center.dy <= startThumbCenter!.dy && center.dy >= endThumbCenter!.dy;

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 10.0, height: 5.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = isActive
            ? themeData!.activeDividerColor!
            : model.themeData.canvasColor,
    );
  }
}
