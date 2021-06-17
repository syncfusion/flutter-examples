/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the doughnut series with color mapping.
class DoughnutCustomization extends SampleView {
  /// Render the doughnut series with color mapping.
  const DoughnutCustomization(Key key) : super(key: key);

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class of doughnut series with color mapping.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildDoughnutCustomizationChart();
  }

  /// Returns the circular chart with color mapping doughnut series.
  SfCircularChart _buildDoughnutCustomizationChart() {
    return SfCircularChart(
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
            widget: Container(
                child: const Text('90%',
                    style: TextStyle(color: Colors.grey, fontSize: 25))))
      ],
      title: ChartTitle(
          text: isCardView ? '' : 'Work progress',
          textStyle: const TextStyle(fontSize: 20)),
      series: _getDoughnutCustomizationSeries(),
    );
  }

  /// Return the list of doughnut series which need to be color mapping.
  List<DoughnutSeries<ChartSampleData, String>>
      _getDoughnutCustomizationSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'A', y: 10, pointColor: const Color.fromRGBO(255, 4, 0, 1)),
      ChartSampleData(
          x: 'B', y: 10, pointColor: const Color.fromRGBO(255, 15, 0, 1)),
      ChartSampleData(
          x: 'C', y: 10, pointColor: const Color.fromRGBO(255, 31, 0, 1)),
      ChartSampleData(
          x: 'D', y: 10, pointColor: const Color.fromRGBO(255, 60, 0, 1)),
      ChartSampleData(
          x: 'E', y: 10, pointColor: const Color.fromRGBO(255, 90, 0, 1)),
      ChartSampleData(
          x: 'F', y: 10, pointColor: const Color.fromRGBO(255, 115, 0, 1)),
      ChartSampleData(
          x: 'G', y: 10, pointColor: const Color.fromRGBO(255, 135, 0, 1)),
      ChartSampleData(
          x: 'H', y: 10, pointColor: const Color.fromRGBO(255, 155, 0, 1)),
      ChartSampleData(
          x: 'I', y: 10, pointColor: const Color.fromRGBO(255, 175, 0, 1)),
      ChartSampleData(
          x: 'J', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
      ChartSampleData(
          x: 'K', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
      ChartSampleData(
          x: 'L', y: 10, pointColor: const Color.fromRGBO(251, 188, 2, 1)),
      ChartSampleData(
          x: 'M', y: 10, pointColor: const Color.fromRGBO(245, 188, 6, 1)),
      ChartSampleData(
          x: 'N', y: 10, pointColor: const Color.fromRGBO(233, 188, 12, 1)),
      ChartSampleData(
          x: 'O', y: 10, pointColor: const Color.fromRGBO(220, 187, 19, 1)),
      ChartSampleData(
          x: 'P', y: 10, pointColor: const Color.fromRGBO(208, 187, 26, 1)),
      ChartSampleData(
          x: 'Q', y: 10, pointColor: const Color.fromRGBO(193, 187, 34, 1)),
      ChartSampleData(
          x: 'R', y: 10, pointColor: const Color.fromRGBO(177, 186, 43, 1)),
      ChartSampleData(
          x: 'S', y: 10, pointColor: const Color.fromRGBO(230, 230, 230, 1)),
      ChartSampleData(
          x: 'T', y: 10, pointColor: const Color.fromRGBO(230, 230, 230, 1))
    ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: chartData,
        radius: '100%',
        strokeColor: model.themeData.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        strokeWidth: 2,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,

        /// The property used to apply the color for each douchnut series.
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String,
      ),
    ];
  }
}
