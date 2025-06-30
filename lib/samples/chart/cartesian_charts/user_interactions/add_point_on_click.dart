/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the line series chart with interactive feature.
class InteractiveChart extends SampleView {
  /// Creates the line series chart with interactive feature.
  const InteractiveChart(Key key) : super(key: key);

  @override
  _InteractiveChartState createState() => _InteractiveChartState();
}

/// State class of the line series chart with interactive feature.
class _InteractiveChartState extends SampleViewState {
  _InteractiveChartState();

  late List<ChartSampleData> _chartData;
  late bool _isResetVisible;

  ChartSeriesController<ChartSampleData, num>? _seriesController;

  @override
  void initState() {
    _chartData = _buildChartData();
    _isResetVisible = false;
    super.initState();
  }

  /// Method to get chart data points.
  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(x: 1, y: 5),
      ChartSampleData(x: 2, y: 8),
      ChartSampleData(x: 3, y: 6),
      ChartSampleData(x: 4, y: 8),
      ChartSampleData(x: 5, y: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = !model.isWebFullView ? 40 : 60;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, isCardView ? 0 : 15, 5, bottomPadding),
        child: Container(child: _buildInteractiveChart()),
      ),
      floatingActionButton: SizedBox(
        height: model.isWebFullView ? 45 : 40,
        width: 45,
        child: FloatingActionButton(
          onPressed: _isResetVisible
              ? () => setState(() {
                  _chartData = _buildChartData();
                  _isResetVisible = false;
                })
              : null,
          backgroundColor: _isResetVisible
              ? model.primaryColor
              : Colors.grey[600],
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }

  /// Returns the cartesian line chart with interactive feature.
  SfCartesianChart _buildInteractiveChart() {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 10),
      plotAreaBorderWidth: 0,
      enableAxisAnimation: true,
      primaryXAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        rangePadding: ChartRangePadding.additional,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.additional,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
      ),
      series: <CartesianSeries<ChartSampleData, num>>[
        LineSeries<ChartSampleData, num>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData data, int index) => data.x,
          yValueMapper: (ChartSampleData data, int index) => data.y,
          name: 'Germany',
          markerSettings: const MarkerSettings(isVisible: true),
          onRendererCreated:
              (ChartSeriesController<ChartSampleData, num> controller) {
                _seriesController = controller;
              },
        ),
      ],
      onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
        _isResetVisible = true;
        final Offset value = Offset(args.position.dx, args.position.dy);
        final CartesianChartPoint<dynamic> chartPoint = _seriesController!
            .pixelToPoint(value);
        _chartData.add(ChartSampleData(x: chartPoint.x, y: chartPoint.y));
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
