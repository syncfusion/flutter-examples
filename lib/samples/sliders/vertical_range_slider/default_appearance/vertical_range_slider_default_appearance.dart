///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders default range slider widget
class VerticalDefaultRangeSliderPage extends SampleView {
  /// Creates default range slider widget
  const VerticalDefaultRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalDefaultRangeSliderPageState createState() =>
      _VerticalDefaultRangeSliderPageState();
}

class _VerticalDefaultRangeSliderPageState extends SampleViewState {
  _VerticalDefaultRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _DefaultRangeSlider();
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

class _DefaultRangeSlider extends SampleView {
  @override
  _DefaultRangeSliderState createState() => _DefaultRangeSliderState();
}

class _DefaultRangeSliderState extends SampleViewState {
  final SfRangeValues _inactiveRangeSliderValue =
      const SfRangeValues(20.0, 80.0);
  SfRangeValues _activeRangeSliderValue = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _inactiveRangeSlider() {
    //ignore: missing_required_param
    return SfRangeSlider.vertical(
      min: 0.0,
      max: 100.0,
      values: _inactiveRangeSliderValue,
      onChanged: null,
    );
  }

  SfRangeSliderTheme _activeRangeSliderSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider.vertical(
          min: 0.0,
          max: 100.0,
          onChanged: (dynamic values) {
            setState(() {
              _activeRangeSliderValue = values as SfRangeValues;
            });
          },
          values: _activeRangeSliderValue,
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
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
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: _activeRangeSliderSlider()),
              const Text('Enabled')
            ]),
            Column(children: <Widget>[
              Expanded(child: _inactiveRangeSlider()),
              const Text('Disabled')
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
