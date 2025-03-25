/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default pie series chart.
class PieDefault extends SampleView {
  /// Creates the default pie series chart.
  const PieDefault(Key key) : super(key: key);

  @override
  _PieDefaultState createState() => _PieDefaultState();
}

/// State class for the default pie series chart.
class _PieDefaultState extends SampleViewState {
  _PieDefaultState();
  late List<ChartSampleData> _chartData;
  late int _explodeIndex;

  @override
  void initState() {
    _explodeIndex = 0;
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 13, text: 'David \n 13%'),
      ChartSampleData(x: 'Steve', y: 24, text: 'Steve \n 24%'),
      ChartSampleData(x: 'Jack', y: 25, text: 'Jack \n 25%'),
      ChartSampleData(x: 'Others', y: 38, text: 'Others \n 38%'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPieChart();
  }

  /// Returns a circular chart with pie series.
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      series: _buildDefaultPieSeries(),
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildDefaultPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        explode: true,
        explodeIndex: _explodeIndex,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
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
