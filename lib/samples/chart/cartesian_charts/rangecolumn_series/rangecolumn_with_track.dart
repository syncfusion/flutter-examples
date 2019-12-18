import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class RangeColumnWithTrack extends StatefulWidget {
  RangeColumnWithTrack({this.sample, Key key}) : super(key: key);  
  SubItem sample;

  @override
  _RangeColumnWithTrackState createState() =>
      _RangeColumnWithTrackState(sample);
}

class _RangeColumnWithTrackState extends State<RangeColumnWithTrack> {
  _RangeColumnWithTrackState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRangeColumnwithTrack(false),sample);
  }
}



SfCartesianChart getRangeColumnwithTrack(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Meeting timings of an employee'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        minimum: 1,
        maximum: 10,
        labelFormat: '{value} PM',
        majorTickLines: MajorTickLines(size: 0)),
    series: getRangeColumnSerieswithTrack(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<RangeColumnSeries<ChartSampleData, String>> getRangeColumnSerieswithTrack(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x:'Day 1', y:3, yValue:5),
    ChartSampleData(x:'Day 2', y:4, yValue:7),
    ChartSampleData(x:'Day 3', y:4, yValue:8),
    ChartSampleData(x:'Day 4', y:2, yValue:5),
    ChartSampleData(x:'Day 5', y:5, yValue:7),
  ];
  return <RangeColumnSeries<ChartSampleData, String>>[
    RangeColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        isTrackVisible: true,
        trackColor: const Color.fromRGBO(198, 201, 207, 1),
        borderRadius: BorderRadius.circular(15),
        trackBorderColor: Colors.grey[100],
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: !isTileView, labelAlignment: ChartDataLabelAlignment.top))
  ];
}
