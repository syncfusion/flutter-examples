///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider ticks and labels.
class RadialRangeSliderLabelsTicks extends SampleView {
  /// Creates the RadialSlider ticks and labels sample.
  const RadialRangeSliderLabelsTicks(Key key) : super(key: key);

  @override
  _RadialRangeSliderLabelsTicksState createState() =>
      _RadialRangeSliderLabelsTicksState();
}

class _RadialRangeSliderLabelsTicksState extends SampleViewState {
  _RadialRangeSliderLabelsTicksState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 35;
      _annotationFontSize = 15;
    } else {
      _firstMarkerSize = model.isWebFullView ? 35 : 15;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
    }

    return Center(
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            showFirstLabel: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.85,
            minimum: 0,
            maximum: 12,
            interval: 3,
            axisLineStyle: const AxisLineStyle(
                color: Color.fromRGBO(128, 94, 246, 0.3),
                thickness: 0.075,
                thicknessUnit: GaugeSizeUnit.factor),
            tickOffset: 0.15,
            labelOffset: 0.1,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 30,
            minorTickStyle: const MinorTickStyle(
                length: 0.05, lengthUnit: GaugeSizeUnit.factor),
            majorTickStyle: const MajorTickStyle(
                length: 0.1, lengthUnit: GaugeSizeUnit.factor),
            ranges: <GaugeRange>[
              GaugeRange(
                  endValue: _secondMarkerValue,
                  startValue: _firstMarkerValue,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: const Color.fromRGBO(128, 94, 246, 1),
                  endWidth: 0.075,
                  startWidth: 0.075)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: const Color.fromRGBO(128, 94, 246, 1),
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                elevation: 5,
                markerOffset: 0.1,
                color: const Color.fromRGBO(128, 94, 246, 1),
                enableDragging: true,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _annotationValue2.contains(_annotationValue1)
                            ? _annotationValue1
                            : '$_annotationValue1 - $_annotationValue2',
                        style: TextStyle(
                          fontSize: _annotationFontSize,
                          fontFamily: 'Times',
                        ),
                      ),
                    ],
                  ),
                  angle: 90)
            ]),
      ]),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = _secondMarkerValue.round().toInt();
      _annotationValue2 = _value == 12
          ? '$_value PM'
          : _value == 0
              ? ' 12 AM'
              : '$_value AM';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 1) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = _firstMarkerValue.round().toInt();
      _annotationValue1 = _value == 12
          ? '$_value PM'
          : _value == 0
              ? ' 12 AM'
              : '$_value AM';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 1) {
      args.cancel = true;
    }
  }

  double _secondMarkerValue = 9;
  double _firstMarkerValue = 0;
  double _firstMarkerSize = 35;
  double _annotationFontSize = 25;
  String _annotationValue1 = '12 AM';
  String _annotationValue2 = '9 AM';
}
