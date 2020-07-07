import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class SliderColorCustomizationPage extends SampleView {
  const SliderColorCustomizationPage(Key key) : super(key: key);

  @override
  _SliderColorCustomizationPageState createState() =>
      _SliderColorCustomizationPageState();
}

class _SliderColorCustomizationPageState extends SampleViewState {
  _SliderColorCustomizationPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = SliderColorCustomization();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? slider
        : SingleChildScrollView(
            child: Container(height: 325, child: slider),
          );
  }
}

// ignore: must_be_immutable
class SliderColorCustomization extends SampleView {
  @override
  _SliderColorCustomizationState createState() =>
      _SliderColorCustomizationState();
}

class _SliderColorCustomizationState extends SampleViewState {
  double _trackSliderValue = 0;
  double _thumbStrokeSliderValue = 50;

  SfSliderTheme _sliderWithTrackColorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackColor: Colors.teal,
            inactiveTrackColor: Colors.teal.withOpacity(0.24),
            thumbColor: Colors.teal,
            activeTrackHeight: 5.0,
            inactiveTrackHeight: 5.0,
            tooltipBackgroundColor: Colors.teal,
            overlayColor: Colors.teal.withOpacity(0.24)),
        child: SfSlider(
            showLabels: true,
            showTicks: true,
            interval: 25,
            min: -50.0,
            max: 50.0,
            value: _trackSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _trackSliderValue = values;
              });
            },
            showTooltip: true,
            numberFormat: NumberFormat('#')));
  }

  SfSliderTheme _sliderWithThumbStrokeColorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackHeight: 5.0,
            inactiveTrackHeight: 5.0,
            inactiveDivisorColor: kIsWeb ? model.webBackgroundColor: model.cardThemeColor,
            activeDivisorColor: kIsWeb ? model.webBackgroundColor: model.cardThemeColor,
            activeDivisorStrokeWidth: 2,
            activeDivisorStrokeColor: Colors.deepOrange.withOpacity(0.24),
            inactiveDivisorStrokeWidth: 2,
            inactiveDivisorStrokeColor: Colors.deepOrange,
            activeDivisorRadius: 5.0,
            inactiveDivisorRadius: 5.0,
            activeTrackColor: Colors.deepOrange,
            inactiveTrackColor: Colors.deepOrange.withOpacity(0.24),
            overlayColor: Colors.deepOrange.withOpacity(0.12),
            thumbColor: kIsWeb ? model.webBackgroundColor: model.cardThemeColor,
            thumbStrokeWidth: 2.0,
            tooltipBackgroundColor: Colors.deepOrange,
            thumbStrokeColor: Colors.deepOrange),
        child: SfSlider(
            interval: 25,
            showDivisors: true,
            min: 0.0,
            max: 100.0,
            value: _thumbStrokeSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _thumbStrokeSliderValue = values;
              });
            },
            showTooltip: true,
            numberFormat: NumberFormat('#')));
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
            title('Active and inactive track color'),
            columnSpacing10,
            _sliderWithTrackColorCustomization(),
            columnSpacing40,
            title('Thumb and divisor stroke color'),
            columnSpacing10,
            _sliderWithThumbStrokeColorCustomization(),
            columnSpacing30,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
