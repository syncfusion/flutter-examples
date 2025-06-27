///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
// ignore: depend_on_referenced_packages
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

  final double _inactiveSliderValue = 50.0;
  double _activeSliderValue = 50.0;
  bool _isInversed = false;

  SfSlider _inactiveSlider() {
    //ignore: missing_required_param
    return SfSlider.vertical(
      max: 100.0,
      isInversed: _isInversed,
      value: _inactiveSliderValue,
      onChanged: null,
    );
  }

  SfSliderTheme _activeSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        max: 100.0,
        isInversed: _isInversed,
        onChanged: (dynamic values) {
          setState(() {
            _activeSliderValue = values as double;
          });
        },
        value: _activeSliderValue,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Center(
      child: SizedBox(
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
          Column(
            children: <Widget>[
              Expanded(child: _activeSlider()),
              const Text('Enabled'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _inactiveSlider()),
              const Text('Disabled'),
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
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? slider
            : SingleChildScrollView(
                child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: slider,
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _isInversed,
          title: const Text('Inversed', softWrap: false),
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
