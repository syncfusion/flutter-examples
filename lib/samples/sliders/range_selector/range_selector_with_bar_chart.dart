///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  DateTime _dayMin = DateTime(2020, 05, 31, 12);
  DateTime _dayMax = DateTime(2020, 06, 30, 12);
  SfRangeValues _monthValues =
      SfRangeValues(DateTime(2020, 06, 12), DateTime(2020, 06, 23));

  RangeController _rangeController;

  List<ChartSampleData> _chartData;

  String _profitText;

  @override
  void initState() {
    super.initState();

    _chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2020, 06, 01), y: 100.0),
      ChartSampleData(x: DateTime(2020, 06, 02), y: 150.541),
      ChartSampleData(x: DateTime(2020, 06, 03), y: -25.818),
      ChartSampleData(x: DateTime(2020, 06, 04), y: 30.51),
      ChartSampleData(x: DateTime(2020, 06, 05), y: -50.302),
      ChartSampleData(x: DateTime(2020, 06, 06), y: -150.017),
      ChartSampleData(x: DateTime(2020, 06, 07), y: -25.683),
      ChartSampleData(x: DateTime(2020, 06, 08), y: 75.818),
      ChartSampleData(x: DateTime(2020, 06, 09), y: 130.541),
      ChartSampleData(x: DateTime(2020, 06, 10), y: -55.341),
      ChartSampleData(x: DateTime(2020, 06, 11), y: -90.205),
      ChartSampleData(x: DateTime(2020, 06, 12), y: -35.541),
      ChartSampleData(x: DateTime(2020, 06, 13), y: 10.818),
      ChartSampleData(x: DateTime(2020, 06, 14), y: 45.51),
      ChartSampleData(x: DateTime(2020, 06, 15), y: 78.302),
      ChartSampleData(x: DateTime(2020, 06, 16), y: -37.017),
      ChartSampleData(x: DateTime(2020, 06, 17), y: -14.683),
      ChartSampleData(x: DateTime(2020, 06, 18), y: -49.818),
      ChartSampleData(x: DateTime(2020, 06, 19), y: 98.541),
      ChartSampleData(x: DateTime(2020, 06, 20), y: 75.341),
      ChartSampleData(x: DateTime(2020, 06, 21), y: -69.205),
      ChartSampleData(x: DateTime(2020, 06, 22), y: 18.541),
      ChartSampleData(x: DateTime(2020, 06, 23), y: 73.818),
      ChartSampleData(x: DateTime(2020, 06, 24), y: -96.51),
      ChartSampleData(x: DateTime(2020, 06, 25), y: -23.302),
      ChartSampleData(x: DateTime(2020, 06, 26), y: -79.017),
      ChartSampleData(x: DateTime(2020, 06, 27), y: 41.683),
      ChartSampleData(x: DateTime(2020, 06, 28), y: -65.818),
      ChartSampleData(x: DateTime(2020, 06, 29), y: -52.541),
      ChartSampleData(x: DateTime(2020, 06, 30), y: 23.341),
    ];

    _rangeController = RangeController(
      start: _monthValues.start,
      end: _monthValues.end,
    );

    _updateProfit(_monthValues);
  }

  @override
  void dispose() {
    _rangeController?.dispose();
    _chartData?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme = themeData.brightness == Brightness.light;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                        child: Text(
                          'Sales Metrics',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: SfRangeSelectorTheme(
                            data: SfRangeSelectorThemeData(
                              thumbColor:
                                  isLightTheme ? Colors.white : Colors.black,
                              thumbStrokeColor:
                                  isLightTheme ? Colors.black : Colors.white,
                              thumbStrokeWidth: 2.0,
                              activeTrackHeight: 2.5,
                              inactiveTrackHeight: 1.0,
                              activeTrackColor:
                                  isLightTheme ? Colors.black : Colors.white,
                              inactiveTrackColor:
                                  isLightTheme ? Colors.black : Colors.white,
                              inactiveRegionColor: isLightTheme
                                  ? Colors.white.withOpacity(0.75)
                                  : Color.fromRGBO(33, 33, 33, 0.75),
                              tooltipBackgroundColor:
                                  isLightTheme ? Colors.black : Colors.white,
                              overlayColor: isLightTheme
                                  ? Colors.black.withOpacity(0.12)
                                  : Colors.white.withOpacity(0.12),
                              tooltipTextStyle: TextStyle(
                                  color: isLightTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            child: SfRangeSelector(
                              min: _dayMin.subtract(
                                Duration(days: 0, hours: 0),
                              ),
                              max: _dayMax.add(
                                Duration(days: 0, hours: 0),
                              ),
                              controller: _rangeController,
                              dateFormat: DateFormat.yMd(),
                              showTooltip: true,
                              thumbShape: ThumbShape(),
                              trackShape: TrackShape(),
                              overlayShape: OverlayShape(),
                              tooltipShape: TooltipShape(),
                              onChanged: (SfRangeValues values) {
                                setState(() {
                                  _updateProfit(values);
                                });
                              },
                              child: Container(
                                width: mediaQueryData.orientation ==
                                        Orientation.landscape
                                    ? model.isWeb
                                        ? mediaQueryData.size.width * 0.5
                                        : mediaQueryData.size.width
                                    : mediaQueryData.size.width,
                                height: mediaQueryData.size.height * 0.40 - 25,
                                child: _getColumnChart(),
                              ),
                            )),
                      ),
                    ])),
          ),
          Center(
            child: Container(
              height: mediaQueryData.size.height,
              padding: EdgeInsets.only(
                  top:
                      (mediaQueryData.size.height - (model.isWeb ? 180 : 120)) *
                          0.8),
              child: Text(
                _profitText,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Get default column chart
  SfCartesianChart _getColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.all(0),
      primaryXAxis: DateTimeAxis(
        isVisible: false,
        minimum: _dayMin,
        maximum: _dayMax,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: -150,
        maximum: 150,
      ),
      series: _getColumnSeries(),
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, DateTime>> _getColumnSeries() {
    return <ColumnSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointColorMapper: (ChartSampleData data, _) =>
            data.y < 0 ? Colors.red : Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      )
    ];
  }

  void _updateProfit(SfRangeValues values) {
    double count = 0.0;
    double profit = 0.0;
    for (int i = 0; i < _chartData.length; i++) {
      if (_chartData[i].x.isAfter(
              //ignore: avoid_as
              (values.start as DateTime).subtract(const Duration(hours: 1))) &&
          _chartData[i].x.isBefore(
              //ignore: avoid_as
              (values.end as DateTime).add(const Duration(hours: 1)))) {
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
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData({this.x, this.y, this.color});

  /// Holds x value of the datapoint
  final dynamic x;

  final dynamic y;

  final Color color;
}

/// To move the thumb to center of the chart, we will override the `paint`
/// method of the `ThumbShape` and we mill adjust the offset passed to the
/// `super.onPaint` to the half the height of the `parentBox`.
class ThumbShape extends SfThumbShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    RenderBox parentBox,
    RenderBox child,
    SfSliderThemeData themeData,
    SfRangeValues currentValues,
    dynamic currentValue,
    Paint paint,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    SfThumb thumb,
  }) {
    super.paint(
        context,
        center -
            Offset(
                0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
        parentBox: parentBox,
        child: child,
        themeData: themeData,
        currentValues: currentValues,
        paint: paint,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumb: thumb);
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
    Offset thumbCenter,
    Offset startThumbCenter,
    Offset endThumbCenter, {
    RenderBox parentBox,
    SfSliderThemeData themeData,
    SfRangeValues currentValues,
    dynamic currentValue,
    Animation<double> enableAnimation,
    Paint inactivePaint,
    Paint activePaint,
    TextDirection textDirection,
  }) {
    super.paint(
        context,
        offset -
            Offset(
                0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
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
        textDirection: textDirection);
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
    RenderBox parentBox,
    SfSliderThemeData themeData,
    SfRangeValues currentValues,
    dynamic currentValue,
    Paint paint,
    Animation<double> animation,
    SfThumb thumb,
  }) {
    super.paint(
        context,
        center -
            Offset(
                0.0, parentBox.size.height / 2 - themeData.overlayRadius / 2),
        parentBox: parentBox,
        themeData: themeData,
        currentValue: currentValue,
        currentValues: currentValues,
        paint: paint,
        animation: animation,
        thumb: thumb);
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
    RenderBox parentBox,
    SfSliderThemeData sliderThemeData,
    Paint paint,
    Animation<double> animation,
    Rect trackRect,
  }) {
    super.paint(
        context,
        thumbCenter -
            Offset(0.0,
                parentBox.size.height / 2 - sliderThemeData.overlayRadius / 2),
        offset,
        textPainter,
        parentBox: parentBox,
        sliderThemeData: sliderThemeData,
        paint: paint,
        animation: animation,
        trackRect: trackRect);
  }
}
