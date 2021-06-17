/// Dart import
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with add and remove series options sample.
class AddSeries extends SampleView {
  /// Creates the chart with add and remove series options sample.
  const AddSeries(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class of the chart with add and remove series options.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();

  /// List holding the collection of chart series data points.
  static List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 0, y: 10),
    ChartSampleData(x: 1, y: 13),
    ChartSampleData(x: 2, y: 20),
    ChartSampleData(x: 3, y: 10),
    ChartSampleData(x: 4, y: 32),
    ChartSampleData(x: 5, y: 19)
  ];

  int count = 0;
  List<LineSeries<ChartSampleData, int>> series =
      <LineSeries<ChartSampleData, int>>[
    LineSeries<ChartSampleData, int>(
      dataSource: chartData,
      width: 2,
      xValueMapper: (ChartSampleData sales, _) => sales.x as int,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
    LineSeries<ChartSampleData, int>(
      dataSource: <ChartSampleData>[
        ChartSampleData(x: 0, y: 22),
        ChartSampleData(x: 1, y: 22),
        ChartSampleData(x: 2, y: 53),
        ChartSampleData(x: 3, y: 28),
        ChartSampleData(x: 4, y: 39),
        ChartSampleData(x: 5, y: 48)
      ],
      width: 2,
      xValueMapper: (ChartSampleData sales, _) => sales.x as int,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const double bottomPadding = 45;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: getAddRemoveSeriesChart()),
        ),
        floatingActionButton: Stack(children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: Container(
                height: 45,
                width: model.isWebFullView ? 140 : 110,
                child: InkWell(
                  splashColor: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: model.isWebFullView ? 65 : 45,
                          height: 50,
                          child: IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(Icons.add_circle,
                                  size: 50, color: model.backgroundColor),
                              onPressed: () {
                                setState(() {
                                  _addSeries();
                                });
                              })),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SizedBox(
                            width: model.isWebFullView ? 65 : 45,
                            height: 50,
                            child: IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(Icons.remove_circle,
                                  size: 50, color: model.backgroundColor),
                              onPressed: () => setState(() {
                                _removeSeries();
                              }),
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

  /// Returns the chart with add and remove series options.
  SfCartesianChart getAddRemoveSeriesChart() {
    //ignore: unused_local_variable
    final List<LineSeries<ChartSampleData, int>> defaultSeries =
        <LineSeries<ChartSampleData, int>>[
      LineSeries<ChartSampleData, int>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 0, y: 10),
          ChartSampleData(x: 1, y: 13),
          ChartSampleData(x: 2, y: 20),
          ChartSampleData(x: 3, y: 10),
          ChartSampleData(x: 4, y: 32),
          ChartSampleData(x: 5, y: 19)
        ],
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x as int,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
      LineSeries<ChartSampleData, int>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 0, y: 22),
          ChartSampleData(x: 1, y: 22),
          ChartSampleData(x: 2, y: 53),
          ChartSampleData(x: 3, y: 28),
          ChartSampleData(x: 4, y: 39),
          ChartSampleData(x: 5, y: 48)
        ],
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x as int,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      )
    ];
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: series,
    );
  }

  ///Get the random data point
  int _getRandomInt(int min, int max) {
    final Random _random = Random();
    return min + _random.nextInt(max - min);
  }

  ///Remove the series from chart
  void _removeSeries() {
    if (series != null && series.isNotEmpty) {
      series.removeLast();
    }
  }

  ///Add series into the chart
  void _addSeries() {
    final List<ChartSampleData> chartData1 = <ChartSampleData>[];
    for (int i = 0; i <= 6; i++) {
      chartData1.add(ChartSampleData(x: i, y: _getRandomInt(10, 50)));
    }
    series.add(LineSeries<ChartSampleData, int>(
      key: ValueKey<String>('${series.length}'),
      dataSource: chartData1,
      xValueMapper: (ChartSampleData sales, _) => sales.x as int,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ));
    count++;
    if (count == 8) {
      count = 0;
    }
  }
}
