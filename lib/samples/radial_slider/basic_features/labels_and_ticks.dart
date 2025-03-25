///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider ticks and labels.
class RadialSliderLabelsTicks extends SampleView {
  /// Creates the RadialSlider ticks and labels.
  const RadialSliderLabelsTicks(Key key) : super(key: key);

  @override
  _RadialSliderLabelsTicksState createState() =>
      _RadialSliderLabelsTicksState();
}

class _RadialSliderLabelsTicksState extends SampleViewState {
  _RadialSliderLabelsTicksState();
  // double _currentValue = 9;
  double _markerValue = 9;
  double _value = 9;
  // double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = '9';

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // _firstMarkerSize = 27;
      _annotationFontSize = 15;
    } else {
      // _firstMarkerSize = model.isWebFullView ? 20 : 15;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
    }

    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showFirstLabel: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.85,
            maximum: 12,
            interval: 3,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(128, 94, 246, 0.3),
              thickness: 0.075,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            tickOffset: 0.15,
            labelOffset: 0.1,
            offsetUnit: GaugeSizeUnit.factor,
            onAxisTapped: handlePointerValueChanged,
            minorTicksPerInterval: 30,
            minorTickStyle: const MinorTickStyle(
              length: 0.05,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            majorTickStyle: const MajorTickStyle(
              length: 0.1,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                color: const Color.fromRGBO(128, 94, 246, 1),
                value: _markerValue,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.075,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _value,
                elevation: 5,
                markerType: MarkerType.circle,
                markerHeight: 35,
                markerWidth: 35,
                enableDragging: true,
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                color: const Color.fromRGBO(128, 94, 246, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _annotationValue,
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' hrs',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 0.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if ((args.value.toInt() - _value).abs() > 2.4) {
      args.cancel = true;
      if (_value > 6) {
        const double value = 12;
        _setPointerValue(value);
      }
    }
  }

  /// method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _value = value;
      _markerValue = _value;
      // _currentValue = _value.roundToDouble();
      // final int _value = _currentValue.round().toInt();
      _annotationValue = '${_value.round()}';
    });
  }
}
