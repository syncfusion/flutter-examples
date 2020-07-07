/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with various marker shapes sample.
class MarkerDefault extends SampleView {
  const MarkerDefault(Key key) : super(key: key);

  @override
  _MarkerDefaultState createState() => _MarkerDefaultState();
}

/// State class of the chart with various marker shapes.
class _MarkerDefaultState extends SampleViewState {
  _MarkerDefaultState();

  @override
  Widget build(BuildContext context) {
    return getMarkerDefaultChart();
  }

  /// Returns the chart with various marker shapes.
  SfCartesianChart getMarkerDefaultChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Vehicles crossed tollgate'),
      legend: Legend(isVisible: isCardView ? false : true),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        dateFormat: DateFormat.Hm(),
        title: AxisTitle(text: isCardView ? '' : 'Time'),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Count'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getMarkeSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart which need to render on the chart with various marker shapes.
  List<LineSeries<ChartSampleData, DateTime>> getMarkeSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2018, 3, 1, 8, 0), y: 60, yValue2: 28, yValue3: 15),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 8, 30), y: 49, yValue2: 40, yValue3: 28),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 9, 0), y: 70, yValue2: 32, yValue3: 16),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 9, 30), y: 56, yValue2: 36, yValue3: 66),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 10, 0), y: 66, yValue2: 50, yValue3: 26),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 10, 30), y: 50, yValue2: 35, yValue3: 14),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 11, 0), y: 55, yValue2: 32, yValue3: 20),
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        name: 'Truck',
        markerSettings: MarkerSettings(
            isVisible: true,
            /// To return the marker shape to marker settings.
            shape: DataMarkerType.pentagon,
            image: const AssetImage('images/truck.png')),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Bike',
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.triangle),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Car',
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.rectangle),
      )
    ];
  }
}
