/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_dropdown.dart';

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
  String _selectedType = 'y';
  String _selectedSortType = 'none';
  SortingOrder _sortingOrder = SortingOrder.none;

  String _sortby = 'y';

  @override
  void initState() {
    _selectedType = 'y';
    _selectedSortType = 'none';
    _sortingOrder = SortingOrder.none;
    _sortby = 'y';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: model.isWeb ? 0 : 60),
        child: _getDefaultSortingChart());
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Sort by ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedType,
                          item: _labelList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'y',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onPositionTypeChange(value.toString());
                          }),
                    ),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Sorting order ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
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
                          value: _selectedSortType,
                          item: _sortList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'none',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onSortingTypeChange(value.toString());
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _getDefaultSortingChart() {
    return SfCartesianChart(
      title: ChartTitle(text: "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 500,
          maximum: 900,
          interval: 100,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getDefaultSortingSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, canShowMarker: false, header: ''),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with sorting options.
  List<BarSeries<ChartSampleData, String>> _getDefaultSortingSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Burj \n Khalifa', y: 828),
      ChartSampleData(x: 'Goldin \n Finance 117', y: 597),
      ChartSampleData(x: 'Makkah Clock \n Royal Tower', y: 601),
      ChartSampleData(x: 'Ping An \n Finance Center', y: 599),
      ChartSampleData(x: 'Shanghai \n Tower', y: 632),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        sortingOrder: _sortingOrder ?? SortingOrder.none,
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
