///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the Radial Slider angles.
class RadialSliderAngles extends SampleView {
  const RadialSliderAngles(Key key) : super(key: key);

  @override
  _RadialSliderAnglesState createState() => _RadialSliderAnglesState();
}

class _RadialSliderAnglesState extends SampleViewState {
  _RadialSliderAnglesState();

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
              alignment: !model.isWeb ? Alignment(0, 0.1) : Alignment(0, 0),
              child: _getSecondSlider(),
            ),
            Align(
                alignment: !model.isWeb ? Alignment(0, 0.1) : Alignment(0, 0),
                child: _getThirdSlider()),
            _getFourthSlider(),
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
            _getSecondSlider(),
            _getThirdSlider(),
            Align(
                alignment: model.isWeb ? Alignment(0, -0.6) : Alignment(0, 0),
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
            pointers: <GaugePointer>[
              RangePointer(
                  width: 0.1,
                  value: _currentValue,
                  cornerStyle: CornerStyle.endCurve,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor),
              MarkerPointer(
                enableDragging: true,
                value: _markerValue,
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
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
                    '$_annotationValue1' + '%',
                    style: TextStyle(
                      fontSize: _annotationFontSize,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ])
      ]),
    );
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
            pointers: <GaugePointer>[
              RangePointer(
                  width: 0.1,
                  value: _currentValueForFirstHalfSlider,
                  cornerStyle: CornerStyle.endCurve,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor),
              MarkerPointer(
                value: _markerValueForFirstHalfSlider,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleValueChangedForFirstHalfSlider,
                onValueChangeEnd: handleValueChangedForFirstHalfSlider,
                onValueChanging: handleValueChangingForFirstHalfSlider,
                enableDragging: true,
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
                    '$_annotationValue2' + '%',
                    style: TextStyle(
                      fontSize: _annotationFontSize,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ]),
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
            pointers: <GaugePointer>[
              RangePointer(
                  width: 0.1,
                  value: _currentValueForPieSlider,
                  cornerStyle: CornerStyle.endCurve,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor),
              MarkerPointer(
                value: _markerValueForPieSlider,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleValueChangedForPieSlider,
                onValueChangeEnd: handleValueChangedForPieSlider,
                onValueChanging: handleValueChangingForPieSlider,
                enableDragging: true,
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
                    '$_annotationValue3' + '%',
                    style: TextStyle(
                      fontSize: _annotationFontSize,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
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
            radiusFactor: 0.9,
            axisLineStyle: AxisLineStyle(
                thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor),
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 0,
            canScaleToFit: true,
            pointers: <GaugePointer>[
              RangePointer(
                  width: 0.1,
                  value: _currentValueForFirstQuarterSlider,
                  cornerStyle: CornerStyle.endCurve,
                  color: const Color.fromRGBO(0, 198, 139, 1),
                  sizeUnit: GaugeSizeUnit.factor),
              MarkerPointer(
                value: _markerValueForFirstQuarterSlider,
                color: model.currentThemeData.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderWidth: 4,
                onValueChanged: handleValueChangedForFirstQuarterSlider,
                onValueChangeEnd: handleValueChangedForFirstQuarterSlider,
                onValueChanging: handleValueChangingForFirstQuarterSlider,
                enableDragging: true,
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
                    '$_annotationValue4' + '%',
                    style: TextStyle(
                      fontSize: _annotationFontSize,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color:
                          model.currentThemeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  positionFactor: 0.13,
                  angle: 0)
            ]),
      ]),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValue).abs() > 20) {
      args.cancel = true;
      if (_markerValue > 50) {
        final double value = 100;
        _setPointerValue(value);
      }
    }
  }

  /// Method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _markerValue = value.roundToDouble();
      _currentValue = _markerValue + 2;
      _annotationValue1 = value.round().toStringAsFixed(0);
    });
  }

  /// Value changing call back for pie slider.
  void handleValueChangingForPieSlider(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValueForPieSlider).abs() > 20) {
      args.cancel = true;
      if (_markerValueForPieSlider > 50) {
        final double value = 100;
        _setPointerValueForPieSlider(value);
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
      _currentValueForPieSlider = _markerValueForPieSlider + 2;
      _annotationValue3 = value.round().toStringAsFixed(0);
    });
  }

  /// Value changing call back for first half slider.
  void handleValueChangingForFirstHalfSlider(ValueChangingArgs args) {
    if ((args.value.round().toInt() - _markerValueForFirstHalfSlider).abs() >
        20) {
      args.cancel = true;
      if (_markerValueForFirstHalfSlider > 50) {
        final double value = 100;
        _setPointerValueForHalfSlider(value);
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
      _currentValueForFirstHalfSlider = _markerValueForFirstHalfSlider + 2;
      _annotationValue2 = value.round().toStringAsFixed(0);
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
      _currentValueForFirstQuarterSlider =
          _markerValueForFirstQuarterSlider + 2;
      _annotationValue4 = value.round().toStringAsFixed(0);
    });
  }

  double _currentValue = 60;
  double _markerValue = 58;
  double _currentValueForPieSlider = 60;
  double _markerValueForPieSlider = 58;
  double _currentValueForFirstHalfSlider = 60;
  double _markerValueForFirstHalfSlider = 58;
  double _currentValueForFirstQuarterSlider = 60;
  double _markerValueForFirstQuarterSlider = 58;
  double _markerSize = 25;
  String _annotationValue1 = '60';
  String _annotationValue2 = '60';
  String _annotationValue3 = '60';
  String _annotationValue4 = '60';
  double _annotationFontSize = 25;
}
