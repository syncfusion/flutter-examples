///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

///Render Slider with step interval
class VerticalStepSliderPage extends SampleView {
  ///Render Slider with step interval
  const VerticalStepSliderPage(Key key) : super(key: key);

  @override
  _VerticalStepSliderPageState createState() => _VerticalStepSliderPageState();
}

class _VerticalStepSliderPageState extends SampleViewState {
  _VerticalStepSliderPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _StepSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? slider
          : SingleChildScrollView(
              child: SizedBox(height: 400, child: slider),
            );
    });
  }
}

class _StepSlider extends SampleView {
  @override
  _StepSliderState createState() => _StepSliderState();
}

class _StepSliderState extends SampleViewState {
  DateTime _yearValue = DateTime(2015, 1, 01);
  double _stepSliderValue = 0;

  SfSliderTheme _sliderWithStepDurationCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
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
              _yearValue = values as DateTime;
            });
          },
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.y().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _sliderWithStepCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
            showLabels: true,
            interval: 5,
            min: -10.0,
            max: 10.0,
            stepSize: 5,
            showTicks: true,
            value: _stepSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _stepSliderValue = values as double;
              });
            },
            enableTooltip: true));
  }

  Widget _buildWebLayout() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.height / 10.0;
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: _sliderWithStepCustomization()),
              const Text('Numeric')
            ]),
            Column(children: <Widget>[
              Expanded(child: _sliderWithStepDurationCustomization()),
              const Text('DateTime')
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
