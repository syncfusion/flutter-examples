/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the arrange by index category axis chart sample.
class CategoryIndexed extends SampleView {
  /// Creates the arrange by index category axis chart sample.
  const CategoryIndexed(Key key) : super(key: key);

  @override
  _CategoryIndexedState createState() => _CategoryIndexedState();
}

/// State class of arrange by index chart.
class _CategoryIndexedState extends SampleViewState {
  _CategoryIndexedState();
  bool? isIndexed = true;

  @override
  void initState() {
    isIndexed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildIndexedCategoryAxisChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Arrange by index',
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Container(
                width: 90,
                child: CheckboxListTile(
                    activeColor: model.backgroundColor,
                    value: isIndexed,
                    onChanged: (bool? value) {
                      setState(() {
                        isIndexed = value!;
                        stateSetter(() {});
                      });
                    })),
          )
        ],
      );
    });
  }

  /// Returns the column chart with arranged index.
  SfCartesianChart _buildIndexedCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Real GDP growth'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
          arrangeByIndex: isIndexed ?? true,
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          interval: isCardView ? 2 : 1,
          title: AxisTitle(text: isCardView ? '' : 'GDP growth rate'),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getIndexedCategoryAxisSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> _getIndexedCategoryAxisSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Myanmar', yValue: 7.3),
      ChartSampleData(x: 'India', yValue: 7.9),
      ChartSampleData(x: 'Bangladesh', yValue: 6.8)
    ];
    final List<ChartSampleData> chartData1 = <ChartSampleData>[
      ChartSampleData(x: 'Poland', yValue: 2.7),
      ChartSampleData(x: 'Australia', yValue: 2.5),
      ChartSampleData(x: 'Singapore', yValue: 2.0)
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: '2015'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData1,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: '2016')
    ];
  }
}
