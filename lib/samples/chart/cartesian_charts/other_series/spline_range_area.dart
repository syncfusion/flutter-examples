/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

class SplineRangeArea extends SampleView {
  const SplineRangeArea(Key key) : super(key: key);
  
  @override
  _SplineRangeAreaState createState() => _SplineRangeAreaState();
}

class _SplineRangeAreaState extends SampleViewState {
  _SplineRangeAreaState();

  @override
  Widget build(BuildContext context) {
    return getSplineRangeAreaChart();
  }

SfCartesianChart getSplineRangeAreaChart() {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isCardView ? '' : 'Product price comparison'),
    legend: Legend(isVisible: isCardView ? false : true),
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks),
    primaryYAxis: NumericAxis(
        minimum: isCardView ? 5 : 0,
        maximum: isCardView ? 55 : 60,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
        majorTickLines: MajorTickLines(size: 0)),
    series: getSplineAreaSeries(isCardView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

/// Returns the list of chart series which need to render on the spline range area chart.
List<SplineRangeAreaSeries<ChartSampleData, String>> getSplineAreaSeries(
    bool isCardView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 45, yValue:32, yValue2: 30, yValue3: 18),
    ChartSampleData(x: 'Feb', y: 48, yValue:34, yValue2: 24, yValue3: 12),
    ChartSampleData(x: 'Mar', y: 46, yValue:32, yValue2: 29, yValue3: 15),
    ChartSampleData(x: 'Apr', y: 48, yValue:36, yValue2: 24, yValue3: 10),
    ChartSampleData(x: 'May', y: 46, yValue:32, yValue2: 30, yValue3: 18),
    ChartSampleData(x: 'Jun', y: 49, yValue:34, yValue2: 24, yValue3: 10)
  ];
  return <SplineRangeAreaSeries<ChartSampleData, String>>[
    SplineRangeAreaSeries<ChartSampleData, String>(
      dataSource: chartData,
      color: const Color.fromRGBO(75, 135, 185, 0.5),
      borderColor: const Color.fromRGBO(75, 135, 185, 1),
      borderWidth: 3,
      borderDrawMode: RangeAreaBorderMode.excludeSides,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      highValueMapper: (ChartSampleData sales, _) => sales.y,
      lowValueMapper: (ChartSampleData sales, _) => sales.yValue,
      name: 'Product A',
    ),
     SplineRangeAreaSeries<ChartSampleData, String>(
      dataSource: chartData,
      borderColor: const Color.fromRGBO(192, 108, 132, 1),
      color: const Color.fromRGBO(192, 108, 132,0.5),
      borderWidth: 3,
      borderDrawMode: RangeAreaBorderMode.excludeSides,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      highValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      lowValueMapper: (ChartSampleData sales, _) => sales.yValue3,
      name: 'Product B',
    )
  ];
}
}