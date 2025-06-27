///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider styles.
class RadialSliderStyles extends SampleView {
  /// Creates the RadialSlider styles.
  const RadialSliderStyles(Key key) : super(key: key);

  @override
  _RadialSliderStylesState createState() => _RadialSliderStylesState();
}

class _RadialSliderStylesState extends SampleViewState {
  _RadialSliderStylesState();

  double _value = 30;
  String _annotationValue = '30%';
  double _annotationFontSize = 25;
  double _markerValue = 28;
  double _firstMarkerSize = 20;
  double _secondMarkerSize = 20;
  double _markerWidth = 10;
  double _size = 150;
  double _borderWidth = 8;
  double _thirdborderwidth = 7.5;

  double _value1 = 30;
  double _markerValue1 = 30;
  String _annotationValue1 = '30%';

  double _value2 = 30;
  double _markerValue2 = 28;
  String _annotationValue2 = '30%';

  double _value3 = 30;
  double _markerValue3 = 28;
  String _annotationValue3 = '30%';

  double _value4 = 30;
  double _markerValue4 = 28;
  String _annotationValue4 = '30%';

  double _value5 = 30;
  double _markerValue5 = 30;
  String _annotationValue5 = '30';

  @override
  Widget build(BuildContext context) {
    final Size actualSize = MediaQuery.of(context).size;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 12;
      _secondMarkerSize = 20;
      _thirdborderwidth = 7.5;
      _borderWidth = 5;
      _markerWidth = 5;
      _annotationFontSize = 15;
    } else {
      _firstMarkerSize = model.isWebFullView ? 15 : 10;
      _secondMarkerSize = model.isWebFullView ? 20 : 15;
      _markerWidth = model.isWebFullView ? 5 : 3;
      _borderWidth = model.isWebFullView ? 5 : 3;
      _thirdborderwidth = model.isWebFullView ? 5 : 3;
      _annotationFontSize = model.isWebFullView ? 15 : 12;
    }

