/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the spline area series chart with infinite scrolling.
class InfiniteScrolling extends SampleView {
  /// Creates the spline area series chart with infinite scrolling.
  const InfiniteScrolling(Key key) : super(key: key);

  @override
  _InfiniteScrollingState createState() => _InfiniteScrollingState();
}

/// State class for the spline area series chart with infinite scrolling.
class _InfiniteScrollingState extends SampleViewState {
  _InfiniteScrollingState();
  late List<ChartSampleData> _chartData;
  late bool _isLoadMoreView;
  late bool _isNeedToUpdateView;
  late bool _isDataUpdated;
  late ZoomPanBehavior _zoomPanBehavior;
  late GlobalKey<State> _globalKey;

  num? _oldAxisVisibleMin;
  num? _oldAxisVisibleMax;

  ChartSeriesController<ChartSampleData, num>? _seriesController;

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
    _chartData = <ChartSampleData>[
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
    _isLoadMoreView = false;
    _isNeedToUpdateView = false;
    _isDataUpdated = true;
    _globalKey = GlobalKey<State>();
    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
  }

  /// Returns the cartesian spline area chart with infinite scrolling.
  SfCartesianChart _buildInfiniteScrollingChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      key: GlobalKey<State>(),
      onActualRangeChanged: (ActualRangeChangedArgs args) {
        if (args.orientation == AxisOrientation.horizontal) {
          if (_isLoadMoreView) {
            args.visibleMin = _oldAxisVisibleMin;
            args.visibleMax = _oldAxisVisibleMax;
          }
          _oldAxisVisibleMin = args.visibleMin;
          _oldAxisVisibleMax = args.visibleMax;
          _isLoadMoreView = false;
        }
      },
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        name: 'XAxis',
        interval: 2,
        enableAutoIntervalOnZooming: false,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text.split('.')[0], null);
        },
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text, null);
        },
      ),
      series: _buildSplineAreaSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      loadMoreIndicatorBuilder:
          (BuildContext context, ChartSwipeDirection direction) =>
              _buildLoadMoreIndicator(context, direction),
    );
  }

  /// Returns the list of cartesian spline area series.
  List<CartesianSeries<ChartSampleData, num>> _buildSplineAreaSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    return <CartesianSeries<ChartSampleData, num>>[
      SplineAreaSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.xValue,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        color: color.withValues(alpha: 0.6),
        borderColor: color,
        onRendererCreated:
            (ChartSeriesController<ChartSampleData, num> controller) {
              _seriesController = controller;
            },
      ),
    ];
  }

  Widget _buildLoadMoreIndicator(
    BuildContext context,
    ChartSwipeDirection direction,
  ) {
    if (direction == ChartSwipeDirection.end) {
      _isNeedToUpdateView = true;
      _globalKey = GlobalKey<State>();
      return StatefulBuilder(
        key: _globalKey,
        builder: (BuildContext context, StateSetter stateSetter) {
          Widget widget;
          if (_isNeedToUpdateView) {
            widget = _buildProgressIndicator();
            _updateView();
            _isDataUpdated = true;
          } else {
            widget = Container();
          }
          return widget;
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }

  Widget _buildProgressIndicator() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        // ignore: use_named_constants
        padding: const EdgeInsets.only(),
        child: Container(
          width: 50,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: model.themeData.colorScheme.brightness == Brightness.light
                  ? <Color>[
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.74),
                    ]
                  : const <Color>[
                      Color.fromRGBO(33, 33, 33, 0.0),
                      Color.fromRGBO(33, 33, 33, 0.74),
                    ],
              stops: const <double>[0.0, 1],
            ),
          ),
          child: SizedBox(
            height: 35,
            width: 35,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(model.primaryColor),
              backgroundColor: Colors.transparent,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  void _updateData() {
    for (int i = 0; i < 4; i++) {
      _chartData.add(
        ChartSampleData(
          xValue: _chartData[_chartData.length - 1].xValue + 1,
          y: _generateRandomInteger(0, 600),
        ),
      );
    }
    _isLoadMoreView = true;
    _seriesController?.updateDataSource(addedDataIndexes: _generateIndexes(4));
  }

  Future<void> _updateView() async {
    await Future<void>.delayed(const Duration(seconds: 1), () {
      _isNeedToUpdateView = false;
      if (_isDataUpdated) {
        _updateData();
        _isDataUpdated = false;
      }
      if (_globalKey.currentState != null) {
        (_globalKey.currentState as dynamic).setState(() {});
      }
    });
  }

  List<int> _generateIndexes(int length) {
    final int lastIndex = _chartData.length - 1;
    final List<int> indexes = <int>[];
    for (int i = length - 1; i >= 0; i--) {
      indexes.add(lastIndex - i);
    }
    return indexes;
  }

  int _generateRandomInteger(int min, int max) {
    final Random random = Random.secure();
    final int result = min + random.nextInt(max - min);
    return result < 50 ? 95 : result;
  }

  @override
  void dispose() {
    _seriesController = null;
    super.dispose();
  }
}
