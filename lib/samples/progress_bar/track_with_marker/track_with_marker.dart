///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///gauges import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarTrackWithMarker extends SampleView {
  const ProgressBarTrackWithMarker(Key key) : super(key: key);

  @override
  _ProgressBarTrackWithMarkerState createState() =>
      _ProgressBarTrackWithMarkerState();
}

class _ProgressBarTrackWithMarkerState extends SampleViewState {
  _ProgressBarTrackWithMarkerState();

  double progressValue = 0;
  double _size = 150;
  Timer _timer;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer _timer) {
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
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 3.5
          : MediaQuery.of(context).size.height / 4.5;
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !model.isWeb
            ? [
                getProgressBarWithCircle(),
                Center(child: Text('Circle marker')),
                getProgressBarWithRectangle(),
                Center(child: Text('Rectangle marker')),
                getProgressBarWithImage(),
                Center(child: Text('Image marker')),
              ]
            : [
                getProgressBarWithCircle(),
                Center(child: Text('Circle marker')),
                getProgressBarWithRectangle(),
                Center(child: Text('Rectangle marker'))
              ],
      ));
    } else {
      _size = MediaQuery.of(context).size.width / 4.5;
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !model.isWeb
            ? [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getProgressBarWithCircle(),
                      Center(child: Text('Circle marker')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getProgressBarWithRectangle(),
                      Center(child: Text('Rectangle marker')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getProgressBarWithImage(),
                      Center(child: Text('Image marker')),
                    ]),
              ]
            : [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getProgressBarWithCircle(),
                      Center(child: Text('Circle marker')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getProgressBarWithRectangle(),
                      Center(child: Text('Rectangle marker')),
                    ]),
              ],
      ));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithCircle() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                color: const Color.fromARGB(30, 0, 169, 181),
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
                    gradient: model.isWeb
                        ? null
                        : SweepGradient(colors: <Color>[
                            Color(0xFF00a9b5),
                            Color(0xFFa4edeb)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ])),
                MarkerPointer(
                  value: progressValue,
                  markerType: MarkerType.circle,
                  markerHeight: model.isWeb ? 25 : 20,
                  markerWidth: model.isWeb ? 25 : 20,
                  enableAnimation: true,
                  animationDuration: 30,
                  animationType: AnimationType.linear,
                  color: const Color(0xFF87e8e8),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text(progressValue.toStringAsFixed(0) + '%'))
              ]),
        ]));
  }

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithRectangle() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                color: const Color.fromARGB(30, 0, 169, 181),
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
                    gradient: model.isWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFF00a9b5),
                            Color(0xFFa4edeb)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ])),
                MarkerPointer(
                  value: progressValue,
                  markerType: MarkerType.rectangle,
                  markerHeight: model.isWeb ? 25 : 18,
                  markerWidth: model.isWeb ? 25 : 18,
                  enableAnimation: true,
                  animationDuration: 30,
                  animationType: AnimationType.linear,
                  color: const Color(0xFF87e8e8),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text(progressValue.toStringAsFixed(0) + '%'))
              ]),
        ]));
  }

  /// Returns gradient progress style circular progress bar.
  Widget getProgressBarWithImage() {
    return Container(
        height: _size,
        width: _size,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                color: const Color.fromARGB(30, 0, 169, 181),
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
                    gradient: model.isWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFF00a9b5),
                            Color(0xFFa4edeb)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ])),
                MarkerPointer(
                  value: progressValue,
                  markerType: MarkerType.image,
                  imageUrl: 'images/ball.png',
                  markerHeight: model.isWeb ? 15 : 30,
                  markerWidth: model.isWeb ? 15 : 30,
                  enableAnimation: true,
                  animationDuration: 30,
                  animationType: AnimationType.linear,
                  color: const Color(0xFF87e8e8),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Text(progressValue.toStringAsFixed(0) + '%'))
              ]),
        ]));
  }
}