    if (actualSize.width > actualSize.height) {
      _size = actualSize.height / 5;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFirtProgressBar(),
              _buildSecondProgressBar(),
              _buildThirdProgressBar(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFourthProgressBar(),
              _buildFifthProgressBar(),
              _buildSixthProgressBar(),
            ],
          ),
        ],
      );
    } else {
      _size = actualSize.height / 5;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFirtProgressBar(),
              _buildSecondProgressBar(),
              _buildThirdProgressBar(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFourthProgressBar(),
              _buildFifthProgressBar(),
              _buildSixthProgressBar(),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFirtProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: AxisLineStyle(
              color: model.themeData.brightness == Brightness.light
                  ? const Color.fromRGBO(191, 214, 252, 1)
                  : const Color.fromRGBO(36, 58, 97, 1),
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                width: 0.1,
                value: _value,
                cornerStyle: CornerStyle.bothCurve,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(41, 118, 246, 1)
                    : const Color.fromRGBO(6, 102, 217, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue,
                elevation: 5,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChangeEnd: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                enableDragging: true,
                overlayColor: const Color.fromRGBO(41, 118, 246, 0.125),
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: _borderWidth,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(41, 118, 246, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue,
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: AxisLineStyle(
              color: model.themeData.brightness == Brightness.light
                  ? const Color.fromRGBO(218, 218, 218, 1)
                  : const Color.fromRGBO(88, 88, 88, 1),
              thickness: 0.15,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
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
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue1,
                elevation: 5,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChangeEnd: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                enableDragging: true,
                color: const Color.fromRGBO(126, 86, 212, 1),
                borderWidth: 9,
                markerWidth: _firstMarkerSize,
                markerHeight: _markerWidth,
                markerType: MarkerType.rectangle,
                borderColor: const Color.fromRGBO(126, 86, 212, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue1,
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThirdProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(254, 166, 25, 1),
              thickness: 0.2,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                value: 100,
                pointerOffset: 0.03,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : const Color.fromRGBO(41, 37, 32, 1),
                width: 0.13,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              RangePointer(
                width: 0.13,
                pointerOffset: 0.03,
                value: _value2,
                color: const Color.fromRGBO(254, 166, 25, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue2,
                elevation: 5,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromRGBO(33, 33, 33, 1),
                borderWidth: _thirdborderwidth,
                onValueChanged: handleThirdPointerValueChanged,
                onValueChangeEnd: handleThirdPointerValueChanged,
                onValueChanging: handleThirdPointerValueChanging,
                enableDragging: true,
                markerHeight: _secondMarkerSize,
                markerWidth: _secondMarkerSize,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(254, 166, 25, 1),
                overlayColor: const Color.fromRGBO(254, 166, 25, 0.125),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue2,
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFourthProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: AxisLineStyle(
              color: model.themeData.brightness == Brightness.light
                  ? const Color.fromRGBO(201, 201, 201, 1)
                  : const Color.fromRGBO(97, 97, 97, 1),
              thickness: 0.24,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                value: 100,
                pointerOffset: 0.03,
                width: 0.18,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              RangePointer(
                width: 0.08,
                pointerOffset: 0.08,
                value: _value3,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue3,
                elevation: 5,
                overlayColor: const Color.fromRGBO(88, 194, 143, 0.125),
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                enableDragging: true,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
              ),
              MarkerPointer(
                value: _markerValue3,
                // elevation: 5,
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                enableDragging: true,
                color: const Color.fromRGBO(88, 194, 143, 1),
                borderWidth: 2,
                markerHeight: 9,
                markerWidth: 9,
                overlayRadius: 0,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue3,
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFifthProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(41, 118, 246, 1),
              thickness: 0.24,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                pointerOffset: 0.065,
                width: 0.1,
                value: _value4,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(254, 166, 25, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValue4,
                // elevation: 5,
                color: const Color.fromRGBO(254, 166, 25, 1),
                markerHeight: 15,
                onValueChanged: handleFifthPointerValueChanged,
                onValueChangeEnd: handleFifthPointerValueChanged,
                onValueChanging: handleFifthPointerValueChanging,
                enableDragging: true,
                markerWidth: 15,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(34, 144, 199, 0.75),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue4,
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSixthProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.85,
            axisLabelStyle: const GaugeTextStyle(fontSize: 8),
            interval: 10,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.03,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showTicks: false,
            showLabels: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              NeedlePointer(
                value: _markerValue5,
                needleColor: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(65, 65, 65, 1)
                    : const Color.fromRGBO(191, 191, 191, 1),
                needleEndWidth: 1.5,
                needleStartWidth: 1.5,
                needleLength: 0.82,
                knobStyle: KnobStyle(
                  knobRadius: model.isWebFullView ? 0.4 : 0.3,
                  borderWidth: 0.05,
                  borderColor: model.themeData.brightness == Brightness.light
                      ? const Color.fromRGBO(65, 65, 65, 1)
                      : const Color.fromRGBO(191, 191, 191, 1),
                  color: model.themeData.brightness == Brightness.light
                      ? Colors.white
                      : const Color.fromRGBO(33, 33, 33, 1),
                ),
              ),
              RangePointer(
                width: 0.15,
                pointerOffset: 0.17,
                value: _value5,
                onValueChanged: handleSixthPointerValueChanged,
                onValueChangeEnd: handleSixthPointerValueChanged,
                onValueChanging: handleSixthPointerValueChanging,
                enableDragging: true,
                color: const Color.fromRGBO(126, 87, 213, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _annotationValue5,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: model.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleFirstPointerValueChanged(double value) {
    _setFirstPointerValue(value);
  }

  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue).abs() > 20) {
      args.cancel = true;

      if (_markerValue > 50) {
        const double value = 100;
        _setFirstPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFirstPointerValue(double value) {
    setState(() {
      _markerValue = value.roundToDouble();
      _value = _markerValue + 2;
      final int currentValue = _markerValue.round();
      _annotationValue = '$currentValue%';
    });
  }

  void handleSecondPointerValueChanged(double value) {
    _setSecondPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue1).abs() > 20) {
      args.cancel = true;

      if (_markerValue1 > 50) {
        const double value = 100;
        _setSecondPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setSecondPointerValue(double value) {
    setState(() {
      _markerValue1 = value.roundToDouble();
      _value1 = _markerValue1;
      final int currentValue = _markerValue1.round();
      _annotationValue1 = '$currentValue%';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleThirdPointerValueChanged(double value) {
    _setThirdPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleThirdPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue2).abs() > 20) {
      args.cancel = true;

      if (_markerValue2 > 50) {
        const double value = 100;
        _setThirdPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setThirdPointerValue(double value) {
    setState(() {
      _markerValue2 = value.roundToDouble();
      _value2 = _markerValue2 + 2;
      final int currentValue = _markerValue2.round();
      _annotationValue2 = '$currentValue%';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleFourthPointerValueChanged(double value) {
    _setFourthPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFourthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue3).abs() > 20) {
      args.cancel = true;

      if (_markerValue3 > 50) {
        const double value = 100;
        _setFourthPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFourthPointerValue(double value) {
    setState(() {
      _markerValue3 = value;
      _value3 = _markerValue3 + 2;
      final int currentValue = _markerValue3.round();
      _annotationValue3 = '$currentValue%';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleFifthPointerValueChanged(double value) {
    _setFifthPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFifthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue4).abs() > 20) {
      args.cancel = true;

      if (_markerValue4 > 50) {
        const double value = 100;
        _setFifthPointerValue(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setFifthPointerValue(double value) {
    setState(() {
      _markerValue4 = value.roundToDouble();
      _value4 = _markerValue4 + 2;
      final int currentValue = _markerValue4.round();
      _annotationValue4 = '$currentValue%';
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSixthPointerValueChanged(double value) {
    _setValueForSixthPointer(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSixthPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue5).abs() > 20) {
      args.cancel = true;

      if (_markerValue5 > 50) {
        const double value = 100;
        _setValueForSixthPointer(value);
      }
    }
  }

  /// Method to set value for pointer
  void _setValueForSixthPointer(double value) {
    setState(() {
      _markerValue5 = value.roundToDouble();
      _value5 = _markerValue5;
      final int currentValue = _value5.round();
      _annotationValue5 = '$currentValue';
    });
  }
}
