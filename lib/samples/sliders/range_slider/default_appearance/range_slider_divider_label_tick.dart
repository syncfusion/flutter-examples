///flutter package import
import 'package:flutter/material.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders the range slider with divider, labels, ticks
class ScaleRangeSliderPage extends SampleView {
  /// Creates the range slider with divider, labels, ticks
  const ScaleRangeSliderPage(Key key) : super(key: key);

  @override
  _ScaleRangeSliderPageState createState() => _ScaleRangeSliderPageState();
}

class _ScaleRangeSliderPageState extends SampleViewState {
  _ScaleRangeSliderPageState();
  SfRangeValues _divisonSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _tickSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _labelSliderValues = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _sliderWithDivider() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      showDividers: true,
      values: _divisonSliderValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _divisonSliderValues = values;
        });
      },
    );
  }

  SfRangeSlider _sliderWithTick() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      showLabels: true,
      showTicks: true,
      minorTicksPerInterval: 1,
      values: _tickSliderValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _tickSliderValues = values;
        });
      },
    );
  }

  SfRangeSlider _sliderWithLabel() {
    return SfRangeSlider(
      max: 100.0,
      interval: 20,
      showLabels: true,
      values: _labelSliderValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _labelSliderValues = values;
        });
      },
    );
  }

  Widget _buildWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title('Dividers'),
          _sliderWithDivider(),
          columnSpacing40,
          title('Labels'),
          _sliderWithLabel(),
          columnSpacing30,
          title('Ticks'),
          _sliderWithTick(),
          columnSpacing40,
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
        return constraints.maxHeight > 325
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 325, child: rangeSlider),
              );
      },
    );
  }
}
