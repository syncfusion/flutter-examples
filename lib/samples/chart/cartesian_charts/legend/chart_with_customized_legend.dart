/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Line Chart with customized legends sample.
class LegendCustomized extends SampleView {
  const LegendCustomized(Key key) : super(key: key);

  @override
  _LegendCustomizedState createState() => _LegendCustomizedState();
}

/// State class of the the Line Chart with customized legends.
class _LegendCustomizedState extends SampleViewState {
  _LegendCustomizedState();

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  List<ChartSampleData>? automobileProductionData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    automobileProductionData = <ChartSampleData>[
      ChartSampleData(
        x: 2005,
        y: 38,
        yValue: 49,
        secondSeriesYValue: 56,
        thirdSeriesYValue: 67,
      ),
      ChartSampleData(
        x: 2006,
        y: 20,
        yValue: 40,
        secondSeriesYValue: 50,
        thirdSeriesYValue: 60,
      ),
      ChartSampleData(
        x: 2007,
        y: 60,
        yValue: 72,
        secondSeriesYValue: 84,
        thirdSeriesYValue: 96,
      ),
      ChartSampleData(
        x: 2008,
        y: 50,
        yValue: 65,
        secondSeriesYValue: 80,
        thirdSeriesYValue: 90,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Automobile production by category',
      ),
      primaryXAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 120,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _buildLineSeries(),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        toggleSeriesVisibility: false,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
              return SizedBox(
                height: 30,
                width: 90,
                child: Row(
                  children: <Widget>[
                    Container(child: _createImage(index)),
                    SizedBox(child: Text(series.name)),
                  ],
                ),
              );
            },
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<CartesianSeries<ChartSampleData, num>> _buildLineSeries() {
    return <CartesianSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: automobileProductionData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'Truck',
        color: const Color.fromRGBO(75, 135, 185, 1),
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartSampleData, num>(
        dataSource: automobileProductionData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        name: 'Car',
        color: const Color.fromRGBO(192, 108, 132, 1),
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartSampleData, num>(
        dataSource: automobileProductionData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Bike',
        color: const Color.fromRGBO(246, 114, 128, 1),
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartSampleData, num>(
        dataSource: automobileProductionData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: 'Bicycle',
        color: const Color.fromRGBO(248, 177, 149, 1),
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  /// Method to create the images for customizing the legends of Chart.
  Image _createImage(int index) {
    final List<Image> images = <Image>[
      Image.asset('images/truck_legend.png'),
      Image.asset('images/car_legend.png'),
      Image.asset('images/bike_legend.png'),
      Image.asset('images/cycle_legend.png'),
    ];
    return images[index];
  }

  @override
  void dispose() {
    automobileProductionData!.clear();
    super.dispose();
  }
}
