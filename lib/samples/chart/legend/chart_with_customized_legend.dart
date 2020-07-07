import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class LegendCustomized extends StatefulWidget {
  LegendCustomized({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LegendCustomizedState createState() => _LegendCustomizedState(sample);
}

class _LegendCustomizedState extends State<LegendCustomized> {
  _LegendCustomizedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getLegendCustomizedChart(false), sample);
  }
}

SfCartesianChart getLegendCustomizedChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title:
        ChartTitle(text: isTileView ? '' : 'Automobile production by category'),
    legend: Legend(
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap,
      legendItemBuilder:
          (String name, dynamic series, dynamic point, int index) {
        return Container(
            height: 30,
            width: 90,
            child: Row(children: <Widget>[
              Container(child: getImage(index)),
              Container(child: Text(series.name)),
            ]));
      },
    ),
    primaryXAxis: NumericAxis(
        minimum: 2005,
        maximum: 2008,
        interval: 1,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 120,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent)),
    series: getLegendCustomizedSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

dynamic getImage(int index) {
  final dynamic images = <dynamic>[
    Image.asset('images/truck_legend.png'),
    Image.asset('images/car_legend.png'),
    Image.asset('images/bike_legend.png'),
    Image.asset('images/cycle_legend.png')
  ];
  return images[index];
}

List<ChartSeries<ChartSampleData, num>> getLegendCustomizedSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2005, y: 38, yValue: 49, yValue2: 56, yValue3: 67),
    ChartSampleData(x: 2006, y: 20, yValue: 40, yValue2: 50, yValue3: 60),
    ChartSampleData(x: 2007, y: 60, yValue: 72, yValue2: 84, yValue3: 96),
    ChartSampleData(x: 2008, y: 50, yValue: 65, yValue2: 80, yValue3: 90),
  ];
  return <ChartSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
      width: 2,
      markerSettings: MarkerSettings(isVisible: true),
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      name: 'Truck',
    ),
    LineSeries<ChartSampleData, num>(
        markerSettings: MarkerSettings(isVisible: true),
        width: 2,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Car'),
    LineSeries<ChartSampleData, num>(
        markerSettings: MarkerSettings(isVisible: true),
        width: 2,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Bike'),
    LineSeries<ChartSampleData, num>(
        markerSettings: MarkerSettings(isVisible: true),
        width: 2,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Bicycle')
  ];
}
