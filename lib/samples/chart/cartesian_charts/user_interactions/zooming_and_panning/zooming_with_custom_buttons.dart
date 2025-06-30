/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the line series chart with custom zooming buttons.
class ButtonZooming extends SampleView {
  /// Creates the line series chart with custom zooming buttons.
  const ButtonZooming(Key key) : super(key: key);

  @override
  _ButtonZoomingState createState() => _ButtonZoomingState();
}

/// State class of the line series chart with custom zooming buttons.
class _ButtonZoomingState extends SampleViewState {
  _ButtonZoomingState();
  late ZoomPanBehavior _zoomPan;
  late List<ChartSampleData> _zoomData;

  @override
  void initState() {
    _zoomPan = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    _zoomData = _buildChartData1();
    super.initState();
  }

  List<ChartSampleData> _buildChartData1() {
    return [
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
      ChartSampleData(x: 65.5, y: 54),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, isCardView ? 0 : 50),
        child: Container(child: _buildChartContainer()),
      ),
      floatingActionButton: isCardView
          ? null
          : _buildFloatingActionButtons(context),
    );
  }

  /// Builds the chart container.
  Widget _buildChartContainer() {
    return _buildButtonZoomingChart();
  }

  /// Builds the floating action buttons for zoom and pan functionalities.
  Widget _buildFloatingActionButtons(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildZoomButton(Icons.add, 'Zoom In', () {
                      _zoomPan.zoomIn();
                    }, const EdgeInsets.fromLTRB(24, 15, 0, 0)),
                    _buildZoomButton(Icons.remove, 'Zoom Out', () {
                      _zoomPan.zoomOut();
                    }, const EdgeInsets.fromLTRB(20, 15, 0, 0)),
                    _buildZoomButton(
                      Icons.keyboard_arrow_up,
                      'Pan Up',
                      () {
                        _zoomPan.panToDirection('top');
                      },
                      const EdgeInsets.fromLTRB(20, 15, 0, 0),
                    ),
                    _buildZoomButton(
                      Icons.keyboard_arrow_down,
                      'Pan Down',
                      () {
                        _zoomPan.panToDirection('bottom');
                      },
                      const EdgeInsets.fromLTRB(20, 15, 0, 0),
                    ),
                    _buildZoomButton(
                      Icons.keyboard_arrow_left,
                      'Pan Left',
                      () {
                        _zoomPan.panToDirection('left');
                      },
                      const EdgeInsets.fromLTRB(20, 15, 0, 0),
                    ),
                    _buildZoomButton(
                      Icons.keyboard_arrow_right,
                      'Pan Right',
                      () {
                        _zoomPan.panToDirection('right');
                      },
                      const EdgeInsets.fromLTRB(20, 15, 0, 0),
                    ),
                    _buildZoomButton(Icons.refresh, 'Reset', () {
                      _zoomPan.reset();
                    }, const EdgeInsets.fromLTRB(20, 15, 0, 0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a zoom button with an icon, tooltip, action, and padding.
  Widget _buildZoomButton(
    IconData icon,
    String tooltipMessage,
    VoidCallback onPressed,
    EdgeInsetsGeometry padding,
  ) {
    return Container(
      width: model.isWebFullView
          ? null
          : (MediaQuery.of(context).size.width / 7) * 0.9,
      padding: padding,
      child: Tooltip(
        message: tooltipMessage,
        child: IconButton(
          icon: Icon(icon, color: model.primaryColor),
          onPressed: onPressed,
        ),
      ),
    );
  }

  /// Returns a cartesian line chart with custom zooming buttons.
  SfCartesianChart _buildButtonZoomingChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(isCardView),
      zoomPanBehavior: _zoomPan,
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries(bool isTileView) {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _zoomData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
      ),
    ];
  }

  @override
  void dispose() {
    _zoomData.clear();
    super.dispose();
  }
}
