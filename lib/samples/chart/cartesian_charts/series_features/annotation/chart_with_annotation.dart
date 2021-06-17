/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with annotation sample.
class AnnotationWatermark extends SampleView {
  /// Creates the chart with annotation sample.
  const AnnotationWatermark(Key key) : super(key: key);

  @override
  _AnnotationWatermarkState createState() => _AnnotationWatermarkState();
}

/// State class of the chart with annotation.
class _AnnotationWatermarkState extends SampleViewState {
  _AnnotationWatermarkState();

  @override
  Widget build(BuildContext context) {
    return _buildWatermarkAnnotationChart();
  }

  /// Returns the Cartesian chart with annotation.
  SfCartesianChart _buildWatermarkAnnotationChart() {
    final bool needSmallAnnotation =
        model.isWebFullView && MediaQuery.of(context).size.height < 530;
    return SfCartesianChart(
        title: ChartTitle(
            text: isCardView ? '' : 'UK social media reach, by platform'),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            isVisible: false,
            labelFormat: '{value}%',
            minimum: 0,
            maximum: 120,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(width: 0)),
        series: _getWatermarkAnnotationSeries(),

        /// To set the annotation content for chart.
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Container(
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
                          enableSmartLabels: false,
                          dataSource: <ChartSampleData>[
                            ChartSampleData(
                                x: 'Facebook',
                                y: 90,
                                xValue: '90%',
                                pointColor: const Color.fromRGBO(0, 63, 92, 1)),
                            ChartSampleData(
                                x: 'Twitter',
                                y: 60,
                                xValue: '60%',
                                pointColor:
                                    const Color.fromRGBO(242, 117, 7, 1)),
                            ChartSampleData(
                                x: 'Instagram',
                                y: 51,
                                xValue: '51%',
                                pointColor:
                                    const Color.fromRGBO(89, 59, 84, 1)),
                            ChartSampleData(
                                x: 'Snapchat',
                                y: 50,
                                xValue: '50%',
                                pointColor:
                                    const Color.fromRGBO(217, 67, 80, 1)),
                          ],
                          dataLabelMapper: (ChartSampleData data, _) =>
                              data.xValue as String,
                          xValueMapper: (ChartSampleData data, _) =>
                              data.x as String,
                          yValueMapper: (ChartSampleData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelIntersectAction: LabelIntersectAction.none,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: isCardView
                                      ? 10
                                      : needSmallAnnotation
                                          ? 7
                                          : 12)),
                          pointColorMapper: (ChartSampleData data, _) =>
                              data.pointColor)
                    ],
                  )),
              coordinateUnit: CoordinateUnit.point,
              region: AnnotationRegion.chart,
              x: 'Instagram',
              y: isCardView ? 85 : 80)
        ]);
  }

  /// Returns the list of series which need to
  /// render on the chart with annotation.
  List<ColumnSeries<ChartSampleData, String>> _getWatermarkAnnotationSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Facebook',
          y: 90,
          xValue: '90',
          pointColor: const Color.fromRGBO(0, 63, 92, 1)),
      ChartSampleData(
          x: 'Twitter',
          y: 60,
          xValue: '60',
          pointColor: const Color.fromRGBO(242, 117, 7, 1)),
      ChartSampleData(
          x: 'Instagram',
          y: 51,
          xValue: '51',
          pointColor: const Color.fromRGBO(89, 59, 84, 1)),
      ChartSampleData(
          x: 'Snapchat',
          y: 50,
          xValue: '50',
          pointColor: const Color.fromRGBO(217, 67, 80, 1)),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.8,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: isCardView
                  ? const TextStyle(color: Colors.white, fontSize: 10)
                  : const TextStyle(color: Colors.white, fontSize: 12),
              labelAlignment: ChartDataLabelAlignment.top)),
    ];
  }
}
