///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders default slider widget
class DefaultSliderPage extends SampleView {
  /// Creates default slider widget
  const DefaultSliderPage(Key key) : super(key: key);

  @override
  _DefaultSliderPageState createState() => _DefaultSliderPageState();
}

class _DefaultSliderPageState extends SampleViewState {
  _DefaultSliderPageState();
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
      return constraints.maxHeight > 300
          ? slider
          : SingleChildScrollView(
              child: SizedBox(height: 300, child: slider),
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
    return SfSlider(
      min: 0.0,
      max: 100.0,
      value: _inactiveSliderValue,
      onChanged: null,
    );
  }

  SfSliderTheme _activeSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
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
            title('Enabled'),
            _activeSlider(),
            columnSpacing40,
            title('Disabled'),
            _inactiveSlider(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
