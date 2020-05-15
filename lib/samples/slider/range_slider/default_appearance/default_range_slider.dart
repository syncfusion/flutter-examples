import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/slider/slider_utils.dart';

//ignore: must_be_immutable
class DefaultRangeSliderPage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DefaultRangeSliderPage([this.sample]);
  SubItem sample;

  @override
  _DefaultRangeSliderPageState createState() =>
      _DefaultRangeSliderPageState(sample);
}

class _DefaultRangeSliderPageState extends State<DefaultRangeSliderPage> {
  _DefaultRangeSliderPageState(this.sample);
  final SubItem sample;
  Widget rangeSlider;
  Widget sampleWidget(SampleModel model) => DefaultRangeSliderPage();

  @override
  void initState() {
    super.initState();
    rangeSlider = DefaultRangeSlider();
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
class DefaultRangeSlider extends StatefulWidget {
  @override
  _DefaultRangeSliderState createState() => _DefaultRangeSliderState();
}

class _DefaultRangeSliderState extends State<DefaultRangeSlider> {
  final SfRangeValues _inactiveSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _activeSliderValues = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _inactiveRangeSlider() {
    //ignore: missing_required_param
    return SfRangeSlider(min: 0.0, max: 100.0, values: _inactiveSliderValues);
  }

  SfRangeSlider _activeRangeSlider() {
    return SfRangeSlider(
      min: 0.0,
      max: 100.0,
      values: _activeSliderValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _activeSliderValues = values;
        });
      },
      showTooltip: true,
      numberFormat: NumberFormat('#'),
    );
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
        title('Enabled'),
        _activeRangeSlider(),
        columnSpacing40,
        title('Disabled'),
        _inactiveRangeSlider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _getWebLayout() : _getMobileLayout());
  }
}
