/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge range customization sample.
class RangeCustomization extends SampleView {
  /// Creates linear gauge with default and customized range styles
  const RangeCustomization(Key key) : super(key: key);

  @override
  _RangeCustomizationState createState() => _RangeCustomizationState();
}

/// State class of linear gauge range customization.
class _RangeCustomizationState extends SampleViewState {
  bool _isHorizontalOrientation = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: const EdgeInsets.all(32.0), child: _buildSegmentedView()),
      Expanded(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
            Container(
              width: getScreenWidth(context, _isHorizontalOrientation),
              child: _buildRange(context),
            )
          ]))))
    ]);
  }

  /// Returns the linear gauge range.
  Widget _buildRange(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHorizontalGauges('Default', _buildDefaultRange()),
                _buildHorizontalGauges(
                    'Exponential', _buildExponentialRange(context)),
                _buildHorizontalGauges('Concave', _buildConcaveRange(context)),
                _buildHorizontalGauges(
                    'Gradient shader', _buildRangeShader(context)),
                _buildHorizontalGauges(
                    'Multiple ranges', _buildMultipleRanges(context)),
              ],
            )
          : Column(
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 30,
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    _buildVerticalGauges('Default', _buildDefaultRange()),
                    _buildVerticalGauges(
                        'Exponential', _buildExponentialRange(context)),
                    _buildVerticalGauges(
                        'Concave', _buildConcaveRange(context)),
                    _buildVerticalGauges(
                        'Gradient shader', _buildRangeShader(context)),
                    _buildVerticalGauges(
                        'Multiple ranges', _buildMultipleRanges(context)),
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
      children: <Widget>[
        Text(axisTrackName),
        linearGauge,
        const SizedBox(height: 10),
      ],
    );
  }

  /// Returns the vertical axis track.
  Widget _buildVerticalGauges(String axisTrackName, Widget linearGauge) {
    return Container(
      width: 150,
      child: Column(
        children: <Widget>[
          Text(axisTrackName),
          const SizedBox(height: 16),
          linearGauge
        ],
      ),
    );
  }

  /// Returns the default range sample.
  Widget _buildDefaultRange() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          animateRange: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          ranges: const <LinearGaugeRange>[LinearGaugeRange()],
        ));
  }

  /// Returns the exponential range sample.
  Widget _buildExponentialRange(BuildContext context) {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          animateRange: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          ranges: const <LinearGaugeRange>[
            LinearGaugeRange(
                startValue: 0.0,
                midValue: 50.0,
                endValue: 100,
                startWidth: 0,
                midWidth: 10,
                endWidth: 50),
          ],
        ));
  }

  /// Returns the concave range sample.
  Widget _buildConcaveRange(BuildContext context) {
    return Container(
        height: _isHorizontalOrientation ? 120 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          animateRange: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          ranges: const <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: 0.0,
              midValue: 50.0,
              endValue: 100,
              startWidth: 70,
              midWidth: -20,
              endWidth: 70,
              rangeShapeType: LinearRangeShapeType.curve,
            ),
          ],
        ));
  }

  /// Returns the range shader sample.
  Widget _buildRangeShader(BuildContext context) {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          animateRange: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: 0.0,
              midValue: 50.0,
              endValue: 100,
              startWidth: 40,
              midWidth: 40,
              endWidth: 40,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                    begin: _isHorizontalOrientation
                        ? Alignment.centerLeft
                        : Alignment.topCenter,
                    end: _isHorizontalOrientation
                        ? Alignment.centerRight
                        : Alignment.bottomCenter,
                    colors: const <Color>[
                      Color(0xff42C09A),
                      Color(0xffE8DA5D),
                      Color(0xffFB7D55),
                    ],
                    stops: const <double>[
                      0.1,
                      0.4,
                      0.8
                    ]).createShader(bounds);
              },
            ),
          ],
        ));
  }

  /// Returns the multiple ranges sample.
  Widget _buildMultipleRanges(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;

    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          minimum: 0,
          maximum: 100,
          animateAxis: true,
          animateRange: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: 0.0,
              endValue: 30,
              startWidth: 40,
              midWidth: 40,
              endWidth: 40,
              child: Container(
                  color: _brightness == Brightness.light
                      ? const Color(0xffF45656)
                      : const Color(0xffFF7B7B)),
            ),
            LinearGaugeRange(
              startValue: 30.0,
              endValue: 65,
              startWidth: 40,
              midWidth: 40,
              endWidth: 40,
              child: Container(
                  color: _brightness == Brightness.light
                      ? const Color(0xffFFC93E)
                      : const Color(0xffFFC93E)),
            ),
            LinearGaugeRange(
              startValue: 65.0,
              endValue: 100,
              startWidth: 40,
              midWidth: 40,
              endWidth: 40,
              child: Container(
                  color: _brightness == Brightness.light
                      ? const Color(0xff0DC9AB)
                      : const Color(0xff0DC9AB)),
            ),
            LinearGaugeRange(
              startValue: 0,
              endValue: 30,
              startWidth: 40,
              endWidth: 40,
              color: Colors.transparent,
              child: RotatedBox(
                  quarterTurns: _isHorizontalOrientation ? 0 : 3,
                  child: Container(
                      child: const Center(
                          child: Text(
                    'Bad',
                    style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff191A1B)),
                  )))),
            ),
            LinearGaugeRange(
              startValue: 30,
              endValue: 65,
              startWidth: 40,
              endWidth: 40,
              color: Colors.transparent,
              child: RotatedBox(
                  quarterTurns: _isHorizontalOrientation ? 0 : 3,
                  child: Container(
                      height: 20,
                      child: const Center(
                          child: Text(
                        'Good',
                        style: TextStyle(
                            fontFamily: 'Roboto-Medium',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191A1B)),
                      )))),
            ),
            LinearGaugeRange(
              startValue: 65,
              endValue: 100,
              startWidth: 40,
              endWidth: 40,
              color: Colors.transparent,
              child: RotatedBox(
                  quarterTurns: _isHorizontalOrientation ? 0 : 3,
                  child: Container(
                      height: 20,
                      child: const Center(
                          child: Text(
                        'Excellent',
                        style: TextStyle(
                            fontFamily: 'Roboto-Medium',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191A1B)),
                      )))),
            )
          ],
        ));
  }

  /// Returns the segmented view for linear gauge orientation.
  Widget _buildSegmentedView() {
    return Center(
        child: CupertinoSegmentedControl<bool>(
            selectedColor: model.backgroundColor,
            borderColor: model.backgroundColor,
            children: <bool, Widget>{
              true: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Horizontal',
                    style: TextStyle(
                        color: _isHorizontalOrientation
                            ? Colors.white
                            : Colors.black),
                  )),
              false: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Vertical',
                    style: TextStyle(
                        color: _isHorizontalOrientation
                            ? Colors.black
                            : Colors.white),
                  )),
            },
            onValueChanged: (bool value) => setState(() {
                  _isHorizontalOrientation = value;
                }),
            groupValue: _isHorizontalOrientation));
  }
}
