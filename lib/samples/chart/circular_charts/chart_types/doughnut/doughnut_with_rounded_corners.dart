/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the doughnut series chart with rounded corners.
class DoughnutRounded extends SampleView {
  /// Creates the doughnut series chart with rounded corners.
  const DoughnutRounded(Key key) : super(key: key);

  @override
  _DoughnutRoundedState createState() => _DoughnutRoundedState();
}

/// State class for the default doughnut series with rounded corners.
class _DoughnutRoundedState extends SampleViewState {
  _DoughnutRoundedState();
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Planning', y: 10),
      ChartSampleData(x: 'Analysis', y: 10),
      ChartSampleData(x: 'Design', y: 10),
      ChartSampleData(x: 'Development', y: 10),
      ChartSampleData(x: 'Testing & Integration', y: 10),
      ChartSampleData(x: 'Maintenance', y: 10),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRoundedDoughnutChart();
  }

  /// Returns a circular doughnut chart with rounded corners.
  SfCircularChart _buildRoundedDoughnutChart() {
    return SfCircularChart(
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      title: ChartTitle(text: isCardView ? '' : 'Software development cycle'),
      series: _buildDoughnutSeries(),
    );
  }

  /// Returns the circular doughnut series.
  List<DoughnutSeries<ChartSampleData, String>> _buildDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '60%',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
