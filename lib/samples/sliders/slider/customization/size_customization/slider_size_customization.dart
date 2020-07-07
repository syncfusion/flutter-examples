import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class SliderSizeCustomizationPage extends SampleView {
  const SliderSizeCustomizationPage(Key key) : super(key: key);

  @override
  _SliderSizeCustomizationPageState createState() =>
      _SliderSizeCustomizationPageState();
}

class _SliderSizeCustomizationPageState extends SampleViewState {
  _SliderSizeCustomizationPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = SfSliderSizeCustomization();
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
class SfSliderSizeCustomization extends SampleView {
  @override
  _SfSliderSizeCustomizationState createState() =>
      _SfSliderSizeCustomizationState();
}

class _SfSliderSizeCustomizationState extends SampleViewState {
  DateTime _yearValue = DateTime(2010, 1, 01);
  double _value = 0.0;

  SfSliderTheme _sliderWithdivisorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeDivisorRadius: 6.0,
            inactiveDivisorRadius: 3.0,
            inactiveDivisorColor: Colors.deepOrangeAccent.withOpacity(0.24),
            activeDivisorColor: Colors.deepOrangeAccent,
            activeTrackColor: Colors.deepOrangeAccent,
            thumbColor: Colors.deepOrangeAccent,
            tooltipBackgroundColor: Colors.deepOrangeAccent,
            inactiveTrackColor: Colors.deepOrangeAccent.withOpacity(0.24),
            overlayColor: Colors.deepOrangeAccent.withOpacity(0.12)),
        child: SfSlider(
          min: DateTime(2000, 01, 01),
          max: DateTime(2020, 01, 01),
          showLabels: true,
          interval: 5,
          stepDuration: const SliderStepDuration(years: 5),
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.onTicks,
          dateIntervalType: DateIntervalType.years,
          showDivisors: true,
          value: _yearValue,
          onChanged: (dynamic values) {
            setState(() {
              _yearValue = values;
            });
          },
          showTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMM().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _sliderWithTrackCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackHeight: 8.0,
            inactiveTrackHeight: 4.0,
            trackCornerRadius: 6.0,
            tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
            showLabels: true,
            interval: 10,
            min: -20.0,
            max: 20.0,
            stepSize: 10,
            value: _value,
            onChanged: (dynamic values) {
              setState(() {
                _value = values;
              });
            },
            showTooltip: true));
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
            title('Active and inactive track height'),
            columnSpacing10,
            _sliderWithTrackCustomization(),
            columnSpacing40,
            title('Active and inactive divisor radius'),
            columnSpacing10,
            _sliderWithdivisorCustomization(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
