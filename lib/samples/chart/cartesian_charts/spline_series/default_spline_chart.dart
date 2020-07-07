/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the defaul spline chart sample.
class SplineDefault extends SampleView {
  const SplineDefault(Key key) : super(key: key);

  @override
  _SplineDefaultState createState() => _SplineDefaultState();
}

/// State class of the default spline chart.
class _SplineDefaultState extends SampleViewState {
  _SplineDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDefaultSplineChart();
  }

  /// Returns the defaul spline chart.
  SfCartesianChart getDefaultSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Average high/low temperature of London'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 30,
          maximum: 80,
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}°F',
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<ChartSampleData, String>> getDefaultSplineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 43, yValue2: 37, yValue3: 41),
      ChartSampleData(x: 'Feb', y: 45, yValue2: 37, yValue3: 45),
      ChartSampleData(x: 'Mar', y: 50, yValue2: 39, yValue3: 48),
      ChartSampleData(x: 'Apr', y: 55, yValue2: 43, yValue3: 52),
      ChartSampleData(x: 'May', y: 63, yValue2: 48, yValue3: 57),
      ChartSampleData(x: 'Jun', y: 68, yValue2: 54, yValue3: 61),
      ChartSampleData(x: 'Jul', y: 72, yValue2: 57, yValue3: 66),
      ChartSampleData(x: 'Aug', y: 70, yValue2: 57, yValue3: 66),
      ChartSampleData(x: 'Sep', y: 66, yValue2: 54, yValue3: 63),
      ChartSampleData(x: 'Oct', y: 57, yValue2: 48, yValue3: 55),
      ChartSampleData(x: 'Nov', y: 50, yValue2: 43, yValue3: 50),
      ChartSampleData(x: 'Dec', y: 45, yValue2: 37, yValue3: 45)
    ];
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'High',
      ),
      SplineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        name: 'Low',
        markerSettings: MarkerSettings(isVisible: true),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      )
    ];
  }
}
