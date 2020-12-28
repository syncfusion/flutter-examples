///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider ticks and labels.
class RadialSliderLabelsTicks extends SampleView {
  const RadialSliderLabelsTicks(Key key) : super(key: key);

  @override
  _RadialSliderLabelsTicksState createState() =>
      _RadialSliderLabelsTicksState();
}

class _RadialSliderLabelsTicksState extends SampleViewState {
  _RadialSliderLabelsTicksState();

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
            onAxisTapped: handlePointerValueChanged,
            minorTicksPerInterval: 5,
            majorTickStyle:
                MajorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.factor),
            pointers: <GaugePointer>[
              RangePointer(
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  value: _currentValue,
                  onValueChanged: handlePointerValueChanged,
                  cornerStyle: CornerStyle.bothCurve,
                  onValueChangeEnd: handlePointerValueChanged,
                  onValueChanging: handlePointerValueChanging,
                  enableDragging: true,
                  width: 0.1,
                  sizeUnit: GaugeSizeUnit.factor),
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
                      Text(
                        '%',
                        style: TextStyle(
                          fontSize: _annotationFontSize,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                        ),
                      )
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
                value: _markerValue,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 7,
                markerOffset: 0.0355,
                offsetUnit: GaugeSizeUnit.factor,
                borderColor: const Color.fromRGBO(0, 198, 139, 1),
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
              ),
            ]),
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
    _setPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 0.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() < 0) {
      args.cancel = true;
    }
  }

  /// method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _currentValue = value.roundToDouble();
      final int _value = _currentValue.round().toInt();
      _annotationValue = '$_value';
      _markerValue = _currentValue;
    });
  }

  double _currentValue = 54;
  double _markerValue = 54;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = '54';
}
