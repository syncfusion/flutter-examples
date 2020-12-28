///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the radial slider thumb customization.
class RadialRangeSliderThumb extends SampleView {
  const RadialRangeSliderThumb(Key key) : super(key: key);

  @override
  _RadialRangeSliderThumbState createState() => _RadialRangeSliderThumbState();
}

class _RadialRangeSliderThumbState extends SampleViewState {
  _RadialRangeSliderThumbState();

  double _firstMarkerValue = 0;
  double _secondMarkerValue = 75;
  double _thirdMarkerValue = 0;
  double _fourthMarkerValue = 75;
  double _fifthMarkerValue = 0;
  double _sixthMarkerValue = 75;
  String _annotationValue1 = '0';
  String _annotationValue_1 = '75';
  String _annotationValue2 = '0';
  String _annotationValue_2 = '75';
  String _annotationValue3 = '0';
  String _annotationValue_3 = '75';

  double _size = 150;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 3.5
          : MediaQuery.of(context).size.height / 5;
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !model.isWeb
            ? [
                getSliderWithCircle(),
                Center(child: Text('Circle thumb')),
                getSliderWithRectangle(),
                Center(child: Text('Rectangle thumb')),
                getSliderWithImage(),
                Center(child: Text('Image thumb')),
              ]
            : [
                getSliderWithCircle(),
                Center(child: Text('Circle thumb')),
                getSliderWithRectangle(),
                Center(child: Text('Rectangle thumb'))
              ],
      ));
    } else {
      _size = MediaQuery.of(context).size.width / 4.5;
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !model.isWeb
            ? [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getSliderWithCircle(),
                      Center(child: Text('Circle thumb')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getSliderWithRectangle(),
                      Center(child: Text('Rectangle thumb')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getSliderWithImage(),
                      Center(child: Text('Image thumb')),
                    ]),
              ]
            : [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getSliderWithCircle(),
                      Center(child: Text('Circle thumb')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getSliderWithRectangle(),
                      Center(child: Text('Rectangle thumb')),
                    ]),
              ],
      ));
    }
  }

  /// Returns gradient progress style circular progress bar.
  Widget getSliderWithCircle() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _secondMarkerValue,
                    startValue: _firstMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: model.isWeb ? Color.fromRGBO(197, 91, 226, 1) : null,
                    gradient: model.isWeb
                        ? null
                        : SweepGradient(colors: <Color>[
                            const Color.fromRGBO(197, 91, 226, 1),
                            const Color.fromRGBO(115, 67, 189, 1)
                          ], stops: <double>[
                            0.5,
                            1
                          ]),
                    endWidth: 0.1,
                    startWidth: 0.1)
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: _firstMarkerValue,
                  markerType: MarkerType.circle,
                  markerHeight: 22,
                  markerWidth: 22,
                  enableDragging: true,
                  onValueChanged: handleFirstPointerValueChanged,
                  onValueChanging: handleFirstPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                ),
                MarkerPointer(
                  value: _secondMarkerValue,
                  markerType: MarkerType.circle,
                  markerHeight: 22,
                  markerWidth: 22,
                  enableDragging: true,
                  onValueChanged: handleSecondPointerValueChanged,
                  onValueChanging: handleSecondPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text('$_annotationValue1 - $_annotationValue_1'))
              ]),
        ]));
  }

  /// Returns gradient progress style circular progress bar.
  Widget getSliderWithRectangle() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                  endValue: _thirdMarkerValue,
                  startValue: _fourthMarkerValue,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: model.isWeb ? Color.fromRGBO(197, 91, 226, 1) : null,
                  gradient: model.isWeb
                      ? null
                      : SweepGradient(colors: <Color>[
                          const Color.fromRGBO(197, 91, 226, 1),
                          const Color.fromRGBO(115, 67, 189, 1)
                        ], stops: <double>[
                          0.5,
                          1
                        ]),
                  endWidth: 0.1,
                  startWidth: 0.1,
                )
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: _thirdMarkerValue,
                  markerType: MarkerType.rectangle,
                  markerHeight: 22,
                  markerWidth: 22,
                  enableDragging: true,
                  onValueChanged: handleThirdPointerValueChanged,
                  onValueChanging: handleThirdPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                ),
                MarkerPointer(
                  value: _fourthMarkerValue,
                  markerType: MarkerType.rectangle,
                  markerHeight: 22,
                  markerWidth: 22,
                  enableDragging: true,
                  onValueChanged: handleFourthPointerValueChanged,
                  onValueChanging: handleFourthPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text('$_annotationValue2 - $_annotationValue_2'))
              ]),
        ]));
  }

  /// Returns gradient progress style circular progress bar.
  Widget getSliderWithImage() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                    endValue: _fifthMarkerValue,
                    startValue: _sixthMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.green,
                    gradient: model.isWeb
                        ? null
                        : SweepGradient(colors: <Color>[
                            const Color.fromRGBO(197, 91, 226, 1),
                            const Color.fromRGBO(115, 67, 189, 1)
                          ], stops: <double>[
                            0.5,
                            1
                          ]),
                    endWidth: 0.1,
                    startWidth: 0.1)
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: _fifthMarkerValue,
                  markerType: MarkerType.image,
                  imageUrl: 'images/ball.png',
                  markerHeight: model.isWeb ? 15 : 30,
                  markerWidth: model.isWeb ? 15 : 30,
                  enableDragging: true,
                  onValueChanged: handleFifthPointerValueChanged,
                  onValueChanging: handleFifthPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                ),
                MarkerPointer(
                  value: _sixthMarkerValue,
                  markerType: MarkerType.image,
                  imageUrl: 'images/ball.png',
                  markerHeight: model.isWeb ? 15 : 30,
                  markerWidth: model.isWeb ? 15 : 30,
                  enableDragging: true,
                  onValueChanged: handleSixthPointerValueChanged,
                  onValueChanging: handleSixthPointerValueChanging,
                  color: const Color.fromRGBO(125, 71, 194, 1),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text('$_annotationValue3 - $_annotationValue_3'))
              ]),
        ]));
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = _secondMarkerValue.abs().toInt();
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
      final int _value = _firstMarkerValue.abs().toInt();
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
      final int _value = _fourthMarkerValue.abs().toInt();
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
      final int _value = _thirdMarkerValue.abs().toInt();
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
      final int _value = _sixthMarkerValue.abs().toInt();
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
      final int _value = _fifthMarkerValue.abs().toInt();
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
}
