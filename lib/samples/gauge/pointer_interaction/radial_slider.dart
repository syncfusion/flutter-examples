/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge radial range range slider
class RadialRangeSliderExample extends SampleView {
  /// Creates the gauge radial range range slider
  const RadialRangeSliderExample(Key key) : super(key: key);

  @override
  _RadialRangeSliderExampleState createState() =>
      _RadialRangeSliderExampleState();
}

class _RadialRangeSliderExampleState extends SampleViewState {
  _RadialRangeSliderExampleState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _markerSize = 20;
      _annotationFontSize = 25;
      _thickness = 0.06;
      _borderWidth = 5;
    } else {
      _markerSize = 18;
      _annotationFontSize = 15;
      _thickness = 0.1;
      _borderWidth = 4;
    }
    return isCardView
        ? _getRadialRangeSlider(isCardView)
        : Scaffold(
            backgroundColor:
                model.isWeb ? Colors.transparent : model.cardThemeColor,
            body: Padding(
                padding: model.isWeb
                    ? const EdgeInsets.fromLTRB(5, 20, 5, 20)
                    : const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      axisLineStyle: AxisLineStyle(
                          thickness: _thickness,
                          thicknessUnit: GaugeSizeUnit.factor),
                      radiusFactor: model.isWeb ? 0.8 : 0.95,
                      minorTicksPerInterval: 4,
                      showFirstLabel: false,
                      minimum: 0,
                      maximum: 12,
                      interval: 1,
                      startAngle: 270,
                      endAngle: 270,
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          value: _firstMarkerValue,
                          onValueChanged: _handleFirstPointerValueChanged,
                          onValueChanging: _handleFirstPointerValueChanging,
                          enableDragging: true,
                          borderColor: const Color(0xFFFFCD60),
                          borderWidth: _borderWidth,
                          color: Colors.white,
                          markerHeight: _markerSize,
                          markerWidth: _markerSize,
                          markerType: MarkerType.circle,
                        ),
                        MarkerPointer(
                          value: _secondMarkerValue,
                          onValueChanged: _handleSecondPointerValueChanged,
                          onValueChanging: _handleSecondPointerValueChanging,
                          color: Colors.white,
                          enableDragging: true,
                          borderColor: const Color(0xFFFFCD60),
                          markerHeight: _markerSize,
                          borderWidth: _borderWidth,
                          markerWidth: _markerSize,
                          markerType: MarkerType.circle,
                        ),
                      ],
                      ranges: <GaugeRange>[
                        GaugeRange(
                            endValue: _secondMarkerValue,
                            sizeUnit: GaugeSizeUnit.factor,
                            startValue: _firstMarkerValue,
                            startWidth: _thickness,
                            endWidth: _thickness)
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
                                      color: const Color(0xFF00A8B5)),
                                ),
                                Text(
                                  ' hr',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                ),
                                Text(
                                  ' $_minutesValue',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                ),
                                Text(
                                  'm',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                )
                              ],
                            ),
                            positionFactor: 0.1,
                            angle: 0)
                      ])
                ])));
  }

  /// Dragged pointer new value is updated to range.
  void _handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      final String _hourValue = '$_value';
      _annotationValue = _hourValue.length == 1 ? '0' + _hourValue : _hourValue;
      _calculateMinutes(_value);
    });
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 1) {
      if (args.value >= _secondMarkerValue) {
        if ((args.value - _firstMarkerValue).abs() > 1) {
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

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 1) {
      if (args.value <= _firstMarkerValue) {
        if ((args.value - _secondMarkerValue).abs() > 1) {
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

  /// Dragged pointer new value is updated to range.
  void _handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      final String _hourValue = '$_value';
      _annotationValue = _hourValue.length == 1 ? '0' + _hourValue : _hourValue;
      _calculateMinutes(_value);
    });
  }

  /// Calculate the minutes value from pointer value to update in annotation.
  void _calculateMinutes(int _value) {
    final double _minutes =
        (_firstMarkerValue - _secondMarkerValue).abs() - _value;
    final List<String> _minList = _minutes.toStringAsFixed(2).split('.');
    double _currentMinutes = double.parse(_minList[1]);
    _currentMinutes =
        _currentMinutes > 60 ? _currentMinutes - 60 : _currentMinutes;
    final String _actualValue = _currentMinutes.toInt().toString();
    _minutesValue =
        _actualValue.length == 1 ? '0' + _actualValue : _actualValue;
  }

  /// Returns the radial range slider gauge
  Widget _getRadialRangeSlider(bool isTileView) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          axisLineStyle: AxisLineStyle(
              thickness: 0.06, thicknessUnit: GaugeSizeUnit.factor),
          minorTicksPerInterval: 4,
          showFirstLabel: false,
          minimum: 0,
          maximum: 12,
          interval: 1,
          startAngle: 270,
          endAngle: 270,
          pointers: <GaugePointer>[
            MarkerPointer(
              value: 2,
              borderColor: const Color(0xFFFFCD60),
              borderWidth: 3,
              color: Colors.white,
              markerHeight: 15,
              markerWidth: 15,
              markerType: MarkerType.circle,
            ),
            MarkerPointer(
              value: 8,
              color: Colors.white,
              borderColor: const Color(0xFFFFCD60),
              markerHeight: 15,
              borderWidth: 3,
              markerWidth: 15,
              markerType: MarkerType.circle,
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
                endValue: 8,
                sizeUnit: GaugeSizeUnit.factor,
                startValue: 2,
                startWidth: 0.06,
                endWidth: 0.06)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: const Text(
                  '6 hr 40 m',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A8B5)),
                ),
                positionFactor: 0.05,
                angle: 0)
          ])
    ]);
  }

  double _borderWidth = 5;
  double _firstMarkerValue = 2;
  double _secondMarkerValue = 8;
  double _markerSize = 25;
  double _annotationFontSize = 25;
  double _thickness = 0.06;
  String _annotationValue = '6';
  String _minutesValue = '40';
}
