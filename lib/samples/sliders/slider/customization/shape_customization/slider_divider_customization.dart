///flutter package import
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

/// Renders slider with customized divider
class DividerCustomizedSlider extends SampleView {
  /// Creates slider with customized divider
  const DividerCustomizedSlider(Key key) : super(key: key);
  @override
  _DividerCustomizedSliderState createState() =>
      _DividerCustomizedSliderState();
}

class _DividerCustomizedSliderState extends SampleViewState {
  double _value = 60.0;

  @override
  Widget build(BuildContext context) {
    return SfSlider(
      max: 100.0,
      value: _value,
      onChanged: (dynamic values) {
        setState(() {
          _value = values as double;
        });
      },
      interval: 10,
      showDividers: true,
      numberFormat: NumberFormat('#'),
      dividerShape: _DividerShape(model),
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
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive = center.dx <= thumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter!.dx;
        break;
    }

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 5.0, height: 10.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = isActive
            ? themeData.activeTrackColor!
            : model.themeData.canvasColor,
    );
  }
}
