///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
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

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _RangeSliderIntervalSelection();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? rangeSlider
          : SingleChildScrollView(
              child: SizedBox(height: 400, child: rangeSlider),
            );
    });
  }
}

class _RangeSliderIntervalSelection extends SampleView {
  @override
  _RangeSliderIntervalSelectionState createState() =>
      _RangeSliderIntervalSelectionState();
}

class _RangeSliderIntervalSelectionState extends SampleViewState {
  SfRangeValues _yearValues =
      SfRangeValues(DateTime(2012, 1, 01), DateTime(2018, 1, 1));
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider.vertical(
          min: DateTime(2010, 01, 01),
          max: DateTime(2020, 01, 01),
          //showDivisors: true,
          interval: 2,
          showLabels: true,
          stepDuration: const SliderStepDuration(years: 2),
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.onTicks,
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
        ));
  }

  SfRangeSliderTheme _numericRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider.vertical(
            showLabels: true,
            interval: 20,
            min: 0.0,
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
            enableTooltip: true));
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
        child: Column(children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: padding / 2),
                    child: Column(children: <Widget>[
                      Expanded(child: _numericRangeSlider()),
                      const Text('Numeric')
                    ])),
                Padding(
                    padding: EdgeInsets.only(bottom: padding / 2),
                    child: Column(children: <Widget>[
                      Expanded(child: _yearRangeSlider()),
                      const Text('DateTime'),
                    ])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: padding / 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.lightbulb_outline,
                      color: Colors.orange, size: 24.0),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Tap on the interval to select it.'),
                  )
                ]),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
