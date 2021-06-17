/// dart import
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the chart with default trackball sample.
class InfiniteScrolling extends SampleView {
  /// Creates the chart with default trackball sample.
  const InfiniteScrolling(Key key) : super(key: key);

  @override
  _InfiniteScrollingState createState() => _InfiniteScrollingState();
}

/// State class the chart with default trackball.
class _InfiniteScrollingState extends SampleViewState {
  _InfiniteScrollingState();

  ChartSeriesController? seriesController;
  late List<ChartSampleData> chartData;

  late bool isLoadMoreView, isNeedToUpdateView, isDataUpdated;

  double? oldAxisVisibleMin, oldAxisVisibleMax;

  late ZoomPanBehavior _zoomPanBehavior;

  late GlobalKey<State> globalKey;
  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildInfiniteScrollingChart();
  }

  void _initializeVariables() {
    chartData = <ChartSampleData>[
      ChartSampleData(xValue: 0, y: 326),
      ChartSampleData(xValue: 1, y: 416),
      ChartSampleData(xValue: 2, y: 290),
      ChartSampleData(xValue: 3, y: 70),
      ChartSampleData(xValue: 4, y: 500),
      ChartSampleData(xValue: 5, y: 416),
      ChartSampleData(xValue: 6, y: 290),
      ChartSampleData(xValue: 7, y: 120),
      ChartSampleData(xValue: 8, y: 500),
    ];
    isLoadMoreView = false;
    isNeedToUpdateView = false;
    isDataUpdated = true;
    globalKey = GlobalKey<State>();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
    );
  }

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart _buildInfiniteScrollingChart() {
    return SfCartesianChart(
      key: GlobalKey<State>(),
      onActualRangeChanged: (ActualRangeChangedArgs args) {
        if (args.orientation == AxisOrientation.horizontal) {
          if (isLoadMoreView) {
            args.visibleMin = oldAxisVisibleMin;
            args.visibleMax = oldAxisVisibleMax;
          }
          oldAxisVisibleMin = args.visibleMin as double;
          oldAxisVisibleMax = args.visibleMax as double;
        }
        isLoadMoreView = false;
      },
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          name: 'XAxis',
          interval: 2,
          enableAutoIntervalOnZooming: false,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: getSeries(),
      axisLabelFormatter: (AxisLabelRenderDetails details) {
        return ChartAxisLabel(
            details.axisName == 'XAxis'
                ? details.text.split('.')[0]
                : details.text,
            null);
      },
      loadMoreIndicatorBuilder:
          (BuildContext context, ChartSwipeDirection direction) =>
              getloadMoreIndicatorBuilder(context, direction),
    );
  }

  List<ChartSeries<ChartSampleData, num>> getSeries() {
    return <ChartSeries<ChartSampleData, num>>[
      SplineAreaSeries<ChartSampleData, num>(
        dataSource: chartData,
        color: const Color.fromRGBO(75, 135, 185, 0.6),
        borderColor: const Color.fromRGBO(75, 135, 185, 1),
        borderWidth: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        onRendererCreated: (ChartSeriesController controller) {
          seriesController = controller;
        },
      ),
    ];
  }

  Widget getloadMoreIndicatorBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      isNeedToUpdateView = true;
      globalKey = GlobalKey<State>();
      return StatefulBuilder(
          key: globalKey,
          builder: (BuildContext context, StateSetter stateSetter) {
            Widget widget;
            if (isNeedToUpdateView) {
              widget = getProgressIndicator();
              _updateView();
              isDataUpdated = true;
            } else {
              widget = Container();
            }
            return widget;
          });
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }

  Widget getProgressIndicator() {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Container(
                width: 50,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: model.themeData.brightness == Brightness.light
                          ? <Color>[
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.74)
                            ]
                          : const <Color>[
                              Color.fromRGBO(33, 33, 33, 0.0),
                              Color.fromRGBO(33, 33, 33, 0.74)
                            ],
                      stops: const <double>[0.0, 1]),
                ),
                child: SizedBox(
                    height: 35,
                    width: 35,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(model.backgroundColor),
                      backgroundColor: Colors.transparent,
                      strokeWidth: 3,
                    )))));
  }

  void _updateData() {
    for (int i = 0; i < 4; i++) {
      chartData.add(ChartSampleData(
          xValue: chartData[chartData.length - 1].xValue + 1,
          y: getRandomInt(0, 600)));
    }
    isLoadMoreView = true;
    seriesController?.updateDataSource(addedDataIndexes: getIndexes(4));
  }

  Future<void> _updateView() async {
    await Future<void>.delayed(const Duration(seconds: 1), () {
      isNeedToUpdateView = false;
      if (isDataUpdated) {
        _updateData();
        isDataUpdated = false;
      }
      if (globalKey.currentState != null) {
        (globalKey.currentState as dynamic).setState(() {});
      }
    });
  }

  List<int> getIndexes(int length) {
    final List<int> indexes = <int>[];
    for (int i = length - 1; i >= 0; i--) {
      indexes.add(chartData.length - 1 - i);
    }
    return indexes;
  }

  int getRandomInt(int min, int max) {
    final Random random = Random();
    final int result = min + random.nextInt(max - min);
    return result < 50 ? 95 : result;
  }
}
