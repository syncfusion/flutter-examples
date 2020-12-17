/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the default pie series.
class PieDefault extends SampleView {
  /// Creates the default pie series.
  const PieDefault(Key key) : super(key: key);

  @override
  _PieDefaultState createState() => _PieDefaultState();
}

/// State class of pie series.
class _PieDefaultState extends SampleViewState {
  _PieDefaultState();

  @override
  Widget build(BuildContext context) {
    return _getDefaultPieChart();
  }

  /// Returns the circular  chart with pie series.
  SfCircularChart _getDefaultPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      series: _getDefaultPieSeries(),
    );
  }

  /// Returns the pie series.
  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 30, text: 'David \n 30%'),
      ChartSampleData(x: 'Steve', y: 35, text: 'Steve \n 35%'),
      ChartSampleData(x: 'Jack', y: 39, text: 'Jack \n 39%'),
      ChartSampleData(x: 'Others', y: 75, text: 'Others \n 75%'),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: pieData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: DataLabelSettings(isVisible: true)),
    ];
  }
}
