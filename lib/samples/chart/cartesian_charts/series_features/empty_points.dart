/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the column series chart with empty points sample.
class EmptyPoints extends SampleView {
  /// Creates the column series chart with empty points sample.
  const EmptyPoints(Key key) : super(key: key);

  @override
  _EmptyPointsState createState() => _EmptyPointsState();
}

/// State class for the column series chart with empty points.
class _EmptyPointsState extends SampleViewState {
  _EmptyPointsState();
  late EmptyPointMode _selectedEmptyPointMode = EmptyPointMode.zero;
  late String _selectedMode;

  List<String>? _emptyPointMode;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _selectedMode = 'zero';
    _selectedEmptyPointMode = EmptyPointMode.zero;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _emptyPointMode = <String>['gap', 'zero', 'average', 'drop'].toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 60,
      ),
      child: _buildEmptyPointChart(),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Empty point mode  ',
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedMode,
                items: _emptyPointMode!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'zero',
                    child: Text(
                      value,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  _onEmptyPointModeChange(value.toString());
                  stateSetter(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Returns the cartesian column chart with empty points.
  SfCartesianChart _buildEmptyPointChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Population growth of various countries'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian column series chart.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'China', y: 0.541),
          ChartSampleData(x: 'Brazil'),
          ChartSampleData(x: 'Bolivia', y: 1.51),
          ChartSampleData(x: 'Mexico', y: 1.302),
          ChartSampleData(x: 'Egypt'),
          ChartSampleData(x: 'Mongolia', y: 1.683),
        ],
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,

        /// To enable the empty point mode, set the specific mode.
        emptyPointSettings: EmptyPointSettings(mode: _selectedEmptyPointMode),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10),
        ),
      ),
    ];
  }

  /// Method to update the empty point mode in the chart on change.
  void _onEmptyPointModeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'gap') {
      _selectedEmptyPointMode = EmptyPointMode.gap;
    }
    if (_selectedMode == 'zero') {
      _selectedEmptyPointMode = EmptyPointMode.zero;
    }
    if (_selectedMode == 'average') {
      _selectedEmptyPointMode = EmptyPointMode.average;
    }
    if (_selectedMode == 'drop') {
      _selectedEmptyPointMode = EmptyPointMode.drop;
    }
    setState(() {
      /// Update the empty point mode change.
    });
  }

  @override
  void dispose() {
    _emptyPointMode!.clear();
    super.dispose();
  }
}
