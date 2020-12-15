///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Widget of the RadialSlider styles.
class RadialSliderStyles extends SampleView {
  const RadialSliderStyles(Key key) : super(key: key);

  @override
  _RadialSliderStylesState createState() => _RadialSliderStylesState();
}

class _RadialSliderStylesState extends SampleViewState {
  _RadialSliderStylesState();

  double _value = 30;
  String _annotationValue = '30';
  double _annotationFontSize = 25;
  double _markerValue = 28;
  double _firstMarkerSize = 20;
  double _secondMarkerSize = 20;
  double _markerWidth = 10;
  double _size = 150;
  double _borderWidth = 8;

  double _value1 = 30;
  double _markerValue1 = 30;
  String _annotationValue1 = '30';

  double _value2 = 30;
  double _markerValue2 = 28;
  String _annotationValue2 = '30';

  double _value3 = 30;
  double _markerValue3 = 28;
  String _annotationValue3 = '30';

  double _value4 = 30;
  double _markerValue4 = 28;
  String _annotationValue4 = '30';

  double _value5 = 30;
  double _markerValue5 = 30;
  String _annotationValue5 = '30';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size actualSize = MediaQuery.of(context).size;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 15;
      _secondMarkerSize = 20;
      _borderWidth = 5;
      _markerWidth = 5;
      _annotationFontSize = 15;
    } else {
      _firstMarkerSize = model.isWeb ? 15 : 10;
      _secondMarkerSize = model.isWeb ? 20 : 15;
      _markerWidth = model.isWeb ? 5 : 3;
      _borderWidth = model.isWeb ? 5 : 3;
      _annotationFontSize = model.isWeb ? 15 : 12;
    }

    if (actualSize.width > actualSize.height) {
      _size = actualSize.height / 5;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFirtProgressBar(),
              _getSecondProgressBar(),
              _getThirdProgressBar()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFourthProgressBar(),
              _getFifthProgressBar(),
              _getSixthProgressBar()
            ],
          ),
        ],
      );
    } else {
      _size = actualSize.height / 5;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFirtProgressBar(),
              _getSecondProgressBar(),
              _getThirdProgressBar()
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFourthProgressBar(),
              _getFifthProgressBar(),
              _getSixthProgressBar()
            ],
          ),
        ],
      );
    }
  }

  Widget _getFirtProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.85,
              axisLineStyle: AxisLineStyle(
                  color: model.currentThemeData.brightness == Brightness.light
                      ? const Color.fromRGBO(191, 214, 252, 1)
                      : const Color.fromRGBO(36, 58, 97, 1),
                  thickness: 0.1,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    width: 0.1,
                    value: _value,
                    cornerStyle: CornerStyle.bothCurve,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? const Color.fromRGBO(41, 118, 246, 1)
                        : const Color.fromRGBO(6, 102, 217, 1),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                    value: _markerValue,
                    onValueChanged: handleFirstPointerValueChanged,
                    onValueChangeEnd: handleFirstPointerValueChanged,
                    onValueChanging: handleFirstPointerValueChanging,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: _borderWidth,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    borderColor: Color.fromRGBO(41, 118, 246, 1)),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue',
                      style: TextStyle(
                          fontSize: _annotationFontSize,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.1,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  Widget _getSecondProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.85,
              axisLineStyle: AxisLineStyle(
                  color: model.currentThemeData.brightness == Brightness.light
                      ? const Color.fromRGBO(218, 218, 218, 1)
                      : const Color.fromRGBO(88, 88, 88, 1),
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    width: 0.15,
                    value: _value1,
                    cornerStyle: CornerStyle.bothCurve,
                    color: const Color.fromRGBO(126, 86, 212, 1),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                    value: _markerValue1,
                    onValueChanged: handleSecondPointerValueChanged,
                    onValueChangeEnd: handleSecondPointerValueChanged,
                    onValueChanging: handleSecondPointerValueChanging,
                    enableDragging: true,
                    color: const Color.fromRGBO(126, 86, 212, 1),
                    borderWidth: 9,
                    markerWidth: _firstMarkerSize,
                    markerHeight: _markerWidth,
                    markerType: MarkerType.rectangle,
                    borderColor: const Color.fromRGBO(126, 86, 212, 1))
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue1',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.1,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  Widget _getThirdProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.85,
              axisLineStyle: AxisLineStyle(
                  color: const Color.fromRGBO(254, 166, 25, 1),
                  thickness: 0.25,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    value: 100,
                    pointerOffset: 0.05,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : const Color.fromRGBO(41, 37, 32, 1),
                    width: 0.145,
                    sizeUnit: GaugeSizeUnit.factor),
                RangePointer(
                    width: 0.144,
                    pointerOffset: 0.05,
                    value: _value2,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                  value: _markerValue2,
                  color: model.currentThemeData.brightness == Brightness.light
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(33, 33, 33, 1),
                  borderWidth: _borderWidth,
                  onValueChanged: handleThirdPointerValueChanged,
                  onValueChangeEnd: handleThirdPointerValueChanged,
                  onValueChanging: handleThirdPointerValueChanging,
                  enableDragging: true,
                  markerHeight: _secondMarkerSize,
                  markerWidth: _secondMarkerSize,
                  markerType: MarkerType.circle,
                  borderColor: const Color.fromRGBO(254, 166, 25, 1),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue2',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.1,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  Widget _getFourthProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.85,
              axisLineStyle: AxisLineStyle(
                  color: model.currentThemeData.brightness == Brightness.light
                      ? const Color.fromRGBO(201, 201, 201, 1)
                      : const Color.fromRGBO(78, 78, 78, 1),
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    value: 100,
                    pointerOffset: 0.03,
                    width: 0.09,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    sizeUnit: GaugeSizeUnit.factor),
                RangePointer(
                    width: 0.05,
                    pointerOffset: 0.05,
                    value: _value3,
                    cornerStyle: CornerStyle.bothCurve,
                    color: const Color.fromRGBO(88, 194, 143, 1),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                    value: _markerValue3,
                    onValueChanged: handleFourthPointerValueChanged,
                    onValueChanging: handleFourthPointerValueChanging,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: 3,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    borderColor: Color.fromRGBO(88, 194, 143, 1)),
                MarkerPointer(
                    value: _markerValue3,
                    onValueChanged: handleFourthPointerValueChanged,
                    onValueChanging: handleFourthPointerValueChanging,
                    enableDragging: true,
                    color: Color.fromRGBO(88, 194, 143, 1),
                    borderWidth: 1,
                    markerHeight: 7,
                    markerWidth: 7,
                    markerType: MarkerType.circle,
                    borderColor: Color.fromRGBO(88, 194, 143, 1)),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue3',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.1,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  Widget _getFifthProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                  color: Color.fromRGBO(41, 118, 246, 1),
                  thickness: 0.3,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    pointerOffset: 0.075,
                    width: 0.15,
                    value: _value4,
                    cornerStyle: CornerStyle.bothCurve,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                    value: _markerValue4,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    markerHeight: _firstMarkerSize,
                    onValueChanged: handleFifthPointerValueChanged,
                    onValueChangeEnd: handleFifthPointerValueChanged,
                    onValueChanging: handleFifthPointerValueChanging,
                    enableDragging: true,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    borderColor: const Color.fromRGBO(34, 144, 199, 0.75))
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue4',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.1,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  Widget _getSixthProgressBar() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.85,
              axisLabelStyle: GaugeTextStyle(fontSize: 8),
              interval: 10,
              axisLineStyle: AxisLineStyle(
                  thickness: 0.03, thicknessUnit: GaugeSizeUnit.factor),
              showTicks: false,
              showLabels: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                NeedlePointer(
                    value: _markerValue5,
                    needleColor:
                        model.currentThemeData.brightness == Brightness.light
                            ? Color.fromRGBO(65, 65, 65, 1)
                            : Color.fromRGBO(191, 191, 191, 1),
                    needleEndWidth: 1.5,
                    needleStartWidth: 1.5,
                    needleLength: 0.72,
                    knobStyle: KnobStyle(
                      knobRadius: model.isWeb ? 0.4 : 0.3,
                      borderWidth: 0.05,
                      borderColor:
                          model.currentThemeData.brightness == Brightness.light
                              ? Color.fromRGBO(65, 65, 65, 1)
                              : Color.fromRGBO(191, 191, 191, 1),
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.white
                              : const Color.fromRGBO(33, 33, 33, 1),
                    )),
                RangePointer(
                    width: 0.07,
                    pointerOffset: 0.27,
                    value: _value5,
                    onValueChanged: handleSixthPointerValueChanged,
                    onValueChangeEnd: handleSixthPointerValueChanged,
                    onValueChanging: handleSixthPointerValueChanging,
                    enableDragging: true,
                    color: const Color.fromRGBO(126, 87, 213, 1),
                    sizeUnit: GaugeSizeUnit.factor),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue5',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          color: model.currentThemeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white),
                    ),
                    positionFactor: 0.04,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleFirstPointerValueChanged(double value) {
    _setFirstPointerValue(value);
  }

  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue).abs() > 20) {
      args.cancel = true;

      if (_markerValue > 50) {
        final double value = 100;
        _setFirstPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFirstPointerValue(double value) {
    setState(() {
      _markerValue = value.roundToDouble();
      _value = (_markerValue + 2);
      final int _currentValue = _markerValue.round().toInt();
      _annotationValue = '$_currentValue';
    });
  }

  void handleSecondPointerValueChanged(double value) {
    _setSecondPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue1).abs() > 20) {
      args.cancel = true;

      if (_markerValue1 > 50) {
        final double value = 100;
        _setSecondPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setSecondPointerValue(double value) {
    setState(() {
      _markerValue1 = value.roundToDouble();
      _value1 = (_markerValue1);
      final int _currentValue = _markerValue1.round().toInt();
      _annotationValue1 = '$_currentValue';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleThirdPointerValueChanged(double value) {
    _setThirdPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleThirdPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue2).abs() > 20) {
      args.cancel = true;

      if (_markerValue2 > 50) {
        final double value = 100;
        _setThirdPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setThirdPointerValue(double value) {
    setState(() {
      _markerValue2 = value.roundToDouble();
      _value2 = (_markerValue2 + 2);
      final int _currentValue = _markerValue2.round().toInt();
      _annotationValue2 = '$_currentValue';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleFourthPointerValueChanged(double value) {
    _setFourthPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFourthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue3).abs() > 20) {
      args.cancel = true;

      if (_markerValue3 > 50) {
        final double value = 100;
        _setFourthPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFourthPointerValue(double value) {
    setState(() {
      _markerValue3 = value;
      _value3 = (_markerValue3 + 2);
      final int _currentValue = _markerValue3.round().toInt();
      _annotationValue3 = '$_currentValue';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleFifthPointerValueChanged(double value) {
    _setFifthPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFifthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue4).abs() > 20) {
      args.cancel = true;

      if (_markerValue4 > 50) {
        final double value = 100;
        _setFifthPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFifthPointerValue(double value) {
    setState(() {
      _markerValue4 = value.roundToDouble();
      _value4 = (_markerValue4 + 2);
      final int _currentValue = _markerValue4.round().toInt();
      _annotationValue4 = '$_currentValue';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSixthPointerValueChanged(double value) {
    _setValueForSixthPointer(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSixthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue5).abs() > 20) {
      args.cancel = true;

      if (_markerValue5 > 50) {
        final double value = 100;
        _setValueForSixthPointer(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setValueForSixthPointer(double value) {
    setState(() {
      _markerValue5 = value.roundToDouble();
      _value5 = _markerValue5;
      final int _currentValue = _value5.round().toInt();
      _annotationValue5 = '$_currentValue';
    });
  }
}
