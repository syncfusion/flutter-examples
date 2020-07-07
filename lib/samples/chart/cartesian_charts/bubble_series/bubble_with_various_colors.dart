import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BubblePointColor extends StatefulWidget {
  BubblePointColor({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BubblePointColorState createState() => _BubblePointColorState(sample);
}

class _BubblePointColorState extends State<BubblePointColor> {
  _BubblePointColorState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getPointColorBubbleChart(false), sample);
  }
}

SfCartesianChart getPointColorBubbleChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Countries by area'),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.rotate45),
    primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(text: isTileView ? '' : 'Area(km²)'),
        axisLine: AxisLine(width: 0),
        minimum: 650000,
        maximum: 1500000,
        rangePadding: ChartRangePadding.additional,
        majorTickLines: MajorTickLines(size: 0)),
    series: getPointColorBubbleSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        textAlignment: ChartAlignment.near,
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'Country : point.x\nArea : point.y km²'),
  );
}

List<BubbleSeries<ChartSampleData, String>> getPointColorBubbleSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'Namibia',
        y: 825615,
        size: 0.37,
        pointColor: const Color.fromRGBO(123, 180, 235, 1)),
    ChartSampleData(
        x: 'Angola',
        y: 1246700,
        size: 0.84,
        pointColor: const Color.fromRGBO(53, 124, 210, 1)),
    ChartSampleData(
        x: 'Tanzania',
        y: 945087,
        size: 0.64,
        pointColor: const Color.fromRGBO(221, 138, 189, 1)),
    ChartSampleData(
        x: 'Egypt',
        y: 1002450,
        size: 0.68,
        pointColor: const Color.fromRGBO(248, 184, 131, 1)),
    ChartSampleData(
        x: 'Nigeria',
        y: 923768,
        size: 0.62,
        pointColor: const Color.fromRGBO(112, 173, 71, 1)),
    ChartSampleData(
        x: 'Peru',
        y: 1285216,
        size: 0.87,
        pointColor: const Color.fromRGBO(0, 189, 174, 1)),
    ChartSampleData(
        x: 'Ethiopia',
        y: 1104300,
        size: 0.74,
        pointColor: const Color.fromRGBO(229, 101, 144, 1)),
    ChartSampleData(
        x: 'Venezuela',
        y: 916445,
        size: 0.62,
        pointColor: const Color.fromRGBO(127, 132, 232, 1)),
    ChartSampleData(
        x: 'Niger',
        y: 1267000,
        size: 0.85,
        pointColor: const Color.fromRGBO(160, 81, 149, 1)),
    ChartSampleData(
        x: 'Turkey',
        y: 783562,
        size: 0.53,
        pointColor: const Color.fromRGBO(234, 122, 87, 1)),
  ];
  return <BubbleSeries<ChartSampleData, String>>[
    BubbleSeries<ChartSampleData, String>(
      dataSource: chartData,
      opacity: 0.8,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
      sizeValueMapper: (ChartSampleData sales, _) => sales.size,
    )
  ];
}
