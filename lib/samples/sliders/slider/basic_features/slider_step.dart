import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class StepSliderPage extends SampleView {
  const StepSliderPage(Key key) : super(key: key);

  @override
  _StepSliderPageState createState() => _StepSliderPageState();
}

class _StepSliderPageState extends SampleViewState {
  _StepSliderPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = StepSlider();
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
class StepSlider extends SampleView {
  @override
  _StepSliderState createState() => _StepSliderState();
}

class _StepSliderState extends SampleViewState {
  DateTime _yearValue = DateTime(2015, 1, 01);
  double _stepSliderValue = 0;

  SfSliderTheme _sliderWithStepDurationCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
          min: DateTime(2010, 01, 01),
          max: DateTime(2020, 01, 01),
          showLabels: true,
          interval: 2,
          stepDuration: const SliderStepDuration(years: 2),
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.onTicks,
          dateIntervalType: DateIntervalType.years,
          showTicks: true,
          value: _yearValue,
          onChanged: (dynamic values) {
            setState(() {
              _yearValue = values;
            });
          },
          showTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.y().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _sliderWithStepCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
            showLabels: true,
            interval: 5,
            min: -10.0,
            max: 10.0,
            stepSize: 5,
            showTicks: true,
            value: _stepSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _stepSliderValue = values;
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
            title('Numeric'),
            columnSpacing10,
            _sliderWithStepCustomization(),
            columnSpacing40,
            title('Date'),
            columnSpacing10,
            _sliderWithStepDurationCustomization(),
            columnSpacing40
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
