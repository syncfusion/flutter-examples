/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart
/// with empty points sample.
class PointColorMapper extends SampleView {
  /// Creates the column series chart with empty points sample.
  const PointColorMapper(Key key) : super(key: key);

  @override
  _PointColorMapperState createState() => _PointColorMapperState();
}

/// State class for the column series chart with empty points.
class _PointColorMapperState extends SampleViewState {
  _PointColorMapperState();
  TooltipBehavior? _tooltipBehavior;

  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 4.3),
      ChartSampleData(x: 'Feb', y: 5.2),
      ChartSampleData(x: 'Mar', y: 6.7),
      ChartSampleData(x: 'Apr', y: 9.4),
      ChartSampleData(x: 'May', y: 12.7),
      ChartSampleData(x: 'Jun', y: 15.7),
      ChartSampleData(x: 'Jul', y: 17.8),
      ChartSampleData(x: 'Aug', y: 17),
      ChartSampleData(x: 'Sep', y: 15),
      ChartSampleData(x: 'Oct', y: 11.8),
      ChartSampleData(x: 'Nov', y: 7.8),
      ChartSampleData(x: 'Dec', y: 5.3),
    ];
    super.initState();
  }

  Color? _determinePointColorByValue(num? value) {
    Color? color;
    if (value! < 4.5) {
      color = const Color.fromRGBO(252, 238, 160, 1);
    } else if (value > 4.5 && value < 5.5) {
      color = const Color.fromRGBO(250, 230, 120, 1);
    } else if (value >= 5.5 && value < 9.5) {
      color = const Color.fromRGBO(247, 203, 90, 1);
    } else if (value > 9.5 && value < 12.5) {
      color = const Color.fromRGBO(237, 162, 0, 1);
    } else if (value > 12.5 && value < 13.5) {
      color = const Color.fromRGBO(221, 146, 0, 1);
    } else if (value > 13.5 && value < 15.5) {
      color = const Color.fromRGBO(228, 133, 22, 1);
    } else if (value > 15.5 && value < 16.5) {
      color = const Color.fromRGBO(212, 102, 0, 1);
    } else if (value > 13.5 && value < 16.5) {
      color = const Color.fromRGBO(182, 87, 0, 1);
    } else if (value > 16.5 && value < 17.5) {
      color = const Color.fromRGBO(182, 87, 0, 1);
    } else if (value > 17.5 && value < 18.5) {
      color = const Color.fromRGBO(173, 66, 16, 1);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: model.isWebFullView ? 0 : 60),
      child: _buildPointColorMapperChart(),
    );
  }

  /// Returns the cartesian column chart with point color mapper.
  SfCartesianChart _buildPointColorMapperChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Average monthly temperature of London'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}°C',
        minimum: 0,
        maximum: 25,
        interval: model.isWeb ? 5 : 10,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<CartesianSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'London',
        pointColorMapper: (ChartSampleData data, int index) =>
            _determinePointColorByValue(data.y),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
