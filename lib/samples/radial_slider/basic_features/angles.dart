///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the Radial Slider angles.
class RadialSliderAngles extends SampleView {
  /// Creates the Radial Slider angles.
  const RadialSliderAngles(Key key) : super(key: key);

  @override
  _RadialSliderAnglesState createState() => _RadialSliderAnglesState();
}

class _RadialSliderAnglesState extends SampleViewState {
  _RadialSliderAnglesState();

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
      _size = height / 6;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildFirstSlider(),
            Align(
              alignment: !model.isWebFullView
                  ? const Alignment(0, 0.1)
                  : Alignment.center,
              child: _buildSecondSlider(),
            ),
            Align(
              alignment: !model.isWebFullView
                  ? const Alignment(0, 0.1)
                  : Alignment.center,
              child: _buildThirdSlider(),
            ),
            _buildFourthSlider(),
          ],
        ),
      );
    } else {
      _size = width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: model.isWebFullView
                  ? Alignment.centerRight
                  : Alignment.center,
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
              child: _buildFourthSlider(),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildFirstSlider() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            useRangeColorForAxis: true,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(88, 194, 143, 0.3),
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
                value: _currentValue,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                enableDragging: true,
                elevation: 5,
                value: _markerValue,
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                color: const Color.fromRGBO(88, 194, 143, 1),
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$_annotationValue1'
                  '%',
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: model.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                angle: 0,
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
            radiusFactor: 0.8,
            canScaleToFit: model.isWebFullView && width > height,
            axisLineStyle: const AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromRGBO(88, 194, 143, 0.3),
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 90,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                width: 0.1,
                value: _markerValueForFirstHalfSlider,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValueForFirstHalfSlider,
                elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleValueChangedForFirstHalfSlider,
                onValueChangeEnd: handleValueChangedForFirstHalfSlider,
                onValueChanging: handleValueChangingForFirstHalfSlider,
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
                  '$_annotationValue2'
                  '%',
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: model.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                angle: 0,
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
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromRGBO(88, 194, 143, 0.3),
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            canScaleToFit: model.isWebFullView && width > height,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 90,
            pointers: <GaugePointer>[
              RangePointer(
                width: 0.1,
                value: _markerValueForPieSlider,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValueForPieSlider,
                elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleValueChangedForPieSlider,
                onValueChangeEnd: handleValueChangedForPieSlider,
                onValueChanging: handleValueChangingForPieSlider,
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
                  '$_annotationValue3'
                  '%',
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: model.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                angle: 0,
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
            radiusFactor: 0.9,
            axisLineStyle: const AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromRGBO(88, 194, 143, 0.3),
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 0,
            pointers: <GaugePointer>[
              RangePointer(
                width: 0.1,
                value: _markerValueForFirstQuarterSlider,
                cornerStyle: CornerStyle.bothCurve,
                color: const Color.fromRGBO(88, 194, 143, 1),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _markerValueForFirstQuarterSlider,
                elevation: 5,
                color: const Color.fromRGBO(88, 194, 143, 1),
                // model.currentThemeData.brightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                // borderWidth: 4,
                onValueChanged: handleValueChangedForFirstQuarterSlider,
                onValueChangeEnd: handleValueChangedForFirstQuarterSlider,
                onValueChanging: handleValueChangingForFirstQuarterSlider,
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
                  '$_annotationValue4'
                  '%',
                  style: TextStyle(
                    fontSize: _annotationFontSize,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: model.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                angle: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _markerValue).abs() > 20) {
      args.cancel = true;
      if (_markerValue > 50) {
        const double value = 100;
        _setPointerValue(value);
      }
    }
  }

  /// Method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _markerValue = value.roundToDouble();
      _currentValue = _markerValue;
      _annotationValue1 = value.round().toStringAsFixed(0);
    });
  }

  /// Value changing call back for pie slider.
  void handleValueChangingForPieSlider(ValueChangingArgs args) {
    if ((args.value.round() - _markerValueForPieSlider).abs() > 80) {
      args.cancel = true;
      if (_markerValueForPieSlider > 95) {
        _setPointerValueForPieSlider(100);
      }
    }
  }

  /// Value changed call back for pie slider.
  void handleValueChangedForPieSlider(double value) {
    _setPointerValueForPieSlider(value);
  }

  void _setPointerValueForPieSlider(double value) {
    setState(() {
      _markerValueForPieSlider = value.roundToDouble();
      //_currentValueForPieSlider = _markerValueForPieSlider + 2;
      _annotationValue3 = _markerValueForPieSlider.toStringAsFixed(0);
    });
  }

  /// Value changing call back for first half slider.
  void handleValueChangingForFirstHalfSlider(ValueChangingArgs args) {
    if ((args.value.round() - _markerValueForFirstHalfSlider).abs() > 80) {
      args.cancel = true;
      if (_markerValueForFirstHalfSlider > 95) {
        _setPointerValueForHalfSlider(100);
      }
    }
  }

  /// Value changed call back for first half slider.
  void handleValueChangedForFirstHalfSlider(double value) {
    _setPointerValueForHalfSlider(value);
  }

  /// Method to set the value for pointer value
  void _setPointerValueForHalfSlider(double value) {
    setState(() {
      _markerValueForFirstHalfSlider = value.roundToDouble();
      //_currentValueForFirstHalfSlider = _markerValueForFirstHalfSlider + 2;
      _annotationValue2 = _markerValueForFirstHalfSlider.toStringAsFixed(0);
    });
  }

  /// Value changing call back for first quarter slider.
  void handleValueChangingForFirstQuarterSlider(ValueChangingArgs args) {
    if (args.value.toInt() < 0) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first quarter slider.
  void handleValueChangedForFirstQuarterSlider(double value) {
    setState(() {
      _markerValueForFirstQuarterSlider = value.roundToDouble();
      // _currentValueForFirstQuarterSlider =
      //     _markerValueForFirstQuarterSlider + 2;
      _annotationValue4 = value.round().toStringAsFixed(0);
    });
  }

  double _currentValue = 60;
  double _markerValue = 60;
  double _markerValueForPieSlider = 60;
  double _markerValueForFirstHalfSlider = 60;
  double _markerValueForFirstQuarterSlider = 60;
  double _markerSize = 25;
  String _annotationValue1 = '60';
  String _annotationValue2 = '60';
  String _annotationValue3 = '60';
  String _annotationValue4 = '60';
  double _annotationFontSize = 25;
}
