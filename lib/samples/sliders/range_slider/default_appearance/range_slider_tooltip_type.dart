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
  SfRangeValues _yearValues = SfRangeValues(
    DateTime(2002, 4),
    DateTime(2003, 10),
  );
  SfRangeValues _hourValues = SfRangeValues(
    DateTime(2010, 01, 01, 13),
    DateTime(2010, 01, 01, 17),
  );
  bool _shouldAlwaysShowTooltip = false;

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider(
        min: DateTime(2001),
        max: DateTime(2005),
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
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
        tooltipTextFormatterCallback:
            (dynamic actualLabel, String formattedText) {
              return DateFormat.yMMM().format(actualLabel);
            },
      ),
    );
  }

  SfRangeSliderTheme _hourRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider(
        min: DateTime(2010, 01, 01, 9),
        max: DateTime(2010, 01, 01, 21, 05),
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
        shouldAlwaysShowTooltip: _shouldAlwaysShowTooltip,
        tooltipShape: const SfPaddleTooltipShape(),
        tooltipTextFormatterCallback:
            (dynamic actualLabel, String formattedText) {
              return DateFormat('h:mm a').format(actualLabel);
            },
      ),
    );
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
        return constraints.maxHeight > 300
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: rangeSlider),
              );
      },
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
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
        );
      },
    );
  }
}
