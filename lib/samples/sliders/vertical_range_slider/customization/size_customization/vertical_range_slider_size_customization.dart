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

///Renders range slider with customized size
class VerticalSfRangeSliderSizeCustomizationPage extends SampleView {
  ///Creates range slider with customized divider
  const VerticalSfRangeSliderSizeCustomizationPage(Key key) : super(key: key);

  @override
  _VerticalSfRangeSliderSizeCustomizationPageState createState() =>
      _VerticalSfRangeSliderSizeCustomizationPageState();
}

class _VerticalSfRangeSliderSizeCustomizationPageState extends SampleViewState {
  _VerticalSfRangeSliderSizeCustomizationPageState();
  SfRangeValues _yearValues = SfRangeValues(DateTime(2005), DateTime(2015));
  SfRangeValues _values = const SfRangeValues(-25.0, 25.0);

  SfRangeSliderTheme _dividerCustomizationRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        activeDividerRadius: 6.0,
        inactiveDividerRadius: 3.0,
        inactiveDividerColor: Colors.teal.withValues(alpha: 0.24),
        activeDividerColor: Colors.teal,
        activeTrackColor: Colors.teal,
        thumbColor: Colors.teal,
        tooltipBackgroundColor: Colors.teal,
        overlayColor: Colors.teal.withValues(alpha: 0.12),
        inactiveTrackColor: Colors.teal.withValues(alpha: 0.24),
      ),
      child: SfRangeSlider.vertical(
        min: DateTime(2000),
        max: DateTime(2020),
        showLabels: true,
        interval: 5,
        stepDuration: const SliderStepDuration(years: 5),
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        showDividers: true,
        values: _yearValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _yearValues = values;
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

  SfRangeSliderTheme _numericRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        activeTrackHeight: 8.0,
        activeTrackColor: Colors.orange,
        thumbColor: Colors.orange,
        tooltipBackgroundColor: Colors.orange,
        overlayColor: Colors.orange.withValues(alpha: 0.12),
        inactiveTrackColor: Colors.orange.withValues(alpha: 0.24),
      ),
      child: SfRangeSlider.vertical(
        showLabels: true,
        interval: 25,
        min: -50.0,
        max: 50.0,
        stepSize: 25,
        showTicks: true,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
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
              Expanded(child: _numericRangeSlider()),
              const Text('Track'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _dividerCustomizationRangeSlider()),
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
}
