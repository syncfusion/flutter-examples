/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with default selection option sample.
class DefaultSelection extends SampleView {
  /// Creates the chart with default selection option
  const DefaultSelection(Key key) : super(key: key);

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState();
}

/// State class of the chart with default selection.
class _DefaultSelectionState extends SampleViewState {
  _DefaultSelectionState();
  late bool _enableMultiSelect;
  late bool _toggleSelection;

  late List<String> _modeList;

  late String _selectedMode;
  late SelectionBehavior _selectionBehavior;
  late SelectionType _mode;
  late List<ChartSampleData> chartData;

  @override
  void initState() {
    _modeList = <String>['point', 'series', 'cluster'].toList();
    _selectedMode = 'point';
    _mode = SelectionType.point;
    _enableMultiSelect = false;
    _toggleSelection = true;
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'CHN', y: 17, secondSeriesYValue: 54, thirdSeriesYValue: 9),
      ChartSampleData(
          x: 'USA', y: 19, secondSeriesYValue: 67, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'IDN', y: 29, secondSeriesYValue: 65, thirdSeriesYValue: 6),
      ChartSampleData(
          x: 'JAP', y: 13, secondSeriesYValue: 61, thirdSeriesYValue: 26),
      ChartSampleData(
          x: 'BRZ', y: 24, secondSeriesYValue: 68, thirdSeriesYValue: 8)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectionBehavior = SelectionBehavior(
        enable: true,
        unselectedOpacity: 0.5,
        toggleSelection: _toggleSelection);
    return _buildDefaultSelectionChart();
  }

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: model.isMobile ? 0.0 : 18.0),
                      Text('Mode',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16,
                            color: model.textColor,
                          )),
                      SizedBox(height: model.isMobile ? 30.0 : 16.0),
                      Text(
                          model.isWebFullView
                              ? 'Enable multi-\nselection'
                              : 'Enable multi-selection',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16,
                            color: model.textColor,
                          )),
                      SizedBox(height: model.isMobile ? 30.0 : 16.0),
                      Text(
                          model.isWebFullView
                              ? 'Toggle \nselection'
                              : 'Toggle selection',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16,
                            color: model.textColor,
                          )),
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: model.isMobile
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: model.isMobile ? 14.0 : 0.0),
                            DropdownButton<String>(
                                focusColor: Colors.transparent,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedMode,
                                items: _modeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'point',
                                      child: Text(value,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                onChanged: (dynamic value) {
                                  _onModeTypeChange(value);
                                  stateSetter(() {});
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 2.0 : 10.0),
                      Checkbox(
                          activeColor: model.backgroundColor,
                          value: _enableMultiSelect,
                          onChanged: (bool? value) {
                            setState(() {
                              _enableMultiSelect = value!;
                              stateSetter(() {});
                            });
                          }),
                      SizedBox(height: model.isMobile ? 2.0 : 25.0),
                      Checkbox(
                          activeColor: model.backgroundColor,
                          value: _toggleSelection,
                          onChanged: (bool? value) {
                            setState(() {
                              _toggleSelection = value!;
                              stateSetter(() {});
                            });
                          }),
                    ])
              ]),
        ],
      );
    });
  }

  /// Returns the cartesian chart with default selection.
  SfCartesianChart _buildDefaultSelectionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: !isCardView ? 'Age distribution by country' : ''),

      /// To specify the selection mode for chart.
      selectionType: _mode,
      selectionGesture: ActivationMode.singleTap,
      enableMultiSelection: _enableMultiSelect,
      primaryXAxis: CategoryAxis(
          title: AxisTitle(text: !isCardView ? 'Countries' : ''),
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSelectionSeries(),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the cartesian chart.
  List<ColumnSeries<ChartSampleData, String>> _getDefaultSelectionSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          selectionBehavior: _selectionBehavior,
          name: 'Age 0-14'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          selectionBehavior: _selectionBehavior,
          name: 'Age 15-64'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          selectionBehavior: _selectionBehavior,
          name: 'Age 65 & Above')
    ];
  }

  /// Method for updating the selected selectionType in the chart on chage.
  void _onModeTypeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'point') {
      _mode = SelectionType.point;
    }
    if (_selectedMode == 'series') {
      _mode = SelectionType.series;
    }
    if (_selectedMode == 'cluster') {
      _mode = SelectionType.cluster;
    }
    setState(() {
      /// update the selection type changes
    });
  }
}
