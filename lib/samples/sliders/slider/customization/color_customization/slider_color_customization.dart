///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';

///Renders slider with customized color
class SliderColorCustomizationPage extends SampleView {
  ///Creates slider with customized color
  const SliderColorCustomizationPage(Key key) : super(key: key);

  @override
  _SliderColorCustomizationPageState createState() =>
      _SliderColorCustomizationPageState();
}

class _SliderColorCustomizationPageState extends SampleViewState {
  _SliderColorCustomizationPageState();
  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _SliderColorCustomization();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 325
          ? slider
          : SingleChildScrollView(
              child: SizedBox(height: 325, child: slider),
            );
    });
  }
}

class _SliderColorCustomization extends SampleView {
  @override
  _SliderColorCustomizationState createState() =>
      _SliderColorCustomizationState();
}

class _SliderColorCustomizationState extends SampleViewState {
  double _trackSliderValue = 0;
  double _thumbStrokeSliderValue = 50;

  SfSliderTheme _sliderWithTrackColorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackColor: Colors.teal,
            inactiveTrackColor: Colors.teal.withOpacity(0.24),
            thumbColor: Colors.teal,
            tooltipBackgroundColor: Colors.teal,
            overlayColor: Colors.teal.withOpacity(0.24)),
        child: SfSlider(
            showLabels: true,
            showTicks: true,
            interval: 25,
            min: -50.0,
            max: 50.0,
            value: _trackSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _trackSliderValue = values as double;
              });
            },
            enableTooltip: true,
            numberFormat: NumberFormat('#')));
  }

  SfSliderTheme _sliderWithThumbStrokeColorCustomization() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            inactiveDivisorColor: model.isWebFullView
                ? model.webBackgroundColor
                : model.cardThemeColor,
            activeDivisorColor: model.isWebFullView
                ? model.webBackgroundColor
                : model.cardThemeColor,
            activeDivisorStrokeWidth: 2,
            activeDivisorStrokeColor: Colors.deepOrange.withOpacity(0.24),
            inactiveDivisorStrokeWidth: 2,
            inactiveDivisorStrokeColor: Colors.deepOrange,
            activeDivisorRadius: 5.0,
            inactiveDivisorRadius: 5.0,
            activeTrackColor: Colors.deepOrange,
            inactiveTrackColor: Colors.deepOrange.withOpacity(0.24),
            overlayColor: Colors.deepOrange.withOpacity(0.12),
            thumbColor: model.isWebFullView
                ? model.webBackgroundColor
                : model.cardThemeColor,
            thumbStrokeWidth: 2.0,
            tooltipBackgroundColor: Colors.deepOrange,
            thumbStrokeColor: Colors.deepOrange),
        child: SfSlider(
            interval: 25,
            showDivisors: true,
            min: 0.0,
            max: 100.0,
            value: _thumbStrokeSliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _thumbStrokeSliderValue = values as double;
              });
            },
            enableTooltip: true,
            numberFormat: NumberFormat('#')));
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
            title('Active and inactive track color'),
            columnSpacing10,
            _sliderWithTrackColorCustomization(),
            columnSpacing40,
            title('Thumb and divisor stroke color'),
            columnSpacing10,
            _sliderWithThumbStrokeColorCustomization(),
            columnSpacing30,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
