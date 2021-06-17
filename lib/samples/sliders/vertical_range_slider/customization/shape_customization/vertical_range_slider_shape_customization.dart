///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import 'vertical_range_slider_divisor_customization.dart';
import 'vertical_range_slider_thumb_customization.dart';
import 'vertical_range_slider_tick_customization.dart';

/// Renders range slider with customized shapes
class VerticalShapeCustomizedRangeSliderPage extends SampleView {
  /// Creates range slider with customized shapes
  const VerticalShapeCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalShapeCustomizedRangeSliderPageState createState() =>
      _VerticalShapeCustomizedRangeSliderPageState();
}

class _VerticalShapeCustomizedRangeSliderPageState extends SampleViewState {
  _VerticalShapeCustomizedRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _ShapeCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? rangeSlider
          : SingleChildScrollView(
              child: SizedBox(height: 400, child: rangeSlider),
            );
    });
  }
}

class _ShapeCustomizedRangeSlider extends SampleView {
  @override
  _ShapeCustomizedRangeSliderState createState() =>
      _ShapeCustomizedRangeSliderState();
}

class _ShapeCustomizedRangeSliderState extends SampleViewState {
  Widget _buildWebLayout() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.height / 10.0;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(children: <Widget>[
                Expanded(child: VerticalThumbCustomizedRangeSlider()),
                const Text('Thumb')
              ]),
              Column(children: <Widget>[
                Expanded(child: VerticalDivisorCustomizedRangeSlider()),
                const Text('Divisor'),
              ]),
              Column(children: <Widget>[
                Expanded(child: VerticalTickCustomizedRangeSlider()),
                const Text('Tick'),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
