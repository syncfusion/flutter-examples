/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the column chart with plotband recurrrence.
class PlotBandRecurrence extends SampleView {
  /// Creates the column chart with plotband recurrrence.
  const PlotBandRecurrence(Key key) : super(key: key);

  @override
  _PlotBandRecurrenceState createState() => _PlotBandRecurrenceState();
}

/// State class of the column chart with plotband recurrrence.
class _PlotBandRecurrenceState extends SampleViewState {
  _PlotBandRecurrenceState();
  bool? xAxis = false, yAxis = true;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    xAxis = false;
    yAxis = true;
    _tooltipBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlotBandRecurrenceChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text('X Axis',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 90,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: xAxis,
                        onChanged: (bool? value) {
                          setState(() {
                            xAxis = value!;
                            stateSetter(() {});
                          });
                        }))
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Y Axis',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 90,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: yAxis,
                        onChanged: (bool? value) {
                          setState(() {
                            yAxis = value!;
                            stateSetter(() {});
                          });
                        }))
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the ccolumn chart with plot band recurrence.
  SfCartesianChart _buildPlotBandRecurrenceChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'World pollution report'),
      legend: Legend(isVisible: !isCardView),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          interval: 5,
          dateFormat: DateFormat.y(),
          majorGridLines: const MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.years,
          edgeLabelPlacement: EdgeLabelPlacement.hide,
          minimum: DateTime(1975, 1, 1),
          maximum: DateTime(2010, 1, 1),

          /// API for X axis plot band.
          plotBands: <PlotBand>[
            PlotBand(
                isRepeatable: true,
                isVisible: xAxis ?? false,
                repeatEvery: 10,
                sizeType: DateTimeIntervalType.years,
                size: model.isWebFullView ? 3 : 5,
                repeatUntil: DateTime(2010, 1, 1),
                start: DateTime(1965, 1, 1),
                end: DateTime(2010, 1, 1),
                shouldRenderAboveSeries: false,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(227, 228, 230, 0.4)
                    : const Color.fromRGBO(70, 70, 70, 1))
          ]),
      primaryYAxis: NumericAxis(
          minimum: 0,
          interval: 2000,
          maximum: 18000,

          /// API for Y axis plot band.
          plotBands: <PlotBand>[
            PlotBand(
                isRepeatable: true,
                isVisible: yAxis ?? true,
                repeatEvery: 4000,
                size: 2000,
                start: 0,
                end: 18000,
                repeatUntil: 18000,
                shouldRenderAboveSeries: false,
                color: model.themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(227, 228, 230, 0.1)
                    : const Color.fromRGBO(70, 70, 70, 1))
          ],
          majorGridLines: const MajorGridLines(color: Colors.grey),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(fontSize: 0, color: Colors.transparent)),
      series: _getPlotBandRecurrenceSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, DateTime>> _getPlotBandRecurrenceSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1980, 1, 1), y: 15400, yValue: 6400),
      ChartSampleData(x: DateTime(1985, 1, 1), y: 15800, yValue: 3700),
      ChartSampleData(x: DateTime(1990, 1, 1), y: 14000, yValue: 7200),
      ChartSampleData(x: DateTime(1995, 1, 1), y: 10500, yValue: 2300),
      ChartSampleData(x: DateTime(2000, 1, 1), y: 13300, yValue: 4000),
      ChartSampleData(x: DateTime(2005, 1, 1), y: 12800, yValue: 4800)
    ];
    return <ColumnSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        name: 'All sources',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        name: 'Autos & Light Trucks',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
      )
    ];
  }
}
