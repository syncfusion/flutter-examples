/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the default doughnut series chart.
class DoughnutDefault extends SampleView {
  /// Creates the default doughnut series chart.
  const DoughnutDefault(Key key) : super(key: key);

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class for the default doughnut series chart.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();
  late TooltipBehavior _tooltip;
  late List<ChartSampleData> _chartData;
  late int _explodeIndex;

  @override
  void initState() {
    _explodeIndex = 0;
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Chlorine', y: 55, text: '55%'),
      ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
      ChartSampleData(x: 'Magnesium', y: 7.7, text: '7.7%'),
      ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%'),
      ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
      ChartSampleData(x: 'Others', y: 1.4, text: '1.4%'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultDoughnutChart();
  }

  /// Returns a circular chart with default doughnut series.
  SfCircularChart _buildDefaultDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Composition of ocean water'),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: _buildDefaultDoughnutSeries(),
      tooltipBehavior: _tooltip,
    );
  }

  /// Returns the circular doughnut series.
  List<DoughnutSeries<ChartSampleData, String>> _buildDefaultDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        explode: true,
        explodeIndex: _explodeIndex,
        onPointTap: (ChartPointDetails details) {
          setState(() {
            _explodeIndex = details.pointIndex!;
          });
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
