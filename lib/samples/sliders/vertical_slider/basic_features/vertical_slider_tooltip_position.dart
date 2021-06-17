///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders slider with different types of tooltips
class VerticalSliderTooltipTypeSliderPage extends SampleView {
  /// Renders slider with different types of tooltips
  const VerticalSliderTooltipTypeSliderPage(Key key) : super(key: key);

  @override
  _VerticalSliderTooltipPageState createState() =>
      _VerticalSliderTooltipPageState();
}

class _VerticalSliderTooltipPageState extends SampleViewState {
  _VerticalSliderTooltipPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _SliderTooltipType();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 350
          ? slider
          : SingleChildScrollView(
              child: SizedBox(height: 400, child: slider),
            );
    });
  }
}

class _SliderTooltipType extends SampleView {
  @override
  _SliderTooltipTypeState createState() => _SliderTooltipTypeState();
}

class _SliderTooltipTypeState extends SampleViewState {
  DateTime _hourValue = DateTime(2020, 01, 01, 13, 00, 00);
  double _sliderValue = 20;

  SfSliderTheme _numerical() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor,
            labelOffset: const Offset(-30, 0),
            tickOffset: const Offset(-15, 0)),
        child: SfSlider.vertical(
            showLabels: true,
            interval: 10,
            min: 10.0,
            max: 40.0,
            showTicks: true,
            tooltipPosition: SliderTooltipPosition.right,
            value: _sliderValue,
            onChanged: (dynamic values) {
              setState(() {
                _sliderValue = values as double;
              });
            },
            enableTooltip: true));
  }

  SfSliderTheme _dateTimeSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(
          tooltipBackgroundColor: model.backgroundColor,
        ),
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
          //tooltipShape: SfPaddleTooltipShape(),
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
              Expanded(child: _numerical()),
              const Text('Tooltip on the right')
            ]),
            Column(children: <Widget>[
              Expanded(child: _dateTimeSlider()),
              const Text('Tooltip on the left'),
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
