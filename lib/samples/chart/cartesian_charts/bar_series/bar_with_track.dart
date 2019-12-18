import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarTracker extends StatefulWidget {
  BarTracker({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarTrackerState createState() => _BarTrackerState(sample);
}

class _BarTrackerState extends State<BarTracker> {
  _BarTrackerState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getTrackerBarChart(false), sample);
  }
}

SfCartesianChart getTrackerBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Working hours of employees'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        title: AxisTitle(text: isTileView ? '' : 'Hours'),
        minimum: 0,
        maximum: 8,
        majorTickLines: MajorTickLines(size: 0)),
    series: getTrackerBarSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<BarSeries<ChartSampleData, String>> getTrackerBarSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Mike', y: 7.5),
    ChartSampleData(x: 'Chris', y: 7),
    ChartSampleData(x: 'Helana', y: 6),
    ChartSampleData(x: 'Tom', y: 5),
    ChartSampleData(x: 'Federer', y: 7),
    ChartSampleData(x: 'Hussain', y: 7),
  ];
  return <BarSeries<ChartSampleData, String>>[
    BarSeries<ChartSampleData, String>(
      dataSource: chartData,
      borderRadius: BorderRadius.circular(15),
      trackColor: const Color.fromRGBO(198, 201, 207, 1),
      isTrackVisible: true,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];
}
