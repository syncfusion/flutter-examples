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

///Render Slider with customized labels
class VerticalSliderLabelCustomizationPage extends SampleView {
  ///Render Slider with customized labels
  const VerticalSliderLabelCustomizationPage(Key key) : super(key: key);

  @override
  _VerticalSliderLabelCustomizationPageState createState() =>
      _VerticalSliderLabelCustomizationPageState();
}

class _VerticalSliderLabelCustomizationPageState extends SampleViewState {
  _VerticalSliderLabelCustomizationPageState();

  double _labelSliderValue = 50;
  double _tickSliderValue = 0;
  double _dividerSliderValue = 50;
  bool _isInversed = false;

  SfSliderTheme _sliderWithLabelCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        tooltipBackgroundColor: model.primaryColor,
        labelOffset: const Offset(8, 0),
      ),
      child: SfSlider.vertical(
        showLabels: true,
        interval: 20,
        min: 10.0,
        max: 90.0,
        isInversed: _isInversed,
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
      child: SfSlider.vertical(
        showLabels: true,
        showTicks: true,
        interval: 25,
        min: -50.0,
        max: 50.0,
        isInversed: _isInversed,
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
      child: SfSlider.vertical(
        interval: 25,
        showDividers: true,
        max: 100.0,
        isInversed: _isInversed,
        value: _dividerSliderValue,
        tooltipPosition: SliderTooltipPosition.right,
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
              Expanded(child: _sliderWithDividerCustomization()),
              const Text('Dividers'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithLabelCustomization()),
              const Text('Labels'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithTickCustomization()),
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
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: slider),
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
