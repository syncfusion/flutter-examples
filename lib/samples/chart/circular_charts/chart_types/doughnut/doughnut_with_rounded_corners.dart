/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the rounded corner doughnut series.
class DoughnutRounded extends SampleView {
  /// Creates the rounded corner doughnut series.
  const DoughnutRounded(Key key) : super(key: key);

  @override
  _DoughnutRoundedState createState() => _DoughnutRoundedState();
}

/// State class of rounded corner doughnut series.
class _DoughnutRoundedState extends SampleViewState {
  _DoughnutRoundedState();

  @override
  Widget build(BuildContext context) {
    return _buildRoundedDoughnutChart();
  }

  /// Returns the circular charts with rounded corner doughnut series.
  SfCircularChart _buildRoundedDoughnutChart() {
    return SfCircularChart(
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      title: ChartTitle(text: isCardView ? '' : 'Software development cycle'),
      series: _getRoundedDoughnutSeries(),
    );
  }

  /// Returns rounded corner doughunut series.
  List<DoughnutSeries<ChartSampleData, String>> _getRoundedDoughnutSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Planning', y: 10),
      ChartSampleData(x: 'Analysis', y: 10),
      ChartSampleData(x: 'Design', y: 10),
      ChartSampleData(x: 'Development', y: 10),
      ChartSampleData(x: 'Testing & Integration', y: 10),
      ChartSampleData(x: 'Maintainance', y: 10)
    ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: chartData,
        animationDuration: 0,
        cornerStyle: CornerStyle.bothCurve,
        radius: '80%',
        innerRadius: '60%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
      ),
    ];
  }
}
