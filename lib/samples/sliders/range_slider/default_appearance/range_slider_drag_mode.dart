/// Flutter package import
import 'package:flutter/material.dart';

/// Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders the range slider with different drag mode option.
class RangeSliderDragModePage extends SampleView {
  /// Creates the range slider with different drag mode option.
  const RangeSliderDragModePage(Key key) : super(key: key);

  @override
  _RangeSliderDragModePageState createState() =>
      _RangeSliderDragModePageState();
}

class _RangeSliderDragModePageState extends SampleViewState {
  _RangeSliderDragModePageState();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxHeight > 325
            ? _DragModeRangeSlider()
            : SingleChildScrollView(
                child: SizedBox(height: 325, child: _DragModeRangeSlider()),
              );
      },
    );
  }
}

class _DragModeRangeSlider extends SampleView {
  @override
  _DragModeRangeSliderState createState() => _DragModeRangeSliderState();
}

class _DragModeRangeSliderState extends SampleViewState {
  SfRangeValues _dragOnThumbValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _dragBetweenThumbValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _dragBothThumbValues = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _buildSliderWithDragModeOnThumb() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      values: _dragOnThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragOnThumbValues = values;
        });
      },
    );
  }

  SfRangeSlider _buildSliderWithDragModeBetweenThumbs() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      values: _dragBetweenThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      dragMode: SliderDragMode.betweenThumbs,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragBetweenThumbValues = values;
        });
      },
    );
  }

  SfRangeSlider _buildSliderWithDragModeBoth() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      values: _dragBothThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      dragMode: SliderDragMode.both,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragBothThumbValues = values;
        });
      },
    );
  }

  Widget _buildWebLayout() {
    return Align(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title('On thumb'),
          _buildSliderWithDragModeOnThumb(),
          columnSpacing40,
          title('Between thumbs'),
          _buildSliderWithDragModeBetweenThumbs(),
          columnSpacing30,
          title('Both'),
          _buildSliderWithDragModeBoth(),
          columnSpacing40,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
