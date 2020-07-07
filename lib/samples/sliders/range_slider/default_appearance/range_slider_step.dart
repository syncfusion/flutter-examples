import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class SliderStepDurationPage extends SampleView {
  const SliderStepDurationPage(Key key) : super(key: key);

  @override
  _SliderStepDurationPageState createState() => _SliderStepDurationPageState();
}

class _SliderStepDurationPageState extends SampleViewState {
  _SliderStepDurationPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = SliderStepDurationView();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(height: 300, child: rangeSlider),
          );
  }
}

// ignore: must_be_immutable
class SliderStepDurationView extends SampleView {
  @override
  _SliderStepDurationState createState() => _SliderStepDurationState();
}

class _SliderStepDurationState extends SampleViewState {
  SfRangeValues _yearValues =
      SfRangeValues(DateTime(2005, 1, 01), DateTime(2015, 1, 1));
  SfRangeValues _values = const SfRangeValues(-25.0, 25.0);

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider(
          min: DateTime(2000, 01, 01),
          max: DateTime(2020, 01, 01),
          showLabels: true,
          interval: 5,
          stepDuration: const SliderStepDuration(years: 5),
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.onTicks,
          dateIntervalType: DateIntervalType.years,
          showTicks: true,
          values: _yearValues,
          onChanged: (SfRangeValues values) {
            setState(() {
              _yearValues = values;
            });
          },
          showTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMM().format(actualLabel);
          },
        ));
  }

  SfRangeSliderTheme _numericRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider(
            showLabels: true,
            interval: 25,
            min: -50.0,
            max: 50.0,
            stepSize: 25,
            showTicks: true,
            values: _values,
            onChanged: (SfRangeValues values) {
              setState(() {
                _values = values;
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
            _numericRangeSlider(),
            columnSpacing40,
            title('Date'),
            columnSpacing10,
            _yearRangeSlider(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
