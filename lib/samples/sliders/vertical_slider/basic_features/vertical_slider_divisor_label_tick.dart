///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

///Render Slider with customized labels
class VerticalSliderLabelCustomizationPage extends SampleView {
  ///Render Slider with customized labels
  const VerticalSliderLabelCustomizationPage(Key key) : super(key: key);

  @override
  _VerticalSliderLabelCustomizationPageState createState() =>
      _VerticalSliderLabelCustomizationPageState();
}

class _VerticalSliderLabelCustomizationPageState extends SampleViewState {
  _VerticalSliderLabelCustomizationPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _SliderLabelCustomization();
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

class _SliderLabelCustomization extends SampleView {
  @override
  _SliderLabelCustomizationState createState() =>
      _SliderLabelCustomizationState();
}

class _SliderLabelCustomizationState extends SampleViewState {
  double _labelSliderValue = 50;
  double _tickSliderValue = 0;
  double _divisorSliderValue = 50;

  SfSliderTheme _sliderWithLabelCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor,
            labelOffset: const Offset(8, 0)),
        child: SfSlider.vertical(
          showLabels: true,
          interval: 20,
          min: 10.0,
          max: 90.0,
          value: _labelSliderValue,
          onChanged: (dynamic values) {
            setState(() {
              _labelSliderValue = values as double;
            });
          },
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
  }

  SfSliderTheme _sliderWithTickCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
          showLabels: true,
          showTicks: true,
          interval: 25,
          min: -50.0,
          max: 50.0,
          value: _tickSliderValue,
          onChanged: (dynamic values) {
            setState(() {
              _tickSliderValue = values as double;
            });
          },
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
  }

  SfSliderTheme _sliderWithDivisorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
          interval: 25,
          showDivisors: true,
          min: 0.0,
          max: 100.0,
          value: _divisorSliderValue,
          tooltipPosition: SliderTooltipPosition.right,
          onChanged: (dynamic values) {
            setState(() {
              _divisorSliderValue = values as double;
            });
          },
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
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
        padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: _sliderWithDivisorCustomization()),
              const Text('Divisors')
            ]),
            Column(children: <Widget>[
              Expanded(child: _sliderWithLabelCustomization()),
              const Text('Labels'),
            ]),
            Column(children: <Widget>[
              Expanded(child: _sliderWithTickCustomization()),
              const Text('Ticks')
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
