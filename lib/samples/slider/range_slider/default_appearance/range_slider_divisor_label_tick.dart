import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/slider/slider_utils.dart';

//ignore: must_be_immutable
class ScaleRangeSliderPage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ScaleRangeSliderPage([this.sample]);
  SubItem sample;

  @override
  _ScaleRangeSliderPageState createState() =>
      _ScaleRangeSliderPageState(sample);
}

class _ScaleRangeSliderPageState extends State<ScaleRangeSliderPage> {
  _ScaleRangeSliderPageState(this.sample);
  final SubItem sample;
  Widget rangeSlider;
  Widget sampleWidget(SampleModel model) => ScaleRangeSliderPage();

  @override
  void initState() {
    super.initState();
    rangeSlider = ScaleRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
          ? rangeSlider
          : SingleChildScrollView(
              child: Container(height: 300, child: rangeSlider)),
    );
  }
}

// ignore: must_be_immutable
class ScaleRangeSlider extends StatefulWidget {
  @override
  _ScaleRangeSliderState createState() => _ScaleRangeSliderState();
}

class _ScaleRangeSliderState extends State<ScaleRangeSlider> {
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
        width: MediaQuery.of(context).size.width >= 1000 ? 500 : 400,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _getWebLayout() : _getMobileLayout());
  }
}
