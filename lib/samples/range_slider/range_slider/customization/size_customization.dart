import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';

import '../gradient.dart';
import '../track_color_customization.dart';

// ignore: must_be_immutable
class RangeSliderSizeCustomizationPage extends StatefulWidget {
  RangeSliderSizeCustomizationPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderSizeCustomizationPageState createState() =>
      _RangeSliderSizeCustomizationPageState(sample);
}

class _RangeSliderSizeCustomizationPageState
    extends State<RangeSliderSizeCustomizationPage> {
  _RangeSliderSizeCustomizationPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return RangeSliderSizeCustomizationPageFrontPanel(sample);
  }
}

class RangeSliderSizeCustomizationPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderSizeCustomizationPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderSizeCustomizationPageFrontPanelState createState() =>
      _RangeSliderSizeCustomizationPageFrontPanelState(sampleList);
}

class _RangeSliderSizeCustomizationPageFrontPanelState
    extends State<RangeSliderSizeCustomizationPageFrontPanel> {
  _RangeSliderSizeCustomizationPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: MediaQuery.of(context).orientation == Orientation.portrait
          ? SizeCustomizedRangeSlider()
          : SingleChildScrollView(child: Container(height: 350,child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: SizeCustomizedRangeSlider()),
            )))
          );
  }
}

// ignore: must_be_immutable
class SizeCustomizedRangeSlider extends StatefulWidget {
  @override
  _SizeCustomizedRangeSliderState createState() =>
      _SizeCustomizedRangeSliderState();
}

class _SizeCustomizedRangeSliderState extends State<SizeCustomizedRangeSlider> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getAlignedTextWidget('Active and inactive colors'),
          const SizedBox(height: 10,),
          TrackColorCustomizedRangeSlider(),
          const SizedBox(height: 25),
          GradientRangeSlider(),
        ],
      ),
    );
  }
}
