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
  SfRangeValues _values = const SfRangeValues(140.0, 160.0);
  SfRangeValues _hourValues = SfRangeValues(
    DateTime(2010, 01, 01, 13),
    DateTime(2010, 01, 01, 17),
  );
  bool _isInversed = false;
  bool _shouldAlwaysShowTooltip = false;

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        tooltipBackgroundColor: model.primaryColor,
        labelOffset: const Offset(-40, 0),
        tickOffset: const Offset(-14, 0),
      ),
      child: SfRangeSlider.vertical(
        min: 100.0,
        max: 200.0,
        showLabels: true,
        interval: 20,
        showTicks: true,
        isInversed: _isInversed,
        values: _values,
        tooltipPosition: SliderTooltipPosition.right,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        enableTooltip: true,
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
      ),
    );
  }

  SfRangeSliderTheme _hourRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        min: DateTime(2010, 01, 01, 9),
        max: DateTime(2010, 01, 01, 21),
        showLabels: true,
        interval: 4,
        showTicks: true,
        isInversed: _isInversed,
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
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
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
              Expanded(child: _yearRangeSlider()),
              const Text('Tooltip on the right'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _hourRangeSlider()),
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
        final Widget rangeSlider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: rangeSlider),
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
              activeColor: model.primaryColor,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool? value) {
                setState(() {
                  _isInversed = value!;
                  stateSetter(() {});
                });
              },
            ),
            CheckboxListTile(
              value: _shouldAlwaysShowTooltip,
              title: const Text('Show tooltip always', softWrap: false),
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
