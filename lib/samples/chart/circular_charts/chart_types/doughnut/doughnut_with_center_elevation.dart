/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the doughnut series with center elevation.
class DoughnutElevation extends SampleView {
  /// Creates the doughnut series with center elevation.
  const DoughnutElevation(Key key) : super(key: key);

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class of doughnut series with center elevation.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildElevationDoughnutChart();
  }

  /// Returns the circular charts with center elevation dughnut series.
  SfCircularChart _buildElevationDoughnutChart() {
    return SfCircularChart(
      /// It used to set the annotation on circular chart.
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
            height: '100%',
            width: '100%',
            widget: PhysicalModel(
              shape: BoxShape.circle,
              elevation: 10,
              color: const Color.fromRGBO(230, 230, 230, 1),
              child: Container(),
            )),
        CircularChartAnnotation(
            widget: const Text('62%',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25)))
      ],
      title: ChartTitle(
          text: isCardView ? '' : 'Progress of a task',
          textStyle: const TextStyle(fontSize: 20)),
      series: _getElevationDoughnutSeries(),
    );
  }

  /// Returns the doughnut series which need to be center elevation.
  List<DoughnutSeries<ChartSampleData, String>> _getElevationDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'A',
                y: 62,
                pointColor: const Color.fromRGBO(0, 220, 252, 1)),
            ChartSampleData(
                x: 'B',
                y: 38,
                pointColor: const Color.fromRGBO(230, 230, 230, 1))
          ],
          animationDuration: 0,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor)
    ];
  }
}
