import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';

// ignore: must_be_immutable
class SliderIntervalCustomization extends StatefulWidget {
  SliderIntervalCustomization({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SliderIntervalCustomizationState createState() =>
      _SliderIntervalCustomizationState(sample);
}

class _SliderIntervalCustomizationState
    extends State<SliderIntervalCustomization> {
  _SliderIntervalCustomizationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return SliderIntervalCustomizationFrontPanel(sample);
  }
}

class SliderIntervalCustomizationFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  SliderIntervalCustomizationFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _SliderIntervalCustomizationFrontPanelState createState() =>
      _SliderIntervalCustomizationFrontPanelState(sampleList);
}

class _SliderIntervalCustomizationFrontPanelState
    extends State<SliderIntervalCustomizationFrontPanel> {
  _SliderIntervalCustomizationFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: MediaQuery.of(context).orientation == Orientation.portrait
          ? IntervalCustomizedRangeSlider()
          : SingleChildScrollView(child: Container(height: 300,child: IntervalCustomizedRangeSlider())
            ),
          );
  }
}

// ignore: must_be_immutable
class IntervalCustomizedRangeSlider extends StatefulWidget {
  @override
  _IntervalCustomizedRangeSliderState createState() =>
      _IntervalCustomizedRangeSliderState();
}

class _IntervalCustomizedRangeSliderState
    extends State<IntervalCustomizedRangeSlider> {
  final double _min = 0;
  final double _max = 100;
  final double _min1 = 0;
  final double _max1 = 100;
  final double _min2 = 0;
  final double _max2 = 100;
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);
  SfRangeValues _values1 = const SfRangeValues(20.0, 80.0);
  SfRangeValues _values2 = const SfRangeValues(20.0, 80.0);
  final double sizeBoxHeight = 20;

  SfRangeSlider sliderWithDivisor() {
    return SfRangeSlider(
        min: _min,
        max: _max,
        interval: 20,
        showDivisors: true,
        values: _values,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (dynamic values) {
          setState(() {
            _values = values;
          });
        });
  }

  SfRangeSliderTheme sliderWithTick() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        labelOffset: const Offset(0, 5),
      ),
      child: SfRangeSlider(
          min: _min1,
          max: _max1,
          interval: 20,
          showLabels: true,
          showTicks: true,
          minorTicksPerInterval: 1,
          labelPlacement: LabelPlacement.onTicks,
          values: _values1,
          onChanged: (dynamic values) {
            setState(() {
              _values1 = values;
            });
          }),
    );
  }

  SfRangeSliderTheme sliderWithLabel() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        labelOffset: const Offset(0, 14),
      ),
      child: SfRangeSlider(
          min: _min2,
          max: _max2,
          interval: 20,
          showLabels: true,
          values: _values2,
          onChanged: (dynamic values) {
            setState(() {
              _values2 = values;
            });
          }),
    );
  }

  Widget _getAlignedTextWidget(String text,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        padding: const EdgeInsets.only(left: 25),
      ),
    );
  }

  Widget get sizedBox => SizedBox(height: sizeBoxHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getAlignedTextWidget('Divisors'),
          sliderWithDivisor(),
          sizedBox,
          _getAlignedTextWidget('Labels'),
          sliderWithLabel(),
          const SizedBox(height: 30,),
          _getAlignedTextWidget('Ticks'),
          sliderWithTick(),
          sizedBox,
        ],
      ),
    );
  }
}
