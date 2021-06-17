/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with custom zooming buttons sample.
class ButtonZooming extends SampleView {
  /// Creates the chart with custom zooming buttons.
  const ButtonZooming(Key key) : super(key: key);

  @override
  _ButtonZoomingState createState() => _ButtonZoomingState();
}

/// State class of the chart with custom zooming buttons.
class _ButtonZoomingState extends SampleViewState {
  _ButtonZoomingState();
  late ZoomPanBehavior _zoomPan;
  @override
  void initState() {
    _zoomPan = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, isCardView ? 0 : 50),
          child: Container(child: _buildButtonZoomingChart()),
        ),
        floatingActionButton: isCardView
            ? null
            : Container(
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_up,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_left,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_right,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: model.isWebFullView
                                  ? null
                                  : (MediaQuery.of(context).size.width / 7) *
                                      0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    _zoomPan.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ));
  }

  /// Returns the Cartesian chart with custom zooming buttons.
  SfCartesianChart _buildButtonZoomingChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: getButtonZoomingSeries(isCardView),
      zoomPanBehavior: _zoomPan,
    );
  }

  /// List holding the collection of chart series data points.
  final List<ChartSampleData> zoomData = <ChartSampleData>[
    ChartSampleData(x: 1.5, y: 21),
    ChartSampleData(x: 2.2, y: 24),
    ChartSampleData(x: 3.32, y: 36),
    ChartSampleData(x: 4.56, y: 38),
    ChartSampleData(x: 5.87, y: 54),
    ChartSampleData(x: 6.8, y: 57),
    ChartSampleData(x: 8.5, y: 70),
    ChartSampleData(x: 9.5, y: 21),
    ChartSampleData(x: 10.2, y: 24),
    ChartSampleData(x: 11.32, y: 36),
    ChartSampleData(x: 14.56, y: 38),
    ChartSampleData(x: 15.87, y: 54),
    ChartSampleData(x: 16.8, y: 57),
    ChartSampleData(x: 18.5, y: 23),
    ChartSampleData(x: 21.5, y: 21),
    ChartSampleData(x: 22.2, y: 24),
    ChartSampleData(x: 23.32, y: 36),
    ChartSampleData(x: 24.56, y: 32),
    ChartSampleData(x: 25.87, y: 54),
    ChartSampleData(x: 26.8, y: 12),
    ChartSampleData(x: 28.5, y: 54),
    ChartSampleData(x: 30.2, y: 24),
    ChartSampleData(x: 31.32, y: 36),
    ChartSampleData(x: 34.56, y: 38),
    ChartSampleData(x: 35.87, y: 14),
    ChartSampleData(x: 36.8, y: 57),
    ChartSampleData(x: 38.5, y: 70),
    ChartSampleData(x: 41.5, y: 21),
    ChartSampleData(x: 41.2, y: 24),
    ChartSampleData(x: 43.32, y: 36),
    ChartSampleData(x: 44.56, y: 21),
    ChartSampleData(x: 45.87, y: 54),
    ChartSampleData(x: 46.8, y: 57),
    ChartSampleData(x: 48.5, y: 54),
    ChartSampleData(x: 49.56, y: 38),
    ChartSampleData(x: 49.87, y: 14),
    ChartSampleData(x: 51.8, y: 57),
    ChartSampleData(x: 54.5, y: 32),
    ChartSampleData(x: 55.5, y: 21),
    ChartSampleData(x: 57.2, y: 24),
    ChartSampleData(x: 59.32, y: 36),
    ChartSampleData(x: 60.56, y: 21),
    ChartSampleData(x: 62.87, y: 54),
    ChartSampleData(x: 63.8, y: 23),
    ChartSampleData(x: 65.5, y: 54)
  ];

  /// Returns the list of chart series which need to render
  /// on the chart with custom zooming buttons.
  List<LineSeries<ChartSampleData, num>> getButtonZoomingSeries(
      bool isTileView) {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          dataSource: zoomData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2)
    ];
  }
}
