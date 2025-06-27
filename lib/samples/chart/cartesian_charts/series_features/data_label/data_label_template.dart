/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with customized data labels.
class DataLabelTemplate extends SampleView {
  /// Creates the column series chart with customized data labels.
  const DataLabelTemplate(Key key) : super(key: key);

  @override
  _DataLabelTemplateState createState() => _DataLabelTemplateState();
}

/// State class for the column series chart
/// with customized data labels.
class _DataLabelTemplateState extends SampleViewState {
  _DataLabelTemplateState();

  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataLabelTemplateChart();
  }

  /// Returns a cartesian column chart with customized data labels.
  SfCartesianChart _buildDataLabelTemplateChart() {
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
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        interval: 20,
        maximum: 120,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
          return _CustomColumnSeriesRenderer();
        },
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(93, 80, 202, 1),
            Color.fromRGBO(183, 45, 145, 1),
            Color.fromRGBO(250, 203, 118, 1),
          ],
          stops: <double>[0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        animationDuration: 0,
        dataLabelSettings: _buildDataLabelSettings(),
      ),
    ];
  }

  /// Builds the data label settings for the column series.
  DataLabelSettings _buildDataLabelSettings() {
    return DataLabelSettings(
      isVisible: true,
      builder:
          (
            dynamic data,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
          ) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 35,
                  child: Image.asset(
                    _getImageTemplate(pointIndex),
                    height: 45,
                    width: 30,
                  ),
                ),
                Text(
                  data.y.toString() + '%',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            );
          },
    );
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

  @override
  void dispose() {
    _chartData!.clear();
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
    if (segmentRect != null) {
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
