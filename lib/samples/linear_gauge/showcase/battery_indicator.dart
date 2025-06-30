/// Flutter package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge battery indicator showcase sample.
class BatteryIndicator extends SampleView {
  /// Creates the linear gauge battery indicator showcase sample.
  const BatteryIndicator(Key key) : super(key: key);

  @override
  _BatteryIndicatorState createState() => _BatteryIndicatorState();
}

/// State class of battery indicator showcase sample.
class _BatteryIndicatorState extends SampleViewState {
  _BatteryIndicatorState();

  final double _minimum = 0;
  final double _maximum = 100;
  final double _batteryPercentage = 75;

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
              child: _buildBatteryIndicator(context),
            ),
          )
        : Center(child: _buildBatteryIndicator(context));
  }

  /// Returns the battery indicator.
  Widget _buildBatteryIndicator(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    final Color? fillColor = _batteryPercentage <= 25
        ? const Color(0xffF45656)
        : _batteryPercentage <= 50
        ? const Color(0xffFFC93E)
        : Colors.green[400];
    return SizedBox(
      width: 145,
      child: SfLinearGauge(
        minimum: _minimum,
        maximum: _maximum,
        showLabels: false,
        showTicks: false,
        tickPosition: LinearElementPosition.cross,
        majorTickStyle: const LinearTickStyle(color: Colors.green, length: 20),
        minorTickStyle: const LinearTickStyle(color: Colors.red, length: 10),
        axisTrackStyle: const LinearAxisTrackStyle(
          thickness: 1,
          color: Colors.transparent,
        ),
        ranges: <LinearGaugeRange>[
          LinearGaugeRange(
            startValue: _minimum,
            startWidth: 70,
            endWidth: 70,
            color: Colors.transparent,
            endValue: _maximum - 2,
            position: LinearElementPosition.cross,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: brightness == Brightness.light
                      ? const Color(0xffAAAAAA)
                      : const Color(0xff4D4D4D),
                  width: 4,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          LinearGaugeRange(
            startValue: _minimum + 5,
            startWidth: 55,
            endWidth: 55,
            endValue: _batteryPercentage < _maximum / 4
                ? _batteryPercentage
                : _maximum / 4,
            position: LinearElementPosition.cross,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          LinearGaugeRange(
            startValue: _batteryPercentage >= (_maximum / 4 + 2)
                ? (_maximum / 4 + 2)
                : _minimum + 5,
            endValue: _batteryPercentage < (_maximum / 4 + 2)
                ? _minimum + 5
                : _batteryPercentage <= _maximum / 2
                ? _batteryPercentage
                : _maximum / 2,
            startWidth: 55,
            endWidth: 55,
            position: LinearElementPosition.cross,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          LinearGaugeRange(
            startValue: _batteryPercentage >= (_maximum / 2 + 2)
                ? (_maximum / 2 + 2)
                : _minimum + 5,
            endValue: _batteryPercentage < (_maximum / 2 + 2)
                ? _minimum + 5
                : _batteryPercentage <= (_maximum * 3 / 4)
                ? _batteryPercentage
                : (_maximum * 3 / 4),
            startWidth: 55,
            endWidth: 55,
            position: LinearElementPosition.cross,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          LinearGaugeRange(
            startValue: _batteryPercentage >= (_maximum * 3 / 4 + 2)
                ? (_maximum * 3 / 4 + 2)
                : _minimum + 5,
            endValue: _batteryPercentage < (_maximum * 3 / 4 + 2)
                ? _minimum + 5
                : _batteryPercentage < _maximum
                ? _batteryPercentage
                : _maximum - 7,
            startWidth: 55,
            endWidth: 55,
            position: LinearElementPosition.cross,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: _maximum,
            enableAnimation: false,
            markerAlignment: LinearMarkerAlignment.start,
            child: Container(
              height: 38,
              width: 16,
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? Colors.transparent
                    : const Color(0xff232323),
                border: Border.all(
                  color: brightness == Brightness.light
                      ? const Color(0xffAAAAAA)
                      : const Color(0xff4D4D4D),
                  width: 4,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
            ),
          ),
        ],
        barPointers: <LinearBarPointer>[
          LinearBarPointer(
            value: 100,
            thickness: 30,
            position: LinearElementPosition.outside,
            offset: 50,
            enableAnimation: false,
            color: Colors.transparent,
            child: Center(
              child: Text(
                'Charged: ' + _batteryPercentage.toStringAsFixed(0) + '%',
                style: TextStyle(
                  fontSize:
                      (defaultTargetPlatform == TargetPlatform.macOS ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                      ? 18
                      : 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
