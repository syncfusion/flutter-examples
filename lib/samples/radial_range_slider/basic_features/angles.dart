///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the Radial Slider angles.
class RadialRangeSliderAngles extends SampleView {
  const RadialRangeSliderAngles(Key key) : super(key: key);

  @override
  _RadialRangeSliderAnglesState createState() =>
      _RadialRangeSliderAnglesState();
}

class _RadialRangeSliderAnglesState extends SampleViewState {
  _RadialRangeSliderAnglesState();

  double _size = 150;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _markerSize = 18;
      _annotationFontSize = 15;
    } else {
      _markerSize = model.isWeb ? 18 : 12;
      _annotationFontSize = model.isWeb ? 15 : 12;
    }
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 6
          : MediaQuery.of(context).size.height / 6;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getFirstSlider(),
            Align(
              alignment: !model.isWeb ? Alignment(0, 0) : Alignment(0, 0),
              child: _getSecondSlider(),
            ),
            Align(
                alignment: !model.isWeb ? Alignment(0, 0) : Alignment(0, 0),
                child: _getThirdSlider()),
            Align(
                alignment: model.isWeb ? Alignment(0, 0) : Alignment(0, 0),
                child: _getFourthSlider()),
          ],
        ),
      );
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getFirstSlider(),
            Align(
              alignment: Alignment(0.8, 0),
              child: _getSecondSlider(),
            ),
            Align(
              alignment: Alignment(-0.5, 0),
              child: _getThirdSlider(),
            ),
            Align(
                alignment: model.isWeb ? Alignment(0, 0) : Alignment(0, 0.5),
                child: _getFourthSlider()),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getSecondSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
                thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 90,
            endAngle: 270,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: _thirdMarkerValue,
                  endValue: _fourthMarkerValue,
                  endWidth: 0.1,
                  startWidth: 0.1,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _thirdMarkerValue,
                enableDragging: true,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                onValueChanged: handleThirdPointerValueChanged,
                onValueChanging: handleThirdPointerValueChanging,
                borderWidth: 4,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _fourthMarkerValue,
                enableDragging: true,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    '$_annotationValue2 - $_annotationValue_2',
                    style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: model.currentThemeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ])
      ]),
    );
  }

  Widget _getThirdSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
                thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 90,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: _fifthMarkerValue,
                  endValue: _sixthMarkerValue,
                  endWidth: 0.1,
                  startWidth: 0.1,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _fifthMarkerValue,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleFifthPointerValueChanged,
                onValueChanging: handleFifthPointerValueChanging,
                enableDragging: true,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _sixthMarkerValue,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleSixthPointerValueChanged,
                onValueChanging: handleSixthPointerValueChanging,
                enableDragging: true,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    '$_annotationValue3 - $_annotationValue_3',
                    style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: model.currentThemeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ]),
      ]),
    );
  }

  Widget _getFirstSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
                thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: _firstMarkerValue,
                  endValue: _secondMarkerValue,
                  endWidth: 0.1,
                  startWidth: 0.1,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                enableDragging: true,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                enableDragging: true,
                borderWidth: 4,
                borderColor:
                    model.currentThemeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    '$_annotationValue1 - $_annotationValue_1',
                    style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: model.currentThemeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ])
      ]),
    );
  }

  Widget _getFourthSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
              thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 0,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: _seventhMarkerValue,
                endValue: _eighthMarkerValue,
                endWidth: 0.1,
                startWidth: 0.1,
                color: const Color.fromRGBO(0, 198, 139, 1),
                sizeUnit: GaugeSizeUnit.factor)
          ],
          pointers: <GaugePointer>[
            MarkerPointer(
              value: _seventhMarkerValue,
              color: model.currentThemeData.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderWidth: 4,
              onValueChanged: handleSeventhPointerValueChanged,
              onValueChanging: handleSeventhPointerValueChanging,
              enableDragging: true,
              borderColor: model.currentThemeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              markerHeight: _markerSize,
              markerWidth: _markerSize,
              markerType: MarkerType.circle,
            ),
            MarkerPointer(
              value: _eighthMarkerValue,
              color: model.currentThemeData.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderWidth: 4,
              onValueChanged: handleEighthPointerValueChanged,
              onValueChanging: handleEighthPointerValueChanging,
              enableDragging: true,
              borderColor: model.currentThemeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              markerHeight: _markerSize,
              markerWidth: _markerSize,
              markerType: MarkerType.circle,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Text(
                  '$_annotationValue4 - $_annotationValue_4',
                  style: TextStyle(
                      fontSize: _annotationFontSize,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                ),
                positionFactor: 0.13,
                angle: 0)
          ],
        ),
      ]),
    );
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
      }
    }
  }

  double _firstMarkerValue = 0;
  double _secondMarkerValue = 60;
  double _thirdMarkerValue = 0;
  double _fourthMarkerValue = 60;
  double _fifthMarkerValue = 0;
  double _sixthMarkerValue = 60;
  double _seventhMarkerValue = 0;
  double _eighthMarkerValue = 60;
  String _annotationValue1 = '0';
  String _annotationValue_1 = '60';
  String _annotationValue2 = '0';
  String _annotationValue_2 = '60';
  String _annotationValue3 = '0';
  String _annotationValue_3 = '60';
  String _annotationValue4 = '0';
  String _annotationValue_4 = '60';
  double _markerSize = 10;
  double _annotationFontSize = 25;
}
