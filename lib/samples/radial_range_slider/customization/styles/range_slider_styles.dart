///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Widget of the RadialSlider styles.
class RadialRangeSliderStyles extends SampleView {
  const RadialRangeSliderStyles(Key key) : super(key: key);

  @override
  _RadialRangeSliderStylesState createState() =>
      _RadialRangeSliderStylesState();
}

class _RadialRangeSliderStylesState extends SampleViewState {
  _RadialRangeSliderStylesState();

  double _annotationFontSize = 25;
  double _firstMarkerSize = 20;
  double _secondMarkerSize = 20;
  double _markerWidth = 10;
  double _size = 150;
  double _borderWidth = 8;

  double _firstMarkerValue = 0;
  double _secondMarkerValue = 30;
  String _annotationValue1 = '0';
  String _annotationValue_1 = '30';

  double _thirdMarkerValue = 0;
  double _fourthMarkerValue = 30;
  String _annotationValue2 = '0';
  String _annotationValue_2 = '30';

  double _fifthMarkerValue = 0;
  double _sixthMarkerValue = 30;
  String _annotationValue3 = '0';
  String _annotationValue_3 = '30';

  double _seventhMarkerValue = 0;
  double _eighthMarkerValue = 30;
  String _annotationValue4 = '0';
  String _annotationValue_4 = '30';

  double _ninthMarkerValue = 0;
  double _tenthMarkerValue = 30;
  String _annotationValue5 = '0';
  String _annotationValue_5 = '30';

