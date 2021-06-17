/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the line chart with customized legends sample.
class LegendCustomized extends SampleView {
  /// Creates the line chart with customized legends sample.
  const LegendCustomized(Key key) : super(key: key);

  @override
  _LegendCustomizedState createState() => _LegendCustomizedState();
}

/// State class of the the line chart with customized legends.
class _LegendCustomizedState extends SampleViewState {
  _LegendCustomizedState();

  @override
  Widget build(BuildContext context) {
    return _buildLegendCustomizedChart();
  }

  /// Returns the line chart with customized legends.
  SfCartesianChart _buildLegendCustomizedChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Automobile production by category'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        toggleSeriesVisibility: false,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return Container(
              height: 30,
              width: 90,
              child: Row(children: <Widget>[
                Container(child: _getImage(index)),
                Container(child: Text(series.name)),
              ]));
        },
      ),
      primaryXAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          interval: 1),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 120,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getLegendCustomizedSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the line chart.
  List<ChartSeries<ChartSampleData, num>> _getLegendCustomizedSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 2005,
          y: 38,
          yValue: 49,
          secondSeriesYValue: 56,
          thirdSeriesYValue: 67),
      ChartSampleData(
          x: 2006,
          y: 20,
          yValue: 40,
          secondSeriesYValue: 50,
          thirdSeriesYValue: 60),
      ChartSampleData(
          x: 2007,
          y: 60,
          yValue: 72,
          secondSeriesYValue: 84,
          thirdSeriesYValue: 96),
      ChartSampleData(
          x: 2008,
          y: 50,
          yValue: 65,
          secondSeriesYValue: 80,
          thirdSeriesYValue: 90),
    ];
    return <ChartSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as num,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Truck',
      ),
      LineSeries<ChartSampleData, num>(
          markerSettings: const MarkerSettings(isVisible: true),
          width: 2,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Car'),
      LineSeries<ChartSampleData, num>(
          markerSettings: const MarkerSettings(isVisible: true),
          width: 2,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Bike'),
      LineSeries<ChartSampleData, num>(
          markerSettings: const MarkerSettings(isVisible: true),
          width: 2,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Bicycle')
    ];
  }

  /// Method to get the images for customizing the legends of line chart series.
  Image _getImage(int index) {
    final List<Image> images = <Image>[
      Image.asset('images/truck_legend.png'),
      Image.asset('images/car_legend.png'),
      Image.asset('images/bike_legend.png'),
      Image.asset('images/cycle_legend.png')
    ];
    return images[index];
  }
}
