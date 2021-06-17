///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

///Render Slider with date intervals
class VerticalDateIntervalSliderPage extends SampleView {
  ///Creates Slider with date intervals
  const VerticalDateIntervalSliderPage(Key key) : super(key: key);

  @override
  _VerticalDateIntervalSliderPageState createState() =>
      _VerticalDateIntervalSliderPageState();
}

class _VerticalDateIntervalSliderPageState extends SampleViewState {
  _VerticalDateIntervalSliderPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _VerticalDateIntervalSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? slider
          : SingleChildScrollView(
              child: SizedBox(
                  height: 400,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: slider)),
            );
    });
  }
}

class _VerticalDateIntervalSlider extends SampleView {
  @override
  _VerticalDateIntervalSliderState createState() =>
      _VerticalDateIntervalSliderState();
}

class _VerticalDateIntervalSliderState extends SampleViewState {
  DateTime _yearValue = DateTime(2018, 01, 01);
  DateTime _hourValue = DateTime(2020, 01, 01, 13, 00, 00);

  SfSliderTheme _yearSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
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
              _yearValue = value as DateTime;
            });
          },
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMM().format(actualLabel);
          },
        ));
  }

  SfSliderTheme _hourSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(tooltipBackgroundColor: model.backgroundColor),
        child: SfSlider.vertical(
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
              _hourValue = value as DateTime;
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
              Expanded(
                flex: 4,
                child: _yearSlider(),
              ),
              const Text('Interval as year')
            ]),
            Column(children: <Widget>[
              Expanded(
                flex: 4,
                child: _hourSlider(),
              ),
              const Text('Interval as hour'),
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
