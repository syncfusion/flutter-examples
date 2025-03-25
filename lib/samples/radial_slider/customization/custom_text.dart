///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider custom text.
class RadialSliderCustomText extends SampleView {
  /// Creates the RadialSlider custom text.
  const RadialSliderCustomText(Key key) : super(key: key);

  @override
  _RadialSliderCustomTextState createState() => _RadialSliderCustomTextState();
}

class _RadialSliderCustomTextState extends SampleViewState {
  _RadialSliderCustomTextState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 27;
      _annotationFontSize = 20;
    } else {
      _firstMarkerSize = model.isWebFullView ? 28 : 12;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
    }
    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            axisLineStyle: const AxisLineStyle(
              thickness: 0.07,
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
            ),
            showTicks: false,
            labelOffset: 25,
            onAxisTapped: handlePointerValueChanged,
            pointers: <GaugePointer>[
              RangePointer(
                color: _rangeColor,
                value: _markerValue,
                cornerStyle: CornerStyle.startCurve,
                width: 0.07,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue,
                overlayRadius: 0,
                borderColor: _borderColor,
                overlayColor: _borderColor.withValues(alpha: 0.125),
                borderWidth: model.isWebFullView ? 10 : 7,
                color: Colors.white,
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                elevation: 5,
                enableDragging: true,
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
  void handlePointerValueChanged(double value) {
    setState(() {
      _markerValue = value;
      // ignore: no_leading_underscores_for_local_identifiers
      final int _value = _markerValue.round();
      if (_value < 100 && _annotationValue != 'In-progress') {
        _annotationValue = 'In-progress';
        if (_rangeColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
          _borderColor = const Color.fromRGBO(255, 150, 0, 1);
        }
        if (_annotationColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
        }
      } else if (_value == 100) {
        _annotationValue = 'Done';
        _rangeColor = null;
        _annotationColor = const Color(0xFF00A8B5);
        _borderColor = const Color(0xFF00A8B5);
      }
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 3) {
      args.cancel = true;
    }
  }

  double _markerValue = 60;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = 'In-progress';
  Color? _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
  Color _borderColor = const Color.fromRGBO(255, 150, 0, 1);
  Color _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
}
