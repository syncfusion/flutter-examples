/// Flutter package import
import 'package:flutter/material.dart';

/// Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the vertical range slider with different drag mode option.
class VerticalRangeSliderDragModePage extends SampleView {
  /// Creates the vertical range slider with different drag mode option.
  const VerticalRangeSliderDragModePage(Key key) : super(key: key);

  @override
  _VerticalRangeSliderDragModePageState createState() =>
      _VerticalRangeSliderDragModePageState();
}

class _VerticalRangeSliderDragModePageState extends SampleViewState {
  _VerticalRangeSliderDragModePageState();

  SfRangeValues _dragOnThumbValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _dragBetweenThumbValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _dragBothThumbValues = const SfRangeValues(20.0, 80.0);
  bool _isInversed = false;

  SfRangeSlider _buildSliderWithDragModeOnThumb() {
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      values: _dragOnThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      isInversed: _isInversed,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragOnThumbValues = values;
        });
      },
    );
  }

  SfRangeSlider _buildSliderWithDragModeBetweenThumbs() {
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      values: _dragBetweenThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      dragMode: SliderDragMode.betweenThumbs,
      isInversed: _isInversed,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragBetweenThumbValues = values;
        });
      },
    );
  }

  SfRangeSlider _buildSliderWithDragModeBoth() {
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      values: _dragBothThumbValues,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      dragMode: SliderDragMode.both,
      isInversed: _isInversed,
      onChanged: (SfRangeValues values) {
        setState(() {
          _dragBothThumbValues = values;
        });
      },
    );
  }

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _buildSliderWithDragModeOnThumb()),
              const Text('On thumbs'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _buildSliderWithDragModeBetweenThumbs()),
              const Text('Between thumbs'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _buildSliderWithDragModeBoth()),
              const Text('Both'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget rangeSlider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: rangeSlider),
              );
      },
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          value: _isInversed,
          title: const Text('Inversed', softWrap: false),
          contentPadding: EdgeInsets.zero,
          activeColor: model.primaryColor,
          onChanged: (bool? value) {
            setState(() {
              _isInversed = value!;
              stateSetter(() {});
            });
          },
        );
      },
    );
  }
}
