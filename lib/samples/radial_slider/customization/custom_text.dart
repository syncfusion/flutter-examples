///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider custom text.
class RadialSliderCustomText extends SampleView {
  const RadialSliderCustomText(Key key) : super(key: key);

  @override
  _RadialSliderCustomTextState createState() => _RadialSliderCustomTextState();
}

class _RadialSliderCustomTextState extends SampleViewState {
  _RadialSliderCustomTextState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 20;
      _annotationFontSize = 20;
    } else {
      _firstMarkerSize = model.isWeb ? 25 : 20;
      _annotationFontSize = model.isWeb ? 25 : 15;
    }
    return Center(
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
            ),
            showTicks: false,
            showLabels: true,
            labelOffset: 25,
            onAxisTapped: handlePointerValueChanged,
            pointers: <GaugePointer>[
              RangePointer(
                  color: _rangeColor,
                  value: _currentValue,
                  onValueChanged: handlePointerValueChanged,
                  cornerStyle: CornerStyle.bothCurve,
                  onValueChangeEnd: handlePointerValueChanged,
                  onValueChanging: handlePointerValueChanging,
                  enableDragging: true,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor),
              MarkerPointer(
                value: _markerValue,
                color: Colors.white,
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
                        '$_annotationValue',
                        style: TextStyle(
                          fontSize: _annotationFontSize,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  positionFactor: 0.13,
                  angle: 0.5)
            ])
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    setState(() {
      _currentValue = value.roundToDouble();
      final int _value = _currentValue.toInt();
      if (_value < 100 && _annotationValue != 'In-progress') {
        _annotationValue = 'In-progress';
        if (_rangeColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
        }
        if (_annotationColor != const Color.fromRGBO(255, 150, 0, 1)) {
          _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
        }
      } else if (_value == 100) {
        _annotationValue = 'Done';
        _rangeColor = null;
        _annotationColor = const Color(0xFF00A8B5);
      }

      _markerValue = _currentValue - 2;
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 3) {
      args.cancel = true;
    }
  }

  double _currentValue = 60;
  double _markerValue = 58;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = 'In-progress';
  Color _rangeColor = const Color.fromRGBO(255, 150, 0, 1);
  Color _annotationColor = const Color.fromRGBO(255, 150, 0, 1);
}
