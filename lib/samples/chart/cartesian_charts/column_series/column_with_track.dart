import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ColumnTracker extends StatefulWidget {
  ColumnTracker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ColumnTrackerState createState() => _ColumnTrackerState(sample);
}

class _ColumnTrackerState extends State<ColumnTracker> {
  _ColumnTrackerState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getTrackerColumnChart(false),sample); 
  }
}


SfCartesianChart getTrackerColumnChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Marks of a student'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        axisLine: AxisLine(width: 0),
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getTracker(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'point.y marks in point.x'),
  );
}

List<ColumnSeries<ChartSampleData, String>> getTracker(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x:'Subject 1',y: 71),
    ChartSampleData(x:'Subject 2',y: 84),
    ChartSampleData(x:'Subject 3', y:48),
    ChartSampleData(x:'Subject 4', y:80),
    ChartSampleData(x:'Subject 5', y: 76),
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        isTrackVisible: true,
        trackColor:const Color.fromRGBO(198, 201, 207, 1),
        borderRadius: BorderRadius.circular(15),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Marks',
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: ChartTextStyle(fontSize: 10, color: Colors.white)))
  ];
}

