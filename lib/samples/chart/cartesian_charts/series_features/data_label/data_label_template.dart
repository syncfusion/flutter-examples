/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with various marker shapes sample.
class DataLabelTemplate extends SampleView {
  /// Creates the chart with various marker shapes samphhle.
  const DataLabelTemplate(Key key) : super(key: key);

  @override
  _DataLabelTemplateState createState() => _DataLabelTemplateState();
}

/// State class of the chart with various marker shapes.
class _DataLabelTemplateState extends SampleViewState {
  _DataLabelTemplateState();
  @override
  Widget build(BuildContext context) {
    return _buildDataLabelTemplateChart();
  }

  /// Returns the chart with various marker shapes.
  SfCartesianChart _buildDataLabelTemplateChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Percentage of people using social media on a daily basis'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: 20,
          maximum: 120,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getMarkeSeries(),
    );
  }

  /// Returns the list of chart which need to
  /// render on the chart with marker template.
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
        animationDuration: 0,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        gradient: gradientColors,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                  transform: Matrix4.translationValues(0, 8, 0),
                  height: 50,
                  width: 50,
                  child: Column(children: <Widget>[
                    Container(
                      height: 35,
                      child: Image.asset(
                        _getImageTemplate(pointIndex),
                        height: 45,
                        width: 30,
                      ),
                    ),
                    Container(
                      height: 15,
                      child: Text(
                        data.y.toString() + '%',
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    )
                  ]));
            }),
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
