/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the pie series with grouping datapoints.
class PieGrouping extends SampleView {
  /// Creates the pie series with grouping datapoints.
  const PieGrouping(Key key) : super(key: key);

  @override
  _PieGroupingState createState() => _PieGroupingState();
}

class _PieGroupingState extends SampleViewState {
  _PieGroupingState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroupingPieChart();
  }

  /// Return the circular charts with pie series.
  SfCircularChart _buildGroupingPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Electricity sectors'),
      series: _getGroupingPieSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Return the pie series which need to be grouping.
  List<PieSeries<ChartSampleData, String>> _getGroupingPieSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(
          x: 'Coal',
          y: 56.2,
          text: 'Coal: 200,704.5 MW (56.2%)',
          pointColor: null),
      ChartSampleData(
          x: 'Large\nHydro',
          y: 12.7,
          text: 'Large Hydro: 45,399.22 MW (12.7%)',
          pointColor: null),
      ChartSampleData(
          x: 'Small\nHydro',
          y: 1.3,
          text: 'Small Hydro: 4,594.15 MW (1.3%)',
          pointColor: null),
      ChartSampleData(
          x: 'Wind\nPower',
          y: 10,
          text: 'Wind Power: 35,815.88 MW (10.0%)',
          pointColor: null),
      ChartSampleData(
          x: 'Solar\nPower',
          y: 8,
          text: 'Solar Power: 28,679.21 MW (8.0%)',
          pointColor: null),
      ChartSampleData(
          x: 'Biomass',
          y: 2.6,
          text: 'Biomass: 9,269.8 MW (2.6%)',
          pointColor: const Color.fromRGBO(198, 201, 207, 1)),
      ChartSampleData(
          x: 'Nuclear',
          y: 1.9,
          text: 'Nuclear: 6,780 MW (1.9%)',
          pointColor: const Color.fromRGBO(198, 201, 207, 1)),
      ChartSampleData(
          x: 'Gas',
          y: 7,
          text: 'Gas: 24,937.22 MW (7.0%)',
          pointColor: const Color.fromRGBO(198, 201, 207, 1)),
      ChartSampleData(
          x: 'Diesel',
          y: 0.2,
          text: 'Diesel: 637.63 MW (0.2%)',
          pointColor: const Color.fromRGBO(198, 201, 207, 1))
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          radius: '90%',
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.inside),
          dataSource: pieData,
          startAngle: 90,
          endAngle: 90,

          /// To enable and specify the group mode for pie chart.
          groupMode: CircularChartGroupMode.value,
          groupTo: 7,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y)
    ];
  }
}
