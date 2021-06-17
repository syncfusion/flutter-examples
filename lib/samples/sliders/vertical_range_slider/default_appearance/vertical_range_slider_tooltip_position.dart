///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders slider with tooltip range
class VerticalTooltipRangeSliderPage extends SampleView {
  /// Creates slider with tooltip range
  const VerticalTooltipRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalTooltipRangeSliderPageState createState() =>
      _VerticalTooltipRangeSliderPageState();
}

class _VerticalTooltipRangeSliderPageState extends SampleViewState {
  _VerticalTooltipRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _TooltipRangeSlider();
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

class _TooltipRangeSlider extends SampleView {
  @override
  _TooltipRangeSliderState createState() => _TooltipRangeSliderState();
}

class _TooltipRangeSliderState extends SampleViewState {
  SfRangeValues _values = const SfRangeValues(140.0, 160.0);
  SfRangeValues _hourValues = SfRangeValues(
      DateTime(2010, 01, 01, 13, 00, 00), DateTime(2010, 01, 01, 17, 00, 00));

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor,
            labelOffset: const Offset(-40, 0),
            tickOffset: const Offset(-14, 0)),
        child: SfRangeSlider.vertical(
          min: 100.0,
          max: 200.0,
          showLabels: true,
          interval: 20,
          showTicks: true,
          values: _values,
          tooltipPosition: SliderTooltipPosition.right,
          onChanged: (SfRangeValues values) {
            setState(() {
              _values = values;
            });
          },
          enableTooltip: true,
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
          labelPlacement: LabelPlacement.onTicks,
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
              const Text('Tooltip on the right')
            ]),
            Column(children: <Widget>[
              Expanded(child: _hourRangeSlider()),
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
