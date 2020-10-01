/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_dropdown.dart';

/// Renders the chart with empty points sample.
class EmptyPoints extends SampleView {
  /// Creates the chart with empty points sample.
  const EmptyPoints(Key key) : super(key: key);

  @override
  _EmptyPointsState createState() => _EmptyPointsState();
}

/// State class of the chart with empty points.
class _EmptyPointsState extends SampleViewState {
  _EmptyPointsState();
  final List<String> _emptyPointMode =
      <String>['gap', 'zero', 'average', 'drop'].toList();
  EmptyPointMode _selectedEmptyPointMode = EmptyPointMode.gap;
  String _selectedMode;

  @override
  void initState() {
    _selectedMode = 'zero';
    _selectedEmptyPointMode = EmptyPointMode.gap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: model.isWeb ? 0 : 60),
        child: _getEmptyPointChart());
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Empty point mode  ',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                height: 50,
                width: 150,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                        value: _selectedMode,
                        item: _emptyPointMode.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'gap',
                              child: Text('$value',
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        valueChanged: (dynamic value) {
                          _onEmptyPointModeChange(value.toString());
                        }),
                  ),
                ))
          ],
        ),
      ),
    ]);
  }

  /// Returns the cartesian chart with empty points.
  SfCartesianChart _getEmptyPointChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Population growth of various countries'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: MajorTickLines(size: 0)),
      series: _getEmptyPointSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of charts which need to
  /// render on the chart with empty points.
  List<ColumnSeries<ChartSampleData, String>> _getEmptyPointSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', y: 0.541),
      ChartSampleData(x: 'Brazil', y: null),
      ChartSampleData(x: 'Bolivia', y: 1.51),
      ChartSampleData(x: 'Mexico', y: 1.302),
      ChartSampleData(x: 'Egypt', y: null),
      ChartSampleData(x: 'Mongolia', y: 1.683),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,

        /// To enable the empty point mode, set the specific mode.
        emptyPointSettings: EmptyPointSettings(
            mode: _selectedEmptyPointMode, color: Colors.grey),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }

  /// Method to update the empty point mode in the cahrt on change.
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
      /// update the empty point mode change
    });
  }
}
