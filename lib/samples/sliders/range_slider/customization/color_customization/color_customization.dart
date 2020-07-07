import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

import '../color_customization/gradient_track.dart';

class ColorCustomizedRangeSliderPage extends SampleView {
  const ColorCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _ColorCustomizedRangeSliderPageState createState() =>
      _ColorCustomizedRangeSliderPageState();
}

class _ColorCustomizedRangeSliderPageState extends SampleViewState {
  _ColorCustomizedRangeSliderPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = ColorCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                  child: Container(child: rangeSlider),
                )));
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
            title('Active and inactive track color'),
            const SizedBox(
              height: 10,
            ),
            GradientTrackRangeSlider()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}