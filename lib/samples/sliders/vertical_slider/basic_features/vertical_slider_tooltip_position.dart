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

  DateTime _hourValue = DateTime(2020, 01, 01, 13);
  double _sliderValue = 20;
  bool _isInversed = false;
  bool _shouldAlwaysShowTooltip = false;

  SfSliderTheme _numerical() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        tooltipBackgroundColor: model.primaryColor,
        labelOffset: const Offset(-30, 0),
        tickOffset: const Offset(-15, 0),
      ),
      child: SfSlider.vertical(
        showLabels: true,
        interval: 10,
        min: 10.0,
        max: 40.0,
        showTicks: true,
        isInversed: _isInversed,
        tooltipPosition: SliderTooltipPosition.right,
        value: _sliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _sliderValue = values as double;
          });
        },
        enableTooltip: true,
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
      ),
    );
  }

  SfSliderTheme _dateTimeSlider() {
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
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
        //tooltipShape: SfPaddleTooltipShape(),
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
    final double padding = MediaQuery.of(context).size.height / 12.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _numerical()),
              const Text('Tooltip on the right'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _dateTimeSlider()),
              const Text('Tooltip on the left'),
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

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
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
            ),
            CheckboxListTile(
              value: _shouldAlwaysShowTooltip,
              title: const Text('Show tooltip always'),
              activeColor: model.primaryColor,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool? value) {
                setState(() {
                  _shouldAlwaysShowTooltip = value!;
                  stateSetter(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }
}
