/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the vertical range column chart.
class RangeBarChart extends SampleView {
  const RangeBarChart(Key key) : super(key: key);

  @override
  _RangeBarChartState createState() => _RangeBarChartState();
}

/// State class of the vertical range column chart.
class _RangeBarChartState extends SampleViewState {
  _RangeBarChartState();

  @override
  Widget build(BuildContext context) {
    return getRangeBarChart();
  }

  /// Returns the vertical range column chart.
  SfCartesianChart getRangeBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(
          text:
              isCardView ? '' : 'Temperature variation – Sydney vs Melbourne'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      legend: Legend(isVisible: !isCardView),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}°F',
          minimum: 40,
          maximum: 80),
      series: getVerticalRangeColumnSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
      /// To enable this property we can get the vertical series.
      isTransposed: true,
    );
  }

  /// Returns the list of chart series which need to render on the vertical range column chart.
  List<RangeColumnSeries<ChartSampleData, String>>
      getVerticalRangeColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jul', y: 46, yValue: 63, yValue2: 43, yValue3: 57),
      ChartSampleData(x: 'Aug', y: 48, yValue: 64, yValue2: 45, yValue3: 59),
      ChartSampleData(x: 'Sep', y: 54, yValue: 68, yValue2: 48, yValue3: 63),
      ChartSampleData(x: 'Oct', y: 57, yValue: 72, yValue2: 50, yValue3: 68),
      ChartSampleData(x: 'Nov', y: 61, yValue: 75, yValue2: 54, yValue3: 72),
      ChartSampleData(x: 'Dec', y: 64, yValue: 79, yValue2: 57, yValue3: 75),
    ];
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          lowValueMapper: (ChartSampleData sales, _) => sales.y,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Sydney',
          dataLabelSettings: DataLabelSettings(
              isVisible: !isCardView,
              labelAlignment: ChartDataLabelAlignment.top)),
      RangeColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          lowValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: 'Melbourne',
          dataLabelSettings: DataLabelSettings(
              isVisible: !isCardView,
              labelAlignment: ChartDataLabelAlignment.top))
    ];
  }
}