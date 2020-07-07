/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

class ColumnDefault extends SampleView {
  const ColumnDefault(Key key) : super(key: key); 

  @override
  _ColumnDefaultState createState() => _ColumnDefaultState();
}

class _ColumnDefaultState extends SampleViewState {
  _ColumnDefaultState();
  

  @override
  Widget build(BuildContext context) {
    return getDefaultColumnChart();
  }

  SfCartesianChart getDefaultColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth of various countries'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultColumnSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> getDefaultColumnSeries() {
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
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }
}
