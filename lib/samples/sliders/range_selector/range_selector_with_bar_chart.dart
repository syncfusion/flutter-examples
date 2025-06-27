///Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local import
import '../../../model/sample_view.dart';

/// Renders the range selector with bar chart selection option
class RangeSelectorBarChartPage extends SampleView {
  /// Creates the range selector with bar chart selection option
  const RangeSelectorBarChartPage(Key key) : super(key: key);

  @override
  _RangeSelectorBarChartPageState createState() =>
      _RangeSelectorBarChartPageState();
}

class _RangeSelectorBarChartPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _RangeSelectorBarChartPageState();

  final DateTime _dayMin = DateTime(2020, 05, 31, 12);
  final DateTime _dayMax = DateTime(2020, 06, 30, 12);
  final SfRangeValues _monthValues = SfRangeValues(
    DateTime(2020, 06, 12),
    DateTime(2020, 06, 23),
  );

  late RangeController _rangeController;

  late List<_ChartSampleData> _chartData;

  late String _profitText;

  @override
  void initState() {
    super.initState();

    _chartData = <_ChartSampleData>[
      _ChartSampleData(x: DateTime(2020, 06), y: 100.0),
      _ChartSampleData(x: DateTime(2020, 06, 02), y: 150.541),
      _ChartSampleData(x: DateTime(2020, 06, 03), y: -25.818),
      _ChartSampleData(x: DateTime(2020, 06, 04), y: 30.51),
      _ChartSampleData(x: DateTime(2020, 06, 05), y: -50.302),
      _ChartSampleData(x: DateTime(2020, 06, 06), y: -150.017),
      _ChartSampleData(x: DateTime(2020, 06, 07), y: -25.683),
      _ChartSampleData(x: DateTime(2020, 06, 08), y: 75.818),
      _ChartSampleData(x: DateTime(2020, 06, 09), y: 130.541),
      _ChartSampleData(x: DateTime(2020, 06, 10), y: -55.341),
      _ChartSampleData(x: DateTime(2020, 06, 11), y: -90.205),
      _ChartSampleData(x: DateTime(2020, 06, 12), y: -35.541),
      _ChartSampleData(x: DateTime(2020, 06, 13), y: 10.818),
      _ChartSampleData(x: DateTime(2020, 06, 14), y: 45.51),
      _ChartSampleData(x: DateTime(2020, 06, 15), y: 78.302),
      _ChartSampleData(x: DateTime(2020, 06, 16), y: -37.017),
      _ChartSampleData(x: DateTime(2020, 06, 17), y: -14.683),
      _ChartSampleData(x: DateTime(2020, 06, 18), y: -49.818),
      _ChartSampleData(x: DateTime(2020, 06, 19), y: 98.541),
      _ChartSampleData(x: DateTime(2020, 06, 20), y: 75.341),
      _ChartSampleData(x: DateTime(2020, 06, 21), y: -69.205),
      _ChartSampleData(x: DateTime(2020, 06, 22), y: 18.541),
      _ChartSampleData(x: DateTime(2020, 06, 23), y: 73.818),
      _ChartSampleData(x: DateTime(2020, 06, 24), y: -96.51),
      _ChartSampleData(x: DateTime(2020, 06, 25), y: -23.302),
      _ChartSampleData(x: DateTime(2020, 06, 26), y: -79.017),
      _ChartSampleData(x: DateTime(2020, 06, 27), y: 41.683),
      _ChartSampleData(x: DateTime(2020, 06, 28), y: -65.818),
      _ChartSampleData(x: DateTime(2020, 06, 29), y: -52.541),
      _ChartSampleData(x: DateTime(2020, 06, 30), y: 23.341),
    ];

    _rangeController = RangeController(
      start: _monthValues.start,
      end: _monthValues.end,
    );

    _updateProfit(_monthValues);
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _chartData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                  child: Text('Sales Metrics', style: TextStyle(fontSize: 20)),
                ),
                SfRangeSelectorTheme(
                  data: SfRangeSelectorThemeData(
                    thumbColor: isLightTheme ? Colors.white : Colors.black,
                    thumbStrokeColor: isLightTheme
                        ? Colors.black
                        : Colors.white,
                    thumbStrokeWidth: 2.0,
                    activeTrackHeight: 2.5,
                    inactiveTrackHeight: 1.0,
                    activeTrackColor: isLightTheme
                        ? Colors.black
                        : Colors.white,
                    inactiveTrackColor: isLightTheme
                        ? Colors.black
                        : Colors.white,
                    inactiveRegionColor: model.sampleOutputCardColor.withValues(
                      alpha: 0.75,
                    ),
                    tooltipBackgroundColor: isLightTheme
                        ? Colors.black
                        : Colors.white,
                    overlayColor: isLightTheme
                        ? Colors.black.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.12),
                    tooltipTextStyle: TextStyle(
                      color: isLightTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  child: SfRangeSelector(
                    min: _dayMin.subtract(Duration.zero),
                    max: _dayMax.add(Duration.zero),
                    controller: _rangeController,
                    dateFormat: DateFormat.yMd(),
                    enableTooltip: true,
                    thumbShape: ThumbShape(),
                    trackShape: TrackShape(),
                    overlayShape: OverlayShape(),
                    tooltipShape: TooltipShape(),
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _updateProfit(values);
                      });
                    },
                    child: SizedBox(
                      width: mediaQueryData.orientation == Orientation.landscape
                          ? model.isWebFullView
                                ? mediaQueryData.size.width * 0.5
                                : mediaQueryData.size.width
                          : mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.40 - 25,
                      child: _getColumnChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              mediaQueryData.orientation == Orientation.landscape ||
                  model.isWebFullView
              ? EdgeInsets.only(bottom: mediaQueryData.size.height * 0.1)
              : EdgeInsets.only(bottom: mediaQueryData.size.height * 0.2),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(_profitText, style: const TextStyle(fontSize: 18.0)),
          ),
        ),
      ],
    );
  }

  /// Get default column chart
  SfCartesianChart _getColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      primaryXAxis: DateTimeAxis(
        isVisible: false,
        minimum: _dayMin,
        maximum: _dayMax,
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        minimum: -150,
        maximum: 150,
      ),
      series: _getColumnSeries(),
    );
  }

  /// Get default column series
  List<ColumnSeries<_ChartSampleData, DateTime>> _getColumnSeries() {
    return <ColumnSeries<_ChartSampleData, DateTime>>[
      ColumnSeries<_ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartSampleData data, _) => data.x,
        yValueMapper: (_ChartSampleData data, _) => data.y,
        pointColorMapper: (_ChartSampleData data, _) =>
            data.y < 0 ? Colors.red : Colors.green,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ];
  }

  void _updateProfit(SfRangeValues values) {
    double count = 0.0;
    double profit = 0.0;
    for (int i = 0; i < _chartData.length; i++) {
      if (_chartData[i].x.isAfter(
            //ignore: avoid_as
            (values.start as DateTime).subtract(const Duration(hours: 1)),
          ) &&
          _chartData[i].x.isBefore(
            //ignore: avoid_as
            (values.end as DateTime).add(const Duration(hours: 1)),
          )) {
        profit += _chartData[i].y;
        count += 1;
      }
    }

    if (count > 0) {
      profit = 100 * (profit / (count * 150));
    }

    if (profit >= 0) {
      _profitText = 'Total profit: ' + profit.roundToDouble().toString() + '%';
    } else {
      _profitText =
          'Total loss: ' + (-1 * profit.roundToDouble()).toString() + '%';
    }
  }
}

