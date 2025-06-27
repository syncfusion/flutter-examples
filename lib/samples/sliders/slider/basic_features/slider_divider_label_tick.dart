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
import '../../slider_utils.dart';

///Render Slider with customized labels
class SliderLabelCustomizationPage extends SampleView {
  ///Render Slider with customized labels
  const SliderLabelCustomizationPage(Key key) : super(key: key);

  @override
  _SliderLabelCustomizationPageState createState() =>
      _SliderLabelCustomizationPageState();
}

class _SliderLabelCustomizationPageState extends SampleViewState {
  _SliderLabelCustomizationPageState();
  double _labelSliderValue = 50;
  double _tickSliderValue = 0;
  double _dividerSliderValue = 50;

  SfSliderTheme _sliderWithLabelCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider(
        showLabels: true,
        interval: 20,
        max: 100.0,
        value: _labelSliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _labelSliderValue = values as double;
          });
        },
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
      ),
    );
  }

  SfSliderTheme _sliderWithTickCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider(
        showLabels: true,
        showTicks: true,
        interval: 25,
        min: -50.0,
        max: 50.0,
        value: _tickSliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _tickSliderValue = values as double;
          });
        },
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
      ),
    );
  }

  SfSliderTheme _sliderWithDividerCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider(
        interval: 25,
        showDividers: true,
        max: 100.0,
        value: _dividerSliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _dividerSliderValue = values as double;
          });
        },
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
      ),
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
          _sliderWithDividerCustomization(),
          columnSpacing30,
          title('Labels'),
          _sliderWithLabelCustomization(),
          columnSpacing30,
          title('Ticks'),
          _sliderWithTickCustomization(),
          columnSpacing30,
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
        return constraints.maxHeight > 325
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 325, child: slider),
              );
      },
    );
  }
}
