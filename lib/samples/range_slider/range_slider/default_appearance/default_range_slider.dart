import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:flutter_examples/model/model.dart';

// ignore: must_be_immutable
class RangeSliderDefaultPage extends StatefulWidget {
  RangeSliderDefaultPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderDefaultPageState createState() =>
      _RangeSliderDefaultPageState(sample);
}

class _RangeSliderDefaultPageState extends State<RangeSliderDefaultPage> {
  _RangeSliderDefaultPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return RangeSliderDefaultPageFrontPanel(sample);
  }
}

class RangeSliderDefaultPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderDefaultPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderDefaultPageFrontPanelState createState() =>
      _RangeSliderDefaultPageFrontPanelState(sampleList);
}

class _RangeSliderDefaultPageFrontPanelState
    extends State<RangeSliderDefaultPageFrontPanel> {
  _RangeSliderDefaultPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;
  final Widget slider = DefaultRangeSlider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? slider
          : SingleChildScrollView(child: Container(height: 300,child: slider)),
    );
  }
}

// ignore: must_be_immutable
class DefaultRangeSlider extends StatefulWidget {
  @override
  _DefaultRangeSliderState createState() => _DefaultRangeSliderState();
}

class _DefaultRangeSliderState extends State<DefaultRangeSlider> {
  final double _min = 0;
  final double _max = 100;
  final SfRangeValues _defaultValues = const SfRangeValues(0.2, 0.8);
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);
  final double sizeBoxHeight = 40;

  SfRangeSlider inactiveRangeSlider() {
    //ignore: missing_required_param
    return SfRangeSlider(values: _defaultValues);
  }

  SfRangeSlider activeRangeSlider() {
    return SfRangeSlider(
      min: _min,
      max: _max,
      values: _values,
      onChanged: (dynamic value) {
        setState(() {
          _values = value;
        });
      },
      showTooltip: true,
      numberFormat: NumberFormat('#'),
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
          _getAlignedTextWidget('Enabled'),
          activeRangeSlider(),
          sizedBox,
          _getAlignedTextWidget('Disabled'),
          inactiveRangeSlider(),
        ],
      ),
    );
  }
}
