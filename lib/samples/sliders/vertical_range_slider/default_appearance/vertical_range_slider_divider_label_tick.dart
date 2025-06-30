///flutter package import
import 'package:flutter/material.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders the range slider with divider, labels, ticks
class VerticalScaleRangeSliderPage extends SampleView {
  /// Creates the range slider with divider, labels, ticks
  const VerticalScaleRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalScaleRangeSliderPageState createState() =>
      _VerticalScaleRangeSliderPageState();
}

class _VerticalScaleRangeSliderPageState extends SampleViewState {
  _VerticalScaleRangeSliderPageState();
  SfRangeValues _divisonSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _tickSliderValues = const SfRangeValues(20.0, 80.0);
  SfRangeValues _labelSliderValues = const SfRangeValues(20.0, 80.0);
  bool _isInversed = false;

  SfRangeSlider _sliderWithDivider() {
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      showDividers: true,
      isInversed: _isInversed,
      values: _divisonSliderValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _divisonSliderValues = values;
        });
      },
    );
  }

  SfRangeSlider _sliderWithTick() {
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      showLabels: true,
      showTicks: true,
      isInversed: _isInversed,
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
    return SfRangeSlider.vertical(
      max: 100.0,
      interval: 20,
      showLabels: true,
      values: _labelSliderValues,
      isInversed: _isInversed,
      onChanged: (SfRangeValues values) {
        setState(() {
          _labelSliderValues = values;
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
              Expanded(child: _sliderWithDivider()),
              const Text('Dividers'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithLabel()),
              const Text('Labels'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithTick()),
              const Text('Ticks'),
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
