/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with custom tooltip.
class TooltipTemplate extends SampleView {
  /// Creates the column series chart with custom tooltip.
  const TooltipTemplate(Key key) : super(key: key);

  @override
  _TooltipTemplateState createState() => _TooltipTemplateState();
}

/// State class for the cartesian chart with custom tooltip.
class _TooltipTemplateState extends SampleViewState {
  _TooltipTemplateState();
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;
  late LinearGradient _gradient;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.grey[400],
      builder:
          (
            dynamic data,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
          ) {
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
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: 35,
                      child: Image.asset(_buildImageTemplate(pointIndex)),
                    ),
                    Text(
                      data.y.toString() + '%',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textScaler: TextScaler.noScaling,
                    ),
                  ],
                ),
              ),
            );
          },
    );
    _chartData = _buildChartData();
    _gradient = const LinearGradient(
      colors: <Color>[
        Color.fromRGBO(93, 80, 202, 1),
        Color.fromRGBO(183, 45, 145, 1),
        Color.fromRGBO(250, 203, 118, 1),
      ],
      stops: <double>[0.0, 0.5, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
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
      ChartSampleData(x: 'Instagram', y: 63),
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
  }

  @override
  Widget build(BuildContext context) {
    return _buildTooltipTemplateChart();
  }

  /// Returns a cartesian column chart with custom tooltip.
  SfCartesianChart _buildTooltipTemplateChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Percentage of people using social media on a daily basis',
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        interval: 20,
        maximum: isCardView ? 120 : 100,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildColumnSeries(),
    );
  }

  //ignore: unused_element
  Color? _buildTooltipBorderColor(int pointIndex) {
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

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        gradient: _gradient,
        onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
          return _CustomColumnSeriesRenderer();
        },
      ),
    ];
  }

  String _buildImageTemplate(int pointIndex) {
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

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class _CustomColumnSeriesRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  _CustomColumnSeriesRenderer();

  @override
  ColumnSegment<T, D> createSegment() {
    return _ColumnCustomPainter();
  }
}

class _ColumnCustomPainter<T, D> extends ColumnSegment<T, D> {
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
    if (segmentRect != null) {
      final Rect rect = Rect.fromLTRB(
        segmentRect!.left,
        segmentRect!.top,
        segmentRect!.right * animationFactor,
        segmentRect!.bottom,
      );
      canvas.drawRect(rect, myPaint);
    }
  }
}
