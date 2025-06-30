/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the doughnut series chart with color mapping.
class DoughnutCustomization extends SampleView {
  /// Creates the doughnut series chart with color mapping.
  const DoughnutCustomization(Key key) : super(key: key);

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class for doughnut series chart with color mapping.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(
        x: 'A',
        y: 10,
        pointColor: const Color.fromRGBO(255, 4, 0, 1),
      ),
      ChartSampleData(
        x: 'B',
        y: 10,
        pointColor: const Color.fromRGBO(255, 15, 0, 1),
      ),
      ChartSampleData(
        x: 'C',
        y: 10,
        pointColor: const Color.fromRGBO(255, 31, 0, 1),
      ),
      ChartSampleData(
        x: 'D',
        y: 10,
        pointColor: const Color.fromRGBO(255, 60, 0, 1),
      ),
      ChartSampleData(
        x: 'E',
        y: 10,
        pointColor: const Color.fromRGBO(255, 90, 0, 1),
      ),
      ChartSampleData(
        x: 'F',
        y: 10,
        pointColor: const Color.fromRGBO(255, 115, 0, 1),
      ),
      ChartSampleData(
        x: 'G',
        y: 10,
        pointColor: const Color.fromRGBO(255, 135, 0, 1),
      ),
      ChartSampleData(
        x: 'H',
        y: 10,
        pointColor: const Color.fromRGBO(255, 155, 0, 1),
      ),
      ChartSampleData(
        x: 'I',
        y: 10,
        pointColor: const Color.fromRGBO(255, 175, 0, 1),
      ),
      ChartSampleData(
        x: 'J',
        y: 10,
        pointColor: const Color.fromRGBO(255, 188, 0, 1),
      ),
      ChartSampleData(
        x: 'K',
        y: 10,
        pointColor: const Color.fromRGBO(255, 188, 0, 1),
      ),
      ChartSampleData(
        x: 'L',
        y: 10,
        pointColor: const Color.fromRGBO(251, 188, 2, 1),
      ),
      ChartSampleData(
        x: 'M',
        y: 10,
        pointColor: const Color.fromRGBO(245, 188, 6, 1),
      ),
      ChartSampleData(
        x: 'N',
        y: 10,
        pointColor: const Color.fromRGBO(233, 188, 12, 1),
      ),
      ChartSampleData(
        x: 'O',
        y: 10,
        pointColor: const Color.fromRGBO(220, 187, 19, 1),
      ),
      ChartSampleData(
        x: 'P',
        y: 10,
        pointColor: const Color.fromRGBO(208, 187, 26, 1),
      ),
      ChartSampleData(
        x: 'Q',
        y: 10,
        pointColor: const Color.fromRGBO(193, 187, 34, 1),
      ),
      ChartSampleData(
        x: 'R',
        y: 10,
        pointColor: const Color.fromRGBO(177, 186, 43, 1),
      ),
      ChartSampleData(
        x: 'S',
        y: 10,
        pointColor: const Color.fromRGBO(230, 230, 230, 1),
      ),
      ChartSampleData(
        x: 'T',
        y: 10,
        pointColor: const Color.fromRGBO(230, 230, 230, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildDoughnutCustomizationChart();
  }

  /// Returns a circular doughnut chart with color mapping.
  SfCircularChart _buildDoughnutCustomizationChart() {
    return SfCircularChart(
      annotations: const <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Text(
            '90%',
            style: TextStyle(color: Colors.grey, fontSize: 25),
          ),
        ),
      ],
      title: ChartTitle(
        text: isCardView ? '' : 'Work progress',
        textStyle: const TextStyle(fontSize: 20),
      ),
      series: _buildDoughnutCustomizationSeries(),
    );
  }

  /// Returns the circular doughnut series.
  List<DoughnutSeries<ChartSampleData, String>>
  _buildDoughnutCustomizationSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        radius: '100%',
        strokeColor: model.themeData.colorScheme.brightness == Brightness.light
            ? Colors.white
            : Colors.black,

        /// Applies the color for each doughnut segment.
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
