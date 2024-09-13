/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the cartesian chart with default tooltip sample.
class InteractiveChart extends SampleView {
  /// Creates the cartesian chart with default tooltip sample.
  const InteractiveChart(Key key) : super(key: key);

  @override
  _InteractiveChartState createState() => _InteractiveChartState();
}

/// State class of the cartesian chart with default tooltip.
class _InteractiveChartState extends SampleViewState {
  _InteractiveChartState();
  late List<ChartSampleData> chartData;
  late List<ChartSampleData> scatterData;
  late bool isLineExist;
  ChartSeriesController<ChartSampleData, num>? seriesController;
  late bool isSorting;
  late bool isDataAdded;
  late bool isScatterData;
  late bool isRender;
  late bool isResetVisible;

  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x: 1, y: 5),
      ChartSampleData(x: 2, y: 8),
      ChartSampleData(x: 3, y: 6),
      ChartSampleData(x: 4, y: 8),
      ChartSampleData(x: 5, y: 10)
    ];
    scatterData = <ChartSampleData>[];
    isSorting = false;
    isDataAdded = false;
    isScatterData = false;
    isRender = false;
    isResetVisible = false;
    isLineExist = false;
    super.initState();
  }

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = !model.isWebFullView ? 40 : 60;
    return Scaffold(
        backgroundColor: model.sampleOutputCardColor,
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
                isResetVisible ? model.primaryColor : Colors.grey[600],
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ));
  }

  /// Returns the cartesian chart with default tooltip.
  SfCartesianChart _buildInteractiveChart() {
    return SfCartesianChart(
        margin: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryXAxis: const NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            rangePadding: ChartRangePadding.additional,
            majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: const NumericAxis(
            rangePadding: ChartRangePadding.additional,
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0)),
        series: <CartesianSeries<ChartSampleData, num>>[
          LineSeries<ChartSampleData, num>(
              onRendererCreated:
                  (ChartSeriesController<ChartSampleData, num> controller) {
                seriesController = controller;
              },
              dataSource: chartData,
              xValueMapper: (ChartSampleData sales, _) => sales.x as num,
              yValueMapper: (ChartSampleData sales, _) => sales.y,
              name: 'Germany',
              markerSettings: const MarkerSettings(isVisible: true)),
        ],
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          isResetVisible = true;
          final Offset value = Offset(args.position.dx, args.position.dy);
          final CartesianChartPoint<dynamic> chartPoint =
              seriesController!.pixelToPoint(value);
          chartData.add(ChartSampleData(x: chartPoint.x, y: chartPoint.y));
          setState(() {});
        });
  }
}
