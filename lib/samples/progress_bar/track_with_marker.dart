///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarTrackWithMarker extends SampleView {
  /// Creates the progress bar track with marker sample
  const ProgressBarTrackWithMarker(Key key) : super(key: key);

  @override
  _ProgressBarTrackWithMarkerState createState() =>
      _ProgressBarTrackWithMarkerState();
}

class _ProgressBarTrackWithMarkerState extends SampleViewState {
  _ProgressBarTrackWithMarkerState();

  double progressValue = 0;
  double _size = 150;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer timer) {
        setState(() {
          progressValue++;

          if (progressValue == 100) {
            progressValue = 0;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 3.5
          : MediaQuery.of(context).size.height / 4.5;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getProgressBarWithCircle(),
            const Center(child: Text('Circle marker')),
            getProgressBarWithRectangle(),
            const Center(child: Text('Rectangle marker')),
            getProgressBarWithImage(),
            const Center(child: Text('Image marker')),
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
                getProgressBarWithCircle(),
                const Center(child: Text('Circle marker')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getProgressBarWithRectangle(),
                const Center(child: Text('Rectangle marker')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getProgressBarWithImage(),
                const Center(child: Text('Image marker')),
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

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithCircle() {
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
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                cornerStyle: CornerStyle.startCurve,
                gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF00a9b5), Color(0xFFa4edeb)],
                  stops: <double>[0.25, 0.75],
                ),
              ),
              MarkerPointer(
                value: progressValue,
                markerType: MarkerType.circle,
                markerHeight: model.isWebFullView ? 25 : 20,
                markerWidth: model.isWebFullView ? 25 : 20,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                color: const Color(0xFF87e8e8),
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

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithRectangle() {
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
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                cornerStyle: CornerStyle.startCurve,
                gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF00a9b5), Color(0xFFa4edeb)],
                  stops: <double>[0.25, 0.75],
                ),
              ),
              MarkerPointer(
                value: progressValue,
                markerType: MarkerType.rectangle,
                markerHeight: model.isWebFullView ? 25 : 18,
                markerWidth: model.isWebFullView ? 25 : 18,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                color: const Color(0xFF87e8e8),
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

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithImage() {
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
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue,
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                cornerStyle: CornerStyle.startCurve,
                gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF00a9b5), Color(0xFFa4edeb)],
                  stops: <double>[0.25, 0.75],
                ),
              ),
              MarkerPointer(
                value: progressValue,
                markerType: MarkerType.image,
                imageUrl: 'images/ball_progressbar.png',
                markerHeight: model.isWebFullView ? 25 : 30,
                markerWidth: model.isWebFullView ? 25 : 30,
                enableAnimation: true,
                animationDuration: 30,
                animationType: AnimationType.linear,
                color: const Color(0xFF87e8e8),
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