//Chart sample data
class _ChartSampleData {
  /// Holds the data point values like x, y, etc.,
  _ChartSampleData({required this.x, required this.y});

  /// Holds x value of the data point
  final DateTime x;

  final num y;
}

/// To move the thumb to center of the chart, we will override the `paint`
/// method of the `ThumbShape` and we mill adjust the offset passed to the
/// `super.onPaint` to the half the height of the `parentBox`.
class ThumbShape extends SfThumbShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    super.paint(
      context,
      center -
          Offset(0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
      parentBox: parentBox,
      child: child,
      themeData: themeData,
      currentValues: currentValues,
      paint: paint,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumb: thumb,
    );
  }
}

/// To move the track to center of the chart, we will override the `paint`
/// method of the `TrackShape` and we mill adjust the offset passed to the
/// `super.onPaint` to the half the height of the `parentBox`.
class TrackShape extends SfTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
  }) {
    super.paint(
      context,
      offset -
          Offset(0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
      thumbCenter,
      startThumbCenter,
      endThumbCenter,
      parentBox: parentBox,
      themeData: themeData,
      currentValues: currentValues,
      currentValue: currentValue,
      enableAnimation: enableAnimation,
      inactivePaint: inactivePaint,
      activePaint: activePaint,
      textDirection: textDirection,
    );
  }
}

/// To move the overlay to center of the chart, we will override the `paint`
/// method of the `OverlayShape` and we mill adjust the offset passed to the
/// `super.onPaint` to the half the height of the `parentBox`.
class OverlayShape extends SfOverlayShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> animation,
    required SfThumb? thumb,
  }) {
    super.paint(
      context,
      center -
          Offset(0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
      parentBox: parentBox,
      themeData: themeData,
      currentValue: currentValue,
      currentValues: currentValues,
      paint: paint,
      animation: animation,
      thumb: thumb,
    );
  }
}

/// To move the tooltip to center of the chart, we will override the `paint`
/// method of the `TooltipShape` and we mill adjust the offset passed to the
/// `super.onPaint` to the half the height of the `parentBox`.
class TooltipShape extends SfRectangularTooltipShape {
  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter,
    Offset offset,
    TextPainter textPainter, {
    required RenderBox parentBox,
    required SfSliderThemeData sliderThemeData,
    required Paint paint,
    required Animation<double> animation,
    required Rect trackRect,
  }) {
    super.paint(
      context,
      thumbCenter -
          Offset(
            0.0,
            parentBox.size.height / 2 - sliderThemeData.overlayRadius / 2,
          ),
      offset,
      textPainter,
      parentBox: parentBox,
      sliderThemeData: sliderThemeData,
      paint: paint,
      animation: animation,
      trackRect: trackRect,
    );
  }
}
