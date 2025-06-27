import 'package:flutter/cupertino.dart';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge labels customization sample.
class GaugeLabelCustomization extends SampleView {
  /// Creates Linear Gauge with default and customized label styles
  const GaugeLabelCustomization(Key key) : super(key: key);

  @override
  _GaugeLabelCustomizationState createState() =>
      _GaugeLabelCustomizationState();
}

/// State class of linear gauge label customization.
class _GaugeLabelCustomizationState extends SampleViewState {
  _GaugeLabelCustomizationState();

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
                    width: isWebOrDesktop
                        ? MediaQuery.of(context).size.width >= 1000
                              ? _isHorizontalOrientation
                                    ? MediaQuery.of(context).size.width / 3
                                    : MediaQuery.of(context).size.width
                              : 440
                        : MediaQuery.of(context).size.width,
                    child: _buildLabelCustomization(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the linear gauge label customization.
  Widget _buildLabelCustomization(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHorizontalGauges('Custom labels', _buildCustomLabels()),
                _buildHorizontalGauges(
                  'Label offset',
                  _buildLabelsWithOffset(),
                ),
                _buildHorizontalGauges(
                  'Text labels',
                  _buildTextLabels(context),
                ),
                _buildHorizontalGauges(
                  'Label style customization',
                  _buildLabelStyleCustomization(context),
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
                    _buildVerticalGauges('Custom labels', _buildCustomLabels()),
                    _buildVerticalGauges(
                      'Text labels',
                      _buildTextLabels(context),
                    ),
                    _buildVerticalGauges(
                      'Label offset',
                      _buildLabelsWithOffset(),
                    ),
                    _buildVerticalGauges(
                      'Label style customization',
                      _buildLabelStyleCustomization(context),
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

  /// Returns the custom labels sample.
  Widget _buildCustomLabels() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        onGenerateLabels: () {
          return <LinearAxisLabel>[
            const LinearAxisLabel(text: r'$5', value: 0),
            const LinearAxisLabel(text: r'$10', value: 10),
            const LinearAxisLabel(text: r'$15', value: 20),
            const LinearAxisLabel(text: r'$20', value: 30),
          ];
        },
        maximum: 30,
        animateAxis: true,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the text labels sample.
  Widget _buildTextLabels(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    const double deliveryStatus = 20;
    const double orderState = 0;
    const double packedState = 10;
    const double shippedState = 20;
    const double deliveredState = 30;
    const Color activeColor = deliveryStatus > orderState
        ? Color(0xff0DC9AB)
        : Color(0xffD1D9DD);
    final Color inactiveColor = brightness == Brightness.dark
        ? const Color(0xff62686A)
        : const Color(0xFFD1D9DD);

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        maximum: 30,
        labelOffset: 24,
        isAxisInversed: !_isHorizontalOrientation,
        showTicks: false,
        onGenerateLabels: () {
          return <LinearAxisLabel>[
            const LinearAxisLabel(text: 'Ordered', value: 0),
            const LinearAxisLabel(text: 'Packed', value: 10),
            const LinearAxisLabel(text: 'Shipped', value: 20),
            const LinearAxisLabel(text: 'Delivered', value: 30),
          ];
        },
        axisTrackStyle: LinearAxisTrackStyle(color: inactiveColor),
        barPointers: const <LinearBarPointer>[
          LinearBarPointer(
            value: deliveryStatus,
            color: activeColor,
            enableAnimation: false,
          ),
        ],
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: orderState,
            enableAnimation: false,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: model.homeCardColor,
                border: Border.all(width: 4, color: activeColor),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, size: 14, color: activeColor),
              ),
            ),
          ),
          LinearWidgetPointer(
            enableAnimation: false,
            value: packedState,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: model.homeCardColor,
                border: Border.all(width: 4, color: activeColor),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, size: 14, color: activeColor),
              ),
            ),
          ),
          LinearWidgetPointer(
            value: shippedState,
            enableAnimation: false,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: model.homeCardColor,
                border: Border.all(width: 4, color: activeColor),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, size: 14, color: activeColor),
              ),
            ),
          ),
          LinearShapePointer(
            value: deliveredState,
            enableAnimation: false,
            color: inactiveColor,
            width: 24,
            height: 24,
            position: LinearElementPosition.cross,
            shapeType: LinearShapePointerType.circle,
          ),
        ],
      ),
    );
  }

  /// Returns the labels with offset sample.
  Widget _buildLabelsWithOffset() {
    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        labelOffset: 16,
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
      ),
    );
  }

  /// Returns the label style customization sample.
  Widget _buildLabelStyleCustomization(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        axisLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: brightness == Brightness.dark
              ? const Color(0xff8580FF)
              : const Color(0xff6F20F0),
        ),
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
