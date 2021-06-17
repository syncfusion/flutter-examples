///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders default slider widget
class DefaultVerticalSliderPage extends SampleView {
  /// Creates default slider widget
  const DefaultVerticalSliderPage(Key key) : super(key: key);

  @override
  _DefaultVerticalSliderPageState createState() =>
      _DefaultVerticalSliderPageState();
}

class _DefaultVerticalSliderPageState extends SampleViewState {
  _DefaultVerticalSliderPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _DefaultSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? slider
          : SingleChildScrollView(
              child: SizedBox(
                  height: 400,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: slider)),
            );
    });
  }
}

class _DefaultSlider extends SampleView {
  @override
  _DefaultSliderState createState() => _DefaultSliderState();
}

class _DefaultSliderState extends SampleViewState {
  final double _inactiveSliderValue = 50.0;
  double _activeSliderValue = 50.0;

  SfSlider _inactiveSlider() {
    //ignore: missing_required_param
    return SfSlider.vertical(
      min: 0.0,
      max: 100.0,
      value: _inactiveSliderValue,
      onChanged: null,
    );
  }

  SfSliderTheme _activeSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
          min: 0.0,
          max: 100.0,
          onChanged: (dynamic values) {
            setState(() {
              _activeSliderValue = values as double;
            });
          },
          value: _activeSliderValue,
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ));
  }

  Widget _buildWebLayout() {
    return Center(
        child: Container(
            width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
            child: _buildMobileLayout()));
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.height / 10.0;
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: _activeSlider()),
              const Text('Enabled')
            ]),
            Column(children: <Widget>[
              Expanded(child: _inactiveSlider()),
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
