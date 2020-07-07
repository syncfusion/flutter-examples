/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the default range column chart sample.
class RangeColumnDefault extends SampleView {
  const RangeColumnDefault(Key key) : super(key: key);

  @override
  _RangeColumnDefaultState createState() => _RangeColumnDefaultState();
}

/// State class of range column chart.
class _RangeColumnDefaultState extends SampleViewState {
  _RangeColumnDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDefaultRangeColumnChart();
  }

  /// Returns the default range column chart.
  SfCartesianChart getDefaultRangeColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Average half-yearly temperature variation of London, UK'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          interval: isCardView ? 5 : 2,
          labelFormat: '{value}°C',
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultRangeColumnSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Retursn the list of chart series which need to render on the default range column chart.
  List<RangeColumnSeries<ChartSampleData, String>>
      getDefaultRangeColumnSeries() {
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
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: isCardView ? false : true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }
}
