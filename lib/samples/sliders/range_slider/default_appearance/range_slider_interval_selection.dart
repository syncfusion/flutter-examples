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
import '../../slider_utils.dart';

/// Renders the range slider with interval selection
class RangeSliderIntervalSelectionPage extends SampleView {
  /// Renders the range slider with interval selection
  const RangeSliderIntervalSelectionPage(Key key) : super(key: key);

  @override
  _RangeSliderIntervalSelectionPageState createState() =>
      _RangeSliderIntervalSelectionPageState();
}

class _RangeSliderIntervalSelectionPageState extends SampleViewState {
  _RangeSliderIntervalSelectionPageState();
  SfRangeValues _yearValues = SfRangeValues(DateTime(2012), DateTime(2018));
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider(
        min: DateTime(2010),
        max: DateTime(2020),
        interval: 2,
        showLabels: true,
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
      child: SfRangeSlider(
        showLabels: true,
        interval: 20,
        max: 100.0,
        stepSize: 20,
        showTicks: true,
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
          title('Numeric'),
          columnSpacing10,
          _numericRangeSlider(),
          columnSpacing40,
          title('Date'),
          columnSpacing10,
          _yearRangeSlider(),
          columnSpacing40,
          columnSpacing40,
          const Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.orange,
                  size: 24.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text('Tap on the interval to select it.'),
              ),
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
        return constraints.maxHeight > 325
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 325, child: rangeSlider),
              );
      },
    );
  }
}
