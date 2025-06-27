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

  DateTime _yearValue = DateTime(2018);
  DateTime _hourValue = DateTime(2020, 01, 01, 13);
  bool _isInversed = false;

  SfSliderTheme _yearSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        min: DateTime(2016),
        max: DateTime(2020),
        showLabels: true,
        interval: 1,
        dateFormat: DateFormat.y(),
        isInversed: _isInversed,
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
      ),
    );
  }

  SfSliderTheme _hourSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        min: DateTime(2020, 01, 01, 9),
        max: DateTime(2020, 01, 01, 21),
        showLabels: true,
        interval: 4,
        showTicks: true,
        isInversed: _isInversed,
        minorTicksPerInterval: 3,
        dateFormat: DateFormat('h a'),
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
              Expanded(flex: 4, child: _yearSlider()),
              const Text('Interval as year'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(flex: 4, child: _hourSlider()),
              const Text('Interval as hour'),
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
                child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: slider,
                  ),
                ),
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
