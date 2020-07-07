/// Dart imports
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the update data source chart sample.
class UpdateDataSource extends SampleView {
  const UpdateDataSource(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

List<ChartSampleData> chartData = chartData = <ChartSampleData>[
  ChartSampleData(x: 1, y: 30),
  ChartSampleData(x: 3, y: 13),
  ChartSampleData(x: 5, y: 80),
  ChartSampleData(x: 7, y: 30),
  ChartSampleData(x: 9, y: 72)
];
int count = 11;

/// State class of the update data source chart.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  final Random random = Random();

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(UpdateDataSource oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = isCardView ? 0 : 60;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: getUpdateDataSourceChart()),
        ),
        floatingActionButton: isCardView ? null :
        FloatingActionButton(
          onPressed: () => setState(() {
            chartData = <ChartSampleData>[];
            chartData = getChartData();
          }),
          child: const Icon(Icons.refresh, color: Colors.white),
          backgroundColor: model.backgroundColor,
        ));
  }

  /// Returns the update data source cartesian chart.
  SfCartesianChart getUpdateDataSourceChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          minimum: 0, interval: 1, majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.additional,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          minorGridLines: MinorGridLines(width: 0)),
      series: getUpdateDataSourceSeries(),
    );
  }

  /// Returns the list of chart series which need to render on the update data source chart.
  List<ColumnSeries<ChartSampleData, num>> getUpdateDataSourceSeries() {
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(isVisible: true)),
    ];
  }

  num getRandomInt(num min, num max) {
    return min + random.nextInt(max - min);
  }

  List<ChartSampleData> getChartData() {
    chartData.add(ChartSampleData(x: 1, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 3, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 5, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 7, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 9, y: getRandomInt(10, 100)));
    return chartData;
  }

  List<ChartSampleData> getChartData1() {
    // ignore: invalid_use_of_protected_member
    if (chartData != null && chartData.isNotEmpty)
      chartData.removeAt(chartData.length - 1);
    count = count - 1;
    return chartData;
  }
}