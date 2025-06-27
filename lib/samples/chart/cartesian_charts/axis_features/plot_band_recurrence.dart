/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Column Chart with plot band recurrence.
class PlotBandRecurrence extends SampleView {
  const PlotBandRecurrence(Key key) : super(key: key);

  @override
  _PlotBandRecurrenceState createState() => _PlotBandRecurrenceState();
}

/// State class of the Column Chart with plot band recurrence.
class _PlotBandRecurrenceState extends SampleViewState {
  _PlotBandRecurrenceState();

  bool? xAxis;
  bool? yAxis;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _worldPollutionData;

  @override
  void initState() {
    xAxis = false;
    yAxis = true;
    _worldPollutionData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1980), y: 15400, yValue: 6400),
      ChartSampleData(x: DateTime(1985), y: 15800, yValue: 3700),
      ChartSampleData(x: DateTime(1990), y: 14000, yValue: 7200),
      ChartSampleData(x: DateTime(1995), y: 10500, yValue: 2300),
      ChartSampleData(x: DateTime(2000), y: 13300, yValue: 4000),
      ChartSampleData(x: DateTime(2005), y: 12800, yValue: 4800),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              child: Row(
                children: <Widget>[
                  Text(
                    'X Axis',
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: xAxis,
                      onChanged: (bool? value) {
                        setState(() {
                          xAxis = value;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                children: <Widget>[
                  Text(
                    'Y Axis',
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: yAxis,
                      onChanged: (bool? value) {
                        setState(() {
                          yAxis = value;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'World pollution report'),
      primaryXAxis: DateTimeAxis(
        interval: 5,
        dateFormat: DateFormat.y(),
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        minimum: DateTime(1975),
        maximum: DateTime(2010),

        /// API for X axis plot band.
        plotBands: <PlotBand>[
          PlotBand(
            isRepeatable: true,
            isVisible: xAxis ?? false,
            repeatEvery: 10,
            sizeType: DateTimeIntervalType.years,
            size: model.isWebFullView ? 3 : 5,
            repeatUntil: DateTime(2010),
            start: DateTime(1965),
            end: DateTime(2010),
            color: model.themeData.colorScheme.brightness == Brightness.light
                ? const Color.fromRGBO(227, 228, 230, 1)
                : const Color.fromRGBO(70, 70, 70, 1),
          ),
        ],
      ),
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
            color: model.themeData.colorScheme.brightness == Brightness.light
                ? const Color.fromRGBO(227, 228, 230, 1)
                : const Color.fromRGBO(70, 70, 70, 1),
          ),
        ],
        majorGridLines: const MajorGridLines(color: Colors.grey),
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
      ),
      series: _buildColumnSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, DateTime>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: _worldPollutionData,
        name: 'All sources',
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
      ),
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: _worldPollutionData,
        name: 'Autos & Light Trucks',
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
      ),
    ];
  }

  @override
  void dispose() {
    _worldPollutionData!.clear();
    super.dispose();
  }
}
