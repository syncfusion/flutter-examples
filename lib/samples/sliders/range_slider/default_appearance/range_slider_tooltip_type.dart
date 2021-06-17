///flutter package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders slider with tooltip range
class TooltipRangeSliderPage extends SampleView {
  /// Creates slider with tooltip range
  const TooltipRangeSliderPage(Key key) : super(key: key);

  @override
  _TooltipRangeSliderPageState createState() => _TooltipRangeSliderPageState();
}

class _TooltipRangeSliderPageState extends SampleViewState {
  _TooltipRangeSliderPageState();
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
      return constraints.maxHeight > 300
          ? rangeSlider
          : SingleChildScrollView(
              child: SizedBox(height: 300, child: rangeSlider),
            );
    });
  }
}

class _TooltipRangeSlider extends SampleView {
  @override
  _TooltipRangeSliderState createState() => _TooltipRangeSliderState();
}

class _TooltipRangeSliderState extends SampleViewState {
  SfRangeValues _yearValues =
      SfRangeValues(DateTime(2002, 4, 01), DateTime(2003, 10, 01));
  SfRangeValues _hourValues = SfRangeValues(
      DateTime(2010, 01, 01, 13, 00, 00), DateTime(2010, 01, 01, 17, 00, 00));

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: model.backgroundColor),
        child: SfRangeSlider(
          min: DateTime(2001, 01, 01),
          max: DateTime(2005, 01, 01),
          showLabels: true,
          interval: 1,
          dateFormat: DateFormat.y(),
          labelPlacement: LabelPlacement.betweenTicks,
          dateIntervalType: DateIntervalType.years,
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
        child: SfRangeSlider(
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
          tooltipShape: const SfPaddleTooltipShape(),
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat('h:mm a').format(actualLabel);
          },
        ));
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
            title('Rectangular'),
            columnSpacing10,
            _yearRangeSlider(),
            columnSpacing40,
            title('Paddle'),
            columnSpacing10,
            _hourRangeSlider(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
