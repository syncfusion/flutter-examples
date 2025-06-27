/// Flutter package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge ticks customization sample.
class TickCustomization extends SampleView {
  /// Creates linear gauge with default and customized tick styles.
  const TickCustomization(Key key) : super(key: key);

  @override
  _TickCustomizationState createState() => _TickCustomizationState();
}

/// State class of linear gauge tick customization.
class _TickCustomizationState extends SampleViewState {
  _TickCustomizationState();
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
                    child: _buildLinearTickCustomization(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the linear gauge tick customization.
  Widget _buildLinearTickCustomization(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHorizontalGauges('Outside ticks', _buildOutsideTicks()),
                _buildHorizontalGauges('Cross ticks', _buildCrossTicks()),
                _buildHorizontalGauges('Inside ticks', _buildInsideTicks()),
                _buildHorizontalGauges(
                  'Ticks with offset',
                  _buildTicksWithOffset(),
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
                    _buildVerticalGauges('Outside ticks', _buildOutsideTicks()),
                    _buildVerticalGauges('Cross ticks', _buildCrossTicks()),
                    _buildVerticalGauges('Inside ticks', _buildInsideTicks()),
                    _buildVerticalGauges(
                      'Ticks with offset',
                      _buildTicksWithOffset(),
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

  /// Returns the outside ticks sample.
  Widget _buildOutsideTicks() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        labelPosition: LinearLabelPosition.outside,
        tickPosition: LinearElementPosition.outside,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the cross ticks sample.
  Widget _buildCrossTicks() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        tickPosition: LinearElementPosition.cross,
        labelPosition: LinearLabelPosition.outside,
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the inside ticks sample.
  Widget _buildInsideTicks() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the ticks with offset sample.
  Widget _buildTicksWithOffset() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        tickOffset: 20,
        labelOffset: 20,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
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
