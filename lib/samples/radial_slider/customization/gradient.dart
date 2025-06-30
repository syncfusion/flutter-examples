///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider gradient.
class RadialSliderGradient extends SampleView {
  /// Creates the RadialSlider gradient.
  const RadialSliderGradient(Key key) : super(key: key);

  @override
  _RadialSliderGradientState createState() => _RadialSliderGradientState();
}

class _RadialSliderGradientState extends SampleViewState {
  _RadialSliderGradientState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 30;
      _annotationFontSize = 25;
    } else {
      _firstMarkerSize = model.isWebFullView ? 28 : 15;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
    }
    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: const AxisLineStyle(
              thickness: 0,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            tickOffset: 0.20,
            labelOffset: 0.10,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 5,
            onLabelCreated: (AxisLabelCreatedArgs args) {
              final double axisValue = double.parse(args.text);
              final double celsiusValue = (axisValue - 32) / 1.8;
              args.text = celsiusValue.toStringAsFixed(1);
            },
            majorTickStyle: const MajorTickStyle(
              length: 0.1,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$_annotationValue2°C',
                  style: TextStyle(
                    fontSize: _celsiusAnnotationFontSize,
                    fontFamily: 'Times',
                  ),
                ),
                positionFactor: 0.15,
                angle: 90,
              ),
            ],
          ),
          RadialAxis(
            axisLineStyle: const AxisLineStyle(
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showTicks: false,
            labelOffset: 20,
            onAxisTapped: handlePointerValueChanged,
            pointers: <GaugePointer>[
              RangePointer(
                value: _currentValue,
                width: 0.05,
                cornerStyle: CornerStyle.endCurve,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(115, 67, 189, 1),
                    Color.fromRGBO(202, 94, 230, 1),
                  ],
                  stops: <double>[0.5, 1],
                ),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _currentValue,
                overlayColor: const Color.fromRGBO(202, 94, 230, 0.125),
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                enableDragging: true,
                elevation: 5,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 5,
                borderColor: model.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$_annotationValue°F',
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 0,
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
      _currentValue = value.roundToDouble();
      _markerValue = _currentValue;
      // ignore: no_leading_underscores_for_local_identifiers
      final int _value = _currentValue.round();
      _annotationValue = '$_value';
      final double celsiusValue = (_currentValue - 32) / 1.8;
      _annotationValue2 = celsiusValue.toStringAsFixed(1);
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() < 0) {
      args.cancel = true;
    }
  }

  double _currentValue = 60;
  //ignore: unused_field
  double _markerValue = 60;
  double _firstMarkerSize = 30;
  double _annotationFontSize = 25;
  final double _celsiusAnnotationFontSize = 18;
  String _annotationValue = '60';
  String _annotationValue2 = 15.5556.toStringAsFixed(1);
}
