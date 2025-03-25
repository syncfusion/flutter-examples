///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider custom text.
class RadialRangeSliderCustomText extends SampleView {
  /// Creates the RadialSlider custom text sample.
  const RadialRangeSliderCustomText(Key key) : super(key: key);

  @override
  _RadialRangeSliderCustomTextState createState() =>
      _RadialRangeSliderCustomTextState();
}

class _RadialRangeSliderCustomTextState extends SampleViewState {
  _RadialRangeSliderCustomTextState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 30;
      _annotationFontSize = 20;
    } else {
      _firstMarkerSize = model.isWebFullView ? 28 : 20;
      _annotationFontSize = model.isWebFullView ? 28 : 15;
    }
    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            axisLineStyle: const AxisLineStyle(
              thickness: 0.07,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showTicks: false,
            labelOffset: 25,
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _secondMarkerValue,
                startValue: _firstMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: _rangeColor,
                endWidth: 0.07,
                startWidth: 0.07,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                color: Colors.white,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                borderColor: _rangeColor,
                overlayRadius: 0,
                overlayColor: _rangeColor.withValues(alpha: 0.125),
                borderWidth: 8.5,
                markerType: MarkerType.circle,
                enableDragging: true,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                elevation: 5,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                enableDragging: true,
                color: Colors.white,
                borderColor: _rangeColor,
                overlayRadius: 0,
                overlayColor: _rangeColor.withValues(alpha: 0.125),
                borderWidth: 8.5,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double markerValue) {
    setState(() {
      _secondMarkerValue = markerValue;
      final int value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      if (value < 99 && _annotationValue != 'In-progress') {
        _annotationValue = 'In-progress';

        if (_rangeColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
        }
        if (_annotationColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
        }
      } else if (value == 99) {
        _annotationValue = 'Done';
        _rangeColor = const Color(0xFF00A8B5);
        _annotationColor = const Color(0xFF00A8B5);
      }
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double markerValue) {
    setState(() {
      _firstMarkerValue = markerValue;
      final int value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      if (value < 99 && _annotationValue != 'In-progress') {
        _annotationValue = 'In-progress';

        if (_rangeColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
        }
        if (_annotationColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
        }
      } else if (value == 99) {
        _annotationValue = 'Done';
        _rangeColor = const Color(0xFF00A8B5);
        _annotationColor = const Color(0xFF00A8B5);
      }
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  double _secondMarkerValue = 60;
  double _firstMarkerValue = 0;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = 'In-progress';
  Color _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
  Color _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
}
