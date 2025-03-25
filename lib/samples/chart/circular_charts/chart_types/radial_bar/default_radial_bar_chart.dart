/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the default radial bar series chart.
class RadialBarDefault extends SampleView {
  /// Creates the default radial bar series chart.
  const RadialBarDefault(Key key) : super(key: key);

  @override
  _RadialBarDefaultState createState() => _RadialBarDefaultState();
}

/// State class for the default radial bar series chart.
class _RadialBarDefaultState extends SampleViewState {
  _RadialBarDefaultState();
  late List<ChartSampleData> _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.ym',
    );
    _chartData = [
      ChartSampleData(
        x: 'John',
        y: 10,
        text: '100%',
        pointColor: const Color.fromRGBO(248, 177, 149, 1.0),
      ),
      ChartSampleData(
        x: 'Almaida',
        y: 11,
        text: '100%',
        pointColor: const Color.fromRGBO(246, 114, 128, 1.0),
      ),
      ChartSampleData(
        x: 'Don',
        y: 12,
        text: '100%',
        pointColor: const Color.fromRGBO(61, 205, 171, 1.0),
      ),
      ChartSampleData(
        x: 'Tom',
        y: 13,
        text: '100%',
        pointColor: const Color.fromRGBO(1, 174, 190, 1.0),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultRadialBarChart();
  }

  /// Returns the circular chart with radial bar series.
  SfCircularChart _buildDefaultRadialBarChart() {
    return SfCircularChart(
      key: GlobalKey(),
      title: ChartTitle(text: isCardView ? '' : 'Shot put distance'),
      series: _buildRadialBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the default radial bar series.
  List<RadialBarSeries<ChartSampleData, String>> _buildRadialBarSeries() {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index_) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        pointRadiusMapper: (ChartSampleData data, int index) => data.text,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
        maximumValue: 15,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10.0),
        ),
        cornerStyle: CornerStyle.bothCurve,
        gap: '10%',
        radius: '90%',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
