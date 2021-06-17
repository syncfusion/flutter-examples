///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the Radial Slider angles.
class RadialRangeSliderAngles extends SampleView {
  /// Creates the radial slider angles sample.
  const RadialRangeSliderAngles(Key key) : super(key: key);

  @override
  _RadialRangeSliderAnglesState createState() =>
      _RadialRangeSliderAnglesState();
}

class _RadialRangeSliderAnglesState extends SampleViewState {
  _RadialRangeSliderAnglesState();

  double _size = 150;
  late double width, height;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _markerSize = 18;
      _annotationFontSize = 15;
    } else {
      _markerSize = model.isWebFullView ? 25 : 12;
      _annotationFontSize = model.isWebFullView ? 15 : 12;
    }
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (height > width) {
      _size = model.isWebFullView ? height / 6 : height / 6;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildFirstSlider(),
            Align(
              alignment: !model.isWebFullView
                  ? const Alignment(0, 0)
                  : const Alignment(0, 0),
              child: _buildSecondSlider(),
            ),
            Align(
                alignment: !model.isWebFullView
                    ? const Alignment(0, 0)
                    : const Alignment(0, 0),
                child: _buildThirdSlider()),
            Align(
                alignment: model.isWebFullView
                    ? const Alignment(0, 0)
                    : const Alignment(0, 0),
                child: _buildFourthSlider()),
          ],
        ),
      );
    } else {
      _size = width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: model.isWebFullView
                  ? Alignment.centerRight
                  : const Alignment(0, 0),
              child: _buildFirstSlider(),
            ),
            Align(
              alignment: model.isWebFullView
                  ? Alignment.centerLeft
                  : const Alignment(0.8, 0),
              child: _buildSecondSlider(),
            ),
            Align(
              alignment: model.isWebFullView
                  ? Alignment.centerLeft
                  : const Alignment(-0.5, 0),
              child: _buildThirdSlider(),
            ),
            Align(
                alignment: model.isWebFullView
                    ? const Alignment(-0.1, 0.25)
                    : const Alignment(0, 0.5),
                child: _buildFourthSlider()),
          ],
        ),
      );
    }
  }

  Widget _buildSecondSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            interval: 10,
            axisLineStyle: const AxisLineStyle(
                color: Color.fromRGBO(88, 194, 143, 0.3),
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 90,
            endAngle: 270,
            canScaleToFit: model.isWebFullView && width > height,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: _thirdMarkerValue,
                  endValue: _fourthMarkerValue,
                  endWidth: 0.1,
                  startWidth: 0.1,
                  color: const Color.fromRGBO(88, 194, 143, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _thirdMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                onValueChanged: handleThirdPointerValueChanged,
                onValueChanging: handleThirdPointerValueChanging,
                // borderWidth: 4,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _fourthMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
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
                        color: model.currentThemeData!.brightness ==
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

  Widget _buildThirdSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            interval: 10,
            axisLineStyle: const AxisLineStyle(
                color: Color.fromRGBO(88, 194, 143, 0.3),
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 90,
            canScaleToFit: model.isWebFullView && width > height,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: _fifthMarkerValue,
                  endValue: _sixthMarkerValue,
                  endWidth: 0.1,
                  startWidth: 0.1,
                  color: const Color.fromRGBO(88, 194, 143, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _fifthMarkerValue,
                elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleFifthPointerValueChanged,
                onValueChanging: handleFifthPointerValueChanging,
                enableDragging: true,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _sixthMarkerValue,
                elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleSixthPointerValueChanged,
                onValueChanging: handleSixthPointerValueChanging,
                enableDragging: true,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
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
                        color: model.currentThemeData!.brightness ==
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

  Widget _buildFirstSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
                color: Color.fromRGBO(88, 194, 143, 0.3),
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor),
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
                  color: const Color.fromRGBO(88, 194, 143, 1),
                  sizeUnit: GaugeSizeUnit.factor)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                enableDragging: true,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                elevation: 5,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                enableDragging: true,
                // borderWidth: 4,
                // borderColor:
                //     model.currentThemeData.brightness == Brightness.light
                //         ? Colors.black
                //         : Colors.white,
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
                        color: model.currentThemeData!.brightness ==
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

  Widget _buildFourthSlider() {
    return Container(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: 0.8,
          axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(88, 194, 143, 0.3),
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor),
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
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor)
          ],
          pointers: <GaugePointer>[
            MarkerPointer(
              value: _seventhMarkerValue,
              elevation: 5,
              color: const Color.fromRGBO(88, 194, 143, 1),
              // model.currentThemeData.brightness == Brightness.light
              //     ? Colors.white
              //     : Colors.black,
              // borderWidth: 4,
              onValueChanged: handleSeventhPointerValueChanged,
              onValueChanging: handleSeventhPointerValueChanging,
              enableDragging: true,
              // borderColor: model.currentThemeData.brightness == Brightness.light
              //     ? Colors.black
              //     : Colors.white,
              markerHeight: _markerSize,
              markerWidth: _markerSize,
              markerType: MarkerType.circle,
            ),
            MarkerPointer(
              value: _eighthMarkerValue,
              elevation: 5,
              color: const Color.fromRGBO(88, 194, 143, 1),
              // model.currentThemeData.brightness == Brightness.light
              //     ? Colors.white
              //     : Colors.black,
              // borderWidth: 4,
              onValueChanged: handleEighthPointerValueChanged,
              onValueChanging: handleEighthPointerValueChanging,
              enableDragging: true,
              // borderColor: model.currentThemeData.brightness == Brightness.light
              //     ? Colors.black
              //     : Colors.white,
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
                          model.currentThemeData!.brightness == Brightness.light
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
      final int _value = _secondMarkerValue.abs().roundToDouble().toInt();
      _annotationValue_1 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = _firstMarkerValue.abs().roundToDouble().toInt();
      _annotationValue1 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      args.cancel = true;
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
    if (args.value <= _thirdMarkerValue) {
      args.cancel = true;
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
    if (args.value >= _fourthMarkerValue) {
      args.cancel = true;
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
    if (args.value <= _fifthMarkerValue) {
      args.cancel = true;
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
    if (args.value >= _sixthMarkerValue) {
      args.cancel = true;
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
    if (args.value <= _seventhMarkerValue) {
      args.cancel = true;
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
    if (args.value >= _eighthMarkerValue) {
      args.cancel = true;
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
