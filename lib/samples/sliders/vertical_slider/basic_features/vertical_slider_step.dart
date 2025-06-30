///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Core theme import
// ignore: depend_on_referenced_packages
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
  DateTime _yearValue = DateTime(2014);
  double _stepSliderValue = 0;
  bool _isInversed = false;

  SfSliderTheme _sliderWithStepDurationCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        min: DateTime(2010),
        max: DateTime(2018),
        showLabels: true,
        interval: 2,
        isInversed: _isInversed,
        stepDuration: const SliderStepDuration(years: 2),
        dateFormat: DateFormat.y(),
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
      ),
    );
  }

  SfSliderTheme _sliderWithStepCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        showLabels: true,
        interval: 5,
        min: -10.0,
        max: 10.0,
        stepSize: 5,
        showTicks: true,
        isInversed: _isInversed,
        value: _stepSliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _stepSliderValue = values as double;
          });
        },
        enableTooltip: true,
      ),
    );
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
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithStepCustomization()),
              const Text('Numeric'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithStepDurationCustomization()),
              const Text('DateTime'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: slider),
              );
      },
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          value: _isInversed,
          title: const Text('Inversed', softWrap: false),
          contentPadding: EdgeInsets.zero,
          activeColor: model.primaryColor,
          onChanged: (bool? value) {
            setState(() {
              _isInversed = value!;
              stateSetter(() {});
            });
          },
        );
      },
    );
  }
}
