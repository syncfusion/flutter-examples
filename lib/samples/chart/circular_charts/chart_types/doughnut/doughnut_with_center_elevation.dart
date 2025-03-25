/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the doughnut series chart with center elevation.
class DoughnutElevation extends SampleView {
  /// Creates the doughnut series chart with center elevation.
  const DoughnutElevation(Key key) : super(key: key);

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class for the doughnut series chart with center elevation.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'A',
        y: 62,
        pointColor: const Color.fromRGBO(0, 220, 252, 1),
      ),
      ChartSampleData(
        x: 'B',
        y: 38,
        pointColor: const Color.fromRGBO(230, 230, 230, 1),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildElevationDoughnutChart();
  }

  /// Returns a circular doughnut chart with a central elevation.
  SfCircularChart _buildElevationDoughnutChart() {
    return SfCircularChart(
      /// Sets the annotations for the circular chart.
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          height: '100%',
          width: '100%',
          widget: PhysicalModel(
            shape: BoxShape.circle,
            elevation: 10,
            color: const Color.fromRGBO(230, 230, 230, 1),
            child: Container(),
          ),
        ),
        const CircularChartAnnotation(
          widget: Text(
            '62%',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25),
          ),
        ),
      ],
      title: ChartTitle(
        text: isCardView ? '' : 'Progress of a task',
        textStyle: const TextStyle(fontSize: 20),
      ),
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
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        animationDuration: 0,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
