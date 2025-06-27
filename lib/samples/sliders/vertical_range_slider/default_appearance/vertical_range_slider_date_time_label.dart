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
  SfRangeValues _yearValues = SfRangeValues(
    DateTime(2002, 4),
    DateTime(2003, 10),
  );
  SfRangeValues _hourValues = SfRangeValues(
    DateTime(2010, 01, 01, 13),
    DateTime(2010, 01, 01, 17),
  );
  bool _isInversed = false;

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        min: DateTime(2001),
        max: DateTime(2005),
        showLabels: true,
        interval: 1,
        isInversed: _isInversed,
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
              Expanded(child: _yearRangeSlider()),
              const Text('Interval as year'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _hourRangeSlider()),
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
        return CheckboxListTile(
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
        );
      },
    );
  }
}
