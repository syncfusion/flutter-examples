///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders slider with customized size
class VerticalSliderSizeCustomizationPage extends SampleView {
  ///Creates slider with customized size
  const VerticalSliderSizeCustomizationPage(Key key) : super(key: key);

  @override
  _VerticalSliderSizeCustomizationPageState createState() =>
      _VerticalSliderSizeCustomizationPageState();
}

class _VerticalSliderSizeCustomizationPageState extends SampleViewState {
  _VerticalSliderSizeCustomizationPageState();
  DateTime _yearValue = DateTime(2010);
  double _value = 0.0;

  SfSliderTheme _sliderWithDividerCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeDividerRadius: 6.0,
        inactiveDividerRadius: 3.0,
        inactiveDividerColor: Colors.deepOrangeAccent.withValues(alpha: 0.24),
        activeDividerColor: Colors.deepOrangeAccent,
        activeTrackColor: Colors.deepOrangeAccent,
        thumbColor: Colors.deepOrangeAccent,
        tooltipBackgroundColor: Colors.deepOrangeAccent,
        inactiveTrackColor: Colors.deepOrangeAccent.withValues(alpha: 0.24),
        overlayColor: Colors.deepOrangeAccent.withValues(alpha: 0.12),
      ),
      child: SfSlider.vertical(
        min: DateTime(2000),
        max: DateTime(2020),
        showLabels: true,
        interval: 5,
        stepDuration: const SliderStepDuration(years: 5),
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        showDividers: true,
        value: _yearValue,
        onChanged: (dynamic values) {
          setState(() {
            _yearValue = values as DateTime;
          });
        },
        enableTooltip: true,
        tooltipTextFormatterCallback:
            (dynamic actualLabel, String formattedText) {
              return DateFormat.yMMM().format(actualLabel);
            },
      ),
    );
  }

  SfSliderTheme _sliderWithTrackCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 10.0,
        trackCornerRadius: 6.0,
        tooltipBackgroundColor: model.primaryColor,
      ),
      child: SfSlider.vertical(
        showLabels: true,
        interval: 10,
        min: -20.0,
        max: 20.0,
        stepSize: 10,
        value: _value,
        onChanged: (dynamic values) {
          setState(() {
            _value = values as double;
          });
        },
        enableTooltip: true,
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
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithTrackCustomization()),
              const Text('Track'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithDividerCustomization()),
              const Text('Divider'),
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
}
