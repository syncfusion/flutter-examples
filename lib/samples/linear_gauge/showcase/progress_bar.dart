/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the progress bar showcase sample.
class ProgressBar extends SampleView {
  /// Creates the progress bar showcase sample.
  const ProgressBar(Key key) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

/// State class of progress bar sample.
class _ProgressBarState extends SampleViewState {
  _ProgressBarState();

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
              child: _buildProgressBar(context),
            ))
        : _buildProgressBar(context);
  }

  /// Returns the progress bar.
  Widget _buildProgressBar(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;
    const double _progressvalue = 41.467;

    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      height: 30,
                      child: SfLinearGauge(
                        orientation: LinearGaugeOrientation.horizontal,
                        minimum: 0.0,
                        maximum: 100.0,
                        showTicks: false,
                        showLabels: false,
                        animateAxis: true,
                        axisTrackStyle: LinearAxisTrackStyle(
                          thickness: 30,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          borderWidth: 1,
                          borderColor: _brightness == Brightness.dark
                              ? const Color(0xff898989)
                              : Colors.grey[350],
                          color: _brightness == Brightness.dark
                              ? Colors.transparent
                              : Colors.grey[350],
                        ),
                        barPointers: const <LinearBarPointer>[
                          LinearBarPointer(
                              value: _progressvalue,
                              thickness: 30,
                              edgeStyle: LinearEdgeStyle.bothCurve,
                              color: Colors.blue),
                        ],
                      ))))),
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                _progressvalue.toStringAsFixed(2) + '%',
                style: const TextStyle(fontSize: 14, color: Color(0xffFFFFFF)),
              ))),
    ]);
  }
}
