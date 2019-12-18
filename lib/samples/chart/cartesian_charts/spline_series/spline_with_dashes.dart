import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class SplineDashed extends StatefulWidget {
  SplineDashed({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SplineDashedState createState() => _SplineDashedState(sample);
}

class _SplineDashedState extends State<SplineDashed> {
  _SplineDashedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://tcdata360.worldbank.org/indicators/inv.all.pct?country=BRA&indicator=345&countries=GRC,SWE&viz=line_chart&years=1997,2004';
    const String source = 'tcdata360.worldbank.org';
    return getScopedModel(
        getDashedSplineChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDashedSplineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Total investment (% of GDP)'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
      minimum: 16,
      maximum: 28,
      interval: 4,
      labelFormat: '{value}%',
      axisLine: AxisLine(width: 0),
    ),
    series: getDashedSplineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<SplineSeries<ChartSampleData, num>> getDashedSplineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 1997, y: 17.79, yValue2: 20.32, yValue3: 22.44),
    ChartSampleData(x: 1998, y: 18.20, yValue2: 21.46, yValue3: 25.18),
    ChartSampleData(x: 1999, y: 17.44, yValue2: 21.72, yValue3: 24.15),
    ChartSampleData(x: 2000, y: 19, yValue2: 22.86, yValue3: 25.83),
    ChartSampleData(x: 2001, y: 18.93, yValue2: 22.87, yValue3: 25.69),
    ChartSampleData(x: 2002, y: 17.58, yValue2: 21.87, yValue3: 24.75),
    ChartSampleData(x: 2003, y: 16.83, yValue2: 21.67, yValue3: 27.38),
    ChartSampleData(x: 2004, y: 17.93, yValue2: 21.65, yValue3: 25.31)
  ];
  return <SplineSeries<ChartSampleData, num>>[
    SplineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        name: 'Brazil',
        dashArray: <double>[12, 3, 3, 3],
        markerSettings: MarkerSettings(isVisible: true)),
    SplineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        name: 'Sweden',
        dashArray: <double>[12, 3, 3, 3],
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        markerSettings: MarkerSettings(isVisible: true)),
    SplineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        dashArray: <double>[12, 3, 3, 3],
        name: 'Greece',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}
