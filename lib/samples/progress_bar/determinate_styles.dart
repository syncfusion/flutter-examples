///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarDeterminateStyle extends SampleView {
  /// Creates progress bar smaple with determinate styles.
  const ProgressBarDeterminateStyle(Key key) : super(key: key);

  @override
  _ProgressBarDeterminateStyleState createState() =>
      _ProgressBarDeterminateStyleState();
}

class _ProgressBarDeterminateStyleState extends SampleViewState {
  _ProgressBarDeterminateStyleState();
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
  Widget build(BuildContext context) {
    _progressBarColor = ProgressBarColor(model);
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 5
          : MediaQuery.of(context).size.height / 4.5;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getFilledTrackStyle(),
            const Center(child: Text('Filled track')),
            getFilledProgressStyle(),
            const Center(child: Text('Filled progress')),
            getGradientProgressStyle(),
            const Center(child: Text('Gradient track')),
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
                getFilledTrackStyle(),
                const Center(child: Text('Filled track')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getFilledProgressStyle(),
                const Center(child: Text('Filled progress')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getGradientProgressStyle(),
                const Center(child: Text('Gradient track')),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Returns filled track style circular progress bar.
  Widget getFilledTrackStyle() {
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
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 1,
              color:
                  _progressBarColor!.pointerColor ??
                  const Color.fromARGB(255, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.15,
                enableAnimation: true,
                animationDuration: 30,
                color: Colors.white,
                pointerOffset: 0.1,
                cornerStyle: CornerStyle.bothCurve,
                animationType: AnimationType.linear,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  progressValue.toStringAsFixed(0) + '%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns filled progress style circular progress bar.
  Widget getFilledProgressStyle() {
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
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              color:
                  (_progressBarColor!.pointerColor ??
                          const Color.fromRGBO(0, 169, 181, 1))
                      .withAlpha(100),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.95,
                color: _progressBarColor!.pointerColor,
                pointerOffset: 0.05,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.linear,
                animationDuration: 75,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns gradient progress style circular progress bar.
  Widget getGradientProgressStyle() {
    final ThemeData themeData = model.themeData;
    final Color gradientColor1 = themeData.useMaterial3
        ? model.primaryColor.withValues(alpha: 0.4)
        : const Color(0xFFa4edeb);
    final Color gradientColor2 = themeData.useMaterial3
        ? model.primaryColor
        : const Color(0xFF00a9b5);
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
            radiusFactor: model.isWebFullView ? 0.7 : 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 75,
                animationType: AnimationType.linear,
                gradient: SweepGradient(
                  colors: <Color>[gradientColor1, gradientColor2],
                  stops: const <double>[0.25, 0.75],
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(progressValue.toStringAsFixed(0) + '%'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
