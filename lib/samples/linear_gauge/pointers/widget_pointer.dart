/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
              child: _buildWidgetPointer(context),
            )
          ]))))
    ]);
  }

  /// Returns the linear gauge widget pointer.
  Widget _buildWidgetPointer(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: _isHorizontalOrientation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHorizontalGauges(
                    'Text widget', _buildTextWidgetPointer(context)),
                _buildHorizontalGauges(
                    'Icon widget', _buildIconWidgetPointer(context)),
                _buildHorizontalGauges('Multiple widget pointers',
                    _buildMultipleWidgetPointers(context)),
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
                        'Text widget', _buildTextWidgetPointer(context)),
                    _buildVerticalGauges(
                        'Icon widget', _buildIconWidgetPointer(context)),
                    _buildVerticalGauges('Multiple widget pointers',
                        _buildMultipleWidgetPointers(context)),
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
      ),
    );
  }

  /// Returns the text widget pointer sample.
  Widget _buildTextWidgetPointer(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;

    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            axisTrackStyle: LinearAxisTrackStyle(thickness: 24),
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: [
              LinearWidgetPointer(
                value: _textWidgetPointerValue,
                onValueChanged: (value) => {
                  setState(() => {_textWidgetPointerValue = value})
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: _brightness == Brightness.dark
                            ? Color(0xFFFFFFFF)
                            : Color(0xff06589C),
                        boxShadow: [
                          BoxShadow(
                            color: _brightness == Brightness.light
                                ? Colors.grey
                                : Colors.black54,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        shape: BoxShape.circle),
                    child: Center(
                        child: Text(_textWidgetPointerValue.toStringAsFixed(0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _brightness == Brightness.light
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xffF45656),
                            )))),
              )
            ]));
  }

  /// Returns the icon widget pointer sample.
  Widget _buildIconWidgetPointer(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;

    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            axisTrackStyle: LinearAxisTrackStyle(thickness: 24),
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: [
              LinearWidgetPointer(
                value: _iconWidgetPointerValue,
                onValueChanged: (value) => {
                  setState(() => {_iconWidgetPointerValue = value})
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: _brightness == Brightness.dark
                            ? Color(0xFFFFFFFF)
                            : Color(0xff06589C),
                        boxShadow: [
                          BoxShadow(
                            color: _brightness == Brightness.light
                                ? Colors.grey
                                : Colors.black54,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        shape: BoxShape.circle),
                    child: Center(
                        child: Icon(
                      Icons.thumb_up_rounded,
                      size: 20,
                      color: _brightness == Brightness.light
                          ? Color(0xFFFFFFFF)
                          : Color(0xffF45656),
                    ))),
              )
            ]));
  }

  /// Returns the multiple widget pointers sample.
  Widget _buildMultipleWidgetPointers(BuildContext context) {
    final Brightness _brightness = Theme.of(context).brightness;

    return Container(
        height: _isHorizontalOrientation ? 100 : 300,
        child: SfLinearGauge(
            animateAxis: true,
            axisTrackStyle: LinearAxisTrackStyle(thickness: 24),
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            markerPointers: [
              LinearWidgetPointer(
                value: _textPointerValue,
                onValueChanged: (value) => {
                  setState(() => {_textPointerValue = value})
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: _brightness == Brightness.dark
                            ? Color(0xFFFFFFFF)
                            : Color(0xff06589C),
                        boxShadow: [
                          BoxShadow(
                            color: _brightness == Brightness.light
                                ? Colors.grey
                                : Colors.black54,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        shape: BoxShape.circle),
                    child: Center(
                        child: Text(_textPointerValue.toStringAsFixed(0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _brightness == Brightness.light
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xffF45656),
                            )))),
              ),
              LinearWidgetPointer(
                value: _iconPointerValue,
                onValueChanged: (value) => {
                  setState(() => {_iconPointerValue = value})
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: _brightness == Brightness.dark
                            ? Color(0xFFFFFFFF)
                            : Color(0xff06589C),
                        boxShadow: [
                          BoxShadow(
                            color: _brightness == Brightness.light
                                ? Colors.grey
                                : Colors.black54,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        shape: BoxShape.circle),
                    child: Center(
                        child: Icon(
                      Icons.thumb_up_rounded,
                      size: 20,
                      color: _brightness == Brightness.light
                          ? Color(0xFFFFFFFF)
                          : Color(0xffF45656),
                    ))),
              )
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
