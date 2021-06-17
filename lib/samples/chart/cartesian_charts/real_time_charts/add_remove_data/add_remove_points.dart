/// Dart import
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with add and remove points sample.
class AddDataPoints extends SampleView {
  /// Renders the chart with add and remove points sample.
  const AddDataPoints(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class of the chart with add and remove points options.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState() {
    if (chartData.length > 11) {
      chartData.removeRange(10, chartData.length - 1);
    }
  }
  ChartSeriesController? _chartSeriesController;

  /// List for storing the chart series data points.
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 0, y: 10),
    ChartSampleData(x: 1, y: 13),
    ChartSampleData(x: 2, y: 80),
    ChartSampleData(x: 3, y: 30),
    ChartSampleData(x: 4, y: 72),
    ChartSampleData(x: 5, y: 19),
    ChartSampleData(x: 6, y: 30),
    ChartSampleData(x: 7, y: 92),
    ChartSampleData(x: 8, y: 48),
    ChartSampleData(x: 9, y: 20),
    ChartSampleData(x: 10, y: 51),
  ];
  int count = 11;

  /// Get the random value
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  /// Add the data point into the line series
  List<ChartSampleData> _addDataPoint() {
    chartData.add(ChartSampleData(x: count, y: _getRandomInt(10, 100)));
    count = count + 1;
    return chartData;
  }

  /// Remove the data point from the line series
  List<ChartSampleData> _removeDataPoint() {
    if (chartData != null && chartData.isNotEmpty) {
      chartData.removeAt(chartData.length - 1);
    }
    count = count - 1;
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    const double bottomPadding = 40;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: _buildAddRemovePointsChart()),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                        height: isCardView ? 40 : 45,
                        width: model.isWebFullView
                            ? 140
                            : isCardView
                                ? 100
                                : 110,
                        child: InkWell(
                            splashColor: Colors.transparent,
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: model.isWebFullView ? 65 : 45,
                                height: 50,
                                child: IconButton(
                                  onPressed: () {
                                    chartData = _addDataPoint();
                                    _chartSeriesController?.updateDataSource(
                                      addedDataIndexes: <int>[
                                        chartData.length - 1
                                      ],
                                    );
                                  },
                                  icon: Icon(Icons.add_circle,
                                      size: isCardView ? 40 : 50,
                                      color: model.backgroundColor),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: SizedBox(
                                      width: model.isWebFullView ? 65 : 45,
                                      height: 50,
                                      child: IconButton(
                                          onPressed: () {
                                            if (chartData.length > 1) {
                                              chartData = _removeDataPoint();
                                              _chartSeriesController
                                                  ?.updateDataSource(
                                                updatedDataIndexes: <int>[
                                                  chartData.length - 1
                                                ],
                                                removedDataIndexes: <int>[
                                                  chartData.length - 1
                                                ],
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.remove_circle,
                                            size: isCardView ? 40 : 50,
                                            color: model.backgroundColor,
                                          ))))
                            ])))))
          ],
        ));
  }

  /// Returns the chart with add and remove points options.
  SfCartesianChart _buildAddRemovePointsChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getAddRemovePointSeries(),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the chart with add and remove points.
  List<LineSeries<ChartSampleData, num>> _getAddRemovePointSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2),
    ];
  }
}
