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
import '../../slider_utils.dart';

///Render Slider with step interval
class StepSliderPage extends SampleView {
  ///Render Slider with step interval
  const StepSliderPage(Key key) : super(key: key);

  @override
  _StepSliderPageState createState() => _StepSliderPageState();
}

class _StepSliderPageState extends SampleViewState {
  _StepSliderPageState();
  DateTime _yearValue = DateTime(2014);
  double _stepSliderValue = 0;

  SfSliderTheme _sliderWithStepDurationCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider(
        min: DateTime(2010),
        max: DateTime(2018),
        showLabels: true,
        interval: 2,
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
            _stepSliderValue = values as double;
          });
        },
        enableTooltip: true,
      ),
    );
  }

  Widget _buildWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
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
          columnSpacing40,
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
        return constraints.maxHeight > 300
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: slider),
              );
      },
    );
  }
}
