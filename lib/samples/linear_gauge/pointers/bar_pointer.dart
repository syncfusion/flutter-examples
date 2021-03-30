/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge bar pointer sample.
class BarPointer extends SampleView {
  /// Creates linear gauge with default and customized bar pointer styles.
  const BarPointer(Key key) : super(key: key);

  @override
  _BarPointerState createState() => _BarPointerState();
}

/// State class of linear gauge bar pointer.
class _BarPointerState extends SampleViewState {
  _BarPointerState();
  bool _isHorizontalOrientation = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(margin: EdgeInsets.all(32.0), child: _buildSegmentedView()),
      Expanded(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            Container(
              width: getScreenWidth(context, _isHorizontalOrientation),
              child: _buildBarPointer(context),
            )
          ]))))
    ]);
  }

  /// Returns the linear gauge bar pointer.
  Widget _buildBarPointer(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHorizontalGauges(
                    'Outside', _buildBarPointerOutsideAxis()),
                _buildHorizontalGauges('Cross', _buildBarPointerCrossAxis()),
                _buildHorizontalGauges('Inside', _buildBarPointerInsideAxis()),
                _buildHorizontalGauges(
                    'Gradient shader', _buildBarPointerWithShader()),
                _buildHorizontalGauges('Multiple bar pointers',
                    _buildMultipleBarPointers(context)),
              ],
            )
          : Column(
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 30,
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildVerticalGauges(
                        'Outside', _buildBarPointerOutsideAxis()),
                    _buildVerticalGauges('Cross', _buildBarPointerCrossAxis()),
                    _buildVerticalGauges(
                        'Inside', _buildBarPointerInsideAxis()),
                    _buildVerticalGauges(
                        'Gradient shader', _buildBarPointerWithShader()),
                    _buildVerticalGauges('Multiple bar pointers',
                        _buildMultipleBarPointers(context)),
                  ],
                ),
              ],
            ),
    );
  }

  /// Returns the horizontal axis track.
  Widget _buildHorizontalGauges(String axisTrackName, Widget linearGauge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(axisTrackName),
        linearGauge,
        SizedBox(height: 10),
      ],
    );
  }

  /// Returns the vertical axis track.
  Widget _buildVerticalGauges(String axisTrackName, Widget linearGauge) {
    return Container(
        width: 150,
        child: Column(
          children: [Text(axisTrackName), SizedBox(height: 16), linearGauge],
        ));
  }

  /// Returns the outside axis bar pointer.
  Widget _buildBarPointerOutsideAxis() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                  value: 70, position: LinearElementPosition.outside)
            ]));
  }

  /// Returns the cross axis bar pointer.
  Widget _buildBarPointerCrossAxis() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          barPointers: [LinearBarPointer(value: 70)],
        ));
  }

  /// Returns the inside axis bar pointer.
  Widget _buildBarPointerInsideAxis() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: 70,
                position: LinearElementPosition.inside,
              )
            ]));
  }

  /// Returns the bar pointer with shader.
  Widget _buildBarPointerWithShader() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: 70,
                offset: 5,
                shaderCallback: (bounds) {
                  return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green, Colors.blue]).createShader(bounds);
                },
                position: LinearElementPosition.outside,
                edgeStyle: LinearEdgeStyle.bothCurve,
              )
            ]));
  }

  /// Returns the multiple bar pointers.
  Widget _buildMultipleBarPointers(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            animateAxis: true,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: 10,
                position: LinearElementPosition.inside,
                color: _brightness == Brightness.light
                    ? Color(0xffF45656)
                    : Color(0xffFF7B7B),
              ),
              LinearBarPointer(
                value: 70,
                position: LinearElementPosition.outside,
              ),
            ]));
  }

  /// Returns the segmented view for linear gauge orientation.
  Widget _buildSegmentedView() {
    return Center(
        child: CupertinoSegmentedControl(
            selectedColor: model.backgroundColor,
            borderColor: model.backgroundColor,
            children: {
              true: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Horizontal',
                    style: TextStyle(
                        color: _isHorizontalOrientation
                            ? Colors.white
                            : Colors.black),
                  )),
              false: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Vertical',
                    style: TextStyle(
                        color: _isHorizontalOrientation
                            ? Colors.black
                            : Colors.white),
                  )),
            },
            onValueChanged: (bool value) =>
                setState(() => {_isHorizontalOrientation = value}),
            groupValue: _isHorizontalOrientation));
  }
}
