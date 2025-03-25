/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// Renders the funnel series chart with legend.
class FunnelLegend extends SampleView {
  /// Renders the funnel series chart with legend.
  const FunnelLegend(Key key) : super(key: key);

  @override
  _FunnelLegendState createState() => _FunnelLegendState();
}

class _FunnelLegendState extends SampleViewState {
  _FunnelLegendState();
  late List<ChartSampleData> _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Others', y: 10, text: '10%'),
      ChartSampleData(x: 'Medical ', y: 11, text: '11%'),
      ChartSampleData(x: 'Saving ', y: 14, text: '14%'),
      ChartSampleData(x: 'Shopping', y: 17, text: '17%'),
      ChartSampleData(x: 'Travel', y: 21, text: '21%'),
      ChartSampleData(x: 'Food', y: 27, text: '27%'),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendFunnelChart();
  }

  /// Returns the funnel chart which contains the legend.
  SfFunnelChart _buildLegendFunnelChart() {
    return SfFunnelChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Monthly expenditure of an individual',
      ),

      /// To enable the legend for funnel chart.
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildFunnelSeries(),
    );
  }

  /// Returns the funnel series.
  FunnelSeries<ChartSampleData, String> _buildFunnelSeries() {
    return FunnelSeries<ChartSampleData, String>(
      dataSource: _chartData,
      xValueMapper: (ChartSampleData data, int index) => data.x,
      yValueMapper: (ChartSampleData data, int index) => data.y,
      dataLabelSettings: DataLabelSettings(isVisible: !isCardView),
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
