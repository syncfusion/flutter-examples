///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider styles.
class RadialRangeSliderStyles extends SampleView {
  /// Creates the the RadialSlider styles.
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
  String _annotationValue_1 = '30%';

  double _thirdMarkerValue = 0;
  double _fourthMarkerValue = 30;
  String _annotationValue2 = '0';
  String _annotationValue_2 = '30%';

  double _fifthMarkerValue = 0;
  double _sixthMarkerValue = 30;
  String _annotationValue3 = '0';
  String _annotationValue_3 = '30%';

  double _seventhMarkerValue = 0;
  double _eighthMarkerValue = 30;
  String _annotationValue4 = '0';
  String _annotationValue_4 = '30%';

  double _ninthMarkerValue = 0;
  double _tenthMarkerValue = 30;
  String _annotationValue5 = '0';
  String _annotationValue_5 = '30%';

  double _eleventhMarkerValue = 0;
  double _twelethMarkerValue = 30;
  String _annotationValue6 = '0';
  String _annotationValue_6 = '30';

  @override
  Widget build(BuildContext context) {
    final Size actualSize = MediaQuery.of(context).size;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 12;
      _secondMarkerSize = 20;
      _borderWidth = 5;
      _markerWidth = 5;
      _annotationFontSize = 15;
    } else {
      _firstMarkerSize = model.isWebFullView ? 15 : 10;
      _secondMarkerSize = model.isWebFullView ? 20 : 15;
      _markerWidth = model.isWebFullView ? 3 : 3;
      _borderWidth = model.isWebFullView ? 5 : 3;
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
              _buildFirtSlider(),
              _buildSecondSlider(),
              _buildThirdSlider(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFourthSlider(),
              _buildFifthSlider(),
              _buildSixthSlider(),
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
              _buildFirtSlider(),
              _buildSecondSlider(),
              _buildThirdSlider(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFourthSlider(),
              _buildFifthSlider(),
              _buildSixthSlider(),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFirtSlider() {
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
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _secondMarkerValue,
                startValue: _firstMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(41, 118, 246, 1),
                endWidth: 0.1,
                startWidth: 0.1,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: _borderWidth,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                overlayColor: const Color.fromRGBO(41, 118, 246, 0.125),
                borderColor: const Color.fromRGBO(41, 118, 246, 1),
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                enableDragging: true,
                elevation: 5,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: _borderWidth,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                overlayColor: const Color.fromRGBO(41, 118, 246, 0.125),
                borderColor: const Color.fromRGBO(41, 118, 246, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$_annotationValue1 - $_annotationValue_1',
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

  Widget _buildSecondSlider() {
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
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _fourthMarkerValue,
                startValue: _thirdMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(126, 86, 212, 1),
                endWidth: 0.15,
                startWidth: 0.15,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                enableDragging: true,
                value: _thirdMarkerValue,
                elevation: 5,
                color: const Color.fromRGBO(126, 86, 212, 1),
                borderWidth: 9,
                markerWidth: _firstMarkerSize,
                markerHeight: _markerWidth,
                onValueChanged: handleThirdPointerValueChanged,
                onValueChanging: handleThirdPointerValueChanging,
                markerType: MarkerType.rectangle,
                borderColor: const Color.fromRGBO(126, 86, 212, 1),
              ),
              MarkerPointer(
                value: _fourthMarkerValue,
                enableDragging: true,
                elevation: 5,
                color: const Color.fromRGBO(126, 86, 212, 1),
                borderWidth: 9,
                markerWidth: _firstMarkerSize,
                markerHeight: _markerWidth,
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                markerType: MarkerType.rectangle,
                borderColor: const Color.fromRGBO(126, 86, 212, 1),
              ),
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
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThirdSlider() {
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
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: 100,
                startValue: 0,
                sizeUnit: GaugeSizeUnit.factor,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : const Color.fromRGBO(41, 37, 32, 1),
                endWidth: 0.13,
                rangeOffset: 0.03,
                startWidth: 0.13,
              ),
              GaugeRange(
                endValue: _sixthMarkerValue,
                startValue: _fifthMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(254, 166, 25, 1),
                rangeOffset: 0.03,
                endWidth: 0.14,
                startWidth: 0.14,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _sixthMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromRGBO(33, 33, 33, 1),
                borderWidth: _borderWidth,
                markerHeight: _secondMarkerSize,
                markerWidth: _secondMarkerSize,
                onValueChanged: handleSixthPointerValueChanged,
                onValueChanging: handleSixthPointerValueChanging,
                markerType: MarkerType.circle,
                overlayColor: const Color.fromRGBO(254, 166, 25, 0.125),
                borderColor: const Color.fromRGBO(254, 166, 25, 1),
              ),
              MarkerPointer(
                value: _fifthMarkerValue,
                enableDragging: true,
                elevation: 5,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromRGBO(33, 33, 33, 1),
                borderWidth: _borderWidth,
                markerHeight: _secondMarkerSize,
                markerWidth: _secondMarkerSize,
                onValueChanged: handleFifthPointerValueChanged,
                onValueChanging: handleFifthPointerValueChanging,
                markerType: MarkerType.circle,
                overlayColor: const Color.fromRGBO(254, 166, 25, 0.125),
                borderColor: const Color.fromRGBO(254, 166, 25, 1),
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

  Widget _buildFourthSlider() {
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
                  : const Color.fromRGBO(78, 78, 78, 1),
              thickness: 0.24,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: 100,
                startValue: 0,
                sizeUnit: GaugeSizeUnit.factor,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                endWidth: 0.18,
                rangeOffset: 0.03,
                startWidth: 0.18,
              ),
              GaugeRange(
                endValue: _eighthMarkerValue,
                startValue: _seventhMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                rangeOffset: 0.08,
                endWidth: 0.08,
                color: const Color.fromRGBO(88, 194, 143, 1),
                startWidth: 0.08,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _seventhMarkerValue,
                enableDragging: true,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.circle,
                onValueChanged: handleSeventhPointerValueChanged,
                onValueChanging: handleSeventhPointerValueChanging,
                overlayRadius: 0,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
              ),
              MarkerPointer(
                value: _seventhMarkerValue,
                enableDragging: true,
                // elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                borderWidth: 2,
                markerHeight: 9,
                markerWidth: 9,
                overlayRadius: 25,
                markerType: MarkerType.circle,
                onValueChanged: handleSeventhPointerValueChanged,
                onValueChanging: handleSeventhPointerValueChanging,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
              ),
              MarkerPointer(
                value: _eighthMarkerValue,
                enableDragging: true,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.circle,
                onValueChanged: handleEighthPointerValueChanged,
                onValueChanging: handleEighthPointerValueChanging,
                overlayRadius: 0,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
              ),
              MarkerPointer(
                value: _eighthMarkerValue,
                enableDragging: true,
                // elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                borderWidth: 2,
                markerHeight: 9,
                overlayRadius: 25,
                markerWidth: 9,
                markerType: MarkerType.circle,
                onValueChanged: handleEighthPointerValueChanged,
                onValueChanging: handleEighthPointerValueChanging,
                borderColor: const Color.fromRGBO(88, 194, 143, 1),
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

  Widget _buildFifthSlider() {
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
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _tenthMarkerValue,
                startValue: _ninthMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(254, 166, 25, 1),
                endWidth: 0.1,
                rangeOffset: 0.065,
                startWidth: 0.1,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _ninthMarkerValue,
                // elevation: 5,
                color: const Color.fromRGBO(254, 166, 25, 1),
                markerHeight: 15,
                enableDragging: true,
                markerWidth: 15,
                onValueChanged: handleNinthPointerValueChanged,
                onValueChanging: handleNinthPointerValueChanging,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(34, 144, 199, 0.75),
              ),
              MarkerPointer(
                value: _tenthMarkerValue,
                // elevation: 5,
                enableDragging: true,
                color: const Color.fromRGBO(254, 166, 25, 1),
                markerHeight: 15,
                markerWidth: 15,
                onValueChanged: handleTenthPointerValueChanged,
                onValueChanging: handleTenthPointerValueChanging,
                markerType: MarkerType.circle,
                borderColor: const Color.fromRGBO(34, 144, 199, 0.75),
              ),
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
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSixthSlider() {
    final Orientation orientation = MediaQuery.of(context).orientation;
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
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _twelethMarkerValue,
                startValue: _eleventhMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(135, 80, 221, 1),
                endWidth: model.isMobile && orientation == Orientation.landscape
                    ? 0.13
                    : 0.17,
                rangeOffset:
                    model.isMobile && orientation == Orientation.landscape
                    ? 0.13
                    : 0.17,
                startWidth:
                    model.isMobile && orientation == Orientation.landscape
                    ? 0.13
                    : 0.17,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: _twelethMarkerValue,
                enableDragging: true,
                needleColor: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(65, 65, 65, 1)
                    : const Color.fromRGBO(191, 191, 191, 1),
                needleEndWidth: 2,
                needleStartWidth: 2,
                onValueChanged: handleTwelethPointerValueChanged,
                // onValueChangeEnd: handleTwelethPointerValueChanged,
                onValueChanging: handleTwelethPointerValueChanging,
                needleLength:
                    model.isMobile && orientation == Orientation.landscape
                    ? 0.85
                    : 0.82,
                knobStyle: KnobStyle(
                  knobRadius: model.isWebFullView
                      ? 0.4
                      : model.isMobile && orientation == Orientation.landscape
                      ? 0.6
                      : 0.3,
                  borderWidth: 0.05,
                  borderColor: model.themeData.brightness == Brightness.light
                      ? const Color.fromRGBO(65, 65, 65, 1)
                      : const Color.fromRGBO(191, 191, 191, 1),
                  color: model.themeData.brightness == Brightness.light
                      ? Colors.white
                      : const Color.fromRGBO(33, 33, 33, 1),
                ),
              ),
              NeedlePointer(
                value: _eleventhMarkerValue,
                enableDragging: true,
                needleColor: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(65, 65, 65, 1)
                    : const Color.fromRGBO(191, 191, 191, 1),
                needleEndWidth: 2,
                needleStartWidth: 2,
                onValueChanged: handleEleventhPointerValueChanged,
                // onValueChangeEnd: handleEleventhPointerValueChanged,
                onValueChanging: handleEleventhPointerValueChanging,
                needleLength:
                    model.isMobile && orientation == Orientation.landscape
                    ? 0.85
                    : 0.82,
                knobStyle: KnobStyle(
                  knobRadius: model.isWebFullView
                      ? 0.4
                      : model.isMobile && orientation == Orientation.landscape
                      ? 0.6
                      : 0.3,
                  borderWidth: 0.05,
                  borderColor: model.themeData.brightness == Brightness.light
                      ? const Color.fromRGBO(65, 65, 65, 1)
                      : const Color.fromRGBO(191, 191, 191, 1),
                  color: model.themeData.brightness == Brightness.light
                      ? Colors.white
                      : const Color.fromRGBO(33, 33, 33, 1),
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$_annotationValue6 - $_annotationValue_6',
                  style: TextStyle(
                    fontSize: model.isWebFullView ? 10 : 12,
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

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double markerValue) {
    setState(() {
      _secondMarkerValue = markerValue;
      final int value = _secondMarkerValue.abs().round();
      _annotationValue_1 = '$value%';
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
  void handleFirstPointerValueChanged(double markerValue) {
    setState(() {
      _firstMarkerValue = markerValue;
      final int value = _firstMarkerValue.abs().round();
      _annotationValue1 = '$value';
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
  void handleFourthPointerValueChanged(double markerValue) {
    setState(() {
      _fourthMarkerValue = markerValue;
      final int value = _fourthMarkerValue.abs().round();
      _annotationValue_2 = '$value%';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleFourthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _thirdMarkerValue ||
        (args.value - _fourthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleThirdPointerValueChanged(double markerValue) {
    setState(() {
      _thirdMarkerValue = markerValue;
      final int value = _thirdMarkerValue.abs().round();
      _annotationValue2 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleThirdPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _fourthMarkerValue ||
        (args.value - _thirdMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSixthPointerValueChanged(double markerValue) {
    setState(() {
      _sixthMarkerValue = markerValue;
      final int value = _sixthMarkerValue.abs().round();
      _annotationValue_3 = '$value%';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSixthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _fifthMarkerValue ||
        (args.value - _sixthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFifthPointerValueChanged(double markerValue) {
    setState(() {
      _fifthMarkerValue = markerValue;
      final int value = _fifthMarkerValue.abs().round();
      _annotationValue3 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFifthPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _sixthMarkerValue ||
        (args.value - _fifthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleEighthPointerValueChanged(double markerValue) {
    setState(() {
      _eighthMarkerValue = markerValue;
      final int value = _eighthMarkerValue.abs().round();
      _annotationValue_4 = '$value%';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleEighthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _seventhMarkerValue ||
        (args.value - _eighthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleSeventhPointerValueChanged(double markerValue) {
    setState(() {
      _seventhMarkerValue = markerValue;
      final int value = _seventhMarkerValue.abs().round();
      _annotationValue4 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleSeventhPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _eighthMarkerValue ||
        (args.value - _seventhMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleTenthPointerValueChanged(double markerValue) {
    setState(() {
      _tenthMarkerValue = markerValue;
      final int value = _tenthMarkerValue.abs().round();
      _annotationValue_5 = '$value%';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleTenthPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _ninthMarkerValue ||
        (args.value - _tenthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleNinthPointerValueChanged(double markerValue) {
    setState(() {
      _ninthMarkerValue = markerValue;
      final int value = _ninthMarkerValue.abs().round();
      _annotationValue5 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleNinthPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _tenthMarkerValue ||
        (args.value - _ninthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleTwelethPointerValueChanged(double markerValue) {
    setState(() {
      _twelethMarkerValue = markerValue;
      final int value = _twelethMarkerValue.abs().round();
      _annotationValue_6 = '$value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleTwelethPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _eleventhMarkerValue ||
        (args.value - _twelethMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleEleventhPointerValueChanged(double markerValue) {
    setState(() {
      _eleventhMarkerValue = markerValue;
      final int value = _eleventhMarkerValue.abs().round();
      _annotationValue6 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleEleventhPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _twelethMarkerValue ||
        (args.value - _eleventhMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }
}
