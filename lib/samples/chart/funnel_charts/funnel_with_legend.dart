import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class FunnelLegend extends StatefulWidget {
  FunnelLegend({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _FunnelLegendState createState() => _FunnelLegendState(sample);
}

class _FunnelLegendState extends State<FunnelLegend> {
  _FunnelLegendState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getLegendFunnelChart(false), sample);
  }
}

SfFunnelChart getLegendFunnelChart(bool isTileView) {
  return SfFunnelChart(
    smartLabelMode: SmartLabelMode.none,
    title: ChartTitle(
        text: isTileView ? '' : 'Monthly expenditure of an individual'),
    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
    tooltipBehavior:
        TooltipBehavior(enable: true, format: 'point.x : point.y%'),
    series: _getFunnelSeries(isTileView),
  );
}

FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isTileView) {
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
          isVisible: isTileView ? false : true,
          labelPosition: ChartDataLabelPosition.inside));
}
