///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///gauge import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarSegmentStyle extends SampleView {
  /// Creates the progress bar segment style sample.
  const ProgressBarSegmentStyle(Key key) : super(key: key);

  @override
  _ProgressBarSegmentStyleState createState() =>
      _ProgressBarSegmentStyleState();
}

class _ProgressBarSegmentStyleState extends SampleViewState {
  _ProgressBarSegmentStyleState();

  double progressValue = 0;
  double _size = 150;
  late Timer _timer;
  ProgressBarColor? _progressBarColor;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer timer) {
        setState(() {
          if (progressValue == 100) {
            progressValue = 0;
          } else {
            progressValue++;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressBarColor = ProgressBarColor(model);
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 4.5
          : MediaQuery.of(context).size.height / 4;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getSegmentedProgressBar1(),
            _getSegmentedProgressBar2(),
            _getSegmentedProgressBar3(),
          ],
        ),
      );
    } else {
      _size = MediaQuery.of(context).size.width / 4;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getSegmentedProgressBar1(),
            _getSegmentedProgressBar2(),
            _getSegmentedProgressBar3(),
          ],
        ),
      );
    }
  }

  Widget _getSegmentedProgressBar1() {
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
            radiusFactor: 0.85,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.05,
                pointerOffset: 0.07,
                color: _progressBarColor!.pointerColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 30,
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
            radiusFactor: 0.85,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                widget: Text(
                  progressValue.toStringAsFixed(0) + '%',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
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

  Widget _getSegmentedProgressBar2() {
    return SizedBox(
      width: _size,
      height: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showTicks: false,
            showLabels: false,
            endAngle: 55,
            radiusFactor: 0.85,
            axisLineStyle: const AxisLineStyle(
              thickness: 30,
              dashArray: <double>[8, 3],
            ),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                widget: Text(
                  progressValue.toStringAsFixed(0) + '%',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                enableAnimation: true,
                color: _progressBarColor!.pointerColor,
                animationType: AnimationType.linear,
                animationDuration: 30,
                width: 30,
                dashArray: const <double>[8, 3],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSegmentedProgressBar3() {
    return SizedBox(
      width: _size,
      height: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showTicks: false,
            showLabels: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.85,
            axisLineStyle: const AxisLineStyle(
              thickness: 30,
              dashArray: <double>[15, 2],
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 30,
                enableAnimation: true,
                animationDuration: 30,
                gradient: const SweepGradient(
                  colors: <Color>[
                    Color.fromRGBO(255, 4, 0, 1),
                    Color.fromRGBO(255, 15, 0, 1),
                    Color.fromRGBO(255, 31, 0, 1),
                    Color.fromRGBO(255, 60, 0, 1),
                    Color.fromRGBO(255, 90, 0, 1),
                    Color.fromRGBO(255, 115, 0, 1),
                    Color.fromRGBO(255, 135, 0, 1),
                    Color.fromRGBO(255, 155, 0, 1),
                    Color.fromRGBO(255, 175, 0, 1),
                    Color.fromRGBO(255, 188, 0, 1),
                    Color.fromRGBO(255, 188, 0, 1),
                    Color.fromRGBO(251, 188, 2, 1),
                    Color.fromRGBO(245, 188, 6, 1),
                    Color.fromRGBO(233, 188, 12, 1),
                    Color.fromRGBO(220, 187, 19, 1),
                    Color.fromRGBO(208, 187, 26, 1),
                    Color.fromRGBO(193, 187, 34, 1),
                    Color.fromRGBO(177, 186, 43, 1),
                  ],
                  stops: <double>[
                    0.05,
                    0.1,
                    0.15,
                    0.2,
                    0.25,
                    0.3,
                    0.35,
                    0.4,
                    0.45,
                    0.5,
                    0.55,
                    0.6,
                    0.65,
                    0.7,
                    0.75,
                    0.8,
                    0.85,
                    0.9,
                  ],
                ),
                dashArray: const <double>[15, 2],
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                widget: Text(
                  progressValue.toStringAsFixed(0) + '%',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
