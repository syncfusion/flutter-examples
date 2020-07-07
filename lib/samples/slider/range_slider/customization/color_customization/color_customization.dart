import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/slider/slider_utils.dart';

import '../color_customization/gradient_track.dart';

//ignore: must_be_immutable
class ColorCustomizedRangeSliderPage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ColorCustomizedRangeSliderPage([this.sample]);
  SubItem sample;

  @override
  _ColorCustomizedRangeSliderPageState createState() =>
      _ColorCustomizedRangeSliderPageState(sample);
}

class _ColorCustomizedRangeSliderPageState
    extends State<ColorCustomizedRangeSliderPage> {
  _ColorCustomizedRangeSliderPageState(this.sample);
  final SubItem sample;
  Widget rangeSlider;
  Widget sampleWidget(SampleModel model) => ColorCustomizedRangeSliderPage();

  @override
  void initState() {
    super.initState();
    rangeSlider = ColorCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
                ? rangeSlider
                : SingleChildScrollView(
                    child: Container(
                        height: 350,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                          child: Container(child: rangeSlider),
                        ))));
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        title('Active and inactive color'),
        const SizedBox(
          height: 10,
        ),
        GradientTrackRangeSlider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _getWebLayout() : _getMobileLayout());
  }
}
