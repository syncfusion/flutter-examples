import 'dart:math';

import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class UpdateDataSource extends StatefulWidget {
  UpdateDataSource({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LiveVerticalState createState() => _LiveVerticalState(sample);
}

List<ChartSampleData> chartData = chartData = <ChartSampleData>[
  ChartSampleData(x: 1, y: 30),
  ChartSampleData(x: 3, y: 13),
  ChartSampleData(x: 5, y: 80),
  ChartSampleData(x: 7, y: 30),
  ChartSampleData(x: 9, y: 72)
];
int count = 11;

class _LiveVerticalState extends State<UpdateDataSource> {
  _LiveVerticalState(this.sample);
  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

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
    return getScopedModel(null, sample, UpdateDataFrontPanel(sample));
  }
}

SfCartesianChart getUpdateDataSourceChart(bool isTileView,
    [List<ChartSampleData> chartData]) {
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

List<ColumnSeries<ChartSampleData, num>> getUpdateDataSourceSeries() {
  return <ColumnSeries<ChartSampleData, num>>[
    ColumnSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(isVisible: true)),
  ];
}

//ignore: must_be_immutable
class UpdateDataFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  UpdateDataFrontPanel([this.sample]);
  SubItem sample;

  @override
  _UpdateDataFrontPanelState createState() =>
      _UpdateDataFrontPanelState(sample);
}

class _UpdateDataFrontPanelState extends State<UpdateDataFrontPanel> {
  _UpdateDataFrontPanelState(this.sample);
  final SubItem sample;
  final Random random = Random();

  Widget sampleWidget(SampleModel model) => getUpdateDataSourceChart(false);
  num getRandomInt(num min, num max) {
    return min + random.nextInt(max - min);
  }

  List<ChartSampleData> getChartData(SampleModel model) {
    chartData.add(ChartSampleData(x: 1, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 3, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 5, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 7, y: getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 9, y: getRandomInt(10, 100)));
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                child: Container(
                    child: getUpdateDataSourceChart(false, chartData)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => setState(() {
                  chartData = <ChartSampleData>[];
                  chartData = getChartData(model);
                }),
                child: Icon(Icons.refresh, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }
}
