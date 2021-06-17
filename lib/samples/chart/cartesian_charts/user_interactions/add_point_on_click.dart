/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the cartesian chart with default tootlip sample.
class InteractiveChart extends SampleView {
  /// Creates the cartesian chart with default tootlip sample.
  const InteractiveChart(Key key) : super(key: key);

  @override
  _InteractiveChartState createState() => _InteractiveChartState();
}

/// State class of the cartesian chart with default tootlip.
class _InteractiveChartState extends SampleViewState {
  _InteractiveChartState();
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 1, y: 5),
    ChartSampleData(x: 2, y: 8),
    ChartSampleData(x: 3, y: 6),
    ChartSampleData(x: 4, y: 8),
    ChartSampleData(x: 5, y: 10)
  ];
  List<ChartSampleData> scatterData = <ChartSampleData>[];
  bool isLineExist = false;
  ChartSeriesController? seriesController;
  // List<CartesianSeries<ChartSampleData, num>> chartSeries;
  bool isSorting = false;
  bool isDataAdded = false;
  bool isScatterData = false;
  bool isRender = false;
  bool isResetVisible = false;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = !model.isWebFullView ? 40 : 60;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
            padding:
                EdgeInsets.fromLTRB(5, isCardView ? 0 : 15, 5, bottomPadding),
            child: Container(
              child: _buildInteractiveChart(),
            )),
        floatingActionButton: SizedBox(
          height: model.isWebFullView ? 45 : 40,
          width: 45,
          child: FloatingActionButton(
            onPressed: isResetVisible
                ? () => setState(() {
                      chartData = <ChartSampleData>[
                        ChartSampleData(x: 1, y: 5),
                        ChartSampleData(x: 2, y: 8),
                        ChartSampleData(x: 3, y: 6),
                        ChartSampleData(x: 4, y: 8),
                        ChartSampleData(x: 5, y: 10)
                      ];
                      isResetVisible = false;
                    })
                : null,
            backgroundColor:
                isResetVisible ? model.backgroundColor : Colors.grey[600],
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ));
  }

  /// Returns the cartesian chart with default tootlip.
  SfCartesianChart _buildInteractiveChart() {
    return SfCartesianChart(
        margin: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            rangePadding: ChartRangePadding.additional,
            majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.additional,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(width: 0)),
        series: <ChartSeries<ChartSampleData, num>>[
          LineSeries<ChartSampleData, num>(
              onRendererCreated: (ChartSeriesController controller) {
                seriesController = controller;
              },
              animationDuration: 1000,
              color: const Color.fromRGBO(75, 135, 185, 1),
              dataSource: chartData,
              xValueMapper: (ChartSampleData sales, _) => sales.x as num,
              yValueMapper: (ChartSampleData sales, _) => sales.y,
              name: 'Germany',
              markerSettings: const MarkerSettings(isVisible: true)),
        ],
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          isResetVisible = true;
          final Offset value = Offset(args.position.dx, args.position.dy);
          CartesianChartPoint<dynamic> chartpoint;
          chartpoint = seriesController!.pixelToPoint(value);
          chartData.add(ChartSampleData(x: chartpoint.x, y: chartpoint.y));
          setState(() {});
        });
  }
}
