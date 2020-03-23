import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';

import '../divisor_customization.dart';
import '../thumb_customization.dart';
import '../tick_customization.dart';

// ignore: must_be_immutable
class RangeSliderColorCustomizationPage extends StatefulWidget {
  RangeSliderColorCustomizationPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderColorCustomizationPageState createState() =>
      _RangeSliderColorCustomizationPageState(sample);
}

class _RangeSliderColorCustomizationPageState
    extends State<RangeSliderColorCustomizationPage> {
  _RangeSliderColorCustomizationPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return RangeSliderColorCustomizationPageFrontPanel(sample);
  }
}

class RangeSliderColorCustomizationPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderColorCustomizationPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderColorCustomizationPageFrontPanelState createState() =>
      _RangeSliderColorCustomizationPageFrontPanelState(sampleList);
}

class _RangeSliderColorCustomizationPageFrontPanelState
    extends State<RangeSliderColorCustomizationPageFrontPanel> {
  _RangeSliderColorCustomizationPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: MediaQuery.of(context).orientation == Orientation.portrait
          ? ColorCustomizedRangeSlider()
          : SingleChildScrollView(child: Container(height: 500,child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: ColorCustomizedRangeSlider()),
            )))
          );

  }
}

// ignore: must_be_immutable
class ColorCustomizedRangeSlider extends StatefulWidget {
  @override
  _ColorCustomizedRangeSliderState createState() =>
      _ColorCustomizedRangeSliderState();
}

class _ColorCustomizedRangeSliderState
    extends State<ColorCustomizedRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ThumbCustomizedRangeSlider(),
          const SizedBox(height: 40),
          _getAlignedTextWidget('Divisor'),
          DivisorCustomizedRangeSlider(),
          const SizedBox(height: 40),
          _getAlignedTextWidget('Ticks'),
          TickCustomizedRangeSlider()
        ],
      ),
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
    }