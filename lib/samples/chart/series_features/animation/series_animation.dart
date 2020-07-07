/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the cartesian chart with default serie animation sample.
class AnimationDefault extends SampleView {
  const AnimationDefault(Key key) : super(key: key);

  @override
  _AnimationDefaultState createState() => _AnimationDefaultState();
}

/// State class of the cartesian chart with default serie animation.
class _AnimationDefaultState extends SampleViewState {
  _AnimationDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDefaultAnimationChart();
  }

  /// Returns the cartesian chart with default serie animation.
  SfCartesianChart getDefaultAnimationChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales report'),
      legend: Legend(isVisible: isCardView ? false : true),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          minimum: 0,
          interval: isCardView ? 50 : 25,
          maximum: 150,
          majorGridLines: MajorGridLines(width: 0)),
      axes: <ChartAxis>[
        NumericAxis(
          numberFormat: NumberFormat.compact(),
            majorGridLines: MajorGridLines(width: 0),
            opposedPosition: true,
            name: 'yAxis1',
            interval: 1000,
            minimum: 0,
            maximum: 7000)
      ],
      series: getDefaultAnimationSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart which need to render on the cartesian chart.
  List<ChartSeries<ChartSampleData, String>> getDefaultAnimationSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 45, yValue2: 1000),
      ChartSampleData(x: 'Feb', y: 100, yValue2: 3000),
      ChartSampleData(x: 'March', y: 25, yValue2: 1000),
      ChartSampleData(x: 'April', y: 100, yValue2: 7000),
      ChartSampleData(x: 'May', y: 85, yValue2: 5000),
      ChartSampleData(x: 'June', y: 140, yValue2: 7000)
    ];
    return <ChartSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          animationDuration: 2000,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Unit Sold'),
      LineSeries<ChartSampleData, String>(
          animationDuration: 4500,
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          yAxisName: 'yAxis1',
          markerSettings: MarkerSettings(isVisible: true),
          name: 'Total Transaction')
    ];
  }
}
