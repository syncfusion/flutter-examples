import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/helper.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class AnnotationWatermark extends StatefulWidget {
  AnnotationWatermark({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _AnnotationWatermarkState createState() => _AnnotationWatermarkState(sample);
}

class _AnnotationWatermarkState extends State<AnnotationWatermark> {
  _AnnotationWatermarkState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getWatermarkAnnotationChart(false), sample);
  }
}

SfCartesianChart getWatermarkAnnotationChart(bool isTileView) {
  return SfCartesianChart(
      title: ChartTitle(
          text: isTileView ? '' : 'UK social media reach, by platform'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          isVisible: false,
          labelFormat: '{value}%',
          minimum: 0,
          maximum: 120,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0)),
      series: getWatermarkAnnotationSeries(isTileView),
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
            widget: Container(
                height: isTileView ? 100 : 150,
                width: isTileView ? 100 : 150,
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
                              pointColor: const Color.fromRGBO(242, 117, 7, 1)),
                          ChartSampleData(
                              x: 'Instagram',
                              y: 51,
                              xValue: '51%',
                              pointColor: const Color.fromRGBO(89, 59, 84, 1)),
                          ChartSampleData(
                              x: 'Snapchat',
                              y: 50,
                              xValue: '50%',
                              pointColor: const Color.fromRGBO(217, 67, 80, 1)),
                        ],
                        dataLabelMapper: (ChartSampleData data, _) =>
                            data.xValue,
                        xValueMapper: (ChartSampleData data, _) => data.x,
                        yValueMapper: (ChartSampleData data, _) => data.y,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelIntersectAction: LabelIntersectAction.none,
                            textStyle: ChartTextStyle(
                                color: Colors.white,
                                fontSize: isTileView ? 10 : 12)),
                        pointColorMapper: (ChartSampleData data, _) =>
                            data.pointColor)
                  ],
                )),
            coordinateUnit: CoordinateUnit.point,
            region: AnnotationRegion.chart,
            x: 'Instagram',
            y: isTileView ? 85 : 80)
      ]);
}

List<ColumnSeries<ChartSampleData, String>> getWatermarkAnnotationSeries(
    bool isTileView) {
  final dynamic chartData = <ChartSampleData>[
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
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        width: 0.8,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: ChartTextStyle(
                color: Colors.white, fontSize: isTileView ? 10 : 12),
            labelAlignment: ChartDataLabelAlignment.top)),
  ];
}
