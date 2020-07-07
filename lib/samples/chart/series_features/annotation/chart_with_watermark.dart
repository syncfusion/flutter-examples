import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class AnnotationDefault extends StatefulWidget {
  AnnotationDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _AnnotationDefaultState createState() => _AnnotationDefaultState(sample);
}

class _AnnotationDefaultState extends State<AnnotationDefault> {
  _AnnotationDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultAnnotationChart(false), sample);
  }
}

SfCartesianChart getDefaultAnnotationChart(bool isTileView,
    [Brightness currentTheme]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView
            ? ''
            : 'Euro to USD monthly exchange rate - 2015 to 2018'),
    primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0),
    minimum: DateTime(2015, 1, 1),
    maximum: DateTime(2019, 1, 1),
    intervalType: DateTimeIntervalType.years),
    primaryYAxis: NumericAxis(
      axisLine: AxisLine(width: 0),
      labelFormat: '\${value}',
      minimum: 0.95,
      maximum: 1.3,
      majorTickLines: MajorTickLines(size: 0),
    ),
    series: getAnnotationLineSeries(isTileView),
    trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: InteractiveTooltip(format: 'point.x : point.y')),
    annotations: <CartesianChartAnnotation>[
      CartesianChartAnnotation(
        widget: Container(
          child: const Text(
            '€ - \$ ',
            style: TextStyle(
                color: Color.fromRGBO(216, 225, 227, 1),
                // color: currentTheme == Brightness.light? const Color.fromRGBO(0, 0, 0, 0.15) : Color.fromRGBO(255, 255, 255, 0.3),
                fontWeight: FontWeight.bold,
                fontSize: 80),
          ),
        ),
        coordinateUnit: CoordinateUnit.point,
        region: AnnotationRegion.chart,
        x: DateTime(2016, 11, 1),
        y: 1.12,
      )
    ],
  );
}

List<LineSeries<ChartSampleData, DateTime>> getAnnotationLineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2015, 1, 1), y: 1.13),
    ChartSampleData(x: DateTime(2015, 2, 1), y: 1.12),
    ChartSampleData(x: DateTime(2015, 3, 1), y: 1.08),
    ChartSampleData(x: DateTime(2015, 4, 1), y: 1.12),
    ChartSampleData(x: DateTime(2015, 5, 1), y: 1.1),
    ChartSampleData(x: DateTime(2015, 6, 1), y: 1.12),
    ChartSampleData(x: DateTime(2015, 7, 1), y: 1.1),
    ChartSampleData(x: DateTime(2015, 8, 1), y: 1.12),
    ChartSampleData(x: DateTime(2015, 9, 1), y: 1.12),
    ChartSampleData(x: DateTime(2015, 10, 1), y: 1.1),
    ChartSampleData(x: DateTime(2015, 11, 1), y: 1.06),
    ChartSampleData(x: DateTime(2015, 12, 1), y: 1.09),
    ChartSampleData(x: DateTime(2016, 1, 1), y: 1.09),
    ChartSampleData(x: DateTime(2016, 2, 1), y: 1.09),
    ChartSampleData(x: DateTime(2016, 3, 1), y: 1.14),
    ChartSampleData(x: DateTime(2016, 4, 1), y: 1.14),
    ChartSampleData(x: DateTime(2016, 5, 1), y: 1.12),
    ChartSampleData(x: DateTime(2016, 6, 1), y: 1.11),
    ChartSampleData(x: DateTime(2016, 7, 1), y: 1.11),
    ChartSampleData(x: DateTime(2016, 8, 1), y: 1.11),
    ChartSampleData(x: DateTime(2016, 9, 1), y: 1.12),
    ChartSampleData(x: DateTime(2016, 10, 1), y: 1.1),
    ChartSampleData(x: DateTime(2016, 11, 1), y: 1.08),
    ChartSampleData(x: DateTime(2016, 12, 1), y: 1.05),
    ChartSampleData(x: DateTime(2017, 1, 1), y: 1.08),
    ChartSampleData(x: DateTime(2017, 2, 1), y: 1.06),
    ChartSampleData(x: DateTime(2017, 3, 1), y: 1.07),
    ChartSampleData(x: DateTime(2017, 4, 1), y: 1.09),
    ChartSampleData(x: DateTime(2017, 5, 1), y: 1.12),
    ChartSampleData(x: DateTime(2017, 6, 1), y: 1.14),
    ChartSampleData(x: DateTime(2017, 7, 1), y: 1.17),
    ChartSampleData(x: DateTime(2017, 8, 1), y: 1.18),
    ChartSampleData(x: DateTime(2017, 9, 1), y: 1.18),
    ChartSampleData(x: DateTime(2017, 10, 1), y: 1.16),
    ChartSampleData(x: DateTime(2017, 11, 1), y: 1.18),
    ChartSampleData(x: DateTime(2017, 12, 1), y: 1.2),
    ChartSampleData(x: DateTime(2018, 1, 1), y: 1.25),
    ChartSampleData(x: DateTime(2018, 2, 1), y: 1.22),
    ChartSampleData(x: DateTime(2018, 3, 1), y: 1.23),
    ChartSampleData(x: DateTime(2018, 4, 1), y: 1.21),
    ChartSampleData(x: DateTime(2018, 5, 1), y: 1.17),
    ChartSampleData(x: DateTime(2018, 6, 1), y: 1.17),
    ChartSampleData(x: DateTime(2018, 7, 1), y: 1.17),
    ChartSampleData(x: DateTime(2018, 8, 1), y: 1.17),
    ChartSampleData(x: DateTime(2018, 9, 1), y: 1.16),
    ChartSampleData(x: DateTime(2018, 10, 1), y: 1.13),
    ChartSampleData(x: DateTime(2018, 11, 1), y: 1.14),
    ChartSampleData(x: DateTime(2018, 12, 1), y: 1.15),
    ChartSampleData(x: DateTime(2019, 1, 1), y: 1.17)
    ];
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      color: const Color.fromRGBO(242, 117, 7, 1),
    )
  ];
}
