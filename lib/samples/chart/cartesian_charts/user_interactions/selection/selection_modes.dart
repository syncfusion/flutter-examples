/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with default selection options.
class DefaultSelection extends SampleView {
  /// Creates the column series chart with default selection options.
  const DefaultSelection(Key key) : super(key: key);

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState();
}

/// State class for the column series chart with default selection options.
class _DefaultSelectionState extends SampleViewState {
  _DefaultSelectionState();
  late bool _enableMultiSelect;
  late bool _toggleSelection;
  late List<String> _modeList;
  late String _selectedMode;
  late SelectionBehavior _selectionBehavior;
  late SelectionType _selectionType;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _modeList = <String>['point', 'series', 'cluster'].toList();
    _selectedMode = 'point';
    _selectionType = SelectionType.point;
    _enableMultiSelect = false;
    _toggleSelection = true;
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'CHN',
        y: 17,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 9,
      ),
      ChartSampleData(
        x: 'USA',
        y: 19,
        secondSeriesYValue: 67,
        thirdSeriesYValue: 14,
      ),
      ChartSampleData(
        x: 'IDN',
        y: 29,
        secondSeriesYValue: 65,
        thirdSeriesYValue: 6,
      ),
      ChartSampleData(
        x: 'JAP',
        y: 13,
        secondSeriesYValue: 61,
        thirdSeriesYValue: 26,
      ),
      ChartSampleData(
        x: 'BRZ',
        y: 24,
        secondSeriesYValue: 68,
        thirdSeriesYValue: 8,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectionBehavior = SelectionBehavior(
      enable: true,
      toggleSelection: _toggleSelection,
    );
    return _buildDefaultSelectionChart();
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
                _buildSettingsLeftColumn(context),
                _buildSettingsRightColumn(context, stateSetter),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the left column of settings, displaying options for mode selection.
  Widget _buildSettingsLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: model.isMobile ? 0.0 : 18.0),
        Text(
          'Mode',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(height: model.isMobile ? 30.0 : 16.0),
        Text(
          model.isWebFullView
              ? 'Enable multi-\nselection'
              : 'Enable multi-selection',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(height: model.isMobile ? 30.0 : 16.0),
        Text(
          model.isWebFullView ? 'Toggle \nselection' : 'Toggle selection',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
      ],
    );
  }

  /// Builds the right column of settings, containing controls for selection options.
  Widget _buildSettingsRightColumn(
    BuildContext context,
    StateSetter stateSetter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: model.isMobile ? Alignment.topRight : Alignment.topLeft,
          child: _buildSelectionModeDropdown(stateSetter),
        ),
        SizedBox(height: model.isMobile ? 2.0 : 10.0),
        _buildCheckbox(
          value: _enableMultiSelect,
          onChanged: (bool? value) {
            setState(() {
              _enableMultiSelect = value!;
              stateSetter(() {});
            });
          },
        ),
        SizedBox(height: model.isMobile ? 2.0 : 25.0),
        _buildCheckbox(
          value: _toggleSelection,
          onChanged: (bool? value) {
            setState(() {
              _toggleSelection = value!;
              stateSetter(() {});
            });
          },
        ),
      ],
    );
  }

  Widget _buildSelectionModeDropdown(StateSetter stateSetter) {
    return DropdownButton<String>(
      dropdownColor: model.drawerBackgroundColor,
      focusColor: Colors.transparent,
      underline: Container(color: const Color(0xFFBDBDBD), height: 1),
      value: _selectedMode,
      items: _modeList.map((String value) {
        return DropdownMenuItem<String>(
          value: (value != null) ? value : 'point',
          child: Text(value, style: TextStyle(color: model.textColor)),
        );
      }).toList(),
      onChanged: (dynamic value) {
        _updateSelectionMode(value);
        stateSetter(() {});
      },
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?>? onChanged,
  }) {
    return Checkbox(
      activeColor: model.primaryColor,
      value: value,
      onChanged: onChanged,
    );
  }

  /// Returns a cartesian column chart with default selection option.
  SfCartesianChart _buildDefaultSelectionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: !isCardView ? 'Age distribution by country' : ''),

      /// To specify the selection mode for chart.
      selectionType: _selectionType,
      enableMultiSelection: _enableMultiSelect,
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: !isCardView ? 'Countries' : ''),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        selectionBehavior: _selectionBehavior,
        name: 'Age 0-14',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index_) =>
            data.secondSeriesYValue,
        selectionBehavior: _selectionBehavior,
        name: 'Age 15-64',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        selectionBehavior: _selectionBehavior,
        name: 'Age 65 & Above',
      ),
    ];
  }

  /// Method for updating the selected selectionType in the chart on change.
  void _updateSelectionMode(String item) {
    _selectedMode = item;
    if (_selectedMode == 'point') {
      _selectionType = SelectionType.point;
    }
    if (_selectedMode == 'series') {
      _selectionType = SelectionType.series;
    }
    if (_selectedMode == 'cluster') {
      _selectionType = SelectionType.cluster;
    }
    setState(() {
      /// Update the selection type changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
