/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with default data labels sample.
class DataLabelDefault extends SampleView {
  const DataLabelDefault(Key key) : super(key: key);

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState();
}

/// State class of the chart with default data labels.
class _DataLabelDefaultState extends SampleViewState {
  _DataLabelDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDataLabelDefaultChart();
  }

  /// Returns the chart with default data labels.
  SfCartesianChart getDataLabelDefaultChart() {
  return SfCartesianChart(
    title: ChartTitle(text: isCardView ? '' : 'Gross investments'),
    plotAreaBorderWidth: 0,
    legend: Legend(isVisible: isCardView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2006,
        maximum: 2010,
        title: AxisTitle(text: isCardView ? '' : 'Year'),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1),
    primaryYAxis: NumericAxis(
        minimum: 15,
        maximum: 30,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getDataLabelDefaultSeries(),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

/// Returns the list of chart series which need to render on the chart with default data labels.
List<SplineSeries<ChartSampleData, num>> getDataLabelDefaultSeries() {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2006, y: 21.8, yValue: 18.2),
    ChartSampleData(x: 2007, y: 24.9, yValue: 21),
    ChartSampleData(x: 2008, y: 28.5, yValue: 22.1),
    ChartSampleData(x: 2009, y: 27.2, yValue: 21.5),
    ChartSampleData(x: 2010, y: 23.4, yValue: 18.9),
    ChartSampleData(x: 2011, y: 23.4, yValue: 21.3)
  ];
  return <SplineSeries<ChartSampleData, num>>[
    SplineSeries<ChartSampleData, num>(
        legendIconType: LegendIconType.rectangle,
        enableTooltip: true,
        dataSource: chartData,
        color: const Color.fromRGBO(140, 198, 64, 1),
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'Singapore',
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            labelAlignment: ChartDataLabelAlignment.top)),
    SplineSeries<ChartSampleData, num>(
        legendIconType: LegendIconType.rectangle,
        enableTooltip: true,
        color: const Color.fromRGBO(203, 164, 199, 1),
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'Russia',
        /// To enable the data label for cartesian chart.
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            labelAlignment: ChartDataLabelAlignment.top))
  ];
}
}
