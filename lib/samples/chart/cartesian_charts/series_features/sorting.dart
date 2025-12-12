/// Package imports.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Bar series chart with sorting options sample.
class SortingDefault extends SampleView {
  /// Creates the Bar series chart with sorting options sample.
  const SortingDefault(Key key) : super(key: key);

  @override
  _SortingDefaultState createState() => _SortingDefaultState();
}

/// State class for the Bar series chart with sorting options.
class _SortingDefaultState extends SampleViewState {
  _SortingDefaultState();
  late String _selectedType;
  late String _selectedSortType;
  late SortingOrder _sortingOrder;
  late String _sortBy;

  List<String>? _labelList;
  List<String>? _sortList;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _labelList = <String>['y', 'x'].toList();
    _sortList = <String>['none', 'descending', 'ascending'].toList();
    _selectedType = 'y';
    _selectedSortType = 'none';
    _sortingOrder = SortingOrder.none;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
      format: 'point.x : point.y m',
    );
    _sortBy = 'y';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 60,
      ),
      child: _buildDefaultSortingChart(),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildSortByDropdown(stateSetter),
            _buildSortingOrderDropdown(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the dropdown for sorting options.
  Widget _buildSortByDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Sort by', style: TextStyle(color: model.textColor, fontSize: 16)),
        DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _selectedType,
          items: _labelList!.map((String value) {
            return DropdownMenuItem<String>(
              value: (value != null) ? value : 'y',
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }).toList(),
          onChanged: (dynamic value) {
            _onPositionTypeChange(value.toString());
            stateSetter(() {});
          },
        ),
      ],
    );
  }

  /// Builds the dropdown for sorting order options.
  Widget _buildSortingOrderDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sorting order',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _selectedSortType,
          items: _sortList!.map((String value) {
            return DropdownMenuItem<String>(
              value: (value != null) ? value : 'none',
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }).toList(),
          onChanged: (dynamic value) {
            _onSortingTypeChange(value.toString());
            stateSetter(() {});
          },
        ),
      ],
    );
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _buildDefaultSortingChart() {
    return SfCartesianChart(
      title: const ChartTitle(text: "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text =
            args.dataPoints[args.viewportPointIndex].y.toString() + ' m';
      },
      primaryYAxis: const NumericAxis(
        minimum: 500,
        maximum: 900,
        interval: 100,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian bar series.
  List<BarSeries<ChartSampleData, String>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Burj\nKhalifa', y: 828),
          ChartSampleData(x: 'Goldin\nFinance 117', y: 597),
          ChartSampleData(x: 'Makkah Clock\nRoyal Tower', y: 601),
          ChartSampleData(x: 'Ping An\nFinance Center', y: 599),
          ChartSampleData(x: 'Shanghai\nTower', y: 632),
        ],
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        sortingOrder: _sortingOrder,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        sortFieldValueMapper: (ChartSampleData sales, int index) =>
            _sortBy == 'x' ? sales.x : sales.y,
      ),
    ];
  }

  /// Method to update the selected sortBy type in the chart on change.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'y') {
      _sortBy = 'y';
    }
    if (_selectedType == 'x') {
      _sortBy = 'x';
    }
    setState(() {
      /// update the sorting by value change.
    });
  }

  /// Method to update the selected sorting order
  /// in the chart on change.
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
      /// update the sorting order type change.
    });
  }

  @override
  void dispose() {
    _labelList!.clear();
    _sortList!.clear();
    super.dispose();
  }
}
