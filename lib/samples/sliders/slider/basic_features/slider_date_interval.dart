import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class DateIntervalSliderPage extends SampleView {
  const DateIntervalSliderPage(Key key) : super(key: key);

  @override
  _DateIntervalSliderPageState createState() => _DateIntervalSliderPageState();
}

class _DateIntervalSliderPageState extends SampleViewState {
  _DateIntervalSliderPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = DateIntervalSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? slider
        : SingleChildScrollView(
            child: Container(height: 300, child: slider),
          );
  }
}

// ignore: must_be_immutable
class DateIntervalSlider extends SampleView {
  @override
  _DateIntervalSliderState createState() => _DateIntervalSliderState();
}

class _DateIntervalSliderState extends SampleViewState {
  DateTime _yearValue = DateTime(2018, 01, 01);
  DateTime _hourValue = DateTime(2020, 01, 01, 13, 00, 00);

  SfSliderTheme _yearSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
          min: DateTime(2016, 01, 01),
          max: DateTime(2020, 01, 01),
          showLabels: true,
          interval: 1,
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.betweenTicks,
          dateIntervalType: DateIntervalType.years,
          showTicks: true,
          value: _yearValue,
          onChanged: (dynamic value) {
            setState(() {
              _yearValue = value;
            });
          },
          showTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMM().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _hourSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider(
          min: DateTime(2020, 01, 01, 9, 00, 00),
          max: DateTime(2020, 01, 01, 21, 05, 00),
          showLabels: true,
          interval: 4,
          showTicks: true,
          minorTicksPerInterval: 3,
          dateFormat: DateFormat('h a'),
          labelPlacement: LabelPlacement.onTicks,
          dateIntervalType: DateIntervalType.hours,
          value: _hourValue,
          onChanged: (dynamic value) {
            setState(() {
              _hourValue = value;
            });
          },
          showTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat('h:mm a').format(actualLabel);
          },
        ));
  }

  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    final double padding = MediaQuery
        .of(context)
        .size
        .width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title('Interval as year'),
            columnSpacing10,
            _yearSlider(),
            columnSpacing40,
            title('Interval as hour'),
            columnSpacing10,
            _hourSlider(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
