/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';

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
      _markerSize = 25;
      _annotationFontSize = 25;
      _thickness = 0.06;
      _borderWidth = 5;
    } else {
      _markerSize = 23;
      _annotationFontSize = 15;
      _thickness = 0.1;
      _borderWidth = 4;
    }
    return Scaffold(
        backgroundColor:
            model.isWebFullView ? Colors.transparent : model.cardThemeColor,
        body: Padding(
            padding: model.isWebFullView
                ? const EdgeInsets.fromLTRB(5, 20, 5, 20)
                : const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                  axisLineStyle: AxisLineStyle(
                      thickness: model.isWebFullView ? 0.06 : _thickness,
                      thicknessUnit: GaugeSizeUnit.factor),
                  radiusFactor: isCardView
                      ? 0.95
                      : model.isWebFullView
                          ? 0.8
                          : 0.85,
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
                        enableDragging: _enableDragging,
                        borderColor: const Color(0xFFFFCD60),
                        borderWidth: isCardView ? 3 : _borderWidth,
                        color: model.currentThemeData!.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Colors.black.withOpacity(0.8),
                        markerHeight: isCardView ? 15 : _markerSize,
                        markerWidth: isCardView ? 15 : _markerSize,
                        markerType: MarkerType.circle,
                        overlayColor: const Color.fromRGBO(255, 205, 96, 0.3),
                        overlayRadius: isCardView ? 15 : _overlayRadius),
                    MarkerPointer(
                        value: _secondMarkerValue,
                        onValueChanged: _handleSecondPointerValueChanged,
                        onValueChanging: _handleSecondPointerValueChanging,
                        color: model.currentThemeData!.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Colors.black.withOpacity(0.8),
                        enableDragging: _enableDragging,
                        borderColor: const Color(0xFFFFCD60),
                        markerHeight: isCardView ? 15 : _markerSize,
                        borderWidth: isCardView ? 3 : _borderWidth,
                        markerWidth: isCardView ? 15 : _markerSize,
                        markerType: MarkerType.circle,
                        overlayColor: const Color.fromRGBO(255, 205, 96, 0.3),
                        overlayRadius: isCardView ? 15 : _overlayRadius),
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        endValue: _secondMarkerValue,
                        sizeUnit: GaugeSizeUnit.factor,
                        startValue: _firstMarkerValue,
                        startWidth: model.isWebFullView ? 0.06 : _thickness,
                        endWidth: model.isWebFullView ? 0.06 : _thickness)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                            child: Center(
                                child: Text(
                          '${_annotationValue}hr ${_minutesValue}m',
                          style: TextStyle(
                              fontSize: isCardView ? 18 : _annotationFontSize,
                              fontFamily: 'Times',
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00A8B5)),
                        ))),
                        positionFactor: 0.05,
                        angle: 0)
                  ])
            ])));
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              child: Row(
            children: <Widget>[
              Text('Enable dragging', style: TextStyle(color: model.textColor)),
              Container(
                  width: 75,
                  child: CheckboxListTile(
                      activeColor: model.backgroundColor,
                      value: _enableDragging,
                      onChanged: (bool? value) {
                        setState(() {
                          _enableDragging = value!;
                          stateSetter(() {});
                        });
                      }))
            ],
          )),
          Container(
            child: Visibility(
                visible: _enableDragging,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Overlay radius',
                        style: TextStyle(color: model.textColor)),
                    Container(
                      padding: !model.isWebFullView
                          ? const EdgeInsets.fromLTRB(25, 0, 0, 0)
                          : const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      child: CustomDirectionalButtons(
                        maxValue: 35,
                        minValue: 15,
                        initialValue: _overlayRadius,
                        onChanged: (double val) {
                          setState(() {
                            _overlayRadius = val;
                          });
                        },
                        step: 5,
                        loop: false,
                        iconColor: model.textColor,
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      );
    });
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
      args.cancel = true;
    }
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 1) {
      args.cancel = true;
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

  double _borderWidth = 5;
  double _firstMarkerValue = 2;
  double _secondMarkerValue = 8;
  double _markerSize = 25;
  double _annotationFontSize = 25;
  double _thickness = 0.06;
  String _annotationValue = '06';
  String _minutesValue = '40';
  double _overlayRadius = 30;
  bool _enableDragging = true;
}
