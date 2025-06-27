///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarTypes extends SampleView {
  /// Cr
  const ProgressBarTypes(Key key) : super(key: key);

  @override
  _ProgressBarTypesState createState() => _ProgressBarTypesState();
}

class _ProgressBarTypesState extends SampleViewState {
  _ProgressBarTypesState();

  double _size = 150;
  late Timer _timer;
  double _value = 0;
  double _value1 = 0;
  double _value2 = 0;
  double _endValue = 20;
  bool _isLoaded = false;
  ProgressBarColor? _progressBarColor;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (mounted) {
      // ignore: no_leading_underscores_for_local_identifiers
      _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer _timer) {
        setState(() {
          _value++;

          if (!_isLoaded || (_isLoaded && _value1 > 0 && _value1 != 100)) {
            _value1++;
          }

          if (_endValue != 100) {
            _endValue++;
          }

          if ((_value1 > 20 && !_isLoaded) ||
              (_isLoaded && ((_value2 - _value1).abs() == 20) ||
                  _value1 == 100)) {
            _value2++;
          }

          if (_value == 100) {
            _value = 0;
          }
          if (_value1 == 100) {
            _isLoaded = true;
          }

          if (_value2 == 100) {
            _value2 = 0;
            _value1 = 0;
            _value1++;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _progressBarColor = ProgressBarColor(model);
    return Center(child: _getWidget(MediaQuery.of(context).size));
  }

  Widget _getWidget(Size size) {
    if (size.width > size.height) {
      _size = size.width / 4.5;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getDeterminateProgressBar(),
              const Center(child: Text('Determinate')),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getBufferProgressBar(),
              const Center(child: Text('Buffer')),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getSegmentProgressBar(),
              const Center(child: Text('Segment')),
            ],
          ),
        ],
      );
    } else {
      _size = model.isWebFullView ? size.height / 5 : size.height / 4.5;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getDeterminateProgressBar(),
          const Center(child: Text('Determinate')),
          _getBufferProgressBar(),
          const Center(child: Text('Buffer')),
          _getSegmentProgressBar(),
          const Center(child: Text('Segment')),
        ],
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _getDeterminateProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            startAngle: 270,
            endAngle: 270,
            showLabels: false,
            showTicks: false,
            radiusFactor: model.isWebFullView ? 0.7 : 0.75,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                color: _progressBarColor!.pointerColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getBufferProgressBar() {
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
            canScaleToFit: true,
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value1,
                width: 0.05,
                color: _progressBarColor!.bufferColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
              RangePointer(
                value: _value2,
                width: 0.05,
                color: _progressBarColor!.pointerColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSegmentProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          // Create primary radial axis
          RadialAxis(
            interval: 25,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                pointerOffset: 0.07,
                color: _progressBarColor!.pointerColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
          ),
          // Create secondary radial axis for segmented line
          RadialAxis(
            interval: 25,
            showLabels: false,
            showAxisLine: false,
            tickOffset: -0.05,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 0,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            majorTickStyle: MajorTickStyle(
              length: 0.3,
              thickness: 3,
              lengthUnit: GaugeSizeUnit.factor,
              color: model.themeData.brightness == Brightness.light
                  ? Colors.white
                  : const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
        ],
      ),
    );
  }
}
