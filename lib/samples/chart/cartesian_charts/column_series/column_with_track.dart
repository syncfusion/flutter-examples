/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

class ColumnTracker extends SampleView {
  const ColumnTracker(Key key) : super(key: key);   

  @override
  _ColumnTrackerState createState() => _ColumnTrackerState();
}

class _ColumnTrackerState extends SampleViewState {
  _ColumnTrackerState();
  @override
  Widget build(BuildContext context) {
    return getTrackerColumnChart();
  }

  SfCartesianChart getTrackerColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Marks of a student'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getTracker(),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: false,
          header: '',
          format: 'point.y marks in point.x'),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> getTracker() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Subject 1', y: 71),
      ChartSampleData(x: 'Subject 2', y: 84),
      ChartSampleData(x: 'Subject 3', y: 48),
      ChartSampleData(x: 'Subject 4', y: 80),
      ChartSampleData(x: 'Subject 5', y: 76),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Marks',
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: const TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}
