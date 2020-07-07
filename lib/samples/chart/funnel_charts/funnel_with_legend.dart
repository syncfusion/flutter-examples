/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';

class FunnelLegend extends SampleView {
  const FunnelLegend(Key key) : super(key: key);
  
  @override
  _FunnelLegendState createState() => _FunnelLegendState();
}

class _FunnelLegendState extends SampleViewState {
  _FunnelLegendState();

  @override
  Widget build(BuildContext context) {
    return getLegendFunnelChart();
  }

SfFunnelChart getLegendFunnelChart() {
  return SfFunnelChart(
    smartLabelMode: SmartLabelMode.none,
    title: ChartTitle(
        text: isCardView ? '' : 'Monthly expenditure of an individual'),
    /// To enable the legend for funnel chart.
    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
    tooltipBehavior:
        TooltipBehavior(enable: true, format: 'point.x : point.y%'),
    series: _getFunnelSeries(isCardView),
  );
}

FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isCardView) {
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
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: isCardView ? false : true,
          labelPosition: ChartDataLabelPosition.inside));
}
}