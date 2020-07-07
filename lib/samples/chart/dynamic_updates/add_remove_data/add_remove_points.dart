/// Dart import
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with add and remove points sample.
class AddDataPoints extends SampleView {
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
  ChartSeriesController _chartSeriesController;

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

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<ChartSampleData> getChartData(SampleModel model) {
    chartData.add(ChartSampleData(x: count, y: getRandomInt(10, 100)));
    count = count + 1;
    return chartData;
  }

  List<ChartSampleData> getChartData1(SampleModel model) {
    // ignore: invalid_use_of_protected_member
    if (chartData != null && chartData.isNotEmpty)
      chartData.removeAt(chartData.length - 1);
    count = count - 1;
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = isCardView ? 0 : 50;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: getAddRemovePointsChart()),
        ),
        floatingActionButton: isCardView
            ? null
            : Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                      height: 50,
                      width: model.isWeb ? 180 : 120,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                                width: model.isWeb ? 65 : 45,
                                height: 50,
                                child: IconButton(
                                    splashColor: Colors.transparent,
                                    icon: Icon(Icons.add_circle,
                                        size: 50, color: model.backgroundColor),
                                    onPressed: () {
                                      chartData = getChartData(model);
                                      _chartSeriesController.updateDataSource(
                                        addedDataIndexes: <int>[
                                          chartData.length - 1
                                        ],
                                      );
                                    }

                                    //  => setState(() {
                                    //   chartData = getChartData(model);
                                    // }),
                                    )),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 65,
                                  height: 50,
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      icon: Icon(Icons.remove_circle,
                                          size: 50,
                                          color: model.backgroundColor),
                                      onPressed: () {
                                        if (chartData.length > 1) {
                                          chartData = getChartData1(model);
                                          _chartSeriesController
                                              .updateDataSource(
                                            updatedDataIndexes: <int>[
                                              chartData.length - 1
                                            ],
                                            removedDataIndexes: <int>[
                                              chartData.length - 1
                                            ],
                                          );
                                        }
                                      }

                                      // => setState(() {
                                      //   chartData = getChartData1(model);
                                      // }),
                                      ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]));
  }

  /// Returns the chart with add and remove points options.
  SfCartesianChart getAddRemovePointsChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getAddRemovePointSeries(),
    );
  }

  /// List for storing the chart series data points.
  List<ChartSampleData> chartData1 = <ChartSampleData>[
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

  /// Returns the list of chart series which need to render on the chart with add and remove points.
  List<LineSeries<ChartSampleData, num>> getAddRemovePointSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2),
    ];
  }
}
