/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default Range Column Chart sample.
class RangeColumnDefault extends SampleView {
  const RangeColumnDefault(Key key) : super(key: key);

  @override
  _RangeColumnDefaultState createState() => _RangeColumnDefaultState();
}

/// State class of Range Column Chart.
class _RangeColumnDefaultState extends SampleViewState {
  _RangeColumnDefaultState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 3, yValue: 6),
      ChartSampleData(x: 'Feb', y: 3, yValue: 7),
      ChartSampleData(x: 'Mar', y: 4, yValue: 10),
      ChartSampleData(x: 'Apr', y: 6, yValue: 13),
      ChartSampleData(x: 'May', y: 9, yValue: 17),
      ChartSampleData(x: 'June', y: 12, yValue: 20),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Range Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Average half-yearly temperature variation of London, UK',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        interval: isCardView ? 5 : 2,
        labelFormat: '{value}°C',
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildRangeColumnSeries(),
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
        dataLabelSettings: DataLabelSettings(
          isVisible: !isCardView,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: const TextStyle(fontSize: 10),
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
