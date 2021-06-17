///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders slider with customized size
class VerticalSliderSizeCustomizationPage extends SampleView {
  ///Creates slider with customized size
  const VerticalSliderSizeCustomizationPage(Key key) : super(key: key);

  @override
  _VerticalSliderSizeCustomizationPageState createState() =>
      _VerticalSliderSizeCustomizationPageState();
}

class _VerticalSliderSizeCustomizationPageState extends SampleViewState {
  _VerticalSliderSizeCustomizationPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _SfSliderSizeCustomization();
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

class _SfSliderSizeCustomization extends SampleView {
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
        child: SfSlider.vertical(
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
              _yearValue = values as DateTime;
            });
          },
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMM().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _sliderWithTrackCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackHeight: 10.0,
            inactiveTrackHeight: 4.0,
            trackCornerRadius: 6.0,
            tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
            showLabels: true,
            interval: 10,
            min: -20.0,
            max: 20.0,
            stepSize: 10,
            value: _value,
            onChanged: (dynamic values) {
              setState(() {
                _value = values as double;
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
              Expanded(child: _sliderWithTrackCustomization()),
              const Text('Track')
            ]),
            Column(children: <Widget>[
              Expanded(child: _sliderWithdivisorCustomization()),
              const Text('Divisor'),
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
