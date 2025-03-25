/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Scatter Chart with DataTime axis label format.
class DateTimeLabel extends SampleView {
  const DateTimeLabel(Key key) : super(key: key);

  @override
  _DateTimeLabelState createState() => _DateTimeLabelState();
}

/// State class of the Scatter Chart with DataTime axis label format.
class _DateTimeLabelState extends SampleViewState {
  _DateTimeLabelState();

  List<ChartSampleData>? _earthquakesDataOfIndonesia;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _earthquakesDataOfIndonesia = <ChartSampleData>[
      ChartSampleData(x: DateTime(2019, 4, 12), yValue: 6.8),
      ChartSampleData(x: DateTime(2019, 03, 17), yValue: 5.5),
      ChartSampleData(x: DateTime(2018, 11, 14), yValue: 5.6),
      ChartSampleData(x: DateTime(2018, 10, 10), yValue: 6.0),
      ChartSampleData(x: DateTime(2018, 09, 28), yValue: 7.5),
      ChartSampleData(x: DateTime(2018, 08, 19), yValue: 6.9),
      ChartSampleData(x: DateTime(2018, 08, 19), yValue: 6.3),
      ChartSampleData(x: DateTime(2018, 08, 09), yValue: 5.9),
      ChartSampleData(x: DateTime(2018, 08, 05), yValue: 6.9),
      ChartSampleData(x: DateTime(2018, 07, 29), yValue: 6.4),
      ChartSampleData(x: DateTime(2018, 07, 21), yValue: 5.2),
      ChartSampleData(x: DateTime(2018, 04, 18), yValue: 4.5),
      ChartSampleData(x: DateTime(2018, 01, 23), yValue: 6.0),
      ChartSampleData(x: DateTime(2017, 12, 15), yValue: 6.5),
      ChartSampleData(x: DateTime(2017, 10, 31), yValue: 6.3),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y Mw',
      header: '',
      canShowMarker: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Scatter series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Earthquakes in Indonesia'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(width: 0),
        interval: 2,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        dateFormat: DateFormat.yMd(),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        minimum: 4,
        maximum: 8,
        title: AxisTitle(text: isCardView ? '' : 'Magnitude (Mw)'),
      ),
      series: _buildScatterSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Scatter series.
  List<ScatterSeries<ChartSampleData, DateTime>> _buildScatterSeries() {
    return <ScatterSeries<ChartSampleData, DateTime>>[
      ScatterSeries<ChartSampleData, DateTime>(
        dataSource: _earthquakesDataOfIndonesia,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        color: const Color.fromRGBO(232, 84, 84, 1),
        opacity: 0.8,
        markerSettings: const MarkerSettings(height: 15, width: 15),
      ),
    ];
  }

  @override
  void dispose() {
    _earthquakesDataOfIndonesia!.clear();
    super.dispose();
  }
}
