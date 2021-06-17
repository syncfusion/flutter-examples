/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the pie series with various radius datapoints.
class PieRadius extends SampleView {
  /// Creates the pie series with various radius datapoints.
  const PieRadius(Key key) : super(key: key);

  @override
  _PieRadiusState createState() => _PieRadiusState();
}

/// State class of pie series with various radius.
class _PieRadiusState extends SampleViewState {
  _PieRadiusState();

  @override
  Widget build(BuildContext context) {
    return _buildRadiusPieChart();
  }

  /// Returns the circular charts with pie series.
  SfCircularChart _buildRadiusPieChart() {
    return SfCircularChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Various countries population density and area'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      series: _getRadiusPieSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the pie series.
  List<PieSeries<ChartSampleData, String>> _getRadiusPieSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
      ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
      ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
      ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
      ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
      ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
      ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%')
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          startAngle: 100,
          endAngle: 100,
          pointRadiusMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }
}
