/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the pie series chart with grouping data points.
class PieGrouping extends SampleView {
  /// Creates the pie series chart with grouping data points.
  const PieGrouping(Key key) : super(key: key);

  @override
  _PieGroupingState createState() => _PieGroupingState();
}

/// State class for the pie series chart with grouping data points.
class _PieGroupingState extends SampleViewState {
  _PieGroupingState();
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(x: 'Coal', y: 56.2, text: 'Coal: 200,704.5 MW (56.2%)'),
      ChartSampleData(
        x: 'Large\nHydro',
        y: 12.7,
        text: 'Large Hydro: 45,399.22 MW (12.7%)',
      ),
      ChartSampleData(
        x: 'Small\nHydro',
        y: 1.3,
        text: 'Small Hydro: 4,594.15 MW (1.3%)',
      ),
      ChartSampleData(
        x: 'Wind\nPower',
        y: 10,
        text: 'Wind Power: 35,815.88 MW (10.0%)',
      ),
      ChartSampleData(
        x: 'Solar\nPower',
        y: 8,
        text: 'Solar Power: 28,679.21 MW (8.0%)',
      ),
      ChartSampleData(
        x: 'Biomass',
        y: 2.6,
        text: 'Biomass: 9,269.8 MW (2.6%)',
        pointColor: const Color.fromRGBO(198, 201, 207, 1),
      ),
      ChartSampleData(
        x: 'Nuclear',
        y: 1.9,
        text: 'Nuclear: 6,780 MW (1.9%)',
        pointColor: const Color.fromRGBO(198, 201, 207, 1),
      ),
      ChartSampleData(
        x: 'Gas',
        y: 7,
        text: 'Gas: 24,937.22 MW (7.0%)',
        pointColor: const Color.fromRGBO(198, 201, 207, 1),
      ),
      ChartSampleData(
        x: 'Diesel',
        y: 0.3,
        text: 'Diesel: 637.63 MW (0.2%)',
        pointColor: const Color.fromRGBO(198, 201, 207, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroupingPieChart();
  }

  /// Returns a circular pie chart with grouping data points.
  SfCircularChart _buildGroupingPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Electricity sectors'),
      series: _buildPieSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        radius: '90%',
        startAngle: 90,
        endAngle: 90,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
        dataLabelSettings: const DataLabelSettings(isVisible: true),

        /// Enables and specifies the group mode for the pie chart.
        groupMode: CircularChartGroupMode.value,
        groupTo: 7,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
