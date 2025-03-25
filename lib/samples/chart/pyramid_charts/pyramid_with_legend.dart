/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// Renders the pyramid series chart with legend.
class PyramidLegend extends SampleView {
  /// Creates the pyramid series chart with legend.
  const PyramidLegend(Key key) : super(key: key);

  @override
  _PyramidLegendState createState() => _PyramidLegendState();
}

class _PyramidLegendState extends SampleViewState {
  _PyramidLegendState();
  late List<ChartSampleData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Ray', y: 7.3),
      ChartSampleData(x: 'Michael', y: 6.6),
      ChartSampleData(x: 'John ', y: 3),
      ChartSampleData(x: 'Mercy', y: 0.8),
      ChartSampleData(x: 'Tina ', y: 1.4),
      ChartSampleData(x: 'Stephen', y: 5.2),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendPyramidChart();
  }

  /// Returns the pyramid series chart with legend.
  SfPyramidChart _buildLegendPyramidChart() {
    return SfPyramidChart(
      onTooltipRender: (TooltipArgs args) {
        List<String> data;
        String text;
        text = args.dataPoints![args.pointIndex!.toInt()].y.toString();
        if (text.contains('.')) {
          data = text.split('.');
          final String newTe = data[0] + ' years ' + data[1] + ' months';
          args.text = newTe;
        } else {
          args.text = text + ' years';
        }
      },
      title: ChartTitle(
        text: isCardView ? '' : 'Experience of employees in a team',
      ),
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildPyramidSeries(),
    );
  }

  /// Returns the pyramid series.
  PyramidSeries<ChartSampleData, String> _buildPyramidSeries() {
    return PyramidSeries<ChartSampleData, String>(
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
