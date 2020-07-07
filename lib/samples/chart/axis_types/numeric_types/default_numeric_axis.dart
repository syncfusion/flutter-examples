/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the default numeric axis sample.
class NumericDefault extends SampleView {
  const NumericDefault(Key key) : super(key: key);   

  @override
  _NumericDefaultState createState() => _NumericDefaultState();
}

/// State class of the default numeric axis.
class _NumericDefaultState extends SampleViewState {
  _NumericDefaultState();
  

   @override
  Widget build(BuildContext context) {
    return getChart();
  }

 /// Returns the Cartesian chart with default numeric x and y axis.
  SfCartesianChart getChart(){
    return SfCartesianChart(
      title:
          ChartTitle(text: isCardView ? '' : 'Australia vs India ODI - 2019'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView, position: LegendPosition.top),
      /// X axis as numeric axis placed here.
      primaryXAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Match'),
          minimum: 0,
          maximum: 6,
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          edgeLabelPlacement: EdgeLabelPlacement.hide),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Score'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultNumericSeries(),
      tooltipBehavior: TooltipBehavior(
          enable: true, format: 'Score: point.y', canShowMarker: false),
    );
  }
  
  /// Returns the list of Chart series which need to render on the default numeric axis.
  List<ColumnSeries<ChartSampleData, num>> getDefaultNumericSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(xValue: 1, yValue: 240, yValue2: 236),
      ChartSampleData(xValue: 2, yValue: 250, yValue2: 242),
      ChartSampleData(xValue: 3, yValue: 281, yValue2: 313),
      ChartSampleData(xValue: 4, yValue: 358, yValue2: 359),
      ChartSampleData(xValue: 5, yValue: 237, yValue2: 272)
    ];
    return <ColumnSeries<ChartSampleData, num>>[
      ///first series named "Australia".
      ColumnSeries<ChartSampleData, num>(
          enableTooltip: true,
          dataSource: chartData,
          color: const Color.fromRGBO(237, 221, 76, 1),
          name: 'Australia',
          xValueMapper: (ChartSampleData sales, _) => sales.xValue,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2),
      ///second series named "India".
      ColumnSeries<ChartSampleData, num>(
          enableTooltip: true,
          dataSource: chartData,
          color: const Color.fromRGBO(2, 109, 213, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.xValue,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'India'),
    ];
  }
}
