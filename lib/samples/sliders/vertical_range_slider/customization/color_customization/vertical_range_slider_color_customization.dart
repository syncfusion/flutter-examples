///Package import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Local import
import '../../../../../model/sample_view.dart';
import 'vertical_range_slider_gradient_color_customization.dart';

///Renders range slider with customized color
class VerticalColorCustomizedRangeSliderPage extends SampleView {
  ///Creates range slider with customized color
  const VerticalColorCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalColorCustomizedRangeSliderPageState createState() =>
      _VerticalColorCustomizedRangeSliderPageState();
}

class _VerticalColorCustomizedRangeSliderPageState extends SampleViewState {
  _VerticalColorCustomizedRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _ColorCustomizedRangeSlider();
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

class _ColorCustomizedRangeSlider extends SampleView {
  @override
  _ColorCustomizedRangeSliderState createState() =>
      _ColorCustomizedRangeSliderState();
}

class _ColorCustomizedRangeSliderState extends SampleViewState {
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
    return VerticalGradientTrackRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
