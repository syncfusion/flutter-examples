/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the chart with sorting options sample.
class SortingDefault extends SampleView {
  /// Creates the chart with sorting options sample.
  const SortingDefault(Key key) : super(key: key);

  @override
  _SortingDefaultState createState() => _SortingDefaultState();
}

/// State class the chart with sorting options.
class _SortingDefaultState extends SampleViewState {
  _SortingDefaultState();
  bool isSorting = true;
  final List<String> _labelList = <String>['y', 'x'].toList();
  final List<String> _sortList =
      <String>['none', 'descending', 'ascending'].toList();
  late String _selectedType;
  late String _selectedSortType;
  late SortingOrder _sortingOrder;
  late TooltipBehavior _tooltipBehavior;

  late String _sortby;

  @override
  void initState() {
    _selectedType = 'y';
    _selectedSortType = 'none';
    _sortingOrder = SortingOrder.none;
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'point.x : point.y m');
    _sortby = 'y';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: model.isWebFullView || !isCardView ? 0 : 60),
        child: _buildDefaultSortingChart());
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
                Text('Sort by ',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedType,
                      items: _labelList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'y',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onPositionTypeChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Sorting order   ',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                  height: 50,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedSortType,
                      items: _sortList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'none',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onSortingTypeChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _buildDefaultSortingChart() {
    return SfCartesianChart(
      title: ChartTitle(text: "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = args.dataPoints[args.pointIndex].y.toString() + ' m';
      },
      primaryYAxis: NumericAxis(
          minimum: 500,
          maximum: 900,
          interval: 100,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSortingSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with sorting options.
  List<BarSeries<ChartSampleData, String>> _getDefaultSortingSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Burj\nKhalifa', y: 828),
      ChartSampleData(x: 'Goldin\nFinance 117', y: 597),
      ChartSampleData(x: 'Makkah Clock\nRoyal Tower', y: 601),
      ChartSampleData(x: 'Ping An\nFinance Center', y: 599),
      ChartSampleData(x: 'Shanghai\nTower', y: 632),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        sortingOrder: _sortingOrder,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.auto),
        sortFieldValueMapper: (ChartSampleData sales, _) =>
            _sortby == 'x' ? sales.x : sales.y,
      )
    ];
  }

  /// Method to update the selected sortBy type in the chart on change.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'y') {
      _sortby = 'y';
    }
    if (_selectedType == 'x') {
      _sortby = 'x';
    }
    setState(() {
      /// update the sorting by value change
    });
  }

  /// Method to update the selected sording order in the chart on change.
  void _onSortingTypeChange(String item) {
    _selectedSortType = item;
    if (_selectedSortType == 'descending') {
      _sortingOrder = SortingOrder.descending;
    } else if (_selectedSortType == 'ascending') {
      _sortingOrder = SortingOrder.ascending;
    } else {
      _sortingOrder = SortingOrder.none;
    }
    setState(() {
      /// update the sorting order type change
    });
  }
}
