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
import '../../../../model/sample_view.dart';

/// Renders the range slider with interval selection
class VerticalRangeSliderIntervalSelectionPage extends SampleView {
  /// Renders the range slider with interval selection
  const VerticalRangeSliderIntervalSelectionPage(Key key) : super(key: key);

  @override
  _VerticalRangeSliderIntervalSelectionPageState createState() =>
      _VerticalRangeSliderIntervalSelectionPageState();
}

class _VerticalRangeSliderIntervalSelectionPageState extends SampleViewState {
  _VerticalRangeSliderIntervalSelectionPageState();
  SfRangeValues _yearValues = SfRangeValues(DateTime(2012), DateTime(2018));
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);
  bool _isInversed = false;

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        min: DateTime(2010),
        max: DateTime(2020),
        interval: 2,
        showLabels: true,
        isInversed: _isInversed,
        stepDuration: const SliderStepDuration(years: 2),
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        enableIntervalSelection: true,
        showTicks: true,
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
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        showLabels: true,
        interval: 20,
        max: 100.0,
        stepSize: 20,
        showTicks: true,
        isInversed: _isInversed,
        enableIntervalSelection: true,
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
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding / 2),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: padding / 2),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: _numericRangeSlider()),
                      const Text('Numeric'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding / 2),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: _yearRangeSlider()),
                      const Text('DateTime'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: padding / 2),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.lightbulb_outline, color: Colors.orange, size: 24.0),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Tap on the interval to select it.'),
                ),
              ],
            ),
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
