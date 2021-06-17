/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the funnel chart with legend
class FunnelLegend extends SampleView {
  /// Renders the funnel chart with legend
  const FunnelLegend(Key key) : super(key: key);

  @override
  _FunnelLegendState createState() => _FunnelLegendState();
}

class _FunnelLegendState extends SampleViewState {
  _FunnelLegendState();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendFunnelChart();
  }

  ///Get the funnel chart which contains the legend
  SfFunnelChart _buildLegendFunnelChart() {
    return SfFunnelChart(
      smartLabelMode: SmartLabelMode.none,
      title: ChartTitle(
          text: isCardView ? '' : 'Monthly expenditure of an individual'),

      /// To enable the legend for funnel chart.
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: _getFunnelSeries(),
    );
  }

  /// Get the funnel series
  FunnelSeries<ChartSampleData, String> _getFunnelSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Others', y: 10, text: '10%'),
      ChartSampleData(x: 'Medical ', y: 11, text: '11%'),
      ChartSampleData(x: 'Saving ', y: 14, text: '14%'),
      ChartSampleData(x: 'Shopping', y: 17, text: '17%'),
      ChartSampleData(x: 'Travel', y: 21, text: '21%'),
      ChartSampleData(x: 'Food', y: 27, text: '27%'),
    ];
    return FunnelSeries<ChartSampleData, String>(
        dataSource: pieData,
        textFieldMapper: (ChartSampleData data, _) => data.text,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: !isCardView,
            labelPosition: ChartDataLabelPosition.inside));
  }
}
