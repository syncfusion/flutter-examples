/// Flutter package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge widget pointer sample.
class WidgetPointer extends SampleView {
  /// Creates linear gauge with default and customized widget pointer styles
  const WidgetPointer(Key key) : super(key: key);

  @override
  _WidgetPointerState createState() => _WidgetPointerState();
}

/// State class of linear gauge widget pointer.
class _WidgetPointerState extends SampleViewState {
  _WidgetPointerState();
  double _textWidgetPointerValue = 40;
  double _iconWidgetPointerValue = 30;
  double _iconPointerValue = 20;
  double _textPointerValue = 60;
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
                    child: _buildWidgetPointer(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the linear gauge widget pointer.
  Widget _buildWidgetPointer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHorizontalGauges(
                  'Text widget',
                  _buildTextWidgetPointer(context),
                ),
                _buildHorizontalGauges(
                  'Icon widget',
                  _buildIconWidgetPointer(context),
                ),
                _buildHorizontalGauges(
                  'Multiple widget pointers',
                  _buildMultipleWidgetPointers(context),
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
                      'Text widget',
                      _buildTextWidgetPointer(context),
                    ),
                    _buildVerticalGauges(
                      'Icon widget',
                      _buildIconWidgetPointer(context),
                    ),
                    _buildVerticalGauges(
                      model.isDesktop
                          ? 'Multiple widgets'
                          : 'Multiple widget pointers',
                      _buildMultipleWidgetPointers(context),
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

  /// Returns the text widget pointer sample.
  Widget _buildTextWidgetPointer(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 24),
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: _textWidgetPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                _textWidgetPointerValue = value as double;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xff06589C),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: brightness == Brightness.light
                        ? Colors.grey
                        : Colors.black54,
                    offset: const Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _textWidgetPointerValue.toStringAsFixed(0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: brightness == Brightness.light
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xffF45656),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the icon widget pointer sample.
  Widget _buildIconWidgetPointer(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 24),
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: _iconWidgetPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                _iconWidgetPointerValue = value as double;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xff06589C),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: brightness == Brightness.light
                        ? Colors.grey
                        : Colors.black54,
                    offset: const Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.thumb_up_rounded,
                  size: 20,
                  color: brightness == Brightness.light
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xffF45656),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the multiple widget pointers sample.
  Widget _buildMultipleWidgetPointers(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SizedBox(
      height: _isHorizontalOrientation ? 100 : 300,
      child: SfLinearGauge(
        animateAxis: true,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 24),
        orientation: _isHorizontalOrientation
            ? LinearGaugeOrientation.horizontal
            : LinearGaugeOrientation.vertical,
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: _textPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                _textPointerValue = value as double;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xff06589C),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: brightness == Brightness.light
                        ? Colors.grey
                        : Colors.black54,
                    offset: const Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _textPointerValue.toStringAsFixed(0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: brightness == Brightness.light
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xffF45656),
                  ),
                ),
              ),
            ),
          ),
          LinearWidgetPointer(
            value: _iconPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                _iconPointerValue = value as double;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xff06589C),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: brightness == Brightness.light
                        ? Colors.grey
                        : Colors.black54,
                    offset: const Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.thumb_up_rounded,
                  size: 20,
                  color: brightness == Brightness.light
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xffF45656),
                ),
              ),
            ),
          ),
        ],
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
