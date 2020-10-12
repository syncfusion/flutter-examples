/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/checkbox.dart';
import '../../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';

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
  bool _enableMultiSelect = false;

  final List<String> _modeList =
      <String>['point', 'series', 'cluster'].toList();

  String _selectedMode = 'point';
  SelectionBehavior _selectionBehavior;
  SelectionType _mode = SelectionType.point;

  @override
  void initState() {
    _selectedMode = 'point';
    _mode = SelectionType.point;
    _enableMultiSelect = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectionBehavior =
        SelectionBehavior(enable: true, unselectedOpacity: 0.5);

    return _getDefaultSelectionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Mode ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                height: 50,
                width: 250,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'point',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onModeTypeChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Enable multi-selection ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              HandCursor(
                child: CustomCheckBox(
                  activeColor: model.backgroundColor,
                  switchValue: _enableMultiSelect,
                  valueChanged: (dynamic value) {
                    setState(() {
                      _enableMultiSelect = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian chart with default selection.
  SfCartesianChart _getDefaultSelectionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: !isCardView ? 'Age distribution by country' : ''),

      /// To specify the selection mode for chart.
      selectionType: _mode,
      selectionGesture: ActivationMode.singleTap,
      enableMultiSelection: _enableMultiSelect,
      primaryXAxis: CategoryAxis(
          title: AxisTitle(text: !isCardView ? 'Countries' : ''),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getDefaultSelectionSeries(),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the cartesian chart.
  List<ColumnSeries<ChartSampleData, String>> _getDefaultSelectionSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
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
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          selectionBehavior: _selectionBehavior,
          name: 'Age 0-14'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          selectionBehavior: _selectionBehavior,
          name: 'Age 15-64'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
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
