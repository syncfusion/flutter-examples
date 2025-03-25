/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the arrange by index category axis Chart sample.
class CategoryIndexed extends SampleView {
  const CategoryIndexed(Key key) : super(key: key);

  @override
  _CategoryIndexedState createState() => _CategoryIndexedState();
}

/// State class of arrange by index Chart.
class _CategoryIndexedState extends SampleViewState {
  _CategoryIndexedState();

  List<ChartSampleData>? _realGDPGrowthData2015;
  List<ChartSampleData>? _realGDPGrowthDataIn2016;
  bool? _isIndexed;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _realGDPGrowthData2015 = <ChartSampleData>[
      ChartSampleData(x: 'Myanmar', yValue: 7.3),
      ChartSampleData(x: 'India', yValue: 7.9),
      ChartSampleData(x: 'Bangladesh', yValue: 6.8),
    ];
    _realGDPGrowthDataIn2016 = <ChartSampleData>[
      ChartSampleData(x: 'Poland', yValue: 2.7),
      ChartSampleData(x: 'Australia', yValue: 2.5),
      ChartSampleData(x: 'Singapore', yValue: 2.0),
    ];
    _isIndexed = true;
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Arrange by index',
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: SizedBox(
                width: 90,
                child: CheckboxListTile(
                  activeColor: model.primaryColor,
                  value: _isIndexed,
                  onChanged: (bool? value) {
                    setState(() {
                      _isIndexed = value;
                      stateSetter(() {});
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Real GDP growth'),
      primaryXAxis: CategoryAxis(
        arrangeByIndex: _isIndexed ?? true,
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'GDP growth rate'),
        labelFormat: '{value}%',
        interval: isCardView ? 2 : 1,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      legend: Legend(isVisible: !isCardView),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _realGDPGrowthData2015,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: '2015',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _realGDPGrowthDataIn2016,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: '2016',
      ),
    ];
  }

  @override
  void dispose() {
    _realGDPGrowthData2015!.clear();
    _realGDPGrowthDataIn2016!.clear();
    super.dispose();
  }
}
