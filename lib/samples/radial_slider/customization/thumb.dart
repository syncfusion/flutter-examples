///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the radial slider thumb customization.
class RadialSliderThumb extends SampleView {
  /// Creates radial slider thumb customization.
  const RadialSliderThumb(Key key) : super(key: key);

  @override
  _RadialSliderThumbState createState() => _RadialSliderThumbState();
}

class _RadialSliderThumbState extends SampleViewState {
  _RadialSliderThumbState();

  double _progressValue1 = 75;
  double _progressValue2 = 75;
  double _progressValue3 = 75;
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
            pointers: <GaugePointer>[
              RangePointer(
                value: _progressValue1,
                width: 0.1,
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
              ),
              MarkerPointer(
                value: _progressValue1,
                elevation: 5,
                overlayRadius: 0,
                markerType: MarkerType.circle,
                markerHeight: 25,
                markerWidth: 25,
                enableDragging: true,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(_progressValue1.toStringAsFixed(0) + '%'),
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
            pointers: <GaugePointer>[
              RangePointer(
                value: _progressValue2,
                width: 0.1,
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
              ),
              MarkerPointer(
                value: _progressValue2,
                elevation: 5,
                overlayRadius: 0,
                markerType: MarkerType.rectangle,
                markerHeight: 25,
                markerWidth: 25,
                enableDragging: true,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(_progressValue2.toStringAsFixed(0) + '%'),
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
            pointers: <GaugePointer>[
              RangePointer(
                value: _progressValue3,
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(197, 91, 226, 1),
                    Color.fromRGBO(115, 67, 189, 1),
                  ],
                  stops: <double>[0.5, 1],
                ),
              ),
              MarkerPointer(
                value: _progressValue3,
                elevation: 5,
                markerType: MarkerType.image,
                imageUrl: 'images/ball.png',
                markerHeight: model.isWebFullView ? 30 : 30,
                markerWidth: model.isWebFullView ? 30 : 30,
                enableDragging: true,
                onValueChanged: handleThirdPointerValueChanged,
                onValueChanging: handleThirdPointerValueChanging,
                color: const Color.fromRGBO(125, 71, 194, 1),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(_progressValue3.toStringAsFixed(0) + '%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _progressValue1 = value;
    });
  }

  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _progressValue1).abs() > 20) {
      args.cancel = true;
    }
  }

  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _progressValue2 = value;
    });
  }

  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _progressValue2).abs() > 20) {
      args.cancel = true;
    }
  }

  void handleThirdPointerValueChanged(double value) {
    setState(() {
      _progressValue3 = value;
    });
  }

  void handleThirdPointerValueChanging(ValueChangingArgs args) {
    if ((args.value.round() - _progressValue3).abs() > 20) {
      args.cancel = true;
    }
  }
}
