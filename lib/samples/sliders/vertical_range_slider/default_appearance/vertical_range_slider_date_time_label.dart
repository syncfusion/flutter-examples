///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders the range slider with date time labels
class VerticalDateRangeSliderPage extends SampleView {
  /// Creates the range slider with date time labels
  const VerticalDateRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalDateRangeSliderPageState createState() =>
      _VerticalDateRangeSliderPageState();
}

class _VerticalDateRangeSliderPageState extends SampleViewState {
  _VerticalDateRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _DateRangeSlider();
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

class _DateRangeSlider extends SampleView {
  @override
  _DateRangeSliderState createState() => _DateRangeSliderState();
}

class _DateRangeSliderState extends SampleViewState {
  SfRangeValues _yearValues =
      SfRangeValues(DateTime(2002, 4, 01), DateTime(2003, 10, 01));
  SfRangeValues _hourValues = SfRangeValues(
      DateTime(2010, 01, 01, 13, 00, 00), DateTime(2010, 01, 01, 17, 00, 00));

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider.vertical(
          min: DateTime(2001, 01, 01),
          max: DateTime(2005, 01, 01),
          showLabels: true,
          interval: 1,
          dateFormat: DateFormat.y(),
          dateIntervalType: DateIntervalType.years,
          labelPlacement: LabelPlacement.betweenTicks,
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

  SfRangeSliderTheme _hourRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider.vertical(
          min: DateTime(2010, 01, 01, 9, 00, 00),
          max: DateTime(2010, 01, 01, 21, 05, 00),
          showLabels: true,
          interval: 4,
          showTicks: true,
          minorTicksPerInterval: 3,
          dateFormat: DateFormat('h a'),
          dateIntervalType: DateIntervalType.hours,
          values: _hourValues,
          onChanged: (SfRangeValues values) {
            setState(() {
              _hourValues = values;
            });
          },
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat('h:mm a').format(actualLabel);
          },
        ));
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
            Column(children: <Widget>[
              Expanded(child: _yearRangeSlider()),
              const Text('Interval as year')
            ]),
            Column(children: <Widget>[
              Expanded(child: _hourRangeSlider()),
              const Text('Interval as hour')
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
