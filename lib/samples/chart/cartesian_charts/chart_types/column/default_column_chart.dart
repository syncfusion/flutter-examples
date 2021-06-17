/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

///Renders default column chart sample
class ColumnDefault extends SampleView {
  ///Renders default column chart sample
  const ColumnDefault(Key key) : super(key: key);

  @override
  _ColumnDefaultState createState() => _ColumnDefaultState();
}

class _ColumnDefaultState extends SampleViewState {
  _ColumnDefaultState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultColumnChart();
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth of various countries'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', y: 0.541),
      ChartSampleData(x: 'Brazil', y: 0.818),
      ChartSampleData(x: 'Bolivia', y: 1.51),
      ChartSampleData(x: 'Mexico', y: 1.302),
      ChartSampleData(x: 'Egypt', y: 2.017),
      ChartSampleData(x: 'Mongolia', y: 1.683),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }
}
