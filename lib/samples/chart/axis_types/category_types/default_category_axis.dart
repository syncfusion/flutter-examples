import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class CategoryDefault extends StatefulWidget {
  CategoryDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _CategoryDefaultState createState() => _CategoryDefaultState(sample);
}

class _CategoryDefaultState extends State<CategoryDefault> {
  _CategoryDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultCategoryAxisChart(false), sample);
  }
}

SfCartesianChart getDefaultCategoryAxisChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Internet Users - 2016'),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        minimum: 0, maximum: 80, isVisible: false, labelFormat: '{value}M'),
    series: getDefaultCategory(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, String>> getDefaultCategory(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'South\nKorea', yValue: 39, pointColor: Colors.teal[300]),
    ChartSampleData(
        x: 'India',
        yValue: 20,
        pointColor: const Color.fromRGBO(53, 124, 210, 1)),
    ChartSampleData(x: 'South\nAfrica', yValue: 61, pointColor: Colors.pink),
    ChartSampleData(x: 'China', yValue: 65, pointColor: Colors.orange),
    ChartSampleData(x: 'France', yValue: 45, pointColor: Colors.green),
    ChartSampleData(
        x: 'Saudi\nArabia', yValue: 10, pointColor: Colors.pink[300]),
    ChartSampleData(x: 'Japan', yValue: 16, pointColor: Colors.purple[300]),
    ChartSampleData(
        x: 'Mexico',
        yValue: 31,
        pointColor: const Color.fromRGBO(127, 132, 232, 1))
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.yValue,
      pointColorMapper: (ChartSampleData data, _) => data.pointColor,
      dataLabelSettings: DataLabelSettings(isVisible: true),
    )
  ];
}
