///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider ticks and labels.
class RadialRangeSliderLabelsTicks extends SampleView {
  const RadialRangeSliderLabelsTicks(Key key) : super(key: key);

  @override
  _RadialRangeSliderLabelsTicksState createState() =>
      _RadialRangeSliderLabelsTicksState();
}

class _RadialRangeSliderLabelsTicksState extends SampleViewState {
  _RadialRangeSliderLabelsTicksState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 27;
      _annotationFontSize = 25;
    } else {
      _firstMarkerSize = model.isWeb ? 20 : 15;
      _annotationFontSize = model.isWeb ? 25 : 15;
    }

    return Center(
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: AxisLineStyle(
                thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
            tickOffset: 0.2,
            labelOffset: 0.15,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 7,
            majorTickStyle:
                MajorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.factor),
            ranges: <GaugeRange>[
              GaugeRange(
                  endValue: _secondMarkerValue,
                  startValue: _firstMarkerValue,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  endWidth: 0.1,
                  startWidth: 0.1)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '$_annotationValue1 - $_annotationValue2',
                        style: TextStyle(
                          fontSize: _annotationFontSize,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  positionFactor: 0.7,
                  angle: 90)
            ]),
        // Create secondary radial axis for segmented line
        RadialAxis(
          interval: 20,
          showLabels: false,
          showTicks: true,
          showAxisLine: false,
          tickOffset: -0.05,
          offsetUnit: GaugeSizeUnit.factor,
          minorTicksPerInterval: 0,
          radiusFactor: 0.85,
          majorTickStyle: MajorTickStyle(
              length: 0.3,
              thickness: 3,
              lengthUnit: GaugeSizeUnit.factor,
              color: model.currentThemeData.brightness == Brightness.light
                  ? Colors.white
                  : Color.fromRGBO(33, 33, 33, 1)),
          pointers: [
            MarkerPointer(
              value: _firstMarkerValue,
              enableDragging: true,
              color: model.currentThemeData.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderColor: const Color.fromRGBO(0, 198, 139, 1),
              borderWidth: 7,
              markerOffset: 0.0355,
              offsetUnit: GaugeSizeUnit.factor,
              markerHeight: _firstMarkerSize,
              markerWidth: _firstMarkerSize,
              markerType: MarkerType.circle,
              onValueChanged: handleFirstPointerValueChanged,
              onValueChanging: handleFirstPointerValueChanging,
            ),
            MarkerPointer(
              value: _secondMarkerValue,
              color: model.currentThemeData.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderColor: const Color.fromRGBO(0, 198, 139, 1),
              enableDragging: true,
              borderWidth: 6,
              markerOffset: 0.0355,
              offsetUnit: GaugeSizeUnit.factor,
              markerHeight: _firstMarkerSize,
              markerWidth: _firstMarkerSize,
              markerType: MarkerType.circle,
              onValueChanged: handleSecondPointerValueChanged,
              onValueChanging: handleSecondPointerValueChanging,
            )
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = _secondMarkerValue.abs().round().toInt();
      _annotationValue2 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      if (args.value <= _firstMarkerValue) {
        if ((args.value - _secondMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _secondMarkerValue = _firstMarkerValue;
          _firstMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = _firstMarkerValue.abs().round().toInt();
      _annotationValue1 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      if (args.value >= _secondMarkerValue) {
        if ((args.value - _firstMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _firstMarkerValue = _secondMarkerValue;
          _secondMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  double _secondMarkerValue = 70;
  double _firstMarkerValue = 10;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue1 = '10';
  String _annotationValue2 = '70';
}
