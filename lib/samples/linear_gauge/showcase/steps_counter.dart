/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge steps counter sample.
class StepsCounter extends SampleView {
  /// Creates the linear gauge steps counter sample.
  const StepsCounter(Key key) : super(key: key);

  @override
  _StepsCounterState createState() => _StepsCounterState();
}

/// State class of steps counter sample.
class _StepsCounterState extends SampleViewState {
  _StepsCounterState();
  final double _pointerValue = 8456;
  String _image = 'images/person_walking.gif';

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('images/person_walking.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              child: _buildStepsCounter(context),
            ),
          )
        : _buildStepsCounter(context);
  }

  /// Returns the steps counter.
  Widget _buildStepsCounter(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: isWebOrDesktop
                ? MediaQuery.of(context).size.width >= 550
                      ? 450
                      : MediaQuery.of(context).size.width * 0.68
                : MediaQuery.of(context).size.width * 0.68,
            child: SfLinearGauge(
              maximum: 12000.0,
              interval: 12000.0,
              animateAxis: true,
              minorTicksPerInterval: 0,
              axisTrackStyle: LinearAxisTrackStyle(
                thickness: 32,
                borderWidth: 1,
                borderColor: brightness == Brightness.dark
                    ? const Color(0xff898989)
                    : Colors.grey[350],
                color: brightness == Brightness.light
                    ? const Color(0xffE8EAEB)
                    : const Color(0xff62686A),
              ),
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: _pointerValue,
                  animationDuration: 3000,
                  thickness: 32,
                  color: const Color(0xff0DC9AB),
                ),
                LinearBarPointer(
                  value: 12000,
                  enableAnimation: false,
                  thickness: 25,
                  offset: isWebOrDesktop
                      ? (MediaQuery.of(context).size.height >= 50 ? 60 : 0)
                      : 60,
                  color: Colors.transparent,
                  position: LinearElementPosition.outside,
                  child: const Text(
                    'Sun, 7 February',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
              markerPointers: <LinearMarkerPointer>[
                LinearWidgetPointer(
                  value: _pointerValue,
                  animationDuration: 2800,
                  onAnimationCompleted: () {
                    setState(() {
                      _image = 'images/person_walking.png';
                    });
                  },
                  position: LinearElementPosition.outside,
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(_image, fit: BoxFit.fitHeight),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 65),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'STEPS',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _pointerValue.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xff0DC9AB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
