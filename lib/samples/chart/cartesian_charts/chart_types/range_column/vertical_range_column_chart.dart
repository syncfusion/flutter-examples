/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical Range Column Chart.
class RangeBarChart extends SampleView {
  const RangeBarChart(Key key) : super(key: key);

  @override
  _RangeBarChartState createState() => _RangeBarChartState();
}

/// State class of the vertical Range Column Chart.
class _RangeBarChartState extends SampleViewState {
  _RangeBarChartState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Jul',
        y: 46,
        yValue: 63,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 57,
      ),
      ChartSampleData(
        x: 'Aug',
        y: 48,
        yValue: 64,
        secondSeriesYValue: 45,
        thirdSeriesYValue: 59,
      ),
      ChartSampleData(
        x: 'Sep',
        y: 54,
        yValue: 68,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 63,
      ),
      ChartSampleData(
        x: 'Oct',
        y: 57,
        yValue: 72,
        secondSeriesYValue: 50,
        thirdSeriesYValue: 68,
      ),
      ChartSampleData(
        x: 'Nov',
        y: 61,
        yValue: 75,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 72,
      ),
      ChartSampleData(
        x: 'Dec',
        y: 64,
        yValue: 79,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 75,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Range Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      /// To enable this property we can get the vertical series.
      isTransposed: true,
      plotAreaBorderWidth: 1,
      title: ChartTitle(
        text: isCardView ? '' : 'Temperature variation – Sydney vs Melbourne',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}°F',
        minimum: 40,
        maximum: 80,
      ),
      series: _buildRangeColumnSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Range Column series.
  List<RangeColumnSeries<ChartSampleData, String>> _buildRangeColumnSeries() {
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        lowValueMapper: (ChartSampleData sales, int index) => sales.y,
        highValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        name: 'Sydney',
        dataLabelSettings: DataLabelSettings(
          isVisible: !isCardView,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
      RangeColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        lowValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        highValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: 'Melbourne',
        dataLabelSettings: DataLabelSettings(
          isVisible: !isCardView,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
