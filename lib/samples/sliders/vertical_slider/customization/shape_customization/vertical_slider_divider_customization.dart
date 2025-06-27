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

///Renders slider with customized divider
class VerticalDividerCustomizedSlider extends SampleView {
  ///Renders slider with customized divider
  const VerticalDividerCustomizedSlider(Key key) : super(key: key);

  @override
  _VerticalDividerCustomizedSliderState createState() =>
      _VerticalDividerCustomizedSliderState();
}

class _VerticalDividerCustomizedSliderState extends SampleViewState {
  double _value = 60.0;

  @override
  Widget build(BuildContext context) {
    return SfSlider.vertical(
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
    RenderBox? parentBox,
    SfSliderThemeData? themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    Paint? paint,
    Animation<double>? enableAnimation,
    TextDirection? textDirection,
  }) {
    bool isActive;

    isActive = center.dy >= thumbCenter!.dy;

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 10.0, height: 5.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = isActive
            ? themeData!.activeTrackColor!
            : model.themeData.canvasColor,
    );
  }
}
