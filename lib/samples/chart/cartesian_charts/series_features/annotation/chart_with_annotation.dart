/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with annotation sample.
class AnnotationWatermark extends SampleView {
  /// Creates the column series chart with annotation sample.
  const AnnotationWatermark(Key key) : super(key: key);

  @override
  _AnnotationWatermarkState createState() => _AnnotationWatermarkState();
}

/// State class for the column series chart with annotation.
class _AnnotationWatermarkState extends SampleViewState {
  _AnnotationWatermarkState();

  List<ChartSampleData>? _chartData;
  List<ChartSampleData>? _annotationChartData;

  @override
  void initState() {
    _chartData = _buildChartData();
    _annotationChartData = _buildAnnotationChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(
        x: 'Facebook',
        y: 90,
        xValue: '90',
        pointColor: const Color.fromRGBO(0, 63, 92, 1),
      ),
      ChartSampleData(
        x: 'Twitter',
        y: 60,
        xValue: '60',
        pointColor: const Color.fromRGBO(242, 117, 7, 1),
      ),
      ChartSampleData(
        x: 'Instagram',
        y: 51,
        xValue: '51',
        pointColor: const Color.fromRGBO(89, 59, 84, 1),
      ),
      ChartSampleData(
        x: 'Snapchat',
        y: 50,
        xValue: '50',
        pointColor: const Color.fromRGBO(217, 67, 80, 1),
      ),
    ];
  }

  List<ChartSampleData> _buildAnnotationChartData() {
    return [
      ChartSampleData(
        x: 'Facebook',
        y: 90,
        xValue: '90%',
        pointColor: const Color.fromRGBO(0, 63, 92, 1),
      ),
      ChartSampleData(
        x: 'Twitter',
        y: 60,
        xValue: '60%',
        pointColor: const Color.fromRGBO(242, 117, 7, 1),
      ),
      ChartSampleData(
        x: 'Instagram',
        y: 51,
        xValue: '51%',
        pointColor: const Color.fromRGBO(89, 59, 84, 1),
      ),
      ChartSampleData(
        x: 'Snapchat',
        y: 50,
        xValue: '50%',
        pointColor: const Color.fromRGBO(217, 67, 80, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildWatermarkAnnotationChart();
  }

  /// Returns a Cartesian column chart with annotation.
  SfCartesianChart _buildWatermarkAnnotationChart() {
    final bool needSmallAnnotation =
        model.isWebFullView && MediaQuery.of(context).size.height < 530;

    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'UK social media reach, by platform',
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        labelFormat: '{value}%',
        minimum: 0,
        maximum: 120,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
      ),
      series: _buildColumnSeries(),
      annotations: _buildAnnotations(needSmallAnnotation),
    );
  }

  /// Builds the annotations for the chart.
  List<CartesianChartAnnotation> _buildAnnotations(bool needSmallAnnotation) {
    return <CartesianChartAnnotation>[
      CartesianChartAnnotation(
        widget: SizedBox(
          height: isCardView
              ? 100
              : needSmallAnnotation
              ? 80
              : 150,
          width: isCardView
              ? 100
              : needSmallAnnotation
              ? 80
              : 150,
          child: SfCircularChart(
            series: <PieSeries<ChartSampleData, String>>[
              PieSeries<ChartSampleData, String>(
                radius: '90%',
                dataSource: _annotationChartData,
                dataLabelMapper: (ChartSampleData data, int index) =>
                    data.xValue as String,
                xValueMapper: (ChartSampleData data, int index) => data.x,
                yValueMapper: (ChartSampleData data, int index) => data.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.none,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: isCardView
                        ? 10
                        : needSmallAnnotation
                        ? 7
                        : 12,
                  ),
                ),
                pointColorMapper: (ChartSampleData data, int index) =>
                    data.pointColor,
              ),
            ],
          ),
        ),
        coordinateUnit: CoordinateUnit.point,
        x: 'Instagram',
        y: isCardView ? 85 : 80,
      ),
    ];
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        width: 0.8,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: isCardView
              ? const TextStyle(color: Colors.white, fontSize: 10)
              : const TextStyle(color: Colors.white, fontSize: 12),
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    _annotationChartData!.clear();
    super.dispose();
  }
}
