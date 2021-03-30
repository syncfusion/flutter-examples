/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge shape pointer sample.
class ShapePointer extends SampleView {
  /// Creates linear gauge with default and customized shape pointer styles
  const ShapePointer(Key key) : super(key: key);

  @override
  _ShapePointerState createState() => _ShapePointerState();
}

/// State class of linear gauge shape pointer.
class _ShapePointerState extends SampleViewState {
  _ShapePointerState();
  double _invertedTrianglePointerValue = 40;
  double _circlePointerValue = 20;
  double _diamondPointerValue = 50;
  double _rectanglePointerValue = 30;
  double _pointerValue = 10;
  double _multiPointerValue = 100;
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
              child: _buildShapePointer(context),
            )
          ]))))
    ]);
  }

  /// Returns the linear gauge with shape pointer.
  Widget _buildShapePointer(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHorizontalGauges(
                    'Inverted triangle', _buildInvertedTriangleShapePointer()),
                _buildHorizontalGauges('Circle', _buildCircleShapePointer()),
                _buildHorizontalGauges('Diamond', _buildDiamondShapePointer()),
                _buildHorizontalGauges(
                    'Rectangle', _buildRectangleShapePointer()),
                _buildHorizontalGauges(
                    'Multiple pointers', _buildMultipleShapePointers()),
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
                    _buildVerticalGauges('Inverted triangle',
                        _buildInvertedTriangleShapePointer()),
                    _buildVerticalGauges('Circle', _buildCircleShapePointer()),
                    _buildVerticalGauges(
                        'Diamond', _buildDiamondShapePointer()),
                    _buildVerticalGauges(
                        'Rectangle', _buildRectangleShapePointer()),
                    _buildVerticalGauges(
                        'Multiple pointers', _buildMultipleShapePointers()),
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

  /// Returns the inverted triangle shape pointer sample.
  Widget _buildInvertedTriangleShapePointer() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
          animateAxis: true,
          orientation: _isHorizontalOrientation
              ? LinearGaugeOrientation.horizontal
              : LinearGaugeOrientation.vertical,
          markerPointers: <LinearShapePointer>[
            LinearShapePointer(
              value: _invertedTrianglePointerValue,
              onValueChanged: (value) => {
                setState(() => {_invertedTrianglePointerValue = value})
              },
            ),
          ],
          barPointers: [
            LinearBarPointer(value: _invertedTrianglePointerValue),
          ],
        ));
  }

  /// Returns the circle shape pointer sample.
  Widget _buildCircleShapePointer() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: <LinearShapePointer>[
              LinearShapePointer(
                  value: _circlePointerValue,
                  onValueChanged: (value) => {
                        setState(() => {_circlePointerValue = value})
                      },
                  shapeType: LinearShapePointerType.circle),
            ],
            barPointers: [
              LinearBarPointer(value: _circlePointerValue),
            ]));
  }

  /// Returns the diamond shape pointer sample.
  Widget _buildDiamondShapePointer() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: <LinearShapePointer>[
              LinearShapePointer(
                  value: _diamondPointerValue,
                  onValueChanged: (value) => {
                        setState(() => {_diamondPointerValue = value})
                      },
                  shapeType: LinearShapePointerType.diamond),
            ],
            barPointers: [
              LinearBarPointer(value: _diamondPointerValue),
            ]));
  }

  /// Returns the rectangle shape pointer sample.
  Widget _buildRectangleShapePointer() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: <LinearShapePointer>[
              LinearShapePointer(
                value: _rectanglePointerValue,
                onValueChanged: (value) => {
                  setState(() => {_rectanglePointerValue = value})
                },
                shapeType: LinearShapePointerType.rectangle,
              ),
            ],
            barPointers: [
              LinearBarPointer(value: _rectanglePointerValue),
            ]));
  }

  /// Returns the multiple shape pointers sample.
  Widget _buildMultipleShapePointers() {
    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: <LinearShapePointer>[
              LinearShapePointer(
                value: _pointerValue,
                onValueChanged: (value) => {
                  setState(() => {_pointerValue = value})
                },
              ),
              LinearShapePointer(
                  value: _multiPointerValue,
                  onValueChanged: (value) => {
                        setState(() => {_multiPointerValue = value})
                      },
                  shapeType: LinearShapePointerType.diamond)
            ],
            barPointers: [
              LinearBarPointer(value: _pointerValue),
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
