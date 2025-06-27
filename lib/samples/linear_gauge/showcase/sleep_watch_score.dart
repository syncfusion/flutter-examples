import 'package:flutter/foundation.dart';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge sleep watch showcase sample.
class SleepWatch extends SampleView {
  /// Creates the linear gauge sleep watch showcase sample.
  const SleepWatch(Key key) : super(key: key);

  @override
  _SleepWatchState createState() => _SleepWatchState();
}

/// State class of sleep watch showcase sample.
class _SleepWatchState extends SampleViewState {
  _SleepWatchState();

  double _todayValue = 280;
  double _overallValue = 410;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width:
                    (defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.iOS)
                    ? 54
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _todayValue.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 26,
                        color: _todayValue < 200
                            ? Colors.red
                            : _todayValue < 300
                            ? Colors.amber
                            : _todayValue < 400
                            ? const Color(0xffFB7D55)
                            : const Color(0xff0DC9AB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isWebOrDesktop
                    ? MediaQuery.of(context).size.width >= 550
                          ? 450
                          : MediaQuery.of(context).size.width * 0.68
                    : MediaQuery.of(context).size.width * 0.70,
                child: SfLinearGauge(
                  minimum: 100.0,
                  maximum: 500.0,
                  interval: 50.0,
                  animateAxis: true,
                  animateRange: true,
                  showLabels: false,
                  showTicks: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 15,
                    color: brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  markerPointers: <LinearMarkerPointer>[
                    LinearShapePointer(
                      value: _todayValue,
                      onChanged: (dynamic value) {
                        setState(() {
                          _todayValue = value as double;
                        });
                      },
                      height: 20,
                      width: 20,
                      color: _todayValue < 200
                          ? Colors.red
                          : _todayValue < 300
                          ? Colors.amber
                          : _todayValue < 400
                          ? const Color(0xffFB7D55)
                          : const Color(0xff0DC9AB),
                      position: LinearElementPosition.cross,
                      shapeType: LinearShapePointerType.circle,
                    ),
                    const LinearWidgetPointer(
                      value: 150,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Poor', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 250,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Fair', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 350,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Good', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 450,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Excellent', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  ranges: const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 100.0,
                      endValue: 200,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Colors.red,
                    ),
                    LinearGaugeRange(
                      startValue: 200.0,
                      endValue: 300,
                      startWidth: 8,
                      position: LinearElementPosition.cross,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                      startValue: 300.0,
                      endValue: 400,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Color(0xffFB7D55),
                    ),
                    LinearGaugeRange(
                      startValue: 400.0,
                      endValue: 500,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Color(0xff0DC9AB),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width:
                    (defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.iOS)
                    ? 54
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'OVERALL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _overallValue.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 26,
                        color: _overallValue < 200
                            ? Colors.red
                            : _overallValue < 300
                            ? Colors.amber
                            : _overallValue < 400
                            ? const Color(0xffFB7D55)
                            : const Color(0xff0DC9AB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isWebOrDesktop
                    ? MediaQuery.of(context).size.width >= 550
                          ? 450
                          : MediaQuery.of(context).size.width * 0.68
                    : MediaQuery.of(context).size.width * 0.70,
                child: SfLinearGauge(
                  minimum: 100.0,
                  maximum: 500.0,
                  interval: 50.0,
                  animateAxis: true,
                  animateRange: true,
                  showTicks: false,
                  showLabels: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 15,
                    color: brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  markerPointers: <LinearMarkerPointer>[
                    LinearShapePointer(
                      value: _overallValue,
                      onChanged: (dynamic value) {
                        setState(() {
                          _overallValue = value as double;
                        });
                      },
                      height: 20,
                      width: 20,
                      color: _overallValue < 200
                          ? Colors.red
                          : _overallValue < 300
                          ? Colors.amber
                          : _overallValue < 400
                          ? const Color(0xffFB7D55)
                          : const Color(0xff0DC9AB),
                      position: LinearElementPosition.cross,
                      shapeType: LinearShapePointerType.circle,
                    ),
                    const LinearWidgetPointer(
                      value: 150,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Poor', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 250,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Fair', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 350,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Good', style: TextStyle(fontSize: 12)),
                    ),
                    const LinearWidgetPointer(
                      value: 450,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text('Excellent', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  ranges: const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 100.0,
                      endValue: 200,
                      startWidth: 8,
                      midWidth: 8,
                      position: LinearElementPosition.cross,
                      endWidth: 8,
                      color: Colors.red,
                    ),
                    LinearGaugeRange(
                      startValue: 200.0,
                      endValue: 300,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                      startValue: 300.0,
                      endValue: 400,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Color(0xffFB7D55),
                    ),
                    LinearGaugeRange(
                      startValue: 400.0,
                      endValue: 500,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Color(0xff0DC9AB),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