  double _eleventhMarkerValue = 0;
  double _twelethMarkerValue = 30;
  String _annotationValue6 = '0';
  String _annotationValue_6 = '30';

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
      _markerWidth = model.isWeb ? 3 : 3;
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
            children: [_getFirtSlider(), _getSecondSlider(), _getThirdSlider()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFourthSlider(),
              _getFifthSlider(),
              _getSixthSlider()
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
            children: [_getFirtSlider(), _getSecondSlider(), _getThirdSlider()],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getFourthSlider(),
              _getFifthSlider(),
              _getSixthSlider()
            ],
          ),
        ],
      );
    }
  }

  Widget _getFirtSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _secondMarkerValue,
                    startValue: _firstMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Color.fromRGBO(41, 118, 246, 1),
                    endWidth: 0.1,
                    startWidth: 0.1)
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                    value: _firstMarkerValue,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: _borderWidth,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    onValueChanged: handleFirstPointerValueChanged,
                    onValueChanging: handleFirstPointerValueChanging,
                    borderColor: Color.fromRGBO(41, 118, 246, 1)),
                MarkerPointer(
                    value: _secondMarkerValue,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: _borderWidth,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    onValueChanged: handleSecondPointerValueChanged,
                    onValueChanging: handleSecondPointerValueChanging,
                    borderColor: Color.fromRGBO(41, 118, 246, 1)),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue1 - $_annotationValue_1',
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

  Widget _getSecondSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _fourthMarkerValue,
                    startValue: _thirdMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: const Color.fromRGBO(126, 86, 212, 1),
                    endWidth: 0.15,
                    startWidth: 0.15)
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                    enableDragging: true,
                    value: _thirdMarkerValue,
                    color: const Color.fromRGBO(126, 86, 212, 1),
                    borderWidth: 9,
                    markerWidth: _firstMarkerSize,
                    markerHeight: _markerWidth,
                    onValueChanged: handleThirdPointerValueChanged,
                    onValueChanging: handleThirdPointerValueChanging,
                    markerType: MarkerType.rectangle,
                    borderColor: const Color.fromRGBO(126, 86, 212, 1)),
                MarkerPointer(
                    value: _fourthMarkerValue,
                    enableDragging: true,
                    color: const Color.fromRGBO(126, 86, 212, 1),
                    borderWidth: 9,
                    markerWidth: _firstMarkerSize,
                    markerHeight: _markerWidth,
                    onValueChanged: handleFourthPointerValueChanged,
                    onValueChanging: handleFourthPointerValueChanging,
                    markerType: MarkerType.rectangle,
                    borderColor: const Color.fromRGBO(126, 86, 212, 1)),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue2 - $_annotationValue_2',
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

  Widget _getThirdSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: 100,
                    startValue: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : const Color.fromRGBO(41, 37, 32, 1),
                    endWidth: 0.145,
                    rangeOffset: 0.05,
                    startWidth: 0.145),
                GaugeRange(
                    endValue: _sixthMarkerValue,
                    startValue: _fifthMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    rangeOffset: 0.05,
                    endWidth: 0.144,
                    startWidth: 0.144),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: _sixthMarkerValue,
                  enableDragging: true,
                  color: Colors.white,
                  borderWidth: _borderWidth,
                  markerHeight: _secondMarkerSize,
                  markerWidth: _secondMarkerSize,
                  onValueChanged: handleSixthPointerValueChanged,
                  onValueChanging: handleSixthPointerValueChanging,
                  markerType: MarkerType.circle,
                  borderColor: const Color.fromRGBO(254, 166, 25, 1),
                ),
                MarkerPointer(
                  value: _fifthMarkerValue,
                  enableDragging: true,
                  color: Colors.white,
                  borderWidth: _borderWidth,
                  markerHeight: _secondMarkerSize,
                  markerWidth: _secondMarkerSize,
                  onValueChanged: handleFifthPointerValueChanged,
                  onValueChanging: handleFifthPointerValueChanging,
                  markerType: MarkerType.circle,
                  borderColor: const Color.fromRGBO(254, 166, 25, 1),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue3 - $_annotationValue_3',
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

  Widget _getFourthSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: 100,
                    startValue: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    endWidth: 0.09,
                    rangeOffset: 0.03,
                    startWidth: 0.09),
                GaugeRange(
                    endValue: _eighthMarkerValue,
                    startValue: _seventhMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    rangeOffset: 0.05,
                    endWidth: 0.05,
                    color: const Color.fromRGBO(88, 194, 143, 1),
                    startWidth: 0.05),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                    value: _seventhMarkerValue,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: 3,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    onValueChanged: handleSeventhPointerValueChanged,
                    onValueChanging: handleSeventhPointerValueChanging,
                    borderColor: Color.fromRGBO(88, 194, 143, 1)),
                MarkerPointer(
                    value: _seventhMarkerValue,
                    enableDragging: true,
                    color: Color.fromRGBO(88, 194, 143, 1),
                    borderWidth: 1,
                    markerHeight: 7,
                    markerWidth: 7,
                    markerType: MarkerType.circle,
                    onValueChanged: handleSeventhPointerValueChanged,
                    onValueChanging: handleSeventhPointerValueChanging,
                    borderColor: Color.fromRGBO(88, 194, 143, 1)),
                MarkerPointer(
                    value: _eighthMarkerValue,
                    enableDragging: true,
                    color: model.currentThemeData.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderWidth: 3,
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    markerType: MarkerType.circle,
                    onValueChanged: handleEighthPointerValueChanged,
                    onValueChanging: handleEighthPointerValueChanging,
                    borderColor: Color.fromRGBO(88, 194, 143, 1)),
                MarkerPointer(
                    value: _eighthMarkerValue,
                    enableDragging: true,
                    color: Color.fromRGBO(88, 194, 143, 1),
                    borderWidth: 1,
                    markerHeight: 7,
                    markerWidth: 7,
                    markerType: MarkerType.circle,
                    onValueChanged: handleEighthPointerValueChanged,
                    onValueChanging: handleEighthPointerValueChanging,
                    borderColor: Color.fromRGBO(88, 194, 143, 1))
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue4 - $_annotationValue_4',
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

  Widget _getFifthSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _tenthMarkerValue,
                    startValue: _ninthMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    endWidth: 0.15,
                    rangeOffset: 0.075,
                    startWidth: 0.15),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                    value: _ninthMarkerValue,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    markerHeight: _firstMarkerSize,
                    enableDragging: true,
                    markerWidth: _firstMarkerSize,
                    onValueChanged: handleNinthPointerValueChanged,
                    onValueChanging: handleNinthPointerValueChanging,
                    markerType: MarkerType.circle,
                    borderColor: const Color.fromRGBO(34, 144, 199, 0.75)),
                MarkerPointer(
                    value: _tenthMarkerValue,
                    enableDragging: true,
                    color: const Color.fromRGBO(254, 166, 25, 1),
                    markerHeight: _firstMarkerSize,
                    markerWidth: _firstMarkerSize,
                    onValueChanged: handleTenthPointerValueChanged,
                    onValueChanging: handleTenthPointerValueChanging,
                    markerType: MarkerType.circle,
                    borderColor: const Color.fromRGBO(34, 144, 199, 0.75)),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue5 - $_annotationValue_5',
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

  Widget _getSixthSlider() {
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
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _twelethMarkerValue,
                    startValue: _eleventhMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: const Color.fromRGBO(135, 80, 221, 1),
                    endWidth: 0.07,
                    rangeOffset: 0.27,
                    startWidth: 0.07),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                    value: _twelethMarkerValue,
                    enableDragging: true,
                    needleColor:
                        model.currentThemeData.brightness == Brightness.light
                            ? Color.fromRGBO(65, 65, 65, 1)
                            : Color.fromRGBO(191, 191, 191, 1),
                    needleEndWidth: 2,
                    needleStartWidth: 2,
                    onValueChanged: handleTwelethPointerValueChanged,
                    // onValueChangeEnd: handleTwelethPointerValueChanged,
                    onValueChanging: handleTwelethPointerValueChanging,
                    needleLength: 0.71,
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
                NeedlePointer(
                    value: _eleventhMarkerValue,
                    enableDragging: true,
                    needleColor:
                        model.currentThemeData.brightness == Brightness.light
                            ? Color.fromRGBO(65, 65, 65, 1)
                            : Color.fromRGBO(191, 191, 191, 1),
                    needleEndWidth: 2,
                    needleStartWidth: 2,
                    onValueChanged: handleEleventhPointerValueChanged,
                    // onValueChangeEnd: handleEleventhPointerValueChanged,
                    onValueChanging: handleEleventhPointerValueChanging,
                    needleLength: 0.71,
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
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue6 - $_annotationValue_6',
                      style: TextStyle(
                        fontSize: model.isWeb ? 10 : 12,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: model.currentThemeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    positionFactor: 0,
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

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = _secondMarkerValue.abs().round().toInt();
      _annotationValue_1 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      if (args.value <= _firstMarkerValue) {
        if ((args.value - _secondMarkerValue).abs() > 10) {
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

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = _firstMarkerValue.abs().round().toInt();
      _annotationValue1 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      if (args.value >= _secondMarkerValue) {
        if ((args.value - _firstMarkerValue).abs() > 10) {
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

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleFourthPointerValueChanged(double value) {
    setState(() {
      _fourthMarkerValue = value;
      final int _value = _fourthMarkerValue.abs().round().toInt();
      _annotationValue_2 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFourthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _thirdMarkerValue ||
        (args.value - _fourthMarkerValue).abs() > 10) {
      if (args.value <= _thirdMarkerValue) {
        if ((args.value - _fourthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _fourthMarkerValue = _thirdMarkerValue;
          _thirdMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleThirdPointerValueChanged(double value) {
    setState(() {
      _thirdMarkerValue = value;
      final int _value = _thirdMarkerValue.abs().round().toInt();
      _annotationValue2 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleThirdPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _fourthMarkerValue ||
        (args.value - _thirdMarkerValue).abs() > 10) {
      if (args.value >= _fourthMarkerValue) {
        if ((args.value - _thirdMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _thirdMarkerValue = _fourthMarkerValue;
          _fourthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSixthPointerValueChanged(double value) {
    setState(() {
      _sixthMarkerValue = value;
      final int _value = _sixthMarkerValue.abs().round().toInt();
      _annotationValue_3 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSixthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _fifthMarkerValue ||
        (args.value - _sixthMarkerValue).abs() > 10) {
      if (args.value <= _fifthMarkerValue) {
        if ((args.value - _sixthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _sixthMarkerValue = _fifthMarkerValue;
          _fifthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleFifthPointerValueChanged(double value) {
    setState(() {
      _fifthMarkerValue = value;
      final int _value = _fifthMarkerValue.abs().round().toInt();
      _annotationValue3 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFifthPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _sixthMarkerValue ||
        (args.value - _fifthMarkerValue).abs() > 10) {
      if (args.value >= _sixthMarkerValue) {
        if ((args.value - _fifthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _fifthMarkerValue = _sixthMarkerValue;
          _sixthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleEighthPointerValueChanged(double value) {
    setState(() {
      _eighthMarkerValue = value;
      final int _value = _eighthMarkerValue.abs().round().toInt();
      _annotationValue_4 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleEighthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _seventhMarkerValue ||
        (args.value - _eighthMarkerValue).abs() > 10) {
      if (args.value <= _seventhMarkerValue) {
        if ((args.value - _eighthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _eighthMarkerValue = _seventhMarkerValue;
          _seventhMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleSeventhPointerValueChanged(double value) {
    setState(() {
      _seventhMarkerValue = value;
      final int _value = _seventhMarkerValue.abs().round().toInt();
      _annotationValue4 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleSeventhPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _eighthMarkerValue ||
        (args.value - _seventhMarkerValue).abs() > 10) {
      if (args.value >= _eighthMarkerValue) {
        if ((args.value - _seventhMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _seventhMarkerValue = _eighthMarkerValue;
          _eighthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleTenthPointerValueChanged(double value) {
    setState(() {
      _tenthMarkerValue = value;
      final int _value = _tenthMarkerValue.abs().round().toInt();
      _annotationValue_5 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleTenthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _ninthMarkerValue ||
        (args.value - _tenthMarkerValue).abs() > 10) {
      if (args.value <= _ninthMarkerValue) {
        if ((args.value - _tenthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _tenthMarkerValue = _ninthMarkerValue;
          _ninthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleNinthPointerValueChanged(double value) {
    setState(() {
      _ninthMarkerValue = value;
      final int _value = _ninthMarkerValue.abs().round().toInt();
      _annotationValue5 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleNinthPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _tenthMarkerValue ||
        (args.value - _ninthMarkerValue).abs() > 10) {
      if (args.value >= _tenthMarkerValue) {
        if ((args.value - _ninthMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _ninthMarkerValue = _tenthMarkerValue;
          _tenthMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleTwelethPointerValueChanged(double value) {
    setState(() {
      _twelethMarkerValue = value;
      final int _value = _twelethMarkerValue.abs().round().toInt();
      _annotationValue_6 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleTwelethPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _eleventhMarkerValue ||
        (args.value - _twelethMarkerValue).abs() > 10) {
      if (args.value <= _eleventhMarkerValue) {
        if ((args.value - _twelethMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _twelethMarkerValue = _eleventhMarkerValue;
          _eleventhMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  /// Value changed call back for first pointer
  void handleEleventhPointerValueChanged(double value) {
    setState(() {
      _eleventhMarkerValue = value;
      final int _value = _eleventhMarkerValue.abs().round().toInt();
      _annotationValue6 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleEleventhPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _twelethMarkerValue ||
        (args.value - _eleventhMarkerValue).abs() > 10) {
      if (args.value >= _twelethMarkerValue) {
        if ((args.value - _eleventhMarkerValue).abs() > 10) {
          args.cancel = true;
        } else {
          _eleventhMarkerValue = _twelethMarkerValue;
          _twelethMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }
}
