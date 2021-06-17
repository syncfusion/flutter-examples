/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the default range column chart sample.
class RangeColumnDefault extends SampleView {
  /// Creates the default range column chart sample.
  const RangeColumnDefault(Key key) : super(key: key);

  @override
  _RangeColumnDefaultState createState() => _RangeColumnDefaultState();
}

/// State class of range column chart.
class _RangeColumnDefaultState extends SampleViewState {
  _RangeColumnDefaultState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultRangeColumnChart();
  }

  /// Returns the default range column chart.
  SfCartesianChart _buildDefaultRangeColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Average half-yearly temperature variation of London, UK'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: isCardView ? 5 : 2,
          labelFormat: '{value}°C',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultRangeColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Retursn the list of chart series
  /// which need to render on the default range column chart.
  List<RangeColumnSeries<ChartSampleData, String>>
      _getDefaultRangeColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 3, yValue: 6),
      ChartSampleData(x: 'Feb', y: 3, yValue: 7),
      ChartSampleData(x: 'Mar', y: 4, yValue: 10),
      ChartSampleData(x: 'Apr', y: 6, yValue: 13),
      ChartSampleData(x: 'May', y: 9, yValue: 17),
      ChartSampleData(x: 'June', y: 12, yValue: 20),
    ];
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: !isCardView,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }
}
