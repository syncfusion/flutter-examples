/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge battery indicator showcase sample.
class IdleHours extends SampleView {
  /// Creates the linear gauge battery indicator showcase sample.
  const IdleHours(Key key) : super(key: key);

  @override
  _IdleHoursState createState() => _IdleHoursState();
}

/// State class of battery indicator showcase sample.
class _IdleHoursState extends SampleViewState {
  _IdleHoursState();

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 350 : 240,
              child: _buildIdleHours(context),
            ),
          )
        : _buildIdleHours(context);
  }

  Widget _buildIdleHours(BuildContext context) {
    return Center(
      child: SfLinearGauge(
        showTicks: false,
        interval: 30,
        labelOffset: 0,
        axisTrackStyle: const LinearAxisTrackStyle(
          thickness: 100,
          color: Colors.transparent,
        ),
        labelFormatterCallback: (String label) {
          if (label == '0') {
            return '00:00';
          }

          if (label == '30') {
            return '06:00';
          }

          if (label == '60') {
            return '12:00';
          }

          if (label == '90') {
            return '18:00';
          }

          if (label == '100') {
            return '';
          }

          return label;
        },
        markerPointers: List<LinearWidgetPointer>.generate(
          24,
          (int index) => index % 3 == 0
              ? _buildLinearWidgetPointer(index * 4, Colors.lightBlue.shade900)
              : _buildLinearWidgetPointer(index * 4, Colors.lightBlue),
        ),
      ),
    );
  }

  LinearWidgetPointer _buildLinearWidgetPointer(double value, Color color) {
    return LinearWidgetPointer(
      value: value,
      child: Container(
        height: 96,
        width: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
      ),
    );
  }
}
