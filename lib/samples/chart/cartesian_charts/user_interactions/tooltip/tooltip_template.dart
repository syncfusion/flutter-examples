/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with various marker shapes sample.
class TooltipTemplate extends SampleView {
  /// Creates the chart with various marker shapes sample.
  const TooltipTemplate(Key key) : super(key: key);

  @override
  _TooltipTemplateState createState() => _TooltipTemplateState();
}

/// State class of the chart with various marker shapes.
class _TooltipTemplateState extends SampleViewState {
  _TooltipTemplateState();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        color: Colors.grey[400],
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
              alignment: Alignment.center,
              height: 40,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Row(children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: 35,
                      child: Image.asset(_getImageTemplate(pointIndex)),
                    ),
                    Text(
                      data.y.toString() + '%',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textScaleFactor: 1.0,
                    ),
                  ])));
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTooltipTemplateChart();
  }

  /// Returns the chart with various marker shapes.
  SfCartesianChart _buildTooltipTemplateChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Percentage of people using social media on a daily basis'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: 20,
          maximum: isCardView ? 120 : 100,
          majorTickLines: const MajorTickLines(size: 0)),
      tooltipBehavior: _tooltipBehavior,
      series: _getMarkeSeries(),
    );
  }

//ignore: unused_element
  Color? _getTooltipBorderColor(int pointIndex) {
    Color? color;
    if (pointIndex == 0) {
      color = const Color.fromRGBO(192, 33, 39, 1);
    } else if (pointIndex == 1) {
      color = const Color.fromRGBO(26, 157, 235, 1);
    } else if (pointIndex == 2) {
      color = const Color.fromRGBO(93, 80, 202, 1);
    } else if (pointIndex == 3) {
      color = const Color.fromRGBO(254, 250, 55, 1);
    } else if (pointIndex == 4) {
      color = const Color.fromRGBO(60, 92, 156, 1);
    }
    return color;
  }

  /// Returns the list of chart which need to
  /// render on the chart with Tooltip template.
  List<ColumnSeries<ChartSampleData, String>> _getMarkeSeries() {
    final List<Color> color = <Color>[];
    color.add(const Color.fromRGBO(93, 80, 202, 1));
    color.add(const Color.fromRGBO(183, 45, 145, 1));
    color.add(const Color.fromRGBO(250, 203, 118, 1));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'YouTube',
        y: 51,
        pointColor: const Color.fromRGBO(192, 33, 39, 1),
      ),
      ChartSampleData(
        x: 'Twitter',
        y: 42,
        pointColor: const Color.fromRGBO(26, 157, 235, 1),
      ),
      ChartSampleData(
        x: 'Instagram',
        y: 63,
      ),
      ChartSampleData(
        x: 'Snapchat',
        y: 61,
        pointColor: const Color.fromRGBO(254, 250, 55, 1),
      ),
      ChartSampleData(
        x: 'Facebook',
        y: 74,
        pointColor: const Color.fromRGBO(47, 107, 167, 1),
      ),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
          return _CustomColumnSeriesRenderer();
        },
        dataSource: chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        gradient: gradientColors,
      ),
    ];
  }

  String _getImageTemplate(int pointIndex) {
    final String path = pointIndex == 0
        ? 'images/youtube.png'
        : (pointIndex == 1
            ? 'images/maps_twitter.png'
            : (pointIndex == 2
                ? 'images/maps_instagram.png'
                : (pointIndex == 3
                    ? 'images/maps_snapchat.png'
                    : 'images/maps_facebook.png')));
    return path;
  }
}

class _CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  _CustomColumnSeriesRenderer();

  @override
  ChartSegment createSegment() {
    return _ColumnCustomPainter();
  }
}

class _ColumnCustomPainter extends ColumnSegment {
  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

  @override
  void onPaint(Canvas canvas) {
    Paint? myPaint = fillPaint;
    if (currentSegmentIndex == 0) {
      myPaint = Paint()..color = const Color.fromRGBO(192, 33, 39, 1);
    } else if (currentSegmentIndex == 1) {
      myPaint = Paint()..color = const Color.fromRGBO(26, 157, 235, 1);
    } else if (currentSegmentIndex == 2) {
      myPaint = fillPaint;
    } else if (currentSegmentIndex == 3) {
      myPaint = Paint()..color = const Color.fromRGBO(254, 250, 55, 1);
    } else if (currentSegmentIndex == 4) {
      myPaint = Paint()..color = const Color.fromRGBO(60, 92, 156, 1);
    }
    final Rect rect = Rect.fromLTRB(segmentRect.left, segmentRect.top,
        segmentRect.right * animationFactor, segmentRect.bottom);
    canvas.drawRect(rect, myPaint!);
  }
}
