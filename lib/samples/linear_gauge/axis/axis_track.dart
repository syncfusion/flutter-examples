/// Flutter package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge axis track sample.
class AxisTrack extends SampleView {
  /// Creates linear gauge with default and customized axis track styles.
  const AxisTrack(Key key) : super(key: key);

  @override
  _AxisTrackState createState() => _AxisTrackState();
}

/// State class of linear gauge axis track.
class _AxisTrackState extends SampleViewState {
  _AxisTrackState();
  double _pointerValue = 70;
  bool _isHorizontalOrientation = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(32.0),
          child: _buildSegmentedView(),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: getScreenWidth(context, _isHorizontalOrientation),
                    child: _buildAxisTrack(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the linear gauge axis track.
  Widget _buildAxisTrack(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              children: <Widget>[
                _buildHorizontalGauges(
                  'Default axis',
                  _buildDefaultAxis(context),
                ),
                _buildHorizontalGauges(
                  'Edge style',
                  _buildEdgeStyleAxis(context),
                ),
                _buildHorizontalGauges(
                  'Inversed axis',
                  _buildInversedAxis(context),
                ),
                _buildHorizontalGauges(
                  'Range color for axis',
                  _buildRangeColorAxis(context),
                ),
                _buildHorizontalGauges(
                  'Axis extent',
                  _buildAxisExtent(context),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Wrap(
                  runSpacing: 30,
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    _buildVerticalGauges(
                      'Default axis',
                      _buildDefaultAxis(context),
                    ),
                    _buildVerticalGauges(
                      'Edge style',
                      _buildEdgeStyleAxis(context),
                    ),
                    _buildVerticalGauges(
                      'Axis extent',
                      _buildAxisExtent(context),
                    ),
                    _buildVerticalGauges(
                      'Range color for axis',
                      _buildRangeColorAxis(context),
                    ),
                    _buildVerticalGauges(
                      'Inversed axis',
                      _buildInversedAxis(context),
                    ),
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
    return SizedBox(
      width: 150,
      child: Column(
        children: <Widget>[
          Text(axisTrackName),
          const SizedBox(height: 16),
          linearGauge,
        ],
      ),
    );
  }

  /// Returns the default axis.
  Widget _buildDefaultAxis(BuildContext context) {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the edge style axis.
  Widget _buildEdgeStyleAxis(BuildContext context) {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        axisTrackExtent: 8,
        axisTrackStyle: const LinearAxisTrackStyle(
          thickness: 24,
          edgeStyle: LinearEdgeStyle.bothCurve,
        ),
      ),
    );
  }

  /// Returns the inversed axis.
  Widget _buildInversedAxis(BuildContext context) {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        isAxisInversed: true,
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        barPointers: <LinearBarPointer>[LinearBarPointer(value: _pointerValue)],
        markerPointers: <LinearMarkerPointer>[
          LinearShapePointer(
            value: _pointerValue,
            onChanged: (dynamic value) {
              setState(() {
                _pointerValue = value as double;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Returns the range color axis.
  Widget _buildRangeColorAxis(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        minorTicksPerInterval: 4,
        useRangeColorForAxis: true,
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 1),
        ranges: <LinearGaugeRange>[
          LinearGaugeRange(
            endValue: 33,
            color: brightness == Brightness.light
                ? const Color(0xffF45656)
                : const Color(0xffFF7B7B),
          ),
          const LinearGaugeRange(
            startValue: 33,
            endValue: 66,
            color: Color(0xffFFC93E),
          ),
          const LinearGaugeRange(startValue: 66, color: Color(0xff0DC9AB)),
        ],
      ),
    );
  }

  /// Returns the axis extent.
  Widget _buildAxisExtent(BuildContext context) {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        axisTrackExtent: 20,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        labelOffset: 10,
        minorTicksPerInterval: 0,
        animateAxis: true,
      ),
    );
  }

  /// Returns the segmented view for linear gauge orientation.
  Widget _buildSegmentedView() {
    return Center(
      child: CupertinoSegmentedControl<bool>(
        selectedColor: model.primaryColor,
        borderColor: model.primaryColor,
        children: <bool, Widget>{
          true: Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Horizontal',
              style: TextStyle(
                color: _isHorizontalOrientation ? Colors.white : Colors.black,
              ),
            ),
          ),
          false: Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Vertical',
              style: TextStyle(
                color: _isHorizontalOrientation ? Colors.black : Colors.white,
              ),
            ),
          ),
        },
        onValueChanged: (bool value) => setState(() {
          _isHorizontalOrientation = value;
        }),
        groupValue: _isHorizontalOrientation,
      ),
    );
  }
}
