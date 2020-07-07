import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PyramidLegend extends StatefulWidget {
  PyramidLegend({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PyramidLegendState createState() => _PyramidLegendState(sample);
}

class _PyramidLegendState extends State<PyramidLegend> {
  _PyramidLegendState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getLegendPyramidChart(false), sample);
  }
}

SfPyramidChart getLegendPyramidChart(bool isTileView) {
  return SfPyramidChart(
    onTooltipRender: (TooltipArgs args) {
      List<String> data;
      String text;
      text = args.dataPoints[args.pointIndex].y.toString();
      if (text.contains('.')) {
        data = text.split('.');
        final String newTe =
            data[0].toString() + ' years ' + data[1].toString() + ' months';
        args.text = newTe;
      } else {
        args.text = text + ' years';
      }
    },
    smartLabelMode: SmartLabelMode.none,
    title:
        ChartTitle(text: isTileView ? '' : 'Experience of employees in a team'),
    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: _getPyramidSeries(isTileView),
  );
}

PyramidSeries<ChartSampleData, String> _getPyramidSeries(bool isTileView) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Ray', y: 7.3),
    ChartSampleData(
      x: 'Michael',
      y: 6.6,
    ),
    ChartSampleData(
      x: 'John ',
      y: 3,
    ),
    ChartSampleData(
      x: 'Mercy',
      y: 0.8,
    ),
    ChartSampleData(
      x: 'Tina ',
      y: 1.4,
    ),
    ChartSampleData(
      x: 'Stephen',
      y: 5.2,
    ),
  ];
  return PyramidSeries<ChartSampleData, String>(
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: isTileView ? false : true,
          labelPosition: ChartDataLabelPosition.inside));
}
