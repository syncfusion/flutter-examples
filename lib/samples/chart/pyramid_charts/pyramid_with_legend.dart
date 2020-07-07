/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';

class PyramidLegend extends SampleView {
  const PyramidLegend(Key key) : super(key: key);
  
  @override
  _PyramidLegendState createState() => _PyramidLegendState();
}

class _PyramidLegendState extends SampleViewState {
  _PyramidLegendState();

  @override
  Widget build(BuildContext context) {
    return getLegendPyramidChart();
  }

SfPyramidChart getLegendPyramidChart() {
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
        ChartTitle(text: isCardView ? '' : 'Experience of employees in a team'),
    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
    /// To enable the legend for pyramid. And to cusmize the legend options here.
    tooltipBehavior: TooltipBehavior(enable: true),
    series: _getPyramidSeries(isCardView),
  );
}

PyramidSeries<ChartSampleData, String> _getPyramidSeries(bool isCardView) {
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
          isVisible: isCardView ? false : true,
          labelPosition: ChartDataLabelPosition.inside));
}
}