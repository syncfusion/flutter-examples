import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class DefaultSliderPage extends SampleView {
  const DefaultSliderPage(Key key) : super(key: key);

  @override
  _DefaultSliderPageState createState() => _DefaultSliderPageState();
}

class _DefaultSliderPageState extends SampleViewState {
  _DefaultSliderPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = DefaultSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? slider
        : SingleChildScrollView(
            child: Container(height: 300, child: slider),
          );
  }
}

// ignore: must_be_immutable
class DefaultSlider extends SampleView {
  @override
  _DefaultSliderState createState() => _DefaultSliderState();
}

class _DefaultSliderState extends SampleViewState {
  final double _inactiveSliderValue = 50.0;
  double _activeSliderValue = 50.0;

  SfSlider _inactiveSlider() {
    //ignore: missing_required_param
    return SfSlider(min: 0.0, max: 100.0, value: _inactiveSliderValue);
  }

  SfSliderTheme _activeSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
          min: 0.0,
          max: 100.0,
          onChanged: (dynamic values) {
            setState(() {
              _activeSliderValue = values;
            });
          },
          value: _activeSliderValue,
          showTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
  }

  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    final double padding = MediaQuery
        .of(context)
        .size
        .width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title('Enabled'),
            _activeSlider(),
            columnSpacing40,
            title('Disabled'),
            _inactiveSlider(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
