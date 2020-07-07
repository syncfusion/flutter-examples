import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

import '../shape_customization/divisor_customization.dart';
import '../shape_customization/thumb_customization.dart';
import '../shape_customization/tick_customization.dart';

class ShapeCustomizedRangeSliderPage extends SampleView {
  const ShapeCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _ShapeCustomizedRangeSliderPageState createState() =>
      _ShapeCustomizedRangeSliderPageState();
}

class _ShapeCustomizedRangeSliderPageState extends SampleViewState {
  _ShapeCustomizedRangeSliderPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = ShapeCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                  child: Container(child: rangeSlider),
                )));
  }
}

// ignore: must_be_immutable
class ShapeCustomizedRangeSlider extends SampleView {
  @override
  _ShapeCustomizedRangeSliderState createState() =>
      _ShapeCustomizedRangeSliderState();
}

class _ShapeCustomizedRangeSliderState extends SampleViewState {
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
    final double padding = MediaQuery
        .of(context)
        .size
        .width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
