///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the radial slider thumb customization.
class RadialRangeSliderThumb extends SampleView {
  /// Creates the radial slider thumb customization.
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
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 3.5
          : MediaQuery.of(context).size.height / 5;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSliderWithCircle(),
            const Center(child: Text('Circle thumb')),
            _buildSliderWithRectangle(),
            const Center(child: Text('Rectangle thumb')),
            _buildSliderWithImage(),
            const Center(child: Text('Image thumb')),
          ],
        ),
      );
    } else {
      _size = MediaQuery.of(context).size.width / 4.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSliderWithCircle(),
                const Center(child: Text('Circle thumb')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSliderWithRectangle(),
                const Center(child: Text('Rectangle thumb')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSliderWithImage(),
                const Center(child: Text('Image thumb')),
              ],
            ),
          ],
        ),
      );
    }
  }

  /// Returns gradient progress style circular progress bar.
  Widget _buildSliderWithCircle() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _secondMarkerValue,
                startValue: _firstMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: model.isWebFullView
                    ? const Color.fromRGBO(197, 91, 226, 1)
                    : null,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(197, 91, 226, 1),
                    Color.fromRGBO(115, 67, 189, 1),
                  ],
                  stops: <double>[0.5, 1],
                ),
                endWidth: 0.1,
                startWidth: 0.1,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                overlayRadius: 0,
                elevation: 5,
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
                elevation: 5,
                overlayRadius: 0,
                markerType: MarkerType.circle,
                markerHeight: 22,
                markerWidth: 22,
                enableDragging: true,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text('$_annotationValue1 - $_annotationValue_1'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns gradient progress style circular progress bar.
  Widget _buildSliderWithRectangle() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: _thirdMarkerValue,
                endValue: _fourthMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: model.isWebFullView
                    ? const Color.fromRGBO(197, 91, 226, 1)
                    : null,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(197, 91, 226, 1),
                    Color.fromRGBO(115, 67, 189, 1),
                  ],
                  stops: <double>[0.5, 1],
                ),
                endWidth: 0.1,
                startWidth: 0.1,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _thirdMarkerValue,
                overlayRadius: 0,
                elevation: 5,
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
                elevation: 5,
                overlayRadius: 0,
                markerType: MarkerType.rectangle,
                markerHeight: 22,
                markerWidth: 22,
                enableDragging: true,
                onValueChanged: handleFourthPointerValueChanged,
                onValueChanging: handleFourthPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text('$_annotationValue2 - $_annotationValue_2'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns gradient progress style circular progress bar.
  Widget _buildSliderWithImage() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: _fifthMarkerValue,
                endValue: _sixthMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: Colors.green,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(197, 91, 226, 1),
                    Color.fromRGBO(115, 67, 189, 1),
                  ],
                  stops: <double>[0.5, 1],
                ),
                endWidth: 0.1,
                startWidth: 0.1,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                overlayRadius: 0,
                value: _fifthMarkerValue,
                markerType: MarkerType.image,
                imageUrl: 'images/ball.png',
                markerHeight: 30,
                markerWidth: 30,
                enableDragging: true,
                onValueChanged: handleFifthPointerValueChanged,
                onValueChanging: handleFifthPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
              MarkerPointer(
                value: _sixthMarkerValue,
                markerType: MarkerType.image,
                imageUrl: 'images/ball.png',
                markerHeight: 30,
                markerWidth: 30,
                enableDragging: true,
                onValueChanged: handleSixthPointerValueChanged,
                onValueChanging: handleSixthPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text('$_annotationValue3 - $_annotationValue_3'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int secondMarkerValue = _secondMarkerValue.abs().toInt();
      _annotationValue_1 = '$secondMarkerValue';
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
      final int firstMarkerValue = _firstMarkerValue.abs().toInt();
      _annotationValue1 = '$firstMarkerValue';
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
      final int fourthMarkerValue = _fourthMarkerValue.abs().toInt();
      _annotationValue_2 = '$fourthMarkerValue';
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
  void handleThirdPointerValueChanged(double value) {
    setState(() {
      _thirdMarkerValue = value;
      final int thirdMarkerValue = _thirdMarkerValue.abs().toInt();
      _annotationValue2 = '$thirdMarkerValue';
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
  void handleSixthPointerValueChanged(double value) {
    setState(() {
      _sixthMarkerValue = value;
      final int sixthMarkerValue = _sixthMarkerValue.abs().toInt();
      _annotationValue_3 = '$sixthMarkerValue';
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
  void handleFifthPointerValueChanged(double value) {
    setState(() {
      _fifthMarkerValue = value;
      final int fifthMarkerValue = _fifthMarkerValue.abs().toInt();
      _annotationValue3 = '$fifthMarkerValue';
    });
  }

  /// Value changeing call back for first pointer
  void handleFifthPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _sixthMarkerValue ||
        (args.value - _fifthMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }
}
