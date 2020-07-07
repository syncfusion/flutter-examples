/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Render the default doughnut chart.
class DoughnutDefault extends SampleView {
  const DoughnutDefault(Key key) : super(key: key);
  
  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class of doughnut chart.
class _DoughnutDefaultState extends SampleViewState {
  _DoughnutDefaultState();
  
  @override
  Widget build(BuildContext context) {
    // const String sourceLink =
    //     'https://www.pngkit.com/view/u2q8y3w7r5y3t4o0_composition-of-ocean-water-earths-oceans-elements-percentage/';
    // const String source = 'www.pngkit.com';
    return 
        getDefaultDoughnutChart();
  }

/// Return the circular chart with default doughnut series.
SfCircularChart getDefaultDoughnutChart() {
  return SfCircularChart(
    title: ChartTitle(text: isCardView ? '' : 'Composition of ocean water'),
    legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: getDefaultDoughnutSeries(isCardView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

/// Returns the list of doughnut series which need to be render.
List<DoughnutSeries<ChartSampleData, String>> getDefaultDoughnutSeries(
    bool isCardView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Chlorine', y: 55, text: '55%'),
    ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
    ChartSampleData(x: 'Magnesium', y: 7.7, text: '7.7%'),
    ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%'),
    ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
    ChartSampleData(x: 'Others', y: 1.4, text: '1.4%'),
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        radius: '80%',
        explode: true,
        explodeOffset: '10%',
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(isVisible: true))
  ];
}
}