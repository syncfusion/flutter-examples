import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/slider/slider_utils.dart';

import '../shape_customization/divisor_customization.dart';
import '../shape_customization/thumb_customization.dart';
import '../shape_customization/tick_customization.dart';

//ignore: must_be_immutable
class ShapeCustomizedRangeSliderPage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ShapeCustomizedRangeSliderPage([this.sample]);
  SubItem sample;

  @override
  _ShapeCustomizedRangeSliderPageState createState() =>
      _ShapeCustomizedRangeSliderPageState(sample);
}

class _ShapeCustomizedRangeSliderPageState
    extends State<ShapeCustomizedRangeSliderPage> {
  _ShapeCustomizedRangeSliderPageState(this.sample);
  final SubItem sample;
  Widget rangeSlider;
  Widget sampleWidget(SampleModel model) => ShapeCustomizedRangeSliderPage();

  @override
  void initState() {
    super.initState();
    rangeSlider = ShapeCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
                ? rangeSlider
                : SingleChildScrollView(
                    child: Container(
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                          child: Container(child: rangeSlider),
                        ))));
  }
}

// ignore: must_be_immutable
class ShapeCustomizedRangeSlider extends StatefulWidget {
  @override
  _ShapeCustomizedRangeSliderState createState() =>
      _ShapeCustomizedRangeSliderState();
}

class _ShapeCustomizedRangeSliderState
    extends State<ShapeCustomizedRangeSlider> {
  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 3,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ThumbCustomizedRangeSlider(),
        columnSpacing40,
        title('Divisor'),
        DivisorCustomizedRangeSlider(),
        columnSpacing40,
        title('Ticks'),
        TickCustomizedRangeSlider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _getWebLayout() : _getMobileLayout());
  }
}
