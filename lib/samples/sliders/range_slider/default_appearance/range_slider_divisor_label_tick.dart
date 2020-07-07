import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class ScaleRangeSliderPage extends SampleView {
  const ScaleRangeSliderPage(Key key) : super(key: key);

  @override
  _ScaleRangeSliderPageState createState() => _ScaleRangeSliderPageState();
}

class _ScaleRangeSliderPageState extends SampleViewState {
  _ScaleRangeSliderPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = ScaleRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(height: 325, child: rangeSlider),
          );
  }
}

// ignore: must_be_immutable
class ScaleRangeSlider extends SampleView {
  @override
  _ScaleRangeSliderState createState() => _ScaleRangeSliderState();
}

class _ScaleRangeSliderState extends SampleViewState {
  SfRangeValues _divisonSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _tickSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _labelSliderValues = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _sliderWithDivisor() {
    return SfRangeSlider(
        min: 0.0,
        max: 100.0,
        interval: 20,
        showDivisors: true,
        values: _divisonSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _divisonSliderValues = values;
          });
        });
  }

  SfRangeSlider _sliderWithTick() {
    return SfRangeSlider(
        min: 0.0,
        max: 100.0,
        interval: 20,
        showLabels: true,
        showTicks: true,
        minorTicksPerInterval: 1,
        labelPlacement: LabelPlacement.onTicks,
        values: _tickSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _tickSliderValues = values;
          });
        });
  }

  SfRangeSlider _sliderWithLabel() {
    return SfRangeSlider(
        min: 0.0,
        max: 100.0,
        interval: 20,
        showLabels: true,
        values: _labelSliderValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _labelSliderValues = values;
          });
        });
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
            title('Divisors'),
            _sliderWithDivisor(),
            columnSpacing40,
            title('Labels'),
            _sliderWithLabel(),
            columnSpacing30,
            title('Ticks'),
            _sliderWithTick(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
